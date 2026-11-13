local MAP_NAME = "PenguinSlingshotMap_v01"
local existing = workspace:FindFirstChild(MAP_NAME)
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name = MAP_NAME
root.Parent = workspace

local function newFolder(name)
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = root
	return folder
end

local terrainFolder = newFolder("Terrain")
local trackFolder = newFolder("Track")
local obstacleFolder = newFolder("Obstacles")
local decorationFolder = newFolder("Decoration")
local guideFolder = newFolder("Guides")

local Palette = {
	Snow = Color3.fromRGB(240, 246, 252),
	SnowShade = Color3.fromRGB(214, 226, 238),
	Rock = Color3.fromRGB(120, 126, 134),
	Wood = Color3.fromRGB(120, 82, 52),
	Pine = Color3.fromRGB(38, 92, 64),
	Ice = Color3.fromRGB(175, 225, 250),
	Water = Color3.fromRGB(40, 120, 190),
	Red = Color3.fromRGB(190, 60, 55),
	Yellow = Color3.fromRGB(255, 209, 102),
	Purple = Color3.fromRGB(170, 120, 255),
	Dark = Color3.fromRGB(20, 26, 34),
	Black = Color3.fromRGB(25, 25, 25),
	White = Color3.fromRGB(245, 245, 245),
	Orange = Color3.fromRGB(240, 140, 40),
	Bush = Color3.fromRGB(200, 225, 210),
}

local function createPart(parent, name, size, cframe, material, color, options)
	options = options or {}
	local part = Instance.new(options.className or "Part")
	part.Name = name
	part.Anchored = true
	if options.shape then part.Shape = options.shape end
	part.Size = size
	part.CFrame = cframe
	part.Material = material
	part.Color = color
	part.TopSurface = Enum.SurfaceType.Smooth
	part.BottomSurface = Enum.SurfaceType.Smooth
	if options.transparency then part.Transparency = options.transparency end
	if options.canCollide == false then part.CanCollide = false end
	part.Parent = parent
	return part
end

local zones = {
	{ name = "Plateau", z0 = -160, z1 = 0, slope = 0 },
	{ name = "Cliff", z0 = 0, z1 = 20 },
	{ name = "Landing", z0 = 20, z1 = 200, slope = 15 },
	{ name = "RockySlope", z0 = 200, z1 = 520, slope = 18 },
	{ name = "SnowyForest", z0 = 520, z1 = 900, slope = 20 },
	{ name = "IceRiver", z0 = 900, z1 = 1000, slope = 0 },
	{ name = "IceCanyon", z0 = 1000, z1 = 1400, slope = 22 },
	{ name = "AbandonedCamp", z0 = 1400, z1 = 1650, slope = 15 },
	{ name = "Finish", z0 = 1650, z1 = 1800, slope = 5 },
}

local runningElevation = 600
for _, zone in ipairs(zones) do
	zone.e0 = runningElevation
	if zone.name == "Plateau" then
		zone.e1 = 600
	elseif zone.name == "Cliff" then
		zone.e1 = 560
	else
		zone.e1 = runningElevation - (zone.z1 - zone.z0) * math.tan(math.rad(zone.slope))
	end
	runningElevation = zone.e1
end

local function elevationAt(z)
	for _, zone in ipairs(zones) do
		if z >= zone.z0 and z <= zone.z1 then
			return zone.e0 + (zone.e1 - zone.e0) * (z - zone.z0) / (zone.z1 - zone.z0)
		end
	end
	return 0
end

local function slopeAt(z)
	for _, zone in ipairs(zones) do
		if z >= zone.z0 and z <= zone.z1 then return zone.slope or 0 end
	end
	return 0
end

local riverElevation = zones[6].e0
local MOUNTAIN_HALF_WIDTH = 160
local zoneBoundaries = { 20, 200, 520, 900, 1000, 1400, 1650, 1800 }

local function worldPoint(x, y, z)
	return Vector3.new(x, y, -z)
end

local function groundCFrame(x, z, heightAboveGround)
	return CFrame.new(worldPoint(x, elevationAt(z) + heightAboveGround, z))
end

local function buildBlock(parent, name, z0, z1, x0, x1, bottom, top, material, color, options)
	if top - bottom < 0.05 then return end
	return createPart(parent, name, Vector3.new(x1 - x0, top - bottom, z1 - z0),
		CFrame.new((x0 + x1) / 2, (bottom + top) / 2, -(z0 + z1) / 2), material, color, options)
