local CollectionService = game:GetService("CollectionService")

local LEVEL_FOLDER_NAME = "PenguinSlingshotMap_Level2"
local OFFSET_X = 6000
local BASE_Y = 600
local MOUNTAIN_HALF_WIDTH = 220
local V = Vector3.new
local M = Enum.Material

local levelOne = workspace:FindFirstChild("PenguinSlingshotMap_v01")
levelOne:SetAttribute("LevelId", 1)
local existing = workspace:FindFirstChild(LEVEL_FOLDER_NAME)
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name = LEVEL_FOLDER_NAME
root:SetAttribute("LevelId", 2)
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
local villageFolder = newFolder("Village")
local decorationFolder = newFolder("Decoration")
local gameplayFolder = newFolder("Gameplay")

local C = {
	Snow = Color3.fromRGB(244, 248, 253), SnowShade = Color3.fromRGB(219, 230, 241), Ice = Color3.fromRGB(207, 238, 255),
	Stone = Color3.fromRGB(141, 150, 161), StoneDark = Color3.fromRGB(111, 120, 132), Log = Color3.fromRGB(138, 90, 54),
	LogDark = Color3.fromRGB(106, 65, 39), LogLight = Color3.fromRGB(176, 124, 78), Plank = Color3.fromRGB(156, 106, 66),
	Door = Color3.fromRGB(74, 46, 28), Window = Color3.fromRGB(255, 201, 107), Red = Color3.fromRGB(200, 40, 30),
	RedDark = Color3.fromRGB(143, 26, 20), Gold = Color3.fromRGB(242, 179, 61), Corn = Color3.fromRGB(245, 194, 27),
	Pine = Color3.fromRGB(45, 106, 74), PineDark = Color3.fromRGB(36, 88, 61), Black = Color3.fromRGB(30, 40, 51),
	White = Color3.fromRGB(245, 245, 245), Orange = Color3.fromRGB(243, 156, 31), Metal = Color3.fromRGB(77, 83, 92),
	Sack = Color3.fromRGB(216, 195, 154), SackTie = Color3.fromRGB(168, 141, 95), Water = Color3.fromRGB(29, 58, 92),
	Wire = Color3.fromRGB(58, 42, 26), Yellow = Color3.fromRGB(255, 209, 102),
}

local function createPart(parent, name, size, cframe, color, options)
	options = options or {}
	local part = Instance.new(options.className or "Part")
	part.Name = name
	part.Anchored = true
	if options.shape then part.Shape = options.shape end
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = options.material or M.Plastic
	local smooth = options.material == M.Neon or options.noStuds
	part.TopSurface = smooth and Enum.SurfaceType.Smooth or Enum.SurfaceType.Studs
	part.BottomSurface = smooth and Enum.SurfaceType.Smooth or Enum.SurfaceType.Inlet
	if options.className == "WedgePart" then part.FrontSurface = Enum.SurfaceType.Studs end
	if options.transparency then part.Transparency = options.transparency end
	if options.noCollide then part.CanCollide = false end
	if options.noShadow then part.CastShadow = false end
	part.Parent = parent
	return part
end

local function newModel(name, parent)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent
	return model
end

local function at(base, x, y, z, rx, ry, rz)
	return base * CFrame.new(x, y, z) * CFrame.Angles(rx or 0, ry or 0, rz or 0)
end

local zones = {
	{ z0 = -140, z1 = 0, slope = 0 }, { z0 = 0, z1 = 20, cliff = true }, { z0 = 20, z1 = 228, slope = 14 },
	{ z0 = 228, z1 = 670, slope = 17 }, { z0 = 670, z1 = 826, slope = 12 }, { z0 = 826, z1 = 1164, slope = 18 },
	{ z0 = 1164, z1 = 1294, slope = 3 }, { z0 = 1294, z1 = 1684, slope = 20 }, { z0 = 1684, z1 = 1840, slope = 8 },
	{ z0 = 1840, z1 = 1910, slope = 0 },
}
local runningElevation = 0
for _, zone in ipairs(zones) do
	zone.e0 = runningElevation
	if zone.cliff then
		zone.e1 = -40
	else
		zone.e1 = runningElevation - (zone.z1 - zone.z0) * math.tan(math.rad(zone.slope))
	end
	runningElevation = zone.e1
end

