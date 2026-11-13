local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")
local ScriptEditorService = game:GetService("ScriptEditorService")

local shared = ReplicatedStorage.Shared
local server = ServerScriptService.Server
local services = server.Services
local client = StarterPlayer.StarterPlayerScripts.Client

local function ensureModule(parent, name)
	local module = parent:FindFirstChild(name)
	if not module then
		module = Instance.new("ModuleScript")
		module.Name = name
		module.Parent = parent
	end
	return module
end

local function write(container, source)
	ScriptEditorService:UpdateSourceAsync(container, function()
		return source
	end)
end

local function patch(container, replacements)
	local source = container.Source
	for _, pair in ipairs(replacements) do
		local first, last = string.find(source, pair[1], 1, true)
		assert(first, container:GetFullName() .. " is missing: " .. pair[1])
		source = string.sub(source, 1, first - 1) .. pair[2] .. string.sub(source, last + 1)
	end
	write(container, source)
end

write(ensureModule(shared, "LevelRegistry"), [==[--!strict
local CollectionService = game:GetService("CollectionService")

local GameConfig = require(script.Parent.GameConfig)

local LEVEL_ATTRIBUTE = "LevelId"
local DEFAULT_LEVEL = 1
local PLATEAU_SPAWN_TAG = "PlateauSpawn"
local ARRIVAL_HEIGHT = 5

local LevelRegistry = {}

LevelRegistry.Attribute = LEVEL_ATTRIBUTE
LevelRegistry.DefaultLevel = DEFAULT_LEVEL

function LevelRegistry.levelOf(instance: Instance): number
	local current: Instance? = instance
	while current do
		local levelId = current:GetAttribute(LEVEL_ATTRIBUTE)
		if typeof(levelId) == "number" then
			return levelId
		end
		current = current.Parent
	end
	return DEFAULT_LEVEL
end

function LevelRegistry.playerLevel(player: Player): number
	local levelId = player:GetAttribute(LEVEL_ATTRIBUTE)
	return if typeof(levelId) == "number" then levelId else DEFAULT_LEVEL
end

function LevelRegistry.firstTagged(tag: string, levelId: number): Instance?
	for _, instance in CollectionService:GetTagged(tag) do
		if LevelRegistry.levelOf(instance) == levelId then
			return instance
		end
	end
	return nil
end

function LevelRegistry.arrivalFrame(levelId: number): CFrame?
	local plateauSpawn = LevelRegistry.firstTagged(PLATEAU_SPAWN_TAG, levelId)
	if not (plateauSpawn and plateauSpawn:IsA("BasePart")) then
		return nil
	end
	local arrivalPosition = plateauSpawn.Position + Vector3.new(0, ARRIVAL_HEIGHT, 0)
	return CFrame.lookAlong(arrivalPosition, GameConfig.Race.TrackForward)
end

return LevelRegistry
]==])

write(shared.SlingshotGeometry, [==[--!strict
local CollectionService = game:GetService("CollectionService")

local LevelRegistry = require(script.Parent.LevelRegistry)

local SLINGSHOT_TAG = "Slingshot"

local SlingshotGeometry = {}

SlingshotGeometry.Tag = SLINGSHOT_TAG

function SlingshotGeometry.findAll(): { Model }
	local slingshots = {}
	for _, tagged in CollectionService:GetTagged(SLINGSHOT_TAG) do
		if tagged:IsA("Model") then
			table.insert(slingshots, tagged)
		end
	end
	return slingshots
end

function SlingshotGeometry.find(levelId: number?): Model?
	local wantedLevel = levelId or LevelRegistry.DefaultLevel
	for _, slingshot in SlingshotGeometry.findAll() do
		if LevelRegistry.levelOf(slingshot) == wantedLevel then
			return slingshot
		end
	end
	return nil
end

function SlingshotGeometry.seatFrame(slingshot: Model): CFrame
	local seatPosition = slingshot:GetAttribute("SeatPosition") :: Vector3
	local launchForward = slingshot:GetAttribute("LaunchForward") :: Vector3
	return CFrame.lookAlong(seatPosition, launchForward)
end

return SlingshotGeometry
]==])