end

local function buildGround(name, z0, z1, x0, x1)
	local high, low = elevationAt(z0), elevationAt(z1)
	buildBlock(terrainFolder, name .. "Base", z0, z1, x0, x1, 0, low, Enum.Material.Snow, Palette.SnowShade)
	if high - low > 0.05 then
		createPart(terrainFolder, name .. "Slope", Vector3.new(x1 - x0, high - low, z1 - z0),
			CFrame.new((x0 + x1) / 2, (high + low) / 2, -(z0 + z1) / 2), Enum.Material.Snow, Palette.Snow,
			{ className = "WedgePart" })
	end
end

local function buildAlongSlope(parent, name, z0, z1, x0, x1, heightAbove, material, color, options)
	local cuts = { z0 }
	for _, boundary in ipairs(zoneBoundaries) do
		if boundary > z0 and boundary < z1 then table.insert(cuts, boundary) end
	end
	table.insert(cuts, z1)
	for index = 1, #cuts - 1 do
		local startPoint = worldPoint((x0 + x1) / 2, elevationAt(cuts[index]), cuts[index])
		local endPoint = worldPoint((x0 + x1) / 2, elevationAt(cuts[index + 1]), cuts[index + 1])
		local length = (endPoint - startPoint).Magnitude
		local cframe = CFrame.lookAt((startPoint + endPoint) / 2, endPoint) * CFrame.new(0, heightAbove / 2 - 1, 0)
		createPart(parent, name, Vector3.new(x1 - x0, heightAbove + 2, length), cframe, material, color, options)
	end
end

buildBlock(terrainFolder, "Plateau", -160, 0, -120, 120, 0, 600, Enum.Material.Snow, Palette.Snow)
createPart(terrainFolder, "CliffSlope", Vector3.new(240, 40, 20), CFrame.new(0, 580, -10), Enum.Material.Slate, Palette.Rock, { className = "WedgePart" })
buildBlock(terrainFolder, "CliffBase", 0, 20, -120, 120, 0, 560, Enum.Material.Slate, Palette.Rock)

for _, zone in ipairs(zones) do
	if zone.name == "Landing" or zone.name == "RockySlope" or zone.name == "SnowyForest"
		or zone.name == "AbandonedCamp" or zone.name == "Finish" then
		buildGround(zone.name, zone.z0, zone.z1, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH)
	end
end

buildBlock(terrainFolder, "RiverShelf", 900, 920, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH, 0, riverElevation, Enum.Material.Snow, Palette.Snow)
buildBlock(terrainFolder, "RiverBed", 920, 990, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH, 0, riverElevation - 16, Enum.Material.Slate, Palette.Rock)
buildBlock(terrainFolder, "RiverBank", 990, 1000, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH, 0, riverElevation, Enum.Material.Snow, Palette.Snow)
local water = buildBlock(terrainFolder, "RiverWater", 920, 990, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH,
	riverElevation - 16, riverElevation - 4, Enum.Material.Glass, Palette.Water, { transparency = 0.35, canCollide = false })
water.Reflectance = 0.1

local crevasses = {
	{ id = "G1", z0 = 1136, z1 = 1144, x0 = -40, x1 = 10 },
	{ id = "G2", z0 = 1241, z1 = 1249, x0 = -40, x1 = 40 },
}
buildGround("IceCanyonA", 1000, 1136, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH)
buildGround("IceCanyonB", 1144, 1241, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH)
buildGround("IceCanyonC", 1249, 1400, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH)
for _, crevasse in ipairs(crevasses) do
	buildGround("CrevasseSideLeft" .. crevasse.id, crevasse.z0, crevasse.z1, -MOUNTAIN_HALF_WIDTH, crevasse.x0)
	buildGround("CrevasseSideRight" .. crevasse.id, crevasse.z0, crevasse.z1, crevasse.x1, MOUNTAIN_HALF_WIDTH)
	buildBlock(obstacleFolder, "Crevasse_" .. crevasse.id, crevasse.z0, crevasse.z1, crevasse.x0, crevasse.x1,
		0, elevationAt(crevasse.z1) - 20, Enum.Material.Ice, Palette.Dark)