local function elevationAt(zm)
	if zm <= -140 then return 0 end
	for _, zone in ipairs(zones) do
		if zm >= zone.z0 and zm <= zone.z1 then
			return zone.e0 + (zone.e1 - zone.e0) * (zm - zone.z0) / (zone.z1 - zone.z0)
		end
	end
	return zones[#zones].e1
end

local function worldPoint(x, y, zm)
	return V(OFFSET_X + x, BASE_Y + y, -zm)
end

local function ground(x, zm, height)
	return CFrame.new(worldPoint(x, elevationAt(zm) + (height or 0), zm))
end

local function buildBlock(parent, name, z0, z1, x0, x1, bottom, top, color, options)
	if top - bottom < 0.05 then return end
	return createPart(parent, name, V(x1 - x0, top - bottom, z1 - z0), CFrame.new(OFFSET_X + (x0 + x1) / 2, (bottom + top) / 2, -(z0 + z1) / 2), color, options)
end

local function buildGround(name, z0, z1)
	local high, low = BASE_Y + elevationAt(z0), BASE_Y + elevationAt(z1)
	buildBlock(terrainFolder, name .. "Base", z0, z1, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH, 0, low, C.SnowShade)
	if high - low > 0.05 then
		createPart(terrainFolder, name .. "Slope", V(MOUNTAIN_HALF_WIDTH * 2, high - low, z1 - z0),
			CFrame.new(OFFSET_X, (high + low) / 2, -(z0 + z1) / 2), C.Snow, { className = "WedgePart" })
	end
end

local boundaries = {}
for _, zone in ipairs(zones) do table.insert(boundaries, zone.z0) end

local function buildAlongSlope(parent, name, z0, z1, x0, x1, heightAbove, color, options)
	local cuts = { z0 }
	for _, boundary in ipairs(boundaries) do
		if boundary > z0 and boundary < z1 then table.insert(cuts, boundary) end
	end
	table.insert(cuts, z1)
	local parts = {}
	for index = 1, #cuts - 1 do
		local startPoint = worldPoint((x0 + x1) / 2, elevationAt(cuts[index]), cuts[index])
		local endPoint = worldPoint((x0 + x1) / 2, elevationAt(cuts[index + 1]), cuts[index + 1])
		local frame = CFrame.lookAt((startPoint + endPoint) / 2, endPoint) * CFrame.new(0, heightAbove / 2 - 1, 0)
		table.insert(parts, createPart(parent, name, V(x1 - x0, heightAbove + 2, (endPoint - startPoint).Magnitude), frame, color, options))
	end
	return parts
end

buildBlock(terrainFolder, "Plateau", -140, 0, -130, 130, 0, BASE_Y, C.Snow)
createPart(terrainFolder, "CliffSlope", V(260, 40, 20), CFrame.new(OFFSET_X, BASE_Y - 20, -10), C.Stone, { className = "WedgePart" })
buildBlock(terrainFolder, "CliffBase", 0, 20, -130, 130, 0, BASE_Y - 40, C.Stone)
for index = 3, #zones do
	buildGround("Zone" .. index, zones[index].z0, zones[index].z1)
end
buildBlock(terrainFolder, "EndWall", 1910, 1916, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH, 0, BASE_Y + elevationAt(1910) + 10, C.SnowShade)
for _, side in ipairs({ -1, 1 }) do
	buildAlongSlope(trackFolder, "SnowBank", 20, 1840, math.min(side * 60, side * 64), math.max(side * 60, side * 64), 6, C.SnowShade)
	buildBlock(trackFolder, "PlazaBank", 1840, 1906, math.min(side * 60, side * 64), math.max(side * 60, side * 64), BASE_Y + elevationAt(1840) - 1, BASE_Y + elevationAt(1840) + 6, C.SnowShade)
	createPart(terrainFolder, "PlateauFence", V(2, 3, 140), CFrame.new(worldPoint(side * 129, 1.5, -70)), C.Log)
end
createPart(terrainFolder, "PlateauFence", V(260, 3, 2), CFrame.new(worldPoint(0, 1.5, -139)), C.Log)
buildAlongSlope(trackFolder, "FrozenCreek", 1200, 1260, -MOUNTAIN_HALF_WIDTH, MOUNTAIN_HALF_WIDTH, 0.15, C.Ice, { noCollide = true, transparency = 0.15 })
for x = -56, 56, 8 do
	createPart(trackFolder, "EndFencePost", V(1, 4, 1), ground(x, 1913, 12), C.Log)
end
for x = -52, 52, 8 do
	createPart(trackFolder, "EndFenceRail", V(8, 0.6, 0.6), ground(x, 1913, 13), C.Log, { noStuds = true })
	createPart(trackFolder, "EndFenceRail", V(8, 0.6, 0.6), ground(x, 1913, 11.4), C.Log, { noStuds = true })
end

local function snowCap(parent, base, x, y, z, width, scale)
	scale = scale or 1
	createPart(parent, "SnowCapBase", V(width * 1.15 * scale, 0.6 * scale, width * 1.15 * scale), at(base, x, y, z), C.SnowShade, { noShadow = true })
	createPart(parent, "SnowCap", V(width * scale, 1.6 * scale, width * scale), at(base, x, y + scale, z), C.Snow)
	createPart(parent, "SnowCapTop", V(width * 0.7 * scale, scale, width * 0.7 * scale), at(base, x, y + 2.2 * scale, z), C.Snow, { noShadow = true })
end

local function lantern(parent, topFrame, scale, stringLength)
	local model = newModel("Lantern", parent)
	local detail = { noCollide = true, noShadow = true, noStuds = true }
	local b = -stringLength
	createPart(model, "String", V(0.15, stringLength, 0.15), topFrame * CFrame.new(0, -stringLength / 2, 0), C.Wire, detail)
	createPart(model, "CapTop", V(scale, 0.3 * scale, scale), topFrame * CFrame.new(0, b - 0.15 * scale, 0), C.Gold, detail)
	createPart(model, "Body", V(1.6 * scale, 1.9 * scale, 1.6 * scale), topFrame * CFrame.new(0, b - 1.25 * scale, 0), C.Red, { noCollide = true, material = M.Neon })
	createPart(model, "CapBottom", V(scale, 0.3 * scale, scale), topFrame * CFrame.new(0, b - 2.35 * scale, 0), C.Gold, detail)
	createPart(model, "Tassel", V(0.25 * scale, 0.9 * scale, 0.25 * scale), topFrame * CFrame.new(0, b - 2.95 * scale, 0), C.Gold, detail)
end

local function corn(parent, base, x, y, z)
	for index = 0, 2 do
		createPart(parent, "Corn", V(0.7, 2.4, 0.7), at(base, x + (index - 1) * 0.75, y - 1.2 - (index % 2) * 0.3, z), C.Corn, { noCollide = true, noShadow = true, noStuds = true })
	end
	createPart(parent, "CornHolder", V(2.4, 0.3, 0.6), at(base, x, y + 0.1, z), C.LogDark, { noCollide = true, noShadow = true, noStuds = true })
end

local function buildPine(parent, x, zm, scale)
	local model = newModel("Pine", parent)
	local base = ground(x, zm)
	createPart(model, "Trunk", V(2.5, 12, 2.5) * scale, at(base, 0, 6 * scale, 0), C.LogDark, { noStuds = true })
	for index, tier in ipairs({ { 14, 9, 13 }, { 11, 8, 20 }, { 7.5, 7, 26.5 }, { 4, 6, 32 } }) do
		local rotation = math.rad(45 * index)
		createPart(model, "Canopy", V(tier[1], tier[2], tier[1]) * scale, at(base, 0, tier[3] * scale, 0, 0, rotation, 0), index % 2 == 0 and C.Pine or C.PineDark)
		createPart(model, "CanopySnow", V(tier[1] * 0.82, 0.8, tier[1] * 0.82) * scale, at(base, 0, (tier[3] + tier[2] / 2 + 0.3) * scale, 0, 0, rotation, 0), C.Snow, { noShadow = true })
	end
	return model
end

local random = Random.new(21)

local function buildHouse(x, zm, width, depth, side)
	local model = newModel("House", villageFolder)
	local high = math.max(elevationAt(zm - depth / 2 - 2), elevationAt(zm + depth / 2 + 2))
	local low = math.min(elevationAt(zm - depth / 2 - 2), elevationAt(zm + depth / 2 + 2))
	local base = CFrame.new(worldPoint(x, high, zm)) * CFrame.Angles(0, side < 0 and math.pi / 2 or -math.pi / 2, 0)
	local front = depth / 2
	local detail = { noCollide = true, noShadow = true, noStuds = true }
	local foundation = high - low + 2
	createPart(model, "Foundation", V(width + 2, foundation, depth + 2), at(base, 0, -foundation / 2 + 1, 0), C.Stone)
	createPart(model, "Walls", V(width, 9, depth), at(base, 0, 5.5, 0), C.Log, { noStuds = true })
	for index = 1, 4 do
		createPart(model, "LogLine", V(width + 0.3, 0.35, depth + 0.3), at(base, 0, 1 + index * 1.9, 0), C.LogDark, detail)
	end
	for _, sx in ipairs({ -1, 1 }) do
		for _, sz in ipairs({ -1, 1 }) do
			createPart(model, "CornerLog", V(1, 9, 1), at(base, sx * width / 2, 5.5, sz * depth / 2), C.LogLight, detail)
		end
	end
	createPart(model, "Door", V(3.2, 5.4, 0.3), at(base, 0, 3.7, front + 0.05), C.Door, detail)
	createPart(model, "DoorSnow", V(3.8, 0.4, 0.6), at(base, 0, 6.6, front + 0.3), C.Snow, detail)
	for _, sx in ipairs({ -1, 1 }) do
		local wx = sx * (width / 4 + 1)
		createPart(model, "Window", V(2.8, 2.4, 0.25), at(base, wx, 5.6, front + 0.06), C.Window, { noCollide = true, material = M.Neon })
		createPart(model, "Sill", V(3.4, 0.35, 0.4), at(base, wx, 4.25, front + 0.15), C.LogDark, detail)
		createPart(model, "Mullion", V(0.25, 2.4, 0.3), at(base, wx, 5.6, front + 0.12), C.LogDark, detail)
		createPart(model, "SillSnow", V(3.6, 0.5, 0.8), at(base, wx, 4.5, front + 0.3), C.Snow, detail)
	end
	createPart(model, "Eave", V(width + 4.6, 0.7, depth + 4.6), at(base, 0, 10.35, 0), C.LogDark, { noStuds = true })
	local y = 10.7
	for index, layer in ipairs({ { width + 4.4, 2.2, depth + 4.4 }, { width + 3.4, 2, depth + 3 }, { width + 2, 1.8, depth + 1.2 }, { width + 0.2, 1.4, depth - 1.6 }, { width - 2.4, 1, depth - 4.8 } }) do
		createPart(model, "RoofSnow", V(layer[1], layer[2], layer[3]), at(base, 0, y + layer[2] / 2, 0), index == 1 and C.SnowShade or C.Snow, { noShadow = index > 2 })
		y += layer[2]
	end
	for index = 0, math.floor(width / 3) - 1 do
		createPart(model, "SnowDrip", V(1.2, 0.8 + random:NextNumber(), 0.8), at(base, -width / 2 + 1.5 + index * 3, 9.7, front + 2.1), C.Snow, detail)
	end
	local chimneyX = width / 4 * (random:NextNumber() > 0.5 and 1 or -1)
	createPart(model, "Chimney", V(2.4, 6, 2.4), at(base, chimneyX, 15, -depth / 6), C.Stone)
	snowCap(model, base, chimneyX, 18, -depth / 6, 2.4, 0.9)
	lantern(model, at(base, -width / 2 + 1.5, 9.8, front + 2.6), 1, 1.4)
	lantern(model, at(base, width / 2 - 1.5, 9.8, front + 2.6), 1, 1.4)
	if random:NextNumber() > 0.3 then corn(model, base, -(width / 4 + 1) - 2.3, 7.4, front + 0.6) end
	if random:NextNumber() > 0.4 then
		for index = 0, 4 do
			createPart(model, "Firewood", V(1.2, 1.2, 1.2), at(base, width / 2 + 2, 1.6 + math.floor(index / 2) * 1.2, -depth / 4 + (index % 2) * 1.3), C.LogLight, detail)
		end
		createPart(model, "FirewoodSnow", V(2, 0.6, 3), at(base, width / 2 + 2, 4.4, -depth / 4 + 0.6), C.Snow, detail)
	end
	for index = 0, 4 do
		local px = -width / 2 + index * (width / 4)
		createPart(model, "YardPost", V(0.9, 3, 0.9), at(base, px, 1.5, front + 7), C.Log, { noShadow = true })
		createPart(model, "YardPostSnow", V(2.2, 0.9, 2.2), at(base, px, 3.4, front + 7), C.Snow, { noShadow = true })
		createPart(model, "YardPostSnowTop", V(1.4, 0.6, 1.4), at(base, px, 4.1, front + 7), C.Snow, { noShadow = true })
	end
	createPart(model, "YardRail", V(width, 0.4, 0.3), at(base, 0, 2.4, front + 7), C.Log, detail)
end

local Builders = {}
local OBSTACLE = {}

function Builders.post(model, base)
	createPart(model, "Post", V(3, 7, 3), at(base, 0, 3, 0), C.Log, { noStuds = true })
	createPart(model, "CapBase", V(7.6, 0.8, 7.6), at(base, 0, 6.8, 0), C.SnowShade)
	createPart(model, "Cap", V(7, 2.4, 7), at(base, 0, 8.2, 0), C.Snow)
	createPart(model, "CapMiddle", V(5, 1.6, 5), at(base, 0, 10.2, 0), C.Snow)
	createPart(model, "CapTop", V(2.6, 0.8, 2.6), at(base, 0, 11.4, 0), C.Snow)
end

function Builders.fence(model, base, length)
	for px = -length / 2, length / 2 + 0.1, 5 do
		createPart(model, "Post", V(0.8, 3.5, 0.8), at(base, px, 1.75, 0), C.Log, { noStuds = true })
		createPart(model, "PostSnow", V(1.8, 0.8, 1.8), at(base, px, 3.9, 0), C.Snow)
	end
	for px = -length / 2, length / 2 - 0.1, 5 do
		createPart(model, "RailTop", V(5, 0.5, 0.5), at(base, px + 2.5, 2.6, 0), C.LogDark, { noStuds = true })
		createPart(model, "RailBottom", V(5, 0.5, 0.5), at(base, px + 2.5, 1.3, 0), C.LogDark, { noStuds = true })
		createPart(model, "RailSnow", V(5, 0.4, 0.9), at(base, px + 2.5, 2.95, 0), C.Snow)
	end
end

function Builders.wood(model, base)
	for index = 0, 5 do
		for layer = 0, 1 do
			createPart(model, "Firewood", V(4, 1.5, 1.5), at(base, -3 + index * 1.2 + layer * 0.6, 0.75 + layer * 1.3, 0, 0, math.pi / 2, 0), C.LogLight, { shape = Enum.PartType.Cylinder })
		end
	end
	createPart(model, "Snow", V(8.4, 0.8, 4.4), at(base, 0, 3.1, 0), C.Snow)
end

function Builders.sacks(model, base)
	for _, sack in ipairs({ { -2.6, 1.1, 0 }, { 0, 1.1, 0.3 }, { 2.6, 1.1, -0.2 }, { -1.3, 2.7, 0 }, { 1.3, 2.7, 0.1 } }) do
		createPart(model, "Sack", V(2.8, 2, 3.2), at(base, sack[1], sack[2], sack[3]), C.Sack, { noStuds = true })
		createPart(model, "SackTie", V(1, 0.5, 1), at(base, sack[1], sack[2] + 1.2, sack[3]), C.SackTie, { noStuds = true, noShadow = true })
	end
	createPart(model, "Snow", V(5, 0.5, 3), at(base, 0, 3.8, 0), C.Snow)
end

function Builders.bench(model, base)
	createPart(model, "Seat", V(8, 0.6, 2.4), at(base, 0, 2.4, 0), C.Plank)
	createPart(model, "Back", V(8, 1.4, 0.4), at(base, 0, 3.4, 1.1), C.Plank, { noStuds = true })
	for _, side in ipairs({ -1, 1 }) do
		createPart(model, "Leg", V(0.6, 2.1, 2), at(base, side * 3.4, 1.05, 0), C.LogDark, { noStuds = true })
	end
	createPart(model, "SeatSnow", V(7.6, 0.6, 2.2), at(base, 0, 3, 0), C.Snow)
	createPart(model, "BackSnow", V(7.6, 0.4, 0.6), at(base, 0, 4.3, 1.1), C.Snow)
end

function Builders.well(model, base)
	for _, wall in ipairs({ { 0, -3.4, 8, 1.2 }, { 0, 3.4, 8, 1.2 }, { -3.4, 0, 1.2, 5.6 }, { 3.4, 0, 1.2, 5.6 } }) do
		createPart(model, "StoneRing", V(wall[3], 3, wall[4]), at(base, wall[1], 1.5, wall[2]), C.Stone)
	end
	createPart(model, "Water", V(5.6, 0.4, 5.6), at(base, 0, 2.6, 0), C.Water, { noStuds = true })
	for _, side in ipairs({ -1, 1 }) do
		createPart(model, "Post", V(0.8, 7, 0.8), at(base, side * 3.4, 6.5, 0), C.LogDark, { noStuds = true })
	end
	createPart(model, "Crossbar", V(8, 0.6, 0.6), at(base, 0, 9.6, 0), C.LogDark, { noStuds = true })
	createPart(model, "Rope", V(0.15, 3, 0.15), at(base, 0, 8, 0), C.Wire, { noStuds = true, noCollide = true })
	createPart(model, "Bucket", V(1.2, 1.2, 1.2), at(base, 0, 6.2, 0), C.Plank, { noStuds = true })
	local y = 9.9
	for index, layer in ipairs({ { 10, 0.6, 7 }, { 10.4, 1.4, 7.4 }, { 9, 1.2, 6 }, { 6, 1, 3.6 }, { 2.6, 0.8, 1.6 } }) do
		createPart(model, "Roof", V(layer[1], layer[2], layer[3]), at(base, 0, y + layer[2] / 2, 0), index == 1 and C.RedDark or (index == 2 and C.SnowShade or C.Snow))
		y += layer[2]
	end
end

function Builders.snowwall(model, _, gapX, zm)
	local base = ground(0, zm)
	for _, segment in ipairs({ { -60, gapX - 9 }, { gapX + 9, 60 } }) do
		local width = segment[2] - segment[1]
		if width > 0 then
			local cx = (segment[1] + segment[2]) / 2
			createPart(model, "Wall", V(width, 7, 4), at(base, cx, 3.5, 0), C.SnowShade)
			createPart(model, "WallSnow", V(width - 1, 1.6, 3.4), at(base, cx, 7.8, 0), C.Snow)
			createPart(model, "WallTop", V(math.max(1, width - 4), 1, 2), at(base, cx, 9.1, 0), C.Snow)
			for index = 0, math.floor(width / 6) - 1 do
				createPart(model, "SnowLump", V(1.6, 1.6, 1.6), at(base, segment[1] + 3 + index * 6, 1, -2.6), C.Snow, { noShadow = true })
			end
		end
	end
	for _, side in ipairs({ -1, 1 }) do
		lantern(model, at(base, gapX + side * 9.5, 9.4, -2.4), 1, 1)
	end
end

function Builders.cart(model, base)
	createPart(model, "Bed", V(6, 1, 9), at(base, 0, 3, 0), C.Plank)
	for _, side in ipairs({ -1, 1 }) do
		createPart(model, "Side", V(0.4, 1.6, 9), at(base, side * 3, 4.2, 0), C.LogDark, { noStuds = true })
		createPart(model, "Wheel", V(0.6, 3.6, 3.6), at(base, side * 3.4, 1.8, 1.5), C.LogDark, { shape = Enum.PartType.Cylinder })
		createPart(model, "Handle", V(0.5, 0.5, 6), at(base, side, 3, -7), C.LogDark, { noStuds = true })
	end
	for index = 0, 3 do
		createPart(model, "Sack", V(2.4, 2.6, 2.4), at(base, (index % 2 - 0.5) * 2.6, 4.8 + (index > 1 and 2 or 0), (index < 2 and -1.5 or 1) + (index > 1 and 0 or 2.5)), C.Sack, { noStuds = true })
	end
	createPart(model, "Snow", V(5.4, 0.8, 8), at(base, 0, 8.6, 0), C.Snow)
end

function Builders.stall(model, base)
	createPart(model, "Counter", V(10, 4, 5), at(base, 0, 2, 0), C.Plank)
	for _, sx in ipairs({ -1, 1 }) do
		for _, sz in ipairs({ -1, 1 }) do
			createPart(model, "Post", V(0.8, 9, 0.8), at(base, sx * 4.6, 4.5, sz * 2.6), C.LogDark, { noStuds = true })
		end
	end
	for index = 0, 5 do
		createPart(model, "Awning", V(1.9, 0.5, 7.4), at(base, -4.75 + index * 1.9, 9.4, -0.4, 0.18, 0, 0), index % 2 == 1 and C.White or C.Red, { noStuds = true })
	end
	createPart(model, "AwningSnow", V(11, 0.8, 7.4), at(base, 0, 10.2, -0.4, 0.18, 0, 0), C.Snow)
	createPart(model, "AwningSnowTop", V(9, 0.8, 5), at(base, 0, 10.9, -0.2, 0.18, 0, 0), C.Snow, { noShadow = true })
	for _, good in ipairs({ { -3.2, Color3.fromRGB(224, 102, 43) }, { -1.2, C.Gold }, { 1, C.Red }, { 3.2, Color3.fromRGB(124, 179, 66) } }) do
		createPart(model, "Goods", V(1.4, 1.2, 1.4), at(base, good[1], 4.6, -1), good[2], { noStuds = true, noShadow = true })
		createPart(model, "Goods", V(1.2, 1, 1.2), at(base, good[1] + 0.3, 4.5, 0.8), good[2], { noStuds = true, noShadow = true })
	end
	lantern(model, at(base, -4.6, 8.9, -3.4), 0.9, 0.8)
	lantern(model, at(base, 4.6, 8.9, -3.4), 0.9, 0.8)
end

function Builders.barrel(model, base)
	for index = 0, 2 do
		local bx = index == 2 and 0 or (index - 0.5) * 4.4
		local by = index == 2 and 6.9 or 2.3
		createPart(model, "Barrel", V(4.6, 4.6, 4.6), at(base, bx, by, 0, 0, 0, math.pi / 2), C.Plank, { shape = Enum.PartType.Cylinder })
		createPart(model, "Hoop", V(4.7, 0.3, 4.7), at(base, bx, by + 1.4, 0), C.Metal, { noStuds = true, noShadow = true })
	end
	createPart(model, "Snow", V(4, 0.8, 4), at(base, 0, 9.6, 0), C.Snow)
end

function Builders.sled(model, base)
	createPart(model, "Deck", V(6, 1.4, 10), at(base, 0, 1.8, 0), C.Red)
	createPart(model, "Back", V(6, 2.2, 1), at(base, 0, 3.2, 4.5), C.Red)
	for _, side in ipairs({ -1, 1 }) do
		createPart(model, "Runner", V(0.5, 0.5, 11), at(base, side * 2.5, 0.5, 0), C.Metal, { noStuds = true })
	end
	createPart(model, "Snow", V(5, 0.5, 7), at(base, 0, 2.7, -0.5), C.Snow, { noShadow = true })
end

function Builders.lamp(model, base)
	createPart(model, "Pole", V(1.6, 14, 1.6), at(base, 0, 7, 0), C.LogDark, { noStuds = true })
	createPart(model, "Arm", V(5, 0.6, 0.8), at(base, 1.6, 13.4, 0), C.LogDark, { noStuds = true })
	lantern(model, at(base, 3.6, 13.1, 0), 1.1, 1)
	snowCap(model, base, 0, 14, 0, 1.6, 1)
end

function Builders.ball(model, base)
	for _, ball in ipairs({ { 0, 4, 0, 8 }, { -3.5, 2.6, 2, 5.2 }, { 3.2, 2.4, -1.5, 4.8 } }) do
		createPart(model, "Snowball", V(ball[4], ball[4], ball[4]), at(base, ball[1], ball[2], ball[3]), C.Snow, { shape = Enum.PartType.Ball })
	end
end

function Builders.snowman(model, base)
	for _, ball in ipairs({ { 8, 3.5 }, { 6, 9.5 }, { 4, 14 } }) do
		createPart(model, "Snowball", V(ball[1], ball[1], ball[1]), at(base, 0, ball[2], 0), C.Snow, { shape = Enum.PartType.Ball })
	end
	createPart(model, "Nose", V(0.6, 0.6, 2), at(base, 0, 14, -2.6), C.Orange, { noStuds = true, noCollide = true })
	createPart(model, "Scarf", V(4.4, 0.8, 4.4), at(base, 0, 11.6, 0), C.Red, { noStuds = true })
	createPart(model, "Hat", V(3, 2.4, 3), at(base, 0, 16.8, 0), C.Black)
end

function Builders.pillar(model, base, _, _, x)
	createPart(model, "Pillar", V(3, 16, 3), at(base, 0, 8, 0), C.Red, { noStuds = true })
	createPart(model, "Base", V(4, 1, 4), at(base, 0, 0.5, 0), C.Stone)
	createPart(model, "Capital", V(4, 1, 4), at(base, 0, 15.5, 0), C.Gold)
	if math.abs(x) < 40 then corn(model, base, 0, 11, -1.7) end
end

function Builders.icechunk(model, base, _, _, x)
	local turn = (x % 3) * 0.3
	createPart(model, "Ice", V(7, 3, 6), at(base, 0, 1.5, 0, 0, turn, 0), C.Ice, { transparency = 0.1 })
	createPart(model, "IceTop", V(4, 1.5, 3), at(base, 0.8, 3.4, 0.4, 0, turn, 0), Color3.fromRGB(232, 248, 255), { transparency = 0.1 })
end

function Builders.bridge(model, base)
	for index = 0, 7 do
		local t = index / 7
		local zz = (t - 0.5) * 40
		local hy = math.sin(t * math.pi) * 4
		createPart(model, "Plank", V(16, 1, 5.4), at(base, 0, hy - 0.3, -zz, math.cos(t * math.pi) * 0.3, 0, 0), C.Plank)
		for _, side in ipairs({ -1, 1 }) do
			createPart(model, "RailPost", V(0.8, 3, 0.8), at(base, side * 8, hy + 2.5, -zz), C.RedDark, { noStuds = true })
			createPart(model, "RailPostSnow", V(1.4, 0.6, 1.4), at(base, side * 8, hy + 4.3, -zz), C.Snow, { noShadow = true })
		end
	end
	for _, side in ipairs({ -1, 1 }) do
		for index = 0, 6 do
			local t = (index + 0.5) / 7
			createPart(model, "Rail", V(0.4, 0.4, 5.6), at(base, side * 8, math.sin(t * math.pi) * 4 + 3.4, -(t - 0.5) * 40), C.Red, { noStuds = true, noShadow = true })
		end
	end
end

function Builders.icestack(model, base)
	for _, piece in ipairs({ { 0, 1.6, 0, 6, 3.2, 6 }, { -0.8, 4.6, 0.4, 4.6, 2.8, 4.6 }, { 0.6, 7.3, -0.3, 3, 2.6, 3 } }) do
		createPart(model, "IceBlock", V(piece[4], piece[5], piece[6]), at(base, piece[1], piece[2], piece[3], 0, piece[1] * 0.4, 0), C.Ice, { transparency = 0.12 })
	end
end

function Builders.statue(model, base)
	createPart(model, "Pedestal", V(7, 2, 7), at(base, 0, 1, 0), C.Stone)
	createPart(model, "PedestalTop", V(6, 1, 6), at(base, 0, 2.5, 0), C.StoneDark)
	local ice = { transparency = 0.14, noStuds = true }
	createPart(model, "IceBody", V(4.4, 5, 4), at(base, 0, 5.5, 0), C.Ice, ice)
	createPart(model, "IceHead", V(4, 2.8, 3.8), at(base, 0, 9.4, 0), C.Ice, ice)
	createPart(model, "IceBelly", V(3.2, 3.6, 0.3), at(base, 0, 5.2, -2.05), Color3.fromRGB(232, 248, 255), ice)
	for _, side in ipairs({ -1, 1 }) do
		createPart(model, "IceFlipper", V(0.6, 3.4, 2.2), at(base, side * 2.5, 6, 0, 0, 0, side * 0.25), Color3.fromRGB(169, 220, 245), ice)
	end
	createPart(model, "IceBeak", V(1.3, 0.6, 1.4), at(base, 0, 8.8, -2.4), Color3.fromRGB(159, 211, 240), ice)
	createPart(model, "IceBeanie", V(4.2, 1, 4), at(base, 0, 11.3, 0), Color3.fromRGB(217, 243, 255), ice)
	createPart(model, "IcePompom", V(1.2, 1.2, 1.2), at(base, 0, 12.3, 0), C.White, ice)
end

function Builders.pine(model, _, _, zm, x)
	buildPine(model, x, zm, 1)
end

function Builders.log(model, base, length)
	createPart(model, "Log", V(length, 3, 3), at(base, 0, 1.3, 0), C.Log, { shape = Enum.PartType.Cylinder })
	createPart(model, "LogSnow", V(length * 0.9, 0.6, 2), at(base, 0, 2.9, 0), C.Snow, { noShadow = true })
end

local layout = {
	{ "post", 255, -30 }, { "post", 280, 25 }, { "wood", 295, -45 }, { "post", 318, -5 }, { "post", 345, 40 }, { "post", 372, -40 }, { "sacks", 392, 10 }, { "post", 410, -18 }, { "fence", 432, 22, 40 }, { "post", 455, -25 }, { "post", 478, 35 }, { "well", 500, 0 }, { "post", 525, -45 }, { "fence", 548, -15, 50 }, { "post", 570, 30 }, { "snowwall", 592, 22 }, { "post", 615, -30 }, { "bench", 640, 25 }, { "post", 655, -2 },
	{ "lamp", 690, -35 }, { "lamp", 690, 35 }, { "sacks", 702, 0 },
	{ "pillar", 722, -20 }, { "pillar", 722, 20 }, { "pillar", 774, -20 }, { "pillar", 774, 20 }, { "pillar", 722, -58 }, { "pillar", 722, 58 }, { "pillar", 774, -58 }, { "pillar", 774, 58 },
	{ "bench", 748, -39 }, { "sacks", 748, 39 }, { "sled", 805, -30 }, { "barrel", 812, 30 },
	{ "cart", 845, -20 }, { "stall", 862, 46 }, { "barrel", 872, 22 }, { "sled", 890, 5 }, { "stall", 905, -46 }, { "ball", 930, -8 }, { "snowman", 950, 30 }, { "wood", 962, -30 }, { "sled", 980, -10 }, { "barrel", 995, 40 }, { "cart", 1012, 12 }, { "stall", 1030, 46 }, { "sacks", 1045, -22 }, { "lamp", 1065, -45 }, { "lamp", 1065, 45 }, { "ball", 1080, 18 }, { "barrel", 1100, -35 }, { "bench", 1115, 5 }, { "stall", 1125, -46 }, { "snowman", 1140, -12 }, { "sacks", 1152, 32 },
	{ "bench", 1180, -30 }, { "icechunk", 1212, -30 }, { "icechunk", 1220, 26 }, { "icechunk", 1242, -48 }, { "icechunk", 1238, 46 }, { "icechunk", 1254, -22 }, { "bridge", 1230, 0 }, { "icestack", 1275, -36 }, { "icestack", 1280, 36 },
	{ "pine", 1320, -25 }, { "pine", 1345, 30 }, { "pine", 1375, 0 }, { "pine", 1400, -40 }, { "pine", 1425, 20 }, { "post", 1445, -45 }, { "pine", 1460, -10 }, { "log", 1492, 0, 120 }, { "pine", 1515, 40 }, { "pine", 1535, -30 }, { "wood", 1552, 10 }, { "pine", 1570, 15 }, { "post", 1590, -40 }, { "pine", 1610, -15 }, { "pine", 1630, 35 }, { "log", 1655, -20, 70 }, { "wood", 1670, 30 },
	{ "lamp", 1710, -30 }, { "lamp", 1710, 30 }, { "bench", 1732, -15 }, { "statue", 1755, 0 }, { "sacks", 1772, 30 },
}
for _, entry in ipairs(layout) do
	local kind, zm, x, extra = entry[1], entry[2], entry[3], entry[4]
	local model = newModel(kind:sub(1, 1):upper() .. kind:sub(2), obstacleFolder)
	Builders[kind](model, ground(x, zm), extra or x, zm, x)
end

local pavilionSlope = math.rad(12)
local pavilionStart, pavilionEnd = 720, 776
local pavilionCenter = (pavilionStart + pavilionEnd) / 2
local pavilionDepth = (pavilionEnd - pavilionStart) / math.cos(pavilionSlope) + 10
for _, cx in ipairs({ -39, 0, 39 }) do
	local model = newModel("PavilionRoof", decorationFolder)
	local base = ground(cx, pavilionCenter, 17) * CFrame.Angles(-pavilionSlope, 0, 0)
	createPart(model, "Frame", V(32, 1.2, pavilionDepth), at(base, 0, 0, 0), C.RedDark, { noStuds = true })
	for _, edge in ipairs({ -1, 1 }) do
		createPart(model, "Trim", V(33, 1.6, 1.4), at(base, 0, -0.9, edge * pavilionDepth / 2), C.Red, { noStuds = true })
		createPart(model, "SideBeam", V(1.4, 1.6, pavilionDepth + 1.4), at(base, edge * 16, -0.9, 0), C.Red, { noStuds = true })
	end
	createPart(model, "GoldTrim", V(33.4, 0.4, pavilionDepth + 2), at(base, 0, 0.75, 0), C.Gold, { noStuds = true, noShadow = true })
	local y = 0.95
	for index, layer in ipairs({ { 34, 2.4, pavilionDepth + 4 }, { 32, 2.4, pavilionDepth + 1.5 }, { 26, 2.2, pavilionDepth - 6 }, { 18, 2, pavilionDepth - 14 }, { 10, 1.6, pavilionDepth - 24 }, { 4, 1.2, pavilionDepth - 32 } }) do
		createPart(model, "RoofSnow", V(layer[1], layer[2], layer[3]), at(base, 0, y + layer[2] / 2, 0), index == 1 and C.SnowShade or C.Snow, { noShadow = index > 2 })
		y += layer[2]
	end
	for _, zz in ipairs({ pavilionStart + 3, pavilionEnd - 3 }) do
		for _, xx in ipairs({ -9, 9 }) do
			lantern(model, ground(cx + xx, zz, 17 - 1.2), 1.2, 1.4)
		end
	end
end

local function buildVillageGate(zm, label, width, height)
	local model = newModel("VillageGate", decorationFolder)
	local base = ground(0, zm)
	for _, side in ipairs({ -1, 1 }) do
		createPart(model, "PillarBase", V(5, 4, 5), at(base, side * width / 2, 2, 0), C.Stone)
		createPart(model, "Pillar", V(3.6, height, 3.6), at(base, side * width / 2, height / 2 + 4, 0), C.Red, { noStuds = true })
		createPart(model, "PillarCap", V(4.4, 1, 4.4), at(base, side * width / 2, height + 3, 0), C.Gold, { noStuds = true })
	end
	createPart(model, "TopBeam", V(width + 10, 2.4, 3.4), at(base, 0, height + 4.2, 0), C.Red, { noStuds = true })
	createPart(model, "LowerBeam", V(width + 6, 1.2, 2.6), at(base, 0, height - 0.2, 0), C.RedDark, { noStuds = true })
	local y = height + 5.4
	for index, layer in ipairs({ { width + 14, 1.4, 6.4 }, { width + 13, 2.2, 6 }, { width + 11, 2, 4.6 }, { width + 6, 1.4, 3 } }) do
		createPart(model, "Roof", V(layer[1], layer[2], layer[3]), at(base, 0, y + layer[2] / 2, 0), index == 1 and C.RedDark or (index == 2 and C.SnowShade or C.Snow))
		y += layer[2]
	end
	local board = createPart(model, "SignBoard", V(18, 5.6, 0.8), at(base, 0, height - 3.6, 0), C.RedDark, { noStuds = true })
	for _, face in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back }) do
		local surface = Instance.new("SurfaceGui")
		surface.Face = face
		surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		surface.PixelsPerStud = 40
		surface.Parent = board
		local text = Instance.new("TextLabel")
		text.Size = UDim2.fromScale(1, 1)
		text.BackgroundTransparency = 1
		text.Text = label
		text.Font = Enum.Font.FredokaOne
		text.TextScaled = true
		text.TextColor3 = Color3.fromRGB(255, 215, 122)
		text.TextStrokeColor3 = Color3.fromRGB(90, 20, 10)
		text.TextStrokeTransparency = 0.2
		text.Parent = surface
	end
	for index = 0, 3 do
		lantern(model, at(base, (index - 1.5) * (width / 4), height - 0.8, 0), 1.3, 1.4)
	end