write(services.SlingshotService, [==[--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.GameConfig)
local LaunchMath = require(Shared.LaunchMath)
local LevelRegistry = require(Shared.LevelRegistry)
local Remotes = require(Shared.Remotes)
local RunState = require(Shared.RunState)
local SlingshotGeometry = require(Shared.SlingshotGeometry)

local RateLimiter = require(script.Parent.Parent.Util.RateLimiter)
local RunStateService = require(script.Parent.RunStateService)

local slingshotConfig = GameConfig.Slingshot

local launchLimiter = RateLimiter.new(4)
local dismountLimiter = RateLimiter.new(2)
local aimLimiter = RateLimiter.new(30)

type Station = {
	slingshot: Model,
	mountPrompt: ProximityPrompt,
	occupant: Player?,
	aimTimeoutThread: thread?,
}

local stationByOccupant: { [Player]: Station } = {}

local SlingshotService = {}

local function isFiniteNumber(value: any): boolean
	return typeof(value) == "number" and value == value and math.abs(value) < math.huge
end

local function rootPartOf(player: Player): BasePart?
	local character = player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	if rootPart and rootPart:IsA("BasePart") then
		return rootPart
	end
	return nil
end

local function isAlive(player: Player): boolean
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	return humanoid ~= nil and humanoid.Health > 0
end

local function publishAim(station: Station, yawDegrees: number, pitchDegrees: number, pull: number)
	station.slingshot:SetAttribute("AimYaw", yawDegrees)
	station.slingshot:SetAttribute("AimPitch", pitchDegrees)
	station.slingshot:SetAttribute("AimPull", pull)
end

local function releaseOccupant(station: Station)
	local occupant = station.occupant
	if occupant then
		stationByOccupant[occupant] = nil
	end
	station.occupant = nil
	local aimTimeoutThread = station.aimTimeoutThread
	if aimTimeoutThread then
		task.cancel(aimTimeoutThread)
		station.aimTimeoutThread = nil
	end
	station.mountPrompt.Enabled = true
	publishAim(station, 0, 0, 0)
end

local function dismount(player: Player)
	local station = stationByOccupant[player]
	if not station then
		return
	end
	local dismountPosition = station.slingshot:GetAttribute("DismountPosition") :: Vector3
	RunStateService.transition(player, RunState.Idle, { teleportTo = CFrame.new(dismountPosition) })
end

local function onMountTriggered(station: Station, player: Player)
	if station.occupant ~= nil or RunStateService.get(player) ~= RunState.Idle or not isAlive(player) then
		return
	end
	local rootPart = rootPartOf(player)
	local promptAttachment = station.mountPrompt.Parent
	if not rootPart or not (promptAttachment and promptAttachment:IsA("Attachment")) then
		return
	end
	if (rootPart.Position - promptAttachment.WorldPosition).Magnitude > slingshotConfig.MountValidationDistance then
		return
	end
	player:SetAttribute(LevelRegistry.Attribute, LevelRegistry.levelOf(station.slingshot))
	if not RunStateService.transition(player, RunState.Aiming, nil) then
		return
	end

	station.occupant = player
	stationByOccupant[player] = station
	station.mountPrompt.Enabled = false
	station.aimTimeoutThread = task.delay(slingshotConfig.AimTimeoutSeconds, function()
		station.aimTimeoutThread = nil
		dismount(player)
	end)
end

local function onLaunchRequested(player: Player, yawDegrees: any, pitchDegrees: any, power: any)
	if not launchLimiter:allow(player) then
		return
	end
	local station = stationByOccupant[player]
	if not station or RunStateService.get(player) ~= RunState.Aiming then
		return
	end
	if not (isFiniteNumber(yawDegrees) and isFiniteNumber(pitchDegrees) and isFiniteNumber(power)) then
		return
	end
	if power < slingshotConfig.MinimumLaunchPower then
		return
	end
	local rootPart = rootPartOf(player)
	local seatFrame = SlingshotGeometry.seatFrame(station.slingshot)
	if not rootPart or (rootPart.Position - seatFrame.Position).Magnitude > slingshotConfig.LaunchValidationDistance then
		return
	end

	local aim = LaunchMath.clampAim({ yawDegrees = yawDegrees, pitchDegrees = pitchDegrees, power = power })
	RunStateService.transition(player, RunState.Racing, {
		origin = seatFrame.Position + LaunchMath.pullOffset(seatFrame, aim),
		velocity = LaunchMath.velocity(seatFrame, aim),
	})
end

local function onDismountRequested(player: Player)
	if dismountLimiter:allow(player) and RunStateService.get(player) == RunState.Aiming then
		dismount(player)
	end
end

local function onAimChanged(player: Player, yawDegrees: any, pitchDegrees: any, power: any)
	local station = stationByOccupant[player]
	if not station or not aimLimiter:allow(player) then
		return
	end
	if not (isFiniteNumber(yawDegrees) and isFiniteNumber(pitchDegrees) and isFiniteNumber(power)) then
		return
	end
	local aim = LaunchMath.clampAim({ yawDegrees = yawDegrees, pitchDegrees = pitchDegrees, power = power })
	publishAim(station, aim.yawDegrees, aim.pitchDegrees, aim.power)
end

local function registerStation(slingshot: Model)
	local foundPrompt = slingshot:FindFirstChild("MountPrompt", true)
	assert(foundPrompt and foundPrompt:IsA("ProximityPrompt"), slingshot:GetFullName() .. " has no MountPrompt")

	local station: Station = {
		slingshot = slingshot,
		mountPrompt = foundPrompt,
		occupant = nil,
		aimTimeoutThread = nil,
	}
	foundPrompt.Triggered:Connect(function(player: Player)
		onMountTriggered(station, player)
	end)
end

function SlingshotService.init()
	local slingshots = SlingshotGeometry.findAll()
	assert(#slingshots > 0, "No model tagged Slingshot was found")
	for _, slingshot in slingshots do
		registerStation(slingshot)
	end

	Remotes.LaunchRequested.OnServerEvent:Connect(onLaunchRequested)
	Remotes.DismountRequested.OnServerEvent:Connect(onDismountRequested)
	Remotes.AimChanged.OnServerEvent:Connect(onAimChanged)

	RunStateService.Changed:Connect(function(player: Player, _newState: string, previousState: string)
		local station = stationByOccupant[player]
		if previousState == RunState.Aiming and station then
			releaseOccupant(station)
		end
	end)
end

return SlingshotService
]==])

