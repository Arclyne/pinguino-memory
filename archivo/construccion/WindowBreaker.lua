--!strict
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local LevelRegistry = require(ReplicatedStorage.Shared.LevelRegistry)
local RunState = require(ReplicatedStorage.Shared.RunState)

local LEVEL_ID = 5
local WINDOW_TAG = "BreakableWindow"
local SHELL_TAG = "HouseShell"
local SHARD_COUNT = 34
local SHARD_LIFETIME = 1.6
local FADED_TRANSPARENCY = 0.82
local CROSSING_MARGIN = 6
local SLOW_DEPTH = 6
local GLASS_SOUND = "rbxasset://sounds/glassbreak.wav"

type WindowEntry = {
	model: Model,
	parts: { BasePart },
	frame: CFrame,
	halfSize: Vector3,
	lastDepth: number?,
	broken: boolean,
	ready: boolean,
}

type HouseEntry = {
	model: Model,
	zMin: number,
	zMax: number,
	shell: { BasePart },
	name: string,
}

local WindowBreaker = {}

local player = Players.LocalPlayer
local windows: { WindowEntry } = {}
local houses: { HouseEntry } = {}
local faded: { [BasePart]: boolean } = {}
local brokenCount = 0
local connection: RBXScriptConnection? = nil
local gui: ScreenGui? = nil
local counterLabel: TextLabel? = nil
local popLabel: TextLabel? = nil
local roomLabel: TextLabel? = nil
local shardFolder: Folder? = nil
local currentHouse: HouseEntry? = nil

local function levelFolder(): Instance?
	for _, child in Workspace:GetChildren() do
		if child:GetAttribute("LevelId") == LEVEL_ID then
			return child
		end
	end
	return nil
end

local function houseEntryFor(model: Model): HouseEntry?
	for _, house in houses do
		if house.model == model then
			return house
		end
	end
	local zMin = model:GetAttribute("WorldZMin")
	local zMax = model:GetAttribute("WorldZMax")
	if typeof(zMin) ~= "number" or typeof(zMax) ~= "number" then
		return nil
	end
	local name = model:GetAttribute("DisplayName")
	local house: HouseEntry = { model = model, zMin = zMin, zMax = zMax, shell = {}, name = if typeof(name) == "string" then name else model.Name }
	table.insert(houses, house)
	return house
end

local function addShellPart(instance: Instance)
	if not instance:IsA("BasePart") or LevelRegistry.levelOf(instance) ~= LEVEL_ID then
		return
	end
	local model = instance:FindFirstAncestorWhichIsA("Model")
	while model and model:GetAttribute("HouseIndex") == nil do
		model = model:FindFirstAncestorWhichIsA("Model")
	end
	if not model then
		return
	end
	local house = houseEntryFor(model)
	if house and not table.find(house.shell, instance) then
		table.insert(house.shell, instance)
	end
end

local function removeShellPart(instance: Instance)
	for _, house in houses do
		local index = table.find(house.shell, instance :: any)
		if index then
			table.remove(house.shell, index)
		end
	end
	if instance:IsA("BasePart") then
		faded[instance] = nil
	end
end

local function refreshWindows()
	local seen: { [Model]: boolean } = {}
	for _, entry in windows do
		seen[entry.model] = true
	end
	for _, instance in CollectionService:GetTagged(WINDOW_TAG) do
		if instance:IsA("Model") and not seen[instance] and LevelRegistry.levelOf(instance) == LEVEL_ID then
			table.insert(windows, { model = instance, parts = {}, frame = CFrame.identity, halfSize = Vector3.zero, lastDepth = nil, broken = false, ready = false })
		end
	end
	for index = #windows, 1, -1 do
		local entry = windows[index]
		if not entry.model.Parent then
			table.remove(windows, index)
		else
			local glass = entry.model:FindFirstChild("Glass")
			if glass and glass:IsA("BasePart") then
				entry.frame = glass.CFrame
				entry.halfSize = glass.Size / 2
				entry.ready = true
			else
				entry.ready = false
			end
			table.clear(entry.parts)
			for _, descendant in entry.model:GetDescendants() do
				if descendant:IsA("BasePart") then
					table.insert(entry.parts, descendant)
					descendant.LocalTransparencyModifier = if entry.broken then 1 else 0
				end
			end
		end
	end