end

for _, side in ipairs({ -1, 1 }) do
	for _, range in ipairs({ { 20, 900 }, { 1400, 1800 } }) do
		local inner, outer = side * 60, side * 64
		buildAlongSlope(trackFolder, "SnowBank", range[1], range[2], math.min(inner, outer), math.max(inner, outer), 6, Enum.Material.Snow, Palette.Snow)
	end
	local canyonInner, canyonOuter = side * 40, side * 75
	buildAlongSlope(trackFolder, "CanyonWall", 1000, 1400, math.min(canyonInner, canyonOuter), math.max(canyonInner, canyonOuter), 40, Enum.Material.Slate, Palette.Rock)
end

local function buildPine(parent, x, z, scale)
	scale = scale or 1
	local model = Instance.new("Model")
	model.Name = "Pine"
	model.Parent = parent
	createPart(model, "Trunk", Vector3.new(2.5, 14, 2.5) * scale, groundCFrame(x, z, 6 * scale), Enum.Material.Wood, Palette.Wood)
	local tiers = { { 14, 10, 14 }, { 10, 9, 22 }, { 6, 8, 29 }, { 2.5, 6, 35 } }
	for index, tier in ipairs(tiers) do
		createPart(model, "Canopy" .. index, Vector3.new(tier[1], tier[2], tier[1]) * scale,
			groundCFrame(x, z, tier[3] * scale) * CFrame.Angles(0, math.rad(45 * index), 0), Enum.Material.Grass, Palette.Pine)
	end
	return model
end

local function embedDepth(z, length)
	return length / 2 * math.tan(math.rad(slopeAt(z))) + 0.5
end

local randomGenerator = Random.new(7)

local ObstacleBuilders = {}

ObstacleBuilders.Rock = function(parent, x, z)
	createPart(parent, "Rock", Vector3.new(10, 9, 10), groundCFrame(x, z, 4.5 - embedDepth(z, 10))
		* CFrame.Angles(math.rad(randomGenerator:NextNumber(-8, 8)), randomGenerator:NextNumber(0, math.pi), 0), Enum.Material.Rock, Palette.Rock)
end

ObstacleBuilders.Boulder = function(parent, x, z)
	createPart(parent, "Boulder", Vector3.new(16, 14, 14), groundCFrame(x, z, 7 - embedDepth(z, 14))
		* CFrame.Angles(0, randomGenerator:NextNumber(0, math.pi), 0), Enum.Material.Slate, Palette.Rock)
end

ObstacleBuilders.Log = function(parent, x, z, length)
	createPart(parent, "Log", Vector3.new(length, 3, 3), groundCFrame(x, z, 1.2), Enum.Material.Wood, Palette.Wood, { shape = Enum.PartType.Cylinder })
end

ObstacleBuilders.Pine = function(parent, x, z)
	buildPine(parent, x, z, 1)
end

ObstacleBuilders.Stump = function(parent, x, z)
	createPart(parent, "Stump", Vector3.new(3, 5, 5), groundCFrame(x, z, 1.2) * CFrame.Angles(0, 0, math.rad(90)),
		Enum.Material.Wood, Palette.Wood, { shape = Enum.PartType.Cylinder })
end

ObstacleBuilders.Bush = function(parent, x, z)
	local bush = createPart(parent, "Bush", Vector3.new(8, 3, 8), groundCFrame(x, z, 1.3), Enum.Material.LeafyGrass, Palette.Bush)
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Sphere
	mesh.Parent = bush
end

ObstacleBuilders.SnowMound = function(parent, x, z)
	createPart(parent, "SnowMound", Vector3.new(20, 4, 16),
		groundCFrame(x, z, 1.5) * CFrame.Angles(math.rad(-slopeAt(z)), math.pi, 0), Enum.Material.Snow, Palette.Snow, { className = "WedgePart" })
end

ObstacleBuilders.IceFloe = function(parent, x, z)
	createPart(parent, "IceFloe", Vector3.new(10, 14, 10),
		CFrame.new(worldPoint(x, riverElevation - 9, z)) * CFrame.Angles(0, math.rad(randomGenerator:NextNumber(-4, 4)), 0),
		Enum.Material.Ice, Palette.Ice, { transparency = 0.1 })
end