write(services.RaceService, [==[--!strict
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Shared = ReplicatedStorage.Shared
local GameConfig = require(Shared.GameConfig)
local LevelRegistry = require(Shared.LevelRegistry)
local Remotes = require(Shared.Remotes)
local RunState = require(Shared.RunState)

local RateLimiter = require(script.Parent.Parent.Util.RateLimiter)
local RunStateService = require(script.Parent.RunStateService)

local raceConfig = GameConfig.Race
local trackForward = raceConfig.TrackForward

local HAZARD_TAG = "Hazard"
local FALL_HAZARD_KIND = "Fall"
local CRASH_HAZARD_KIND = "Crash"

type Run = {
	startedAt: number,
	finishProgress: number,
}

local runs: { [Player]: Run } = {}
local finishProgressByLevel: { [number]: number } = {}
local secondsSinceLastTick = 0
local crashReportLimiter = RateLimiter.new(2)

local RaceService = {}

local function progressOf(position: Vector3): number
	return position:Dot(trackForward)
end

local function hazardKindAt(character: Model, position: Vector3): string?
	if position.Y < raceConfig.KillHeight then
		return FALL_HAZARD_KIND
	end

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { character }
	raycastParams.RespectCanCollide = true

	local ground = workspace:Raycast(position, Vector3.new(0, -raceConfig.HazardProbeLength, 0), raycastParams)
	if ground and CollectionService:HasTag(ground.Instance, HAZARD_TAG) then
		local hazardKind = ground.Instance:GetAttribute("HazardKind")
		return if typeof(hazardKind) == "string" then hazardKind else FALL_HAZARD_KIND
	end
	return nil
end

local function eliminate(player: Player, hazardKind: string, hazardPosition: Vector3)
	if not runs[player] then
		return
	end
	runs[player] = nil
	Remotes.RaceNotice:FireClient(player, "Eliminated", { hazardKind = hazardKind, hazardPosition = hazardPosition })

	local character = player.Character
	task.delay(GameConfig.Crash.RagdollSeconds, function()
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoid and player.Character == character then
			humanoid.Health = 0
		end
	end)
end

local function finish(player: Player, run: Run)
	local elapsedSeconds = os.clock() - run.startedAt
	if elapsedSeconds < raceConfig.MinimumPlausibleSeconds then
		RunStateService.reset(player, nil)
		player:LoadCharacter()
		return
	end
	RunStateService.transition(player, RunState.Finished, { seconds = elapsedSeconds })
end

local function advance(player: Player, run: Run)
	local character = player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	if not character or not (rootPart and rootPart:IsA("BasePart")) then
		return
	end

	local position = rootPart.Position
	if progressOf(position) >= run.finishProgress then
		finish(player, run)
		return
	end

	local hazardKind = hazardKindAt(character, position)
	if hazardKind then
		eliminate(player, hazardKind, position)
	end
end

local function onHeartbeat(deltaSeconds: number)
	secondsSinceLastTick += deltaSeconds
	if secondsSinceLastTick < raceConfig.TrackerIntervalSeconds then
		return
	end
	secondsSinceLastTick = 0

	for player, run in runs do
		advance(player, run)
	end
end

local function onCrashReported(player: Player)
	if not crashReportLimiter:allow(player) then
		return
	end
	local character = player.Character
	local rootPart = character and character:FindFirstChild("HumanoidRootPart")
	if rootPart and rootPart:IsA("BasePart") then
		eliminate(player, CRASH_HAZARD_KIND, rootPart.Position)
	end
end

function RaceService.init()
	for _, finishLine in CollectionService:GetTagged("FinishLine") do
		if finishLine:IsA("BasePart") then
			finishProgressByLevel[LevelRegistry.levelOf(finishLine)] = progressOf(finishLine.Position)
		end
	end
	assert(next(finishProgressByLevel) ~= nil, "No part tagged FinishLine was found")

	RunStateService.Changed:Connect(function(player: Player, newState: string, previousState: string)
		if newState == RunState.Racing then
			runs[player] = {
				startedAt = os.clock(),
				finishProgress = finishProgressByLevel[LevelRegistry.playerLevel(player)] or math.huge,
			}
		elseif previousState == RunState.Racing then
			runs[player] = nil
		end
	end)

	Remotes.CrashReported.OnServerEvent:Connect(onCrashReported)
	RunService.Heartbeat:Connect(onHeartbeat)
end

return RaceService
]==])