end

local function totalWindows(): number
	local folder = levelFolder()
	local count = folder and folder:GetAttribute("WindowCount")
	return if typeof(count) == "number" then count else #windows
end

local function collect()
	refreshWindows()
	for _, instance in CollectionService:GetTagged(SHELL_TAG) do
		addShellPart(instance)
	end
end

local function styledLabel(parent: Instance, size: UDim2, position: UDim2, textSize: number, color: Color3): TextLabel
	local label = Instance.new("TextLabel")
	label.AnchorPoint = Vector2.new(0.5, 0)
	label.BackgroundTransparency = 1
	label.Size = size
	label.Position = position
	label.Font = Enum.Font.FredokaOne
	label.TextColor3 = color
	label.TextSize = textSize
	label.Text = ""
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 3
	stroke.Color = Color3.fromRGB(20, 24, 42)
	stroke.Parent = label
	label.Parent = parent
	return label
end

local function buildGui()
	if gui then
		return
	end
	local screen = Instance.new("ScreenGui")
	screen.Name = "WindowCounter"
	screen.ResetOnSpawn = false
	screen.IgnoreGuiInset = true
	screen.DisplayOrder = 8
	screen.Enabled = false
	local pill = Instance.new("Frame")
	pill.AnchorPoint = Vector2.new(0.5, 0)
	pill.Position = UDim2.new(0.5, 0, 0, 58)
	pill.Size = UDim2.fromOffset(250, 52)
	pill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	pill.Parent = screen
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = pill
	local border = Instance.new("UIStroke")
	border.Thickness = 4
	border.Color = Color3.fromRGB(20, 24, 42)
	border.Parent = pill
	counterLabel = styledLabel(pill, UDim2.fromScale(1, 1), UDim2.fromScale(0.5, 0), 28, Color3.fromRGB(110, 205, 255))
	roomLabel = styledLabel(screen, UDim2.fromOffset(600, 30), UDim2.new(0.5, 0, 0, 116), 24, Color3.fromRGB(255, 255, 255))
	popLabel = styledLabel(screen, UDim2.fromOffset(700, 110), UDim2.new(0.5, 0, 0.22, 0), 86, Color3.fromRGB(255, 255, 255))
	screen.Parent = player:WaitForChild("PlayerGui")
	gui = screen
end

local function refreshCounter()
	if counterLabel then
		counterLabel.Text = ("VENTANAS %d/%d"):format(brokenCount, totalWindows())
	end
end

local POP_WORDS = { "¡CRASH!", "¡CRACK!", "¡PUM!", "¡ZAS!" }

local function pop(word: string)
	local label = popLabel
	if not label then
		return
	end
	label.Text = word
	label.TextTransparency = 0
	label.Rotation = -10
	label.Size = UDim2.fromOffset(240, 40)
	TweenService:Create(label, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(700, 110), Rotation = 3 }):Play()
	task.delay(0.7, function()
		if label.Text == word then
			TweenService:Create(label, TweenInfo.new(0.35), { TextTransparency = 1 }):Play()
		end
	end)
end

