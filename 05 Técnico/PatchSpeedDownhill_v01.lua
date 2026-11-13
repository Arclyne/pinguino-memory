local SES = game:GetService("ScriptEditorService")
local Client = game.StarterPlayer.StarterPlayerScripts.Client
local results = {}
local function patch(target, edits)
	local src = target.Source
	for _, e in ipairs(edits) do
		if src:find(e[2], 1, true) then
			table.insert(results, target.Name .. ": already")
		else
			local i, j = src:find(e[1], 1, true)
			if i then src = src:sub(1, i - 1) .. e[2] .. src:sub(j + 1) table.insert(results, target.Name .. ": ok")
			else table.insert(results, target.Name .. ": MISS " .. e[1]:sub(1, 40)) end
		end
	end
	SES:UpdateSourceAsync(target, function() return src end)
end
patch(game.ReplicatedStorage.Shared.GameConfig, {
	{ "MaxSpeed = 120,", "MaxSpeed = 145,\n\t\tDownhillBoost = 0.6,\n\t\tDownhillMinimumSlope = 0.08," },
})
patch(Client.Race.SlideMotor, {
	{ "\tdidJump: boolean,", "\tdidJump: boolean,\n\tsteepness: number," },
	{ "\tif isGrounded and planarSpeed > DEGENERATE_LENGTH then", "\tlocal steepness = 0\n\tif isGrounded then\n\t\tlocal downhill = projectOnPlane(-Vector3.yAxis, groundNormal)\n\t\tsteepness = downhill.Magnitude\n\t\tif steepness > slideConfig.DownhillMinimumSlope then\n\t\t\tlocal alongHeading = math.max(heading:Dot(downhill.Unit), 0)\n\t\t\tvelocity += downhill.Unit * (workspace.Gravity * steepness * slideConfig.DownhillBoost * alongHeading * deltaSeconds)\n\t\tend\n\tend\n\n\tif isGrounded and planarSpeed > DEGENERATE_LENGTH then" },
	{ "\t\tdidJump = didJump,", "\t\tdidJump = didJump,\n\t\tsteepness = steepness," },
})
patch(Client.Race.ChaseCamera, {
	{ "local RESTING_FIELD_OF_VIEW = 70", "local EXTRA_DISTANCE = 12\nlocal EXTRA_HEIGHT = 5\nlocal ZOOM_START_SPEED = 55\nlocal ZOOM_RATE = 2.5\nlocal SHAKE_STUDS = 0.18\nlocal RESTING_FIELD_OF_VIEW = 70" },
	{ "\tlocal cameraPosition = if camera then camera.CFrame.Position else rootPart.Position", "\tlocal cameraPosition = if camera then camera.CFrame.Position else rootPart.Position\n\tlocal zoom = 0" },
	{ "\t\tlocal desiredPosition = rootPart.Position - heading * DISTANCE_BEHIND + Vector3.yAxis * HEIGHT_ABOVE", "\t\tlocal targetZoom = math.clamp((velocity.Magnitude - ZOOM_START_SPEED) / (GameConfig.Slide.MaxSpeed - ZOOM_START_SPEED), 0, 1)\n\t\tzoom += (targetZoom - zoom) * (1 - math.exp(-ZOOM_RATE * deltaSeconds))\n\t\tlocal desiredPosition = rootPart.Position - heading * (DISTANCE_BEHIND + EXTRA_DISTANCE * zoom) + Vector3.yAxis * (HEIGHT_ABOVE + EXTRA_HEIGHT * zoom)" },
	{ "\t\tcurrentCamera.CFrame = CFrame.lookAt(cameraPosition, rootPart.Position + heading * LOOK_AHEAD)", "\t\tlocal now = os.clock()\n\t\tlocal shake = Vector3.new(math.noise(now * 9, 0.5), math.noise(0.5, now * 9), 0) * (SHAKE_STUDS * zoom * zoom)\n\t\tcurrentCamera.CFrame = CFrame.lookAt(cameraPosition + shake, rootPart.Position + heading * LOOK_AHEAD)" },
})
local effects = Client.Race:FindFirstChild("SpeedEffects") or Instance.new("ModuleScript")
effects.Name = "SpeedEffects"
effects.Parent = Client.Race
SES:UpdateSourceAsync(effects, function() return [==[--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local GameConfig = require(ReplicatedStorage.Shared.GameConfig)

local EFFECT_START_SPEED = 60
local LINE_COUNT = 34
local SPRAY_MAX_RATE = 140
local TRAIL_THRESHOLD = 0.3
local GROUND_PROBE = 3
local INTENSITY_RATE = 4

type Streak = { frame: Frame, angle: number, distance: number, speed: number }

local SpeedEffects = {}

local connection: RBXScriptConnection? = nil
local cleanup: { Instance } = {}
local streaks: { Streak } = {}
local intensity = 0

local function track<T>(instance: T): T
	table.insert(cleanup, instance :: any)
	return instance
end

local function newStreak(container: Frame): Streak
	local frame = Instance.new("Frame")
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 1
	frame.Parent = container
	return { frame = frame, angle = math.random() * math.pi * 2, distance = 0.3 + math.random() * 0.4, speed = 0.6 + math.random() * 0.8 }
end

local function buildSpeedLines()
	local gui = track(Instance.new("ScreenGui"))
	gui.Name = "SpeedLines"
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.DisplayOrder = 5
	local container = Instance.new("Frame")
	container.BackgroundTransparency = 1
	container.Size = UDim2.fromScale(1, 1)
	container.Parent = gui
	table.clear(streaks)
	for _ = 1, LINE_COUNT do
		table.insert(streaks, newStreak(container))
	end
	gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function buildSpray(rootPart: BasePart): ParticleEmitter
	local attachment = track(Instance.new("Attachment"))
	attachment.Name = "SpeedSprayAttachment"
	attachment.Position = Vector3.new(0, -1.2, 1.2)
	attachment.Parent = rootPart
	local spray = Instance.new("ParticleEmitter")
	spray.Texture = "rbxasset://textures/particles/smoke_main.dds"
	spray.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 236, 255))
	spray.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(1, 1) })
	spray.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.8), NumberSequenceKeypoint.new(1, 2.6) })
	spray.Lifetime = NumberRange.new(0.35, 0.6)
	spray.Speed = NumberRange.new(8, 16)
	spray.SpreadAngle = Vector2.new(35, 20)
	spray.EmissionDirection = Enum.NormalId.Back
	spray.Acceleration = Vector3.new(0, 6, 0)
	spray.LightInfluence = 0.4
	spray.Rate = 0
	spray.Parent = attachment
	return spray
