local container = workspace:FindFirstChild("PenguinSlingshotMap_v01")
local existing = container:FindFirstChild("FinishPlaza")
if existing then existing:Destroy() end

local plaza = Instance.new("Folder")
plaza.Name = "FinishPlaza"
plaza.Parent = container

local finishBase = container.Terrain:FindFirstChild("FinishBase")
local groundTop = finishBase.Position.Y + finishBase.Size.Y / 2

local PLAZA_START = 1800
local PLAZA_END = 1870
local MOUNTAIN_HALF_WIDTH = 160

local Palette = {
	Snow = Color3.fromRGB(240, 246, 252),
	SnowShade = Color3.fromRGB(214, 226, 238),
	Wood = Color3.fromRGB(120, 82, 52),
	Pine = Color3.fromRGB(38, 92, 64),
}

local function createStudPart(parent, name, size, cframe, color)
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.CFrame = cframe
	part.Material = Enum.Material.Plastic
	part.Color = color
	part.TopSurface = Enum.SurfaceType.Studs
	part.BottomSurface = Enum.SurfaceType.Inlet
	part.Parent = parent
	return part
end

local function createZoneBlock(name, z0, z1, x0, x1, bottom, top, color)
	return createStudPart(plaza, name, Vector3.new(x1 - x0, top - bottom, z1 - z0),
		CFrame.new((x0 + x1) / 2, (bottom + top) / 2, -(z0 + z1) / 2), color)
end

local function groundPoint(x, heightAboveGround, z)
	return CFrame.new(x, groundTop + heightAboveGround, -z)
end

createZoneBlock("PlazaGround", PLAZA_START, PLAZA_END, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH, 0, groundTop, Palette.Snow)
for _, side in ipairs({ -1, 1 }) do
	createZoneBlock("SnowBank", PLAZA_START, PLAZA_END - 4, math.min(side * 60, side * 64), math.max(side * 60, side * 64), groundTop - 1, groundTop + 6, Palette.Snow)
end
createZoneBlock("EndSnowWall", PLAZA_END, PLAZA_END + 6, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH, 0, groundTop + 8, Palette.SnowShade)

local fence = Instance.new("Model")
fence.Name = "EndFence"
fence.Parent = plaza
for x = -56, 56, 8 do
	createStudPart(fence, "Post", Vector3.new(1, 4, 1), groundPoint(x, 10, PLAZA_END + 3), Palette.Wood)
end
for x = -52, 52, 8 do
	createStudPart(fence, "RailTop", Vector3.new(8, 0.6, 0.6), groundPoint(x, 11, PLAZA_END + 3), Palette.Wood)
	createStudPart(fence, "RailBottom", Vector3.new(8, 0.6, 0.6), groundPoint(x, 9.4, PLAZA_END + 3), Palette.Wood)
end

for index, drift in ipairs({ { -42, 12, 0.2 }, { -8, 9, -0.15 }, { 30, 14, 0.1 }, { 52, 8, -0.3 } }) do
	createStudPart(plaza, "SnowDrift", Vector3.new(drift[2], 2, 6), groundPoint(drift[1], 0.6, PLAZA_END - 3) * CFrame.Angles(0, drift[3], 0), Palette.Snow)
end

local function buildPine(x, z, scale)
	local pine = Instance.new("Model")
	pine.Name = "Pine"
	pine.Parent = plaza
	createStudPart(pine, "Trunk", Vector3.new(2.5, 14, 2.5) * scale, groundPoint(x, 6 * scale, z), Palette.Wood)
	for index, tier in ipairs({ { 14, 10, 14 }, { 10, 9, 22 }, { 6, 8, 29 }, { 2.5, 6, 35 } }) do
		createStudPart(pine, "Canopy" .. index, Vector3.new(tier[1], tier[2], tier[1]) * scale,
			groundPoint(x, tier[3] * scale, z) * CFrame.Angles(0, math.rad(45 * index), 0), Palette.Pine)
	end
end

for _, spot in ipairs({ { -82, 1812, 1 }, { -104, 1840, 1.2 }, { -130, 1820, 1.1 }, { -90, 1860, 0.9 }, { 84, 1818, 1.1 }, { 108, 1846, 1 }, { 136, 1826, 1.2 }, { 92, 1862, 0.9 } }) do
	buildPine(spot[1], spot[2], spot[3])
end

local camera = workspace.CurrentCamera
if camera then
	camera.CFrame = CFrame.lookAt(Vector3.new(110, groundTop + 70, -1740), Vector3.new(0, groundTop, -1840))
end

print(("FinishPlaza built: Z %d-%d, ground Y %.1f"):format(PLAZA_START, PLAZA_END, groundTop))