write(services.ReturnService, [==[--!strict
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage.Shared
local LevelRegistry = require(Shared.LevelRegistry)
local RunState = require(Shared.RunState)

local RateLimiter = require(script.Parent.Parent.Util.RateLimiter)
local RunStateService = require(script.Parent.RunStateService)

local DESTINATION_ATTRIBUTE = "DestinationLevel"

local returnLimiter = RateLimiter.new(1)

local ReturnService = {}

local function destinationOf(portal: BasePart): number
	local destinationLevel = portal:GetAttribute(DESTINATION_ATTRIBUTE)
	return if typeof(destinationLevel) == "number" then destinationLevel else LevelRegistry.levelOf(portal)
end

local function sendToLevel(player: Player, levelId: number)
	local currentState = RunStateService.get(player)
	if currentState ~= RunState.Finished and currentState ~= RunState.Idle then
		return
	end
	if not returnLimiter:allow(player) then
		return
	end
	local arrivalFrame = LevelRegistry.arrivalFrame(levelId)
	if not arrivalFrame then
		return
	end

	player:SetAttribute(LevelRegistry.Attribute, levelId)
	if currentState == RunState.Finished then
		RunStateService.transition(player, RunState.Idle, { teleportTo = arrivalFrame })
	else
		RunStateService.reset(player, { teleportTo = arrivalFrame })
	end
end

local function watchPortal(portal: Instance)
	if not portal:IsA("BasePart") then
		return
	end
	portal.Touched:Connect(function(touchingPart: BasePart)
		local player = Players:GetPlayerFromCharacter(touchingPart.Parent)
		if player then
			sendToLevel(player, destinationOf(portal))
		end
	end)
end

function ReturnService.init()
	for _, portal in CollectionService:GetTagged("ReturnPortal") do
		watchPortal(portal)
	end
	CollectionService:GetInstanceAddedSignal("ReturnPortal"):Connect(watchPortal)
end

return ReturnService
]==])