end

local function buildTrail(rootPart: BasePart): Trail
	local left = track(Instance.new("Attachment"))
	left.Position = Vector3.new(-1.3, 0, 0.6)
	left.Parent = rootPart
	local right = track(Instance.new("Attachment"))
	right.Position = Vector3.new(1.3, 0, 0.6)
	right.Parent = rootPart
	local trail = track(Instance.new("Trail"))
	trail.Attachment0 = left
	trail.Attachment1 = right
	trail.Color = ColorSequence.new(Color3.fromRGB(200, 235, 255))
	trail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(1, 1) })
	trail.Lifetime = 0.22
	trail.LightEmission = 0.6
	trail.FaceCamera = true
	trail.Enabled = false
	trail.Parent = rootPart
	return trail
end

local function updateStreaks(deltaSeconds: number)
	local visibility = math.clamp((intensity - 0.15) / 0.85, 0, 1)
	for _, streak in streaks do
		streak.distance += streak.speed * deltaSeconds * (0.6 + intensity * 1.6)
		if streak.distance > 0.85 then
			streak.distance = 0.28 + math.random() * 0.15
			streak.angle = math.random() * math.pi * 2
		end
		local frame = streak.frame
		frame.Position = UDim2.fromScale(0.5 + math.cos(streak.angle) * streak.distance * 0.6, 0.5 + math.sin(streak.angle) * streak.distance * 0.6)
		frame.Size = UDim2.new(0, 2, 0.04 + intensity * 0.1, 0)
		frame.Rotation = math.deg(streak.angle) + 90
		frame.BackgroundTransparency = 1 - visibility * 0.55 * math.clamp((streak.distance - 0.28) * 4, 0, 1)
	end
end

function SpeedEffects.start(character: Model, rootPart: BasePart)
	SpeedEffects.stop()
	intensity = 0
	buildSpeedLines()
	local spray = buildSpray(rootPart)
	local trail = buildTrail(rootPart)
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = { character }
	rayParams.RespectCanCollide = true
	local topSpeed = GameConfig.Slide.MaxSpeed
	connection = RunService.RenderStepped:Connect(function(deltaSeconds: number)
		if not rootPart.Parent then
			return
		end
		local speed = rootPart.AssemblyLinearVelocity.Magnitude
		local target = math.clamp((speed - EFFECT_START_SPEED) / (topSpeed - EFFECT_START_SPEED), 0, 1)
		intensity += (target - intensity) * (1 - math.exp(-INTENSITY_RATE * deltaSeconds))
		local grounded = Workspace:Raycast(rootPart.Position, Vector3.new(0, -GROUND_PROBE, 0), rayParams) ~= nil
		spray.Rate = if grounded then SPRAY_MAX_RATE * math.clamp(speed / topSpeed, 0, 1) else 0
		trail.Enabled = intensity > TRAIL_THRESHOLD
		updateStreaks(deltaSeconds)
	end)
end

function SpeedEffects.stop()
	if connection then
		connection:Disconnect()
		connection = nil
	end
	for _, instance in cleanup do
		instance:Destroy()
	end
	table.clear(cleanup)
	table.clear(streaks)
end

return SpeedEffects
]==] end)
patch(Client.Run.Modes.RacingMode, {
	{ "local SlideMotor = require(Client.Race.SlideMotor)", "local SlideMotor = require(Client.Race.SlideMotor)\nlocal SpeedEffects = require(Client.Race.SpeedEffects)" },
	{ "\tself._dependencies.chaseCamera:start(rig.model, rig.rootPart, launchVelocity)", "\tself._dependencies.chaseCamera:start(rig.model, rig.rootPart, launchVelocity)\n\tSpeedEffects.start(rig.model, rig.rootPart)" },
	{ "\tself._dependencies.chaseCamera:stop()", "\tself._dependencies.chaseCamera:stop()\n\tSpeedEffects.stop()" },
})
print("SPEED PATCH", table.concat(results, " | "))