end
buildVillageGate(-90, "ALDEA NEVADA", 60, 16)
buildVillageGate(1800, "¡META!", 132, 20)

local function buildStringLights(zm)
	local model = newModel("StringLights", decorationFolder)
	for _, side in ipairs({ -1, 1 }) do
		createPart(model, "Pole", V(1.4, 22, 1.4), ground(side * 70, zm, 11), C.LogDark, { noStuds = true })
		snowCap(model, ground(side * 70, zm), 0, 22, 0, 1.4, 1)
	end
	createPart(model, "Wire", V(140, 0.15, 0.15), ground(0, zm, 20), C.Wire, { noStuds = true, noCollide = true, noShadow = true })
	for x = -60, 60, 10 do
		lantern(model, ground(x, zm, 20), 0.9, 0.6 + math.cos(x / 60 * math.pi / 2) * 1.4)
	end
end
for _, zm in ipairs({ 900, 1040, 1760 }) do buildStringLights(zm) end

for _, side in ipairs({ -1, 1 }) do
	for zm = 240, 1163, 14 do
		if zm <= 712 or zm >= 784 then
			local base = ground(side * 69, zm)
			createPart(decorationFolder, "BankPost", V(1.2, 4, 1.2), at(base, 0, 2, 0), C.Log, { noShadow = true })
			createPart(decorationFolder, "BankPostSnow", V(3, 1, 3), at(base, 0, 4.4, 0), C.Snow, { noShadow = true })
			createPart(decorationFolder, "BankPostSnowTop", V(2, 0.7, 2), at(base, 0, 5.2, 0), C.Snow, { noShadow = true })
		end
	end