ObstacleBuilders.IceSpike = function(parent, x, z)
	createPart(parent, "IceSpike", Vector3.new(4, 10, 4), groundCFrame(x, z, 4.5) * CFrame.Angles(0, math.rad(45), 0),
		Enum.Material.Ice, Palette.Ice, { transparency = 0.1 })
end

ObstacleBuilders.Sled = function(parent, x, z)
	local model = Instance.new("Model")
	model.Name = "Sled"
	model.Parent = parent
	createPart(model, "Deck", Vector3.new(6, 1.5, 10), groundCFrame(x, z, 1.8), Enum.Material.Wood, Palette.Red)
	createPart(model, "Back", Vector3.new(6, 2, 1), groundCFrame(x, z + 4.5, 3), Enum.Material.Wood, Palette.Red)
	for _, offset in ipairs({ -2.5, 2.5 }) do
		createPart(model, "Runner", Vector3.new(0.6, 0.6, 11), groundCFrame(x + offset, z, 0.6), Enum.Material.Metal, Palette.Dark)
	end
end

ObstacleBuilders.BrokenFence = function(parent, x, z, length)
	local model = Instance.new("Model")
	model.Name = "BrokenFence"
	model.Parent = parent
	local startX = x - length / 2
	local segmentLength = 8
	local segmentCount = math.floor(length / segmentLength)
	for index = 0, segmentCount do
		createPart(model, "Post", Vector3.new(1, 3.5, 1), groundCFrame(startX + index * segmentLength, z, 1.5), Enum.Material.Wood, Palette.Wood)
	end
	for index = 0, segmentCount - 1 do
		if index % 3 ~= 2 then
			local centerX = startX + index * segmentLength + segmentLength / 2
			createPart(model, "RailTop", Vector3.new(segmentLength, 0.6, 0.6), groundCFrame(centerX, z, 2.7), Enum.Material.Wood, Palette.Wood)
			createPart(model, "RailBottom", Vector3.new(segmentLength, 0.6, 0.6), groundCFrame(centerX, z, 1.4), Enum.Material.Wood, Palette.Wood)
		end
	end
end

ObstacleBuilders.Barrels = function(parent, x, z, width)
	local model = Instance.new("Model")
	model.Name = "Barrels"
	model.Parent = parent
	local offsets = (width and width > 5) and { { -4, 0 }, { 0, 3 }, { 4, 0 } } or { { 0, 0 } }
	for _, offset in ipairs(offsets) do
		for level = 0, 1 do
			createPart(model, "Barrel", Vector3.new(5, 5, 5), groundCFrame(x + offset[1], z + offset[2], 2.5 + level * 5) * CFrame.Angles(0, 0, math.rad(90)),
				Enum.Material.WoodPlanks, Palette.Wood, { shape = Enum.PartType.Cylinder })
		end
	end
end

ObstacleBuilders.Snowman = function(parent, x, z)
	local model = Instance.new("Model")
	model.Name = "Snowman"
	model.Parent = parent
	createPart(model, "Base", Vector3.new(8, 8, 8), groundCFrame(x, z, 3.5), Enum.Material.Snow, Palette.Snow, { shape = Enum.PartType.Ball })
	createPart(model, "Body", Vector3.new(6, 6, 6), groundCFrame(x, z, 9.5), Enum.Material.Snow, Palette.Snow, { shape = Enum.PartType.Ball })
	createPart(model, "Head", Vector3.new(4, 4, 4), groundCFrame(x, z, 14), Enum.Material.Snow, Palette.Snow, { shape = Enum.PartType.Ball })
	createPart(model, "Nose", Vector3.new(0.6, 0.6, 2), groundCFrame(x, z - 2.2, 14), Enum.Material.SmoothPlastic, Palette.Orange)
end

ObstacleBuilders.Cabin = function(parent, x, z)
	local model = Instance.new("Model")
	model.Name = "Cabin"
	model.Parent = parent
	local base = elevationAt(z)
	createPart(model, "Walls", Vector3.new(30, 14, 24), CFrame.new(worldPoint(x, base + 5, z)), Enum.Material.WoodPlanks, Palette.Wood)
	createPart(model, "RoofFront", Vector3.new(30, 7, 12), CFrame.new(worldPoint(x, base + 15.5, z + 6)), Enum.Material.Snow, Palette.Snow, { className = "WedgePart" })
	createPart(model, "RoofBack", Vector3.new(30, 7, 12), CFrame.new(worldPoint(x, base + 15.5, z - 6)) * CFrame.Angles(0, math.pi, 0), Enum.Material.Snow, Palette.Snow, { className = "WedgePart" })
