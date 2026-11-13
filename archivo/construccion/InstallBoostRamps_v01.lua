local CollectionService = game:GetService("CollectionService")

local BOOST_RAMP_TAG = "BoostRamp"
local PULSE_TAG = "PulseGlow"
local MARKER_FOLDER_NAME = "BoostRampMarkers"
local MARKER_COLOR = Color3.fromRGB(90, 220, 255)
local MARKER_THICKNESS = 0.12
local MARKER_BAR_WIDTH = 0.55
local MARKER_SURFACE_LIFT = 0.08
local CHEVRON_HALF_ANGLE = math.rad(38)
local MINIMUM_RISE_DEGREES = 8
local SAMPLE_SHARE = 0.35
local CHEVRON_SPACING = 5

local trackForward = Vector3.new(0, 0, -1)

local rampSelectors = {
	{ map = "PenguinSlingshotMap_v01", path = { "Obstacles", "SnowMound" } },
	{ map = "PenguinSlingshotMap_Level2", path = { "Obstacles", "Bridge" }, childName = "Plank" },
	{ map = "PenguinSlingshotMap_Level3", path = { "Obstacles", "ramp_39", "Ramp" } },
}

local function resolve(selector): Instance?
	local current: Instance? = workspace:FindFirstChild(selector.map)
	for _, name in selector.path do
		current = current and current:FindFirstChild(name)
	end
	return current
end

local function topSurfaceHit(part: BasePart, localOffset: Vector3): RaycastResult?
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = { part }
	local castHeight = part.Size.Magnitude
	local origin = part.CFrame:PointToWorldSpace(localOffset) + Vector3.yAxis * castHeight
	return workspace:Raycast(origin, Vector3.new(0, -castHeight * 2, 0), params)
end

type Surface = { frame: CFrame, length: number, width: number }

local function surfaceOf(part: BasePart): Surface?
	local depthOffset = Vector3.new(0, 0, part.Size.Z * SAMPLE_SHARE)
	local nearHit = topSurfaceHit(part, -depthOffset)
	local farHit = topSurfaceHit(part, depthOffset)
	local centerHit = topSurfaceHit(part, Vector3.zero)
	if not (nearHit and farHit and centerHit) then
		return nil
	end
	local nearLocal = part.CFrame:PointToObjectSpace(nearHit.Position)
	local farLocal = part.CFrame:PointToObjectSpace(farHit.Position)
	local riseAgainstBase = math.deg(math.atan2(math.abs(farLocal.Y - nearLocal.Y), math.abs(farLocal.Z - nearLocal.Z)))

	local lowHit, highHit = nearHit, farHit
	local riseDegrees
	if riseAgainstBase >= MINIMUM_RISE_DEGREES then
		if nearLocal.Y > farLocal.Y then
			lowHit, highHit = farHit, nearHit
		end
		riseDegrees = riseAgainstBase
	else
		if nearHit.Position.Y > farHit.Position.Y then
			lowHit, highHit = farHit, nearHit
		end
		local worldUphill = (highHit.Position - lowHit.Position).Unit
		riseDegrees = math.deg(math.asin(math.clamp(worldUphill.Y, -1, 1)))
	end

	local uphill = (highHit.Position - lowHit.Position).Unit
	if uphill:Dot(trackForward) <= 0 or riseDegrees < MINIMUM_RISE_DEGREES then
		return nil
	end
	local normal = centerHit.Normal
	local right = uphill:Cross(normal).Unit
	local frame = CFrame.fromMatrix(centerHit.Position + normal * MARKER_SURFACE_LIFT, right, normal)
	return {
		frame = frame,
		length = (highHit.Position - lowHit.Position).Magnitude / (2 * SAMPLE_SHARE),
		width = part.Size.X,
	}
end

local function createBar(parent: Instance, frame: CFrame, length: number): BasePart
	local bar = Instance.new("Part")
	bar.Name = "BoostChevronBar"
	bar.Anchored = true
	bar.CanCollide = false
	bar.CanQuery = false
	bar.CanTouch = false
	bar.CastShadow = false
	bar.Material = Enum.Material.Neon
	bar.Color = MARKER_COLOR
	bar.Size = Vector3.new(MARKER_BAR_WIDTH, MARKER_THICKNESS, length)
	bar.CFrame = frame
	bar.Parent = parent
	CollectionService:AddTag(bar, PULSE_TAG)
	return bar
end

local function createChevron(parent: Instance, surfaceFrame: CFrame, forwardOffset: number, armLength: number)
	local apex = surfaceFrame * CFrame.new(0, 0, -forwardOffset)
	for _, side in { -1, 1 } do
		local armDirection = Vector3.new(side * math.sin(CHEVRON_HALF_ANGLE), 0, math.cos(CHEVRON_HALF_ANGLE))
		local armCenter = apex * CFrame.new(armDirection * (armLength / 2))
		local armFrame = CFrame.lookAlong(armCenter.Position, apex:VectorToWorldSpace(armDirection), apex.UpVector)
		createBar(parent, armFrame, armLength)
	end
end

local function decorate(part: BasePart, markerFolder: Folder): number
	local surface = surfaceOf(part)
	if not surface then
		return 0
	end
	CollectionService:AddTag(part, BOOST_RAMP_TAG)
	local chevronCount = math.clamp(math.floor(surface.length / CHEVRON_SPACING), 1, 3)
	local armLength = math.min(surface.width * 0.18, 3.5)
	local spacing = surface.length / (chevronCount + 1)
	for index = 1, chevronCount do
		local forwardOffset = -surface.length / 2 + spacing * index
		createChevron(markerFolder, surface.frame, forwardOffset, armLength)
	end
	return 1
end

local report = {}
for _, selector in rampSelectors do
	local target = resolve(selector)
	if not target then
		table.insert(report, selector.map .. ": not found")
		continue
	end
	local container = if target:IsA("BasePart") then target.Parent else target
	local oldMarkers = container and container:FindFirstChild(MARKER_FOLDER_NAME)
	if oldMarkers then
		oldMarkers:Destroy()
	end
	local markerFolder = Instance.new("Folder")
	markerFolder.Name = MARKER_FOLDER_NAME
	markerFolder.Parent = container

	local candidates = {}
	if target:IsA("BasePart") then
		table.insert(candidates, target)
	else
		for _, child in target:GetChildren() do
			if child:IsA("BasePart") and (selector.childName == nil or child.Name == selector.childName) then
				table.insert(candidates, child)
			end
		end
	end
	local tagged = 0
	for _, candidate in candidates do
		tagged += decorate(candidate, markerFolder)
	end
	table.insert(report, string.format("%s: %d boost ramps, %d chevron bars", selector.map, tagged, #markerFolder:GetChildren()))
end

return table.concat(report, "\n")