end

local function inVillage(zm)
	return (zm > 30 and zm < 1294) or (zm > 1684 and zm < 1840)
end
for _, side in ipairs({ -1, 1 }) do
	local zm = 34 + (side > 0 and 24 or 0)
	while zm < 1835 do
		if inVillage(zm) then
			local width = 18 + math.round(random:NextNumber() * 8)
			local depth = 16 + math.round(random:NextNumber() * 6)
			buildHouse(side * (92 + random:NextNumber() * 36 + width / 2), zm, width, depth, side)
			zm += depth + 26 + random:NextNumber() * 20
		else
			buildPine(decorationFolder, side * (80 + random:NextNumber() * 60), zm, 0.9 + random:NextNumber() * 0.4)
			zm += 18 + random:NextNumber() * 12
		end
	end
end
local zm = 30
while zm < 1840 do
	for _, side in ipairs({ -1, 1 }) do
		if random:NextNumber() > 0.35 then
			buildPine(decorationFolder, side * (175 + random:NextNumber() * 35), zm, 1 + random:NextNumber() * 0.4)
		end
	end
	zm += 22 + random:NextNumber() * 16
end
for _, spot in ipairs({ { -100, -130 }, { 100, -130 }, { -110, -20 }, { 110, -20 }, { -60, -135 }, { 60, -135 } }) do
	buildPine(decorationFolder, spot[1], spot[2], 1.1)