local function spawnShards(entry: WindowEntry, velocity: Vector3)
	if not shardFolder then
		local folder = Instance.new("Folder")
		folder.Name = "WindowShards"
		folder.Parent = Workspace
		shardFolder = folder
	end
	local frame = entry.frame
	local half = entry.halfSize
	local forward = if velocity.Magnitude > 1 then velocity.Unit else -frame.LookVector
	for _ = 1, SHARD_COUNT do
		local shard = Instance.new("Part")
		shard.Name = "Shard"
		shard.Material = Enum.Material.Glass
		shard.Color = Color3.fromRGB(205, 240, 255)
		shard.Transparency = 0.25
		shard.Size = Vector3.new(0.3 + math.random() * 1.8, 0.3 + math.random() * 1.8, 0.15)
		shard.CanCollide = false
		shard.CanQuery = false
		shard.CanTouch = false
		shard.CastShadow = false
		shard.CFrame = frame * CFrame.new((math.random() - 0.5) * 2 * half.X, (math.random() - 0.5) * 2 * half.Y, 0) * CFrame.Angles(math.random() * 6, math.random() * 6, math.random() * 6)
		shard.AssemblyLinearVelocity = forward * (25 + math.random() * 45) + Vector3.new((math.random() - 0.5) * 40, 8 + math.random() * 22, (math.random() - 0.5) * 40)
		shard.AssemblyAngularVelocity = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5) * 30
		shard.Parent = shardFolder
		TweenService:Create(shard, TweenInfo.new(SHARD_LIFETIME), { Transparency = 1 }):Play()
		task.delay(SHARD_LIFETIME, function()
			shard:Destroy()
		end)
	end
	local burst = Instance.new("Part")
	burst.Anchored = true
	burst.CanCollide = false
	burst.CanQuery = false
	burst.CanTouch = false
	burst.Transparency = 1
	burst.Size = Vector3.new(1, 1, 1)
	burst.CFrame = frame
	burst.Parent = shardFolder
	local sparkle = Instance.new("ParticleEmitter")
	sparkle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	sparkle.Color = ColorSequence.new(Color3.fromRGB(220, 245, 255))
	sparkle.LightEmission = 1
	sparkle.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.6), NumberSequenceKeypoint.new(1, 0) })
	sparkle.Lifetime = NumberRange.new(0.4, 0.8)
	sparkle.Speed = NumberRange.new(20, 40)
	sparkle.SpreadAngle = Vector2.new(180, 180)
	sparkle.Rate = 0
	sparkle.Parent = burst
	sparkle:Emit(60)
	local sound = Instance.new("Sound")
	sound.SoundId = GLASS_SOUND
	sound.Volume = 0.8
	sound.PlaybackSpeed = 0.9 + math.random() * 0.25
	sound.Parent = burst
	sound:Play()
	task.delay(2, function()
		burst:Destroy()
	end)
end