end

local obstacleLayout = {
	{ "Pine", 230, -52 }, { "Rock", 250, -25 }, { "Rock", 290, 20 }, { "Rock", 330, -5 }, { "Pine", 340, -50 }, { "Rock", 360, 40 },
	{ "Log", 400, -15, 60 }, { "Rock", 405, 42 }, { "Pine", 430, 52 }, { "Rock", 450, -40 }, { "Rock", 455, 10 }, { "Log", 495, 0, 120 },
	{ "Pine", 550, -30 }, { "Pine", 565, 20 }, { "Pine", 600, -5 }, { "Pine", 625, 40 }, { "Pine", 650, -40 }, { "Stump", 670, 10 },
	{ "Pine", 700, -20 }, { "Pine", 705, 28 }, { "Log", 750, 20, 50 }, { "Bush", 752, -35 }, { "SnowMound", 800, -10 },
	{ "Pine", 830, 35 }, { "Pine", 840, -45 }, { "Stump", 860, 5 },
	{ "IceFloe", 935, -45 }, { "IceFloe", 935, -15 }, { "IceFloe", 935, 15 }, { "IceFloe", 935, 45 },
	{ "IceFloe", 955, -30 }, { "IceFloe", 955, 0 }, { "IceFloe", 955, 30 },
	{ "IceFloe", 975, -45 }, { "IceFloe", 975, -15 }, { "IceFloe", 975, 15 }, { "IceFloe", 975, 45 },
	{ "Boulder", 1050, -15 }, { "IceSpike", 1090, 20 }, { "IceSpike", 1095, -30 }, { "Boulder", 1190, 20 },
	{ "IceSpike", 1285, -22 }, { "IceSpike", 1300, 2 }, { "IceSpike", 1315, 24 }, { "Boulder", 1350, -18 }, { "IceSpike", 1375, 22 },
	{ "BrokenFence", 1440, -35, 40 }, { "BrokenFence", 1440, 35, 40 }, { "Barrels", 1482, -11, 12 },
	{ "Snowman", 1520, 20 }, { "Sled", 1560, -25 }, { "Barrels", 1590, 35 }, { "BrokenFence", 1620, -15, 90 }, { "Snowman", 1630, 45 },
	{ "Cabin", 1530, 88 },
}

for _, entry in ipairs(obstacleLayout) do
	ObstacleBuilders[entry[1]](obstacleFolder, entry[3], entry[2], entry[4])
end

local spawnLocation = Instance.new("SpawnLocation")
spawnLocation.Name = "PlateauSpawn"
spawnLocation.Anchored = true
spawnLocation.Size = Vector3.new(30, 1, 30)
spawnLocation.CFrame = CFrame.new(worldPoint(0, 600.5, -110))
spawnLocation.Material = Enum.Material.SmoothPlastic
spawnLocation.Color = Palette.Yellow
spawnLocation.Parent = root

local slingshot = Instance.new("Model")
slingshot.Name = "Slingshot"
slingshot.Parent = root
createPart(slingshot, "Base", Vector3.new(16, 4, 16), CFrame.new(worldPoint(0, 602, -20)), Enum.Material.WoodPlanks, Palette.Wood)
for _, offset in ipairs({ -7, 7 }) do
	createPart(slingshot, "Post", Vector3.new(2, 12, 2), CFrame.new(worldPoint(offset, 610, -14)), Enum.Material.Wood, Palette.Wood)
end
createPart(slingshot, "Band", Vector3.new(14, 0.6, 0.6), CFrame.new(worldPoint(0, 615, -14)), Enum.Material.Fabric, Palette.Red)

for _, wall in ipairs({ { -119, 2, 160, -80 }, { 119, 2, 160, -80 } }) do
	createPart(root, "PlateauFence", Vector3.new(wall[2], 3, wall[3]), CFrame.new(worldPoint(wall[1], 601.5, wall[4])), Enum.Material.Wood, Palette.Wood)