end
buildHouse(-85, -40, 20, 16, -1)
buildHouse(88, -60, 22, 18, 1)

local plateauSpawn = createPart(gameplayFolder, "PlateauSpawn", V(30, 1, 30), CFrame.new(worldPoint(0, 0.5, -110)), C.Yellow)
CollectionService:AddTag(plateauSpawn, "PlateauSpawn")
local finishLine = buildAlongSlope(gameplayFolder, "FinishLine", 1799, 1801, -60, 60, 0.2, C.White, { material = M.Neon, noCollide = true })[1]
CollectionService:AddTag(finishLine, "FinishLine")

local slingshotOffset = V(OFFSET_X, 0, 0)
for _, name in ipairs({ "Slingshot", "SlingshotDecor" }) do
	local source = levelOne:FindFirstChild(name)
	if source then
		local copy = source:Clone()
		copy:PivotTo(source:GetPivot() + slingshotOffset)
		copy.Parent = root
		if name == "Slingshot" then
			copy:SetAttribute("SeatPosition", source:GetAttribute("SeatPosition") + slingshotOffset)
			copy:SetAttribute("DismountPosition", source:GetAttribute("DismountPosition") + slingshotOffset)
		end
	end
end
local waitingSource = levelOne:FindFirstChild("WaitingPenguins")
if waitingSource then
	local copy = waitingSource:Clone()
	for _, penguin in ipairs(copy:GetChildren()) do
		if penguin:IsA("Model") then penguin:PivotTo(penguin:GetPivot() + slingshotOffset) end
	end
	copy.Parent = root