write(ensureModule(services, "LevelService"), [==[--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LevelRegistry = require(ReplicatedStorage.Shared.LevelRegistry)

local LevelService = {}

local function placeAtLevelStart(player: Player, character: Model)
	local levelId = LevelRegistry.playerLevel(player)
	if levelId == LevelRegistry.DefaultLevel then
		return
	end
	local arrivalFrame = LevelRegistry.arrivalFrame(levelId)
	if not arrivalFrame then
		return
	end
	character:WaitForChild("HumanoidRootPart")
	task.defer(function()
		if player.Character == character then
			character:PivotTo(arrivalFrame)
		end
	end)
end

local function watchPlayer(player: Player)
	if player:GetAttribute(LevelRegistry.Attribute) == nil then
		player:SetAttribute(LevelRegistry.Attribute, LevelRegistry.DefaultLevel)
	end
	player.CharacterAdded:Connect(function(character: Model)
		placeAtLevelStart(player, character)
	end)
end

function LevelService.init()
	Players.PlayerAdded:Connect(watchPlayer)
	for _, player in Players:GetPlayers() do
		watchPlayer(player)
	end
end

return LevelService
]==])

write(server.Main, [==[--!strict
local services = script.Parent.Services

local LevelService = require(services.LevelService)
local RunStateService = require(services.RunStateService)
local SlingshotService = require(services.SlingshotService)
local RaceService = require(services.RaceService)
local PoseService = require(services.PoseService)
local ReturnService = require(services.ReturnService)

LevelService.init()
RunStateService.init()
SlingshotService.init()
RaceService.init()
PoseService.init()
ReturnService.init()
]==])

local levelLookup = "SlingshotGeometry.find(LevelRegistry.playerLevel(Players.LocalPlayer))"
local levelRequires = {
	{ 'local ReplicatedStorage = game:GetService("ReplicatedStorage")', 'local Players = game:GetService("Players")\nlocal ReplicatedStorage = game:GetService("ReplicatedStorage")' },
	{ "local LaunchMath = require(ReplicatedStorage.Shared.LaunchMath)", "local LaunchMath = require(ReplicatedStorage.Shared.LaunchMath)\nlocal LevelRegistry = require(ReplicatedStorage.Shared.LevelRegistry)" },
	{ "SlingshotGeometry.find()", levelLookup },
}
patch(client.Run.Modes.AimingMode, levelRequires)
patch(client.Aim.SlingshotBandController, levelRequires)

local dump = game:GetService("ServerStorage"):FindFirstChild("ClaudeScriptDump")
if dump then dump:Destroy() end

print("Level scripts updated")