local function breakWindow(entry: WindowEntry, velocity: Vector3)
	entry.broken = true
	for _, part in entry.parts do
		part.LocalTransparencyModifier = 1
	end
	brokenCount += 1
	refreshCounter()
	pop(POP_WORDS[(brokenCount - 1) % #POP_WORDS + 1])
	spawnShards(entry, velocity)
end

local function restoreWindows()
	for _, entry in windows do
		entry.broken = false
		entry.lastDepth = nil
		for _, part in entry.parts do
			part.LocalTransparencyModifier = 0
		end
	end
	brokenCount = 0
	refreshCounter()
end

local function clearFades()
	for part in faded do
		part.LocalTransparencyModifier = 0
	end
	table.clear(faded)
end

local function segmentHitsPart(part: BasePart, from: Vector3, to: Vector3): boolean
	local localFrom = part.CFrame:PointToObjectSpace(from)
	local localTo = part.CFrame:PointToObjectSpace(to)
	local half = part.Size / 2
	local enter, exit = 0, 1
	local direction = localTo - localFrom
	for _, axis in { "X", "Y", "Z" } do
		local start = (localFrom :: any)[axis] :: number
		local delta = (direction :: any)[axis] :: number
		local limit = (half :: any)[axis] :: number
		if math.abs(delta) < 1e-6 then
			if math.abs(start) > limit then
				return false
			end
		else
			local t1 = (-limit - start) / delta
			local t2 = (limit - start) / delta
			if t1 > t2 then
				t1, t2 = t2, t1
			end
			enter = math.max(enter, t1)
			exit = math.min(exit, t2)
			if enter > exit then
				return false
			end
		end
	end
	return true
end

local function rootPart(): BasePart?
	local character = player.Character
	if not character then
		return nil
	end
	local root = character:FindFirstChild("HumanoidRootPart")
	if root and root:IsA("BasePart") then
		return root
	end
	return character.PrimaryPart
end

local refreshTimer = 0

local function step(deltaSeconds: number)
	local root = rootPart()
	local camera = Workspace.CurrentCamera
	if not root or not camera then
		return
	end
	local position = root.Position
	local velocity = root.AssemblyLinearVelocity
	refreshTimer += deltaSeconds
	if refreshTimer > 0.5 then
		refreshTimer = 0
		refreshWindows()
	end
	for _, entry in windows do
		if entry.ready and not entry.broken then
			local localPosition = entry.frame:PointToObjectSpace(position)
			local depth = localPosition.Z
			local inside = math.abs(localPosition.X) <= entry.halfSize.X + CROSSING_MARGIN and math.abs(localPosition.Y) <= entry.halfSize.Y + CROSSING_MARGIN
			local previous = entry.lastDepth
			if inside and (math.abs(depth) < SLOW_DEPTH or (previous ~= nil and math.sign(previous) ~= math.sign(depth))) then
				breakWindow(entry, velocity)
			end
			entry.lastDepth = if inside then depth else nil
		end
	end
	local from = camera.CFrame.Position
	local targets = { position, position + Vector3.new(0, 4, 0) }
	local zLow = math.min(from.Z, position.Z)
	local zHigh = math.max(from.Z, position.Z)
	local stillFaded: { [BasePart]: boolean } = {}
	local inside: HouseEntry? = nil
	for _, house in houses do
		if position.Z <= house.zMax - 30 and position.Z >= house.zMin + 30 then
			inside = house
		end
		if house.zMax >= zLow and house.zMin <= zHigh then
			for _, part in house.shell do
				for _, target in targets do
					if segmentHitsPart(part, from, target) then
						stillFaded[part] = true
						break
					end
				end
			end
		end
	end
	for part in faded do
		if not stillFaded[part] then
			part.LocalTransparencyModifier = 0
		end
	end
	for part in stillFaded do
		part.LocalTransparencyModifier = FADED_TRANSPARENCY
	end
	faded = stillFaded
	if inside ~= currentHouse then
		currentHouse = inside
		if roomLabel then
			roomLabel.Text = if inside then inside.name else ""
		end
	end
end

local function stop()
	if connection then
		connection:Disconnect()
		connection = nil
	end
	clearFades()
	if gui then
		gui.Enabled = false
	end
end

local function start()
	stop()
	collect()
	buildGui()
	refreshCounter()
	if gui then
		gui.Enabled = true
	end
	connection = RunService.RenderStepped:Connect(step)
end

local function onStateChanged()
	local state = player:GetAttribute("RunState")
	local onLevel = LevelRegistry.playerLevel(player) == LEVEL_ID
	if state == RunState.Racing and onLevel then
		start()
	else
		stop()
		if state == RunState.Aiming or state == RunState.Idle then
			refreshWindows()
			restoreWindows()
			currentHouse = nil
			if roomLabel then
				roomLabel.Text = ""
			end
		end
	end
end

function WindowBreaker.init()
	CollectionService:GetInstanceAddedSignal(SHELL_TAG):Connect(addShellPart)
	CollectionService:GetInstanceRemovedSignal(SHELL_TAG):Connect(removeShellPart)
	player:GetAttributeChangedSignal("RunState"):Connect(onStateChanged)
	player:GetAttributeChangedSignal(LevelRegistry.Attribute):Connect(onStateChanged)
	onStateChanged()
end

return WindowBreaker