end

local levelOnePlazaGround = levelOne.FinishPlaza:FindFirstChild("PlazaGround")
local levelOnePlazaTop = levelOnePlazaGround.Position.Y + levelOnePlazaGround.Size.Y / 2
local portalSource = levelOne:FindFirstChild("ReturnPortalGate")
local portalCopy = portalSource:Clone()
portalCopy:PivotTo(portalSource:GetPivot() + V(OFFSET_X, BASE_Y + elevationAt(1880) - levelOnePlazaTop, -30))
portalCopy.Parent = root
for _, descendant in ipairs(portalCopy:GetDescendants()) do
	if descendant:GetAttribute("DestinationLevel") ~= nil then descendant:SetAttribute("DestinationLevel", nil) end
end
for _, descendant in ipairs(portalSource:GetDescendants()) do
	if CollectionService:HasTag(descendant, "ReturnPortal") then descendant:SetAttribute("DestinationLevel", 2) end
end

local camera = workspace.CurrentCamera
if camera then
	camera.CFrame = CFrame.lookAt(worldPoint(150, 120, -160), worldPoint(0, -120, 450))
end

local partCount = 0
for _, descendant in ipairs(root:GetDescendants()) do
	if descendant:IsA("BasePart") then partCount += 1 end
end
print(("Level 2 built: %d parts, finish Y %.1f, portal Y %.1f"):format(partCount, BASE_Y + elevationAt(1800), BASE_Y + elevationAt(1880)))