end
createPart(root, "PlateauFence", Vector3.new(240, 3, 2), CFrame.new(worldPoint(0, 601.5, -159)), Enum.Material.Wood, Palette.Wood)

createPart(guideFolder, "Guide_WaitingLine", Vector3.new(60, 0.2, 35), CFrame.new(worldPoint(0, 600.1, -57.5)), Enum.Material.Neon, Palette.Yellow, { transparency = 0.7, canCollide = false })
buildAlongSlope(guideFolder, "Guide_LandingZone", 40, 180, -50, 50, 0.3, Enum.Material.Neon, Palette.Yellow, { transparency = 0.8, canCollide = false })

for _, checkpoint in ipairs({ { "CP1", 890 }, { "CP2", 1005 }, { "CP3", 1405 } }) do
	local halfWidth = (checkpoint[2] > 1000 and checkpoint[2] < 1400) and 40 or 60
	buildAlongSlope(guideFolder, "Checkpoint_" .. checkpoint[1], checkpoint[2] - 1, checkpoint[2] + 1, -halfWidth, halfWidth, 0.2, Enum.Material.Neon, Palette.Yellow, { transparency = 0.3, canCollide = false })
	createPart(guideFolder, "CheckpointPole_" .. checkpoint[1], Vector3.new(0.6, 12, 0.6), groundCFrame(-halfWidth + 2, checkpoint[2], 6), Enum.Material.Metal, Palette.White)
	createPart(guideFolder, "CheckpointFlag_" .. checkpoint[1], Vector3.new(0.2, 3, 4), groundCFrame(-halfWidth + 2, checkpoint[2] + 2, 10.5), Enum.Material.Fabric, Palette.Yellow)
end

local finish = Instance.new("Model")
finish.Name = "FinishArch"
finish.Parent = root
for _, offset in ipairs({ -62, 62 }) do
	createPart(finish, "Pillar", Vector3.new(4, 24, 4), groundCFrame(offset, 1700, 11), Enum.Material.WoodPlanks, Palette.Wood)
end
for index = 0, 15 do
	createPart(finish, "Banner", Vector3.new(8, 4, 2), groundCFrame(-60 + index * 8, 1700, 22),
		Enum.Material.SmoothPlastic, index % 2 == 0 and Palette.Black or Palette.White)
end
buildAlongSlope(finish, "FinishLine", 1699, 1701, -60, 60, 0.2, Enum.Material.Neon, Palette.White, { canCollide = false })
createPart(root, "ReturnPortal", Vector3.new(1, 20, 20), groundCFrame(0, 1785, 11) * CFrame.Angles(0, math.rad(90), 0),
	Enum.Material.Neon, Palette.Purple, { shape = Enum.PartType.Cylinder, transparency = 0.3, canCollide = false })

local decorationRandom = Random.new(42)
local z = 30
while z < 1790 do
	local skipRiver = z > 895 and z < 1003
	if not skipRiver then
		for _, side in ipairs({ -1, 1 }) do
			if decorationRandom:NextNumber() > 0.35 then
				local inCanyon = z > 1000 and z < 1400
				local x = side * ((inCanyon and 82 or 72) + decorationRandom:NextNumber() * 72)
				local nearCabin = side == 1 and z > 1505 and z < 1555 and x < 110
				if not nearCabin then
					buildPine(decorationFolder, x, z, 0.8 + decorationRandom:NextNumber() * 0.5)
				end
			end
		end
	end
	z += 14 + decorationRandom:NextNumber() * 10
end
for _, corner in ipairs({ { -100, -150 }, { 100, -150 }, { -105, -40 }, { 105, -40 } }) do
	buildPine(decorationFolder, corner[1], corner[2], 1.1)
end

local defaultSpawn = workspace:FindFirstChild("SpawnLocation")
if defaultSpawn and defaultSpawn:IsA("SpawnLocation") then defaultSpawn.Enabled = false end

local camera = workspace.CurrentCamera
if camera then
	camera.CFrame = CFrame.lookAt(worldPoint(0, 680, -260), worldPoint(0, 450, 450))
end

local partCount = 0
for _, descendant in ipairs(root:GetDescendants()) do
	if descendant:IsA("BasePart") then partCount += 1 end
end
print(("%s built: %d parts, finish elevation %.1f"):format(MAP_NAME, partCount, zones[#zones].e1))
