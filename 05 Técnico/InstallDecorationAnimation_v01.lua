local ScriptEditorService = game:GetService("ScriptEditorService")
local client = game:GetService("StarterPlayer").StarterPlayerScripts.Client
local folder = client:FindFirstChild("Decoration") or Instance.new("Folder")
folder.Name = "Decoration"
folder.Parent = client
local sources = {}
sources.CheeringCrowd = [=====[--!strict
local CollectionService = game:GetService("CollectionService")

local CROWD_TAG = "CheeringPenguin"
local ACTIVE_RADIUS = 380
local CHEER_JUMP_HEIGHT = 1.6
local CHEER_JUMP_RATE = 5
local IDLE_BOB_HEIGHT = 0.15
local IDLE_BOB_RATE = 1.5
local WAVE_RATE = 10
local FLIPPER_SHOULDER = Vector3.new(1.55, 1.1, 0)
local FLIPPER_ARM_OFFSET = Vector3.new(0.15, -1, 0)
local FLIPPER_REST_ANGLE = 0.18
local FLIPPER_RAISE_ANGLE = 1.6
local FLAG_ARM_RAISE_BIAS = 0.6

type Fan = {
	body: BasePart,
	restFrame: CFrame,
	phase: number,
	cheers: boolean,
	leftFlipper: Weld?,
	rightFlipper: Weld?,
}

local fansByModel: { [Model]: Fan } = {}

local CheeringCrowd = {}

local function flipperOffset(side: number, angle: number): CFrame
	return CFrame.new(side * FLIPPER_SHOULDER.X, FLIPPER_SHOULDER.Y, 0)
		* CFrame.Angles(0, 0, side * angle)
		* CFrame.new(side * FLIPPER_ARM_OFFSET.X, FLIPPER_ARM_OFFSET.Y, 0)
end

local function findWeld(body: BasePart, name: string): Weld?
	local weld = body:FindFirstChild(name)
	return if weld and weld:IsA("Weld") then weld else nil
end

local function track(instance: Instance)
	if not instance:IsA("Model") or fansByModel[instance] then
		return
	end
	local body = instance.PrimaryPart
	if not body then
		return
	end
	local phase = instance:GetAttribute("CheerPhase")
	fansByModel[instance] = {
		body = body,
		restFrame = body.CFrame,
		phase = if typeof(phase) == "number" then phase else 0,
		cheers = instance:GetAttribute("Cheers") == true,
		leftFlipper = findWeld(body, "FlipperLeftWeld"),
		rightFlipper = findWeld(body, "FlipperRightWeld"),
	}
end

local function untrack(instance: Instance)
	if instance:IsA("Model") then
		fansByModel[instance] = nil
	end
end

local function animate(fan: Fan, now: number)
	local rate = if fan.cheers then CHEER_JUMP_RATE else IDLE_BOB_RATE
	local height = if fan.cheers then CHEER_JUMP_HEIGHT else IDLE_BOB_HEIGHT
	local lift = math.abs(math.sin(now * rate + fan.phase)) * height
	fan.body.CFrame = fan.restFrame + Vector3.new(0, lift, 0)
	if not fan.cheers then
		return
	end
	local wave = math.sin(now * WAVE_RATE + fan.phase)
	local leftFlipper = fan.leftFlipper
	if leftFlipper then
		leftFlipper.C0 = flipperOffset(-1, FLIPPER_REST_ANGLE + math.max(0, wave) * FLIPPER_RAISE_ANGLE)
	end
	local rightFlipper = fan.rightFlipper
	if rightFlipper then
		rightFlipper.C0 = flipperOffset(1, FLIPPER_REST_ANGLE + FLAG_ARM_RAISE_BIAS + math.max(0, -wave) * FLIPPER_RAISE_ANGLE)
	end
end

function CheeringCrowd.init()
	for _, instance in CollectionService:GetTagged(CROWD_TAG) do
		track(instance)
	end
	CollectionService:GetInstanceAddedSignal(CROWD_TAG):Connect(track)
	CollectionService:GetInstanceRemovedSignal(CROWD_TAG):Connect(untrack)
end

function CheeringCrowd.update(now: number, focus: Vector3)
	for model, fan in fansByModel do
		if not fan.body.Parent then
			fansByModel[model] = nil
		elseif (fan.restFrame.Position - focus).Magnitude <= ACTIVE_RADIUS then
			animate(fan, now)
		end
	end
end

return CheeringCrowd
]=====]
sources.SpinningDecor = [=====[--!strict
local CollectionService = game:GetService("CollectionService")

local SPIN_TAG = "SpinningDecor"
local DEFAULT_SPIN_SPEED = 0.5

type Spinner = {
	restPivot: CFrame,
	speed: number,
}

local spinnersByModel: { [Model]: Spinner } = {}

local SpinningDecor = {}

local function track(instance: Instance)
	if not instance:IsA("Model") or spinnersByModel[instance] then
		return
	end
	local speed = instance:GetAttribute("SpinSpeed")
	spinnersByModel[instance] = {
		restPivot = instance:GetPivot(),
		speed = if typeof(speed) == "number" then speed else DEFAULT_SPIN_SPEED,
	}
end

local function untrack(instance: Instance)
	if instance:IsA("Model") then
		spinnersByModel[instance] = nil
	end
end

function SpinningDecor.init()
	for _, instance in CollectionService:GetTagged(SPIN_TAG) do
		track(instance)
	end
	CollectionService:GetInstanceAddedSignal(SPIN_TAG):Connect(track)
	CollectionService:GetInstanceRemovedSignal(SPIN_TAG):Connect(untrack)
end

function SpinningDecor.update(now: number)
	for model, spinner in spinnersByModel do
		if not model.Parent then
			spinnersByModel[model] = nil
		else
			model:PivotTo(spinner.restPivot * CFrame.Angles(0, now * spinner.speed, 0))
		end
	end
end

return SpinningDecor
]=====]
sources.FlameFlicker = [=====[--!strict
local CollectionService = game:GetService("CollectionService")

local FLAME_TAG = "FlickeringFlame"
local MIN_INTENSITY = 0.75
local MAX_INTENSITY = 1.15

type Flame = {
	part: BasePart,
	light: PointLight?,
	baseBrightness: number,
	baseSize: Vector3,
}

local flamesByPart: { [BasePart]: Flame } = {}
local random = Random.new()

local FlameFlicker = {}

local function track(instance: Instance)
	if not instance:IsA("BasePart") or flamesByPart[instance] then
		return
	end
	local light = instance:FindFirstChildOfClass("PointLight")
	flamesByPart[instance] = {
		part = instance,
		light = light,
		baseBrightness = if light then light.Brightness else 0,
		baseSize = instance.Size,
	}
end

local function untrack(instance: Instance)
	if instance:IsA("BasePart") then
		flamesByPart[instance] = nil
	end
end

function FlameFlicker.init()
	for _, instance in CollectionService:GetTagged(FLAME_TAG) do
		track(instance)
	end
	CollectionService:GetInstanceAddedSignal(FLAME_TAG):Connect(track)
	CollectionService:GetInstanceRemovedSignal(FLAME_TAG):Connect(untrack)
end

function FlameFlicker.update()
	for part, flame in flamesByPart do
		if not part.Parent then
			flamesByPart[part] = nil
		else
			local intensity = random:NextNumber(MIN_INTENSITY, MAX_INTENSITY)
			part.Size = Vector3.new(flame.baseSize.X, flame.baseSize.Y * intensity, flame.baseSize.Z)
			local light = flame.light
			if light then
				light.Brightness = flame.baseBrightness * intensity
			end
		end
	end
end

return FlameFlicker
]=====]
sources.DecorationController = [=====[--!strict
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local CheeringCrowd = require(script.Parent.CheeringCrowd)
local FlameFlicker = require(script.Parent.FlameFlicker)
local SpinningDecor = require(script.Parent.SpinningDecor)

local DecorationController = {}

function DecorationController.init()
	CheeringCrowd.init()
	FlameFlicker.init()
	SpinningDecor.init()
	RunService.RenderStepped:Connect(function()
		local now = os.clock()
		local camera = Workspace.CurrentCamera
		local focus = if camera then camera.CFrame.Position else Vector3.zero
		CheeringCrowd.update(now, focus)
		FlameFlicker.update()
		SpinningDecor.update(now)
	end)
end

return DecorationController
]=====]
for name, source in pairs(sources) do
	local module = folder:FindFirstChild(name) or Instance.new("ModuleScript")
	module.Name = name
	module.Parent = folder
	ScriptEditorService:UpdateSourceAsync(module, function() return source end)
end
local main = client.Main
local function insertAfterLine(source, anchor, line)
	if string.find(source, line, 1, true) then
		return source
	end
	local anchorStart, anchorEnd = string.find(source, anchor, 1, true)
	assert(anchorStart, "anchor not found: " .. anchor)
	local lineEnd = string.find(source, "\n", anchorEnd, true) or #source
	return string.sub(source, 1, lineEnd) .. line .. "\n" .. string.sub(source, lineEnd + 1)
end
ScriptEditorService:UpdateSourceAsync(client.Main, function(source)
	local withRequire = insertAfterLine(source, "local LocalCharacter = require(Client.Character.LocalCharacter)", "local DecorationController = require(Client.Decoration.DecorationController)")
	return insertAfterLine(withRequire, "PresentationController.init()", "DecorationController.init()")
end)
print("Decoration animation installed")
