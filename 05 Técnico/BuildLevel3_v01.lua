local CollectionService = game:GetService("CollectionService")

local LEVEL_FOLDER_NAME = "PenguinSlingshotMap_Level3"
local LEVEL_ID = 3
local OFFSET_X = 12000
local BASE_Y = 600
local FOUNDATION_Y = -60
local STREET_CLEARANCE = 40 - BASE_Y
local V = Vector3.new
local M = Enum.Material

local levelOne = workspace:FindFirstChild("PenguinSlingshotMap_v01")
local levelTwo = workspace:FindFirstChild("PenguinSlingshotMap_Level2")
local existing = workspace:FindFirstChild(LEVEL_FOLDER_NAME)
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name = LEVEL_FOLDER_NAME
root:SetAttribute("LevelId", LEVEL_ID)
root.Parent = workspace

local function newFolder(name)
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = root
	return folder
end
local trackFolder = newFolder("TrackBuildings")
local obstacleFolder = newFolder("Obstacles")
local cityFolder = newFolder("City")
local decorationFolder = newFolder("Decoration")
local gameplayFolder = newFolder("Gameplay")
local hazardFolder = newFolder("Hazards")

local function rgb(hex)
	return Color3.fromRGB(bit32.rshift(hex, 16) % 256, bit32.rshift(hex, 8) % 256, hex % 256)
end

local C = {
	Snow = rgb(0xf4f8fd), SnowShade = rgb(0xdbe6f1), Ice = rgb(0xcfeeff), Concrete = rgb(0xb9b2a8), ConcreteDark = rgb(0x8f8a83),
	Brick = rgb(0xa85c45), Stone = rgb(0x8d96a1), Metal = rgb(0x8e98a3), MetalDark = rgb(0x4d535c), Glass = rgb(0x9fd3f0),
	Red = rgb(0xc8281e), Yellow = rgb(0xffc928), Black = rgb(0x1e2833), White = rgb(0xffffff), Orange = rgb(0xf39c1f),
	Wood = rgb(0x9c6a42), WoodDark = rgb(0x6a4127), Pine = rgb(0x2d6a4a), PineDark = rgb(0x24583d), Blue = rgb(0x2f6fd6),
	Green = rgb(0x3fae5a), Panel = rgb(0x1f3e7a), Crate = rgb(0xb88a55), Pot = rgb(0xb5651d), DishWhite = rgb(0xe9edf2),
	Pole = rgb(0xd8dde3), Door = rgb(0x5a3d2b), WindowLit = rgb(0xffd47e), WindowDark = rgb(0x3a4a63), SignBack = rgb(0x14182b),
	NeonPink = rgb(0xff4fa3), NeonCyan = rgb(0x3ff1ff), Street = rgb(0xcfd6de), Pad = rgb(0xffd166), Fan = rgb(0x2a2f36),
	ToiletDoor = rgb(0x2558ab), Bow = rgb(0xfff3c4), Wire = rgb(0x222222),
}
local FACADE_COLORS = { rgb(0xd9cbb8), rgb(0xc9b6a0), rgb(0xb98a74), rgb(0xa5aab3), rgb(0xd6d1c7), rgb(0xbfa58a), rgb(0x9aa5b5) }
local BULB_COLORS = { rgb(0xff3b3b), rgb(0xffd23f), rgb(0x3fd0ff), rgb(0x7dff7a) }

local random = Random.new(33)

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
	local smooth = options.material == M.Neon or options.material == M.Glass or options.noStuds
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

local function worldPoint(x, y, zm)
	return V(OFFSET_X + x, BASE_Y + y, -zm)
end

local buildings = {
	{ name = "SpawnTower", z0 = -140, z1 = 0, slope = 0, width = 160, drop = 0 },
	{ name = "LandingRoof", z0 = 30, z1 = 250, slope = 12, width = 120, drop = 40 },
	{ name = "DuctRoof", z0 = 262, z1 = 520, slope = 10, width = 110, drop = 10 },
	{ name = "SolarRoof", z0 = 540, z1 = 820, slope = 8, width = 130, drop = 8, jump = true },
	{ name = "HelipadRoof", z0 = 834, z1 = 1060, slope = 6, width = 140, drop = 14 },
	{ name = "GardenRoof", z0 = 1082, z1 = 1330, slope = 10, width = 100, drop = 6, jump = true },
	{ name = "WaterTowerRoof", z0 = 1342, z1 = 1600, slope = 12, width = 120, drop = 18 },
	{ name = "NeonRoof", z0 = 1620, z1 = 1900, slope = 14, width = 110, drop = 4, jump = true },
	{ name = "ConstructionRoof", z0 = 1914, z1 = 2240, slope = 10, width = 120, drop = 12 },
	{ name = "FinalStretchRoof", z0 = 2262, z1 = 2700, slope = 8, width = 120, drop = 10, jump = true },
	{ name = "PortalRoof", z0 = 2700, z1 = 2770, slope = 0, width = 120, drop = 0 },
}
for index, building in ipairs(buildings) do
	building.top0 = index == 1 and 0 or buildings[index - 1].top1 - building.drop
	building.top1 = building.top0 - (building.z1 - building.z0) * math.tan(math.rad(building.slope))
end

local function buildingAt(zm)
	for _, building in ipairs(buildings) do
		if zm >= building.z0 and zm <= building.z1 then return building end
	end
	return nil
end

local function roofY(zm)
	local building = buildingAt(zm)
	if not building then return nil end
	return building.top0 + (building.top1 - building.top0) * (zm - building.z0) / (building.z1 - building.z0)
end

local function clampedRoofY(building, zm)
	local clamped = math.clamp(zm, building.z0, building.z1)
	return building.top0 + (building.top1 - building.top0) * (clamped - building.z0) / (building.z1 - building.z0)
end

local function trackY(zm)
	local onRoof = roofY(zm)
	if onRoof then return onRoof end
	if zm < buildings[1].z0 then return 0 end
	for index = 2, #buildings do
		local previous, nextBuilding = buildings[index - 1], buildings[index]
		if zm > previous.z1 and zm < nextBuilding.z0 then
			return (previous.top1 + nextBuilding.top0) / 2
		end
	end
	return buildings[#buildings].top1
end

local function roofSlab(parent, name, building, zA, zB, x, width, lift, thickness, color, options)
	local startPoint = worldPoint(x, clampedRoofY(building, zA), zA)
	local endPoint = worldPoint(x, clampedRoofY(building, zB), zB)
	local frame = CFrame.lookAt((startPoint + endPoint) / 2, endPoint) * CFrame.new(0, lift + thickness / 2, 0)
	return createPart(parent, name, V(width, thickness, (endPoint - startPoint).Magnitude), frame, color, options)
end

local function placeWindowRow(parent, faceAxis, faceCoord, alongStart, alongEnd, rowY, color)
	for along = alongStart, alongEnd, 8 do
		local lit = random:NextNumber() < 0.3
		local windowColor = lit and C.WindowLit or C.WindowDark
		if faceAxis == "x" then
			createPart(parent, "Window", V(0.6, 6, 4.5), CFrame.new(worldPoint(faceCoord, rowY, along)), windowColor, { noStuds = true, noShadow = true })
		else
			createPart(parent, "Window", V(4.5, 6, 0.6), CFrame.new(worldPoint(along, rowY, faceCoord)), windowColor, { noStuds = true, noShadow = true })
		end
	end
	if faceAxis == "x" then
		createPart(parent, "WindowSill", V(1.8, 0.8, alongEnd - alongStart + 6), CFrame.new(worldPoint(faceCoord, rowY - 3.4, (alongStart + alongEnd) / 2)), C.Snow, { noShadow = true })
	else
		createPart(parent, "WindowSill", V(alongEnd - alongStart + 6, 0.8, 1.8), CFrame.new(worldPoint((alongStart + alongEnd) / 2, rowY - 3.4, faceCoord)), C.Snow, { noShadow = true })
	end
	return color
end

local function hazardPit(name, x0, x1, z0, z1, topY)
	local pit = createPart(hazardFolder, name, V(x1 - x0, 4, z1 - z0), CFrame.new(worldPoint((x0 + x1) / 2, topY - 2, (z0 + z1) / 2)), C.Black, { transparency = 1, noShadow = true, noStuds = true })
	CollectionService:AddTag(pit, "Hazard")
	pit:SetAttribute("HazardKind", "Pit")
	return pit
end

local icicleFolder = newFolder("Icicles")
local function icicle(x, y, zm)
	local length = 1.5 + random:NextNumber() * 3.5
	createPart(icicleFolder, "Icicle", V(0.7, length, 0.7), CFrame.new(worldPoint(x, y - length / 2, zm)), C.Ice, { noStuds = true, noShadow = true, noCollide = true, transparency = 0.15 })
end

local function buildTrackBuilding(index, building)
	local model = newModel(building.name, trackFolder)
	local low = math.min(building.top0, building.top1)
	local depth = building.z1 - building.z0
	local halfWidth = building.width / 2
	local midZ = (building.z0 + building.z1) / 2
	local facade = FACADE_COLORS[(index - 1) % #FACADE_COLORS + 1]
	local bodyTop = building.slope == 0 and low - 1.2 or low
	local bodyBottom = FOUNDATION_Y - BASE_Y
	createPart(model, "Body", V(building.width, bodyTop - bodyBottom, depth), CFrame.new(worldPoint(0, (bodyTop + bodyBottom) / 2, midZ)), facade, { noStuds = true })
	if building.slope == 0 then
		createPart(model, "RoofSnow", V(building.width, 1.2, depth), CFrame.new(worldPoint(0, low - 0.6, midZ)), C.Snow)
	else
		createPart(model, "RoofSnow", V(building.width, building.top0 - building.top1, depth), CFrame.new(worldPoint(0, (building.top0 + building.top1) / 2, midZ)), C.Snow, { className = "WedgePart" })
	end
	createPart(model, "Cornice", V(building.width + 3, 1.6, depth + 3), CFrame.new(worldPoint(0, low - 2, midZ)), C.ConcreteDark, { noStuds = true })
	createPart(model, "CorniceSnow", V(building.width + 3.6, 1, depth + 3.6), CFrame.new(worldPoint(0, low - 0.9, midZ)), C.Snow)
	if building.slope > 0 then
		roofSlab(model, "RoofSnowOverhang", building, building.z0 - 1.5, building.z1 + 1.5, 0, building.width + 3, -1.6, 1.8, C.Snow)
	end

	if index ~= 1 then
		for _, side in ipairs({ -1, 1 }) do
			roofSlab(model, "Parapet", building, building.z0, building.z1, side * (halfWidth - 1.25), 2.5, 0, 4, C.ConcreteDark, { noStuds = true })
			roofSlab(model, "ParapetSnow", building, building.z0, building.z1, side * (halfWidth - 1.25), 3.2, 4, 1, C.Snow)
			roofSlab(model, "SnowBank", building, building.z0 + 1, building.z1 - 1, side * (halfWidth - 4.5), 4, 0, 1.6, C.Snow)
			roofSlab(model, "SnowBankTop", building, building.z0 + 3, building.z1 - 3, side * (halfWidth - 3.6), 2.2, 1.6, 1.4, C.Snow)
		end
	else
		for _, side in ipairs({ -1, 1 }) do
			createPart(model, "Parapet", V(2.5, 4, depth), CFrame.new(worldPoint(side * (halfWidth - 1.25), 2, midZ)), C.ConcreteDark, { noStuds = true })
			createPart(model, "ParapetSnow", V(3.2, 1, depth), CFrame.new(worldPoint(side * (halfWidth - 1.25), 4.5, midZ)), C.Snow)
		end
		createPart(model, "BackParapet", V(building.width, 4, 2.5), CFrame.new(worldPoint(0, 2, building.z0 + 1.25)), C.ConcreteDark, { noStuds = true })
		createPart(model, "BackParapetSnow", V(building.width, 1, 3.2), CFrame.new(worldPoint(0, 4.5, building.z0 + 1.25)), C.Snow)
	end

	local windowFolder = newModel("Windows", model)
	for row = 0, 2 do
		local rowY = low - 9 - row * 12
		for _, side in ipairs({ -1, 1 }) do
			placeWindowRow(windowFolder, "x", side * (halfWidth + 0.3), building.z0 + 6, building.z1 - 6, rowY, facade)
		end
		placeWindowRow(windowFolder, "z", building.z0 - 0.3, -halfWidth + 6, halfWidth - 6, rowY, facade)
		placeWindowRow(windowFolder, "z", building.z1 + 0.3, -halfWidth + 6, halfWidth - 6, rowY, facade)
	end

	local icicleY = low - 2.8
	for zm = building.z0 + 3, building.z1 - 3, 6 do
		icicle(-(halfWidth + 1.3), icicleY, zm)
		icicle(halfWidth + 1.3, icicleY, zm)
	end
	for x = -halfWidth + 3, halfWidth - 3, 6 do
		icicle(x, icicleY, building.z0 - 1.3)
		icicle(x, icicleY, building.z1 + 1.3)
	end

	local nextBuilding = buildings[index + 1]
	if nextBuilding and nextBuilding.jump then
		for stripe = 0, 3 do
			local zEnd = building.z1 - 2 - stripe * 5
			roofSlab(model, "JumpWarning", building, zEnd - 2.2, zEnd, 0, building.width - 10, 0.2, 0.3, stripe % 2 == 0 and C.Yellow or C.Black, { noStuds = true, noCollide = true })
		end
	end

	if index ~= 1 then
		for _, side in ipairs({ -1, 1 }) do
			local innerX = side * (halfWidth + 2)
			local outerX = side * (halfWidth + 260)
			hazardPit("SidePit", math.min(innerX, outerX), math.max(innerX, outerX), building.z0, building.z1, low - 25)
		end
	end
	if nextBuilding and nextBuilding.z0 > building.z1 then
		hazardPit("GapPit", -halfWidth - 260, halfWidth + 260, building.z1 + 1, nextBuilding.z0 - 1, math.min(building.top1, nextBuilding.top0) - 25)
	end
end

for index, building in ipairs(buildings) do
	buildTrackBuilding(index, building)
end
do
	local last = buildings[#buildings]
	createPart(trackFolder, "EndWall", V(last.width, 10, 4), CFrame.new(worldPoint(0, last.top1 + 5, last.z1 - 2)), C.ConcreteDark, { noStuds = true })
	createPart(trackFolder, "EndWallSnow", V(last.width, 1, 4.6), CFrame.new(worldPoint(0, last.top1 + 10.5, last.z1 - 2)), C.Snow)
end

local function obstacleFrame(building, zm, x, halfLength)
	return CFrame.new(worldPoint(x, clampedRoofY(building, zm + halfLength), zm))
end

local function piece(model, base, name, size, x, y, z, color, options, rotation)
	local frame = base * CFrame.new(x, y, z)
	if rotation then frame *= rotation end
	return createPart(model, name, size, frame, color, options)
end

local function cylinder(model, base, name, diameter, height, x, y, z, color, options)
	local opts = options and table.clone(options) or {}
	opts.shape = Enum.PartType.Cylinder
	opts.noStuds = true
	return piece(model, base, name, V(height, diameter, diameter), x, y, z, color, opts, CFrame.Angles(0, 0, math.pi / 2))
end

local function ball(model, base, name, diameter, x, y, z, color, options)
	local opts = options and table.clone(options) or {}
	opts.shape = Enum.PartType.Ball
	opts.noStuds = true
	return piece(model, base, name, V(diameter, diameter, diameter), x, y, z, color, opts)
end

local snowCap = function(model, base, width, depth, y)
	return piece(model, base, "Snow", V(width, 0.8, depth), 0, y, 0, C.Snow)
end

local builders = {}
local halfLengths = {
	ac = 3, vent = 1, chimney = 2, duct = 1.5, skylight = 3, stairhut = 4, dish = 2.5, antenna = 1, tower = 6, solar = 2,
	heli = 11, sock = 1, crates = 2, ramp = 9, planter = 1.5, greenhouse = 11, potpine = 2, snowman = 4, bench = 1.3,
	gantry = 1.5, cones = 1, beams = 1.5, crane = 4, barrier = 1, mixer = 5, toilet = 2, scaffold = 3, xmas = 4, gifts = 2.5,
}

builders.ac = function(m, b)
	piece(m, b, "Unit", V(8, 8, 6), 0, 4, 0, C.Metal, { noStuds = true })
	piece(m, b, "Lid", V(7, 0.4, 5), 0, 8.2, 0, C.MetalDark, { noStuds = true })
	cylinder(m, b, "Fan", 4, 0.5, -1.5, 8.4, 0, C.Fan)
	for k = 0, 3 do piece(m, b, "Grille", V(6.6, 0.25, 0.25), 0, 1.5 + k * 1.6, 3.05, C.MetalDark, { noStuds = true, noShadow = true }) end
	snowCap(m, b, 7.6, 5.6, 8.8)
end
builders.vent = function(m, b)
	for _, dx in ipairs({ -2.2, 0, 2.2 }) do
		cylinder(m, b, "Pipe", 1.4, 2.6, dx, 1.3, 0, C.Metal)
		cylinder(m, b, "PipeSnow", 2.4, 0.6, dx, 2.9, 0, C.Snow)
	end
end
builders.chimney = function(m, b)
	piece(m, b, "Brick", V(4, 9.4, 4), 0, 4.7, 0, C.Brick, { noStuds = true })
	piece(m, b, "Crown", V(4.6, 0.8, 4.6), 0, 9.6, 0, C.ConcreteDark, { noStuds = true })
	piece(m, b, "Snow", V(4.2, 1, 4.2), 0, 10.5, 0, C.Snow)
end
builders.duct = function(m, b, length)
	piece(m, b, "Duct", V(length, 2.4, 3), 0, 2.2, 0, C.Metal, { noStuds = true })
	piece(m, b, "Snow", V(length, 0.6, 3.2), 0, 3.7, 0, C.Snow)
	for k = -length / 2 + 3, length / 2, 8 do piece(m, b, "Support", V(0.8, 1.2, 2.4), k, 0.6, 0, C.MetalDark, { noStuds = true }) end
end
builders.skylight = function(m, b)
	piece(m, b, "Frame", V(6, 1.2, 6), 0, 0.6, 0, C.ConcreteDark)
	piece(m, b, "Glass", V(5, 1.8, 5), 0, 2.1, 0, C.Glass, { material = M.Glass, transparency = 0.35 })
	piece(m, b, "Snow", V(3, 0.5, 3), 0, 3.25, 0, C.Snow)
end
builders.stairhut = function(m, b)
	piece(m, b, "Hut", V(10, 9, 8), 0, 4.5, 0, C.Concrete, { noStuds = true })
	piece(m, b, "Door", V(3.4, 6, 0.3), 0, 3, 4.1, C.Door, { noStuds = true })
	piece(m, b, "Roof", V(11, 0.6, 9), 0, 9.3, 0, C.ConcreteDark, { noStuds = true })
	piece(m, b, "Snow1", V(11, 1.4, 9), 0, 10.3, 0, C.Snow)
	piece(m, b, "Snow2", V(9, 1, 7), 0, 11.5, 0, C.Snow)
	piece(m, b, "Snow3", V(6, 0.8, 4), 0, 12.4, 0, C.Snow)
end
builders.dish = function(m, b)
	piece(m, b, "Post", V(2, 4, 2), 0, 2, 0, C.MetalDark)
	local tilt = CFrame.Angles(-0.9, 0, 0) * CFrame.Angles(0, 0, math.pi / 2)
	piece(m, b, "Dish", V(1.2, 8, 8), 0, 6.5, 0, C.DishWhite, { shape = Enum.PartType.Cylinder, noStuds = true }, tilt)
	piece(m, b, "DishSnow", V(0.4, 7.4, 7.4), 0, 7.1, 0.4, C.Snow, { shape = Enum.PartType.Cylinder, noStuds = true }, tilt)
	piece(m, b, "Arm", V(0.3, 3.4, 0.3), 0, 7.2, -1.6, C.MetalDark, { noStuds = true }, CFrame.Angles(-0.9, 0, 0))
end
builders.antenna = function(m, b)
	piece(m, b, "Mast", V(1.4, 18, 1.4), 0, 9, 0, C.Pole, { noStuds = true })
	for k = 0, 2 do piece(m, b, "Bar", V(5 - k * 1.2, 0.3, 0.3), 0, 12 + k * 2.5, 0, C.Pole, { noStuds = true, noShadow = true }) end
	ball(m, b, "Beacon", 1.2, 0, 18.4, 0, rgb(0xff3030), { material = M.Neon })
	piece(m, b, "Snow", V(2.4, 0.6, 2.4), 0, 0.3, 0, C.Snow)
end
builders.tower = function(m, b)
	for _, sx in ipairs({ -4, 4 }) do
		for _, sz in ipairs({ -4, 4 }) do piece(m, b, "Leg", V(1, 9, 1), sx, 4.5, sz, C.WoodDark, { noStuds = true }) end
	end
	piece(m, b, "Platform", V(10, 0.8, 10), 0, 9, 0, C.WoodDark)
	cylinder(m, b, "Tank", 12, 11, 0, 15, 0, C.Wood)
	for _, y in ipairs({ 11, 15, 19 }) do cylinder(m, b, "Ring", 12.2, 0.35, 0, y, 0, C.MetalDark) end
	cylinder(m, b, "RoofSnow1", 13.2, 1.4, 0, 21.2, 0, C.Snow)
	cylinder(m, b, "RoofSnow2", 9, 1.4, 0, 22.6, 0, C.Snow)
	cylinder(m, b, "RoofSnow3", 4.6, 1.4, 0, 24, 0, C.Snow)
end
builders.solar = function(m, b, length)
	for k = -length / 2 + 2.5, length / 2 - 0.1, 5 do
		piece(m, b, "Stand", V(0.4, 1.2, 0.4), k, 0.6, 1.2, C.MetalDark, { noStuds = true, noShadow = true })
		piece(m, b, "Panel", V(4.8, 0.3, 4), k, 1.6, 0, C.Panel, { material = M.SmoothPlastic, noStuds = true }, CFrame.Angles(-0.45, 0, 0))
		piece(m, b, "PanelSnow", V(4.8, 0.3, 1.6), k, 2.15, 1.1, C.Snow, { noShadow = true }, CFrame.Angles(-0.45, 0, 0))
	end
end
builders.heli = function(m, b)
	piece(m, b, "Body", V(8, 7, 12), 0, 4.5, 0, C.Red, { noStuds = true })
	piece(m, b, "Cockpit", V(6.6, 3, 5), 0, 5, -7, C.Glass, { material = M.Glass, transparency = 0.3 })
	piece(m, b, "Tail", V(2, 2, 14), 0, 6, 11, C.Red, { noStuds = true })
	piece(m, b, "Fin", V(0.6, 4, 3), 0, 8, 17, C.Red, { noStuds = true })
	for _, s in ipairs({ -1, 1 }) do piece(m, b, "Skid", V(0.6, 0.6, 14), s * 3.6, 0.3, 0, C.MetalDark, { noStuds = true }) end
	piece(m, b, "RotorHub", V(1, 1.6, 1), 0, 8.8, 0, C.MetalDark, { noStuds = true })
	piece(m, b, "Blade", V(26, 0.3, 1.4), 0, 9.7, 0, C.MetalDark, { noStuds = true }, CFrame.Angles(0, 0.5, 0))
	piece(m, b, "Blade", V(26, 0.3, 1.4), 0, 9.7, 0, C.MetalDark, { noStuds = true }, CFrame.Angles(0, -1.07, 0))
	piece(m, b, "Snow", V(7.6, 0.8, 11), 0, 8.4, 0, C.Snow)
	piece(m, b, "PadMark", V(3, 0.2, 14), -14, 0.1, 0, C.Yellow, { noStuds = true, noCollide = true })
end
builders.sock = function(m, b)
	piece(m, b, "Pole", V(0.8, 12, 0.8), 0, 6, 0, C.Pole, { noStuds = true })
	piece(m, b, "Sock", V(4, 1.6, 1.6), 2.4, 11, 0, C.Orange, { noStuds = true })
	piece(m, b, "Stripe", V(1.6, 1.2, 1.2), 4.6, 10.8, 0, C.White, { noStuds = true })
end
builders.crates = function(m, b)
	for _, spot in ipairs({ { -1.6, 1, 0 }, { 1.6, 1, 0.2 }, { 0, 3, 0 } }) do piece(m, b, "Crate", V(3, 2, 3), spot[1], spot[2], spot[3], C.Crate) end
	piece(m, b, "Snow", V(2.8, 0.5, 2.8), 0, 4.25, 0, C.Snow)
end
builders.planter = function(m, b, length)
	piece(m, b, "Box", V(length, 2.4, 3), 0, 1.2, 0, C.Wood, { noStuds = true })
	piece(m, b, "Snow", V(length - 0.6, 0.6, 2.6), 0, 2.7, 0, C.Snow)
	local k = -length / 2 + 2
	local alternate = false
	while k < length / 2 do
		ball(m, b, "Shrub", 2.2, k, 3.2, 0, alternate and C.Pine or C.PineDark)
		ball(m, b, "ShrubSnow", 1.4, k, 3.9, 0, C.Snow, { noShadow = true })
		alternate = not alternate
		k += 3.2
	end
end
builders.greenhouse = function(m, b)
	piece(m, b, "Base", V(14, 1, 22), 0, 0.5, 0, C.ConcreteDark)
	piece(m, b, "Glass", V(13, 7, 21), 0, 4.5, 0, C.Glass, { material = M.Glass, transparency = 0.45 })
	for k = -10, 10, 5 do piece(m, b, "Frame", V(13.4, 7, 0.4), 0, 4.5, k, rgb(0xf2f4f6), { noStuds = true }) end
	piece(m, b, "RoofFrame", V(14, 1, 22), 0, 8.5, 0, rgb(0xf2f4f6))
	piece(m, b, "Snow1", V(11, 1.2, 22), 0, 9.6, 0, C.Snow)
	piece(m, b, "Snow2", V(7, 1, 22), 0, 10.7, 0, C.Snow)
	piece(m, b, "Snow3", V(3, 0.8, 22), 0, 11.6, 0, C.Snow)
	for k = 0, 4 do ball(m, b, "Plant", 2, -4 + k * 2, 2, -6 + k * 3, C.Green) end
end
builders.potpine = function(m, b)
	piece(m, b, "Pot", V(4, 3, 4), 0, 1.5, 0, C.Pot)
	piece(m, b, "Trunk", V(1, 2, 1), 0, 4, 0, C.WoodDark, { noStuds = true })
	for k, tier in ipairs({ { 6, 3.5, 5.5 }, { 4.4, 3, 8.4 }, { 2.6, 2.6, 11 } }) do
		local w, h, y = tier[1], tier[2], tier[3]
		local spin = CFrame.Angles(0, (k - 1) * 0.7, 0)
		piece(m, b, "Tier", V(w, h, w), 0, y, 0, k % 2 == 0 and C.Pine or C.PineDark, nil, spin)
		piece(m, b, "TierSnow", V(w * 0.8, 0.5, w * 0.8), 0, y + h / 2 + 0.2, 0, C.Snow, { noShadow = true }, spin)
	end
end
builders.snowman = function(m, b)
	ball(m, b, "Bottom", 8, 0, 3.5, 0, C.Snow)
	ball(m, b, "Middle", 6, 0, 9.5, 0, C.Snow)
	ball(m, b, "Head", 4, 0, 14, 0, C.Snow)
	piece(m, b, "Nose", V(0.6, 0.6, 2), 0, 14, -2.6, C.Orange, { noStuds = true })
	piece(m, b, "Scarf", V(4.4, 0.8, 4.4), 0, 11.8, 0, C.Red, { noStuds = true })
	piece(m, b, "HatBrim", V(3.6, 0.4, 3.6), 0, 15.7, 0, C.Black, { noStuds = true })
	piece(m, b, "Hat", V(2.6, 2.4, 2.6), 0, 17, 0, C.Black, { noStuds = true })
	for _, s in ipairs({ -1, 1 }) do piece(m, b, "Eye", V(0.5, 0.5, 0.3), s * 0.7, 14.6, -1.85, C.Black, { noStuds = true }) end
end
builders.bench = function(m, b)
	piece(m, b, "Seat", V(8, 0.6, 2.4), 0, 2.4, 0, C.Wood)
	piece(m, b, "Back", V(8, 1.4, 0.4), 0, 3.4, 1.1, C.Wood, { noStuds = true })
	for _, s in ipairs({ -1, 1 }) do piece(m, b, "Leg", V(0.6, 2.1, 2), s * 3.4, 1.05, 0, C.MetalDark, { noStuds = true }) end
	piece(m, b, "Snow", V(7.6, 0.6, 2.2), 0, 3, 0, C.Snow)
end
builders.gantry = function(m, b)
	piece(m, b, "Pillar", V(3, 22, 3), 0, 11, 0, C.MetalDark, { noStuds = true })
	piece(m, b, "Snow", V(4, 0.8, 4), 0, 22.4, 0, C.Snow)
end
builders.cones = function(m, b)
	for _, cx in ipairs({ -2.5, 0, 2.5 }) do
		piece(m, b, "ConeBase", V(1.8, 0.3, 1.8), cx, 0.15, 0, C.Orange)
		piece(m, b, "Cone1", V(1.4, 0.8, 1.4), cx, 0.7, 0, C.Orange, { noStuds = true })
		piece(m, b, "ConeStripe", V(1.1, 0.4, 1.1), cx, 1.3, 0, C.White, { noStuds = true })
		piece(m, b, "Cone2", V(0.8, 0.7, 0.8), cx, 1.85, 0, C.Orange)
	end
end
builders.beams = function(m, b, length)
	for k = 0, 2 do
		local z = (k % 2 - 0.5) * 0.8
		piece(m, b, "Beam", V(length, 0.4, 1.2), 0, 0.2 + k * 0.85, z, C.Red, { noStuds = true })
		piece(m, b, "Web", V(length, 0.5, 0.3), 0, 0.65 + k * 0.85, z, C.Red, { noStuds = true, noShadow = true })
	end
	piece(m, b, "Snow", V(length - 1, 0.4, 2), 0, 2.7, 0, C.Snow, { noShadow = true })
end
builders.crane = function(m, b)
	piece(m, b, "Footing", V(8, 4, 8), 0, 2, 0, C.ConcreteDark)
	piece(m, b, "Base", V(7, 6, 7), 0, 7, 0, C.Yellow, { noStuds = true })
	piece(m, b, "Mast", V(2.4, 60, 2.4), 0, 40, 0, C.Yellow, { noStuds = true })
	piece(m, b, "Cab", V(4, 4, 4), 0, 72, 0, C.Yellow, { noStuds = true })
	piece(m, b, "Jib", V(70, 2, 2), 25, 74, 0, C.Yellow, { noStuds = true })
	piece(m, b, "CounterJib", V(20, 2, 2), -12, 74, 0, C.Yellow, { noStuds = true })
	piece(m, b, "Counterweight", V(6, 5, 4), -20, 71.5, 0, C.ConcreteDark, { noStuds = true })
	piece(m, b, "Cable", V(0.3, 30, 0.3), 45, 58, 0, rgb(0x333333), { noStuds = true, noShadow = true, noCollide = true })
	piece(m, b, "Hook", V(3, 2, 3), 45, 42, 0, C.MetalDark, { noStuds = true, noCollide = true })
	piece(m, b, "BaseSnow", V(7.4, 0.8, 7.4), 0, 10.4, 0, C.Snow)
	piece(m, b, "JibSnow", V(70, 0.6, 2.2), 25, 75.3, 0, C.Snow, { noShadow = true })
end
builders.barrier = function(m, b, length)
	for k = -length / 2, length / 2, 6 do piece(m, b, "Post", V(0.6, 3, 1.6), k, 1.5, 0, C.MetalDark, { noStuds = true }) end
	local k = -length / 2
	local stripe = 0
	while k < length / 2 do
		piece(m, b, "Panel", V(2, 1.2, 0.3), k + 1, 2.3, 0, stripe % 2 == 0 and C.Orange or C.White, { noStuds = true })
		stripe += 1
		k += 2
	end
	piece(m, b, "Snow", V(length, 0.4, 0.8), 0, 3.1, 0, C.Snow, { noShadow = true })
end
builders.mixer = function(m, b)
	piece(m, b, "Chassis", V(6, 2, 10), 0, 1, 0, C.MetalDark)
	piece(m, b, "Drum", V(7, 6, 6), 0, 5.4, 0.5, C.Orange, { shape = Enum.PartType.Cylinder, noStuds = true }, CFrame.Angles(0, math.pi / 2, 0) * CFrame.Angles(0, 0, 0.35))
	piece(m, b, "Snow", V(4, 0.6, 6), 0, 8.6, 0.5, C.Snow, nil, CFrame.Angles(-0.35, 0, 0))
end
builders.toilet = function(m, b)
	piece(m, b, "Booth", V(4, 8.4, 4), 0, 4.2, 0, C.Blue, { noStuds = true })
	piece(m, b, "Door", V(3, 7, 0.2), 0, 4, -2.05, C.ToiletDoor, { noStuds = true })
	piece(m, b, "Snow", V(4.4, 0.8, 4.4), 0, 8.8, 0, C.Snow)
end
builders.scaffold = function(m, b)
	for _, sx in ipairs({ -2.6, 2.6 }) do
		for _, sz in ipairs({ -2.6, 2.6 }) do piece(m, b, "Pole", V(0.4, 14, 0.4), sx, 7, sz, C.Metal, { noStuds = true }) end
	end
	for _, y in ipairs({ 3, 7.5, 12 }) do
		piece(m, b, "Deck", V(6, 0.4, 6), 0, y, 0, C.Wood)
		piece(m, b, "DeckSnow", V(5.6, 0.3, 5.6), 0, y + 0.35, 0, C.Snow, { noShadow = true })
	end
end
builders.xmas = function(m, b)
	piece(m, b, "Pot", V(5, 2, 5), 0, 1, 0, C.Red)
	for k, tier in ipairs({ { 9, 5, 5 }, { 7, 4.5, 9 }, { 5, 4, 12.6 }, { 3, 3.5, 15.8 } }) do
		local w, h, y = tier[1], tier[2], tier[3]
		local spin = CFrame.Angles(0, (k - 1) * 0.6, 0)
		piece(m, b, "Tier", V(w, h, w), 0, y, 0, k % 2 == 0 and C.Pine or C.PineDark, nil, spin)
		piece(m, b, "TierSnow", V(w * 0.8, 0.5, w * 0.8), 0, y + h / 2 + 0.2, 0, C.Snow, { noShadow = true }, spin)
		for q = 0, 3 do
			local angle = q * math.pi / 2 + k
			ball(m, b, "Ornament", 0.8, math.cos(angle) * w / 2, y - h / 4, math.sin(angle) * w / 2, BULB_COLORS[q + 1], { material = M.Neon, noShadow = true })
		end
	end
	piece(m, b, "Star", V(1.8, 1.8, 0.6), 0, 19.6, 0, rgb(0xffd23f), { material = M.Neon }, CFrame.Angles(0, 0, math.pi / 4))
end
builders.gifts = function(m, b)
	for _, gift in ipairs({ { -2.4, 1.2, 0, 2.4, C.Red }, { 0.4, 1, 1, 2, C.Blue }, { 2.4, 1.3, -0.6, 2.6, C.Green }, { 0, 2.9, 0, 1.6, C.Yellow } }) do
		local gx, gy, gz, s, color = gift[1], gift[2], gift[3], gift[4], gift[5]
		piece(m, b, "Gift", V(s, s, s), gx, gy, gz, color, { noStuds = true })
		piece(m, b, "Ribbon", V(s + 0.05, s + 0.05, 0.3), gx, gy, gz, C.Bow, { noStuds = true, noShadow = true })
		piece(m, b, "Snow", V(s * 0.9, 0.3, s * 0.9), gx, gy + s / 2 + 0.15, gz, C.Snow, { noShadow = true })
	end
end

local layout = {
	{ "chimney", 190, -34 }, { "chimney", 196, -26 }, { "ac", 215, 28 }, { "vent", 238, -5 },
	{ "ac", 285, -30 }, { "ac", 290, 26 }, { "duct", 310, -12, 50 }, { "vent", 332, 40 }, { "vent", 336, -40 }, { "stairhut", 360, 15 }, { "ac", 388, -32 }, { "dish", 410, 36 }, { "duct", 430, 14, 60 }, { "skylight", 455, -26 }, { "ac", 472, 30 }, { "chimney", 492, -8 }, { "vent", 505, 22 },
	{ "solar", 570, -40, 30 }, { "solar", 570, 8, 36 }, { "solar", 600, -14, 40 }, { "solar", 600, 42, 26 }, { "solar", 630, -44, 24 }, { "solar", 630, 10, 40 }, { "solar", 660, -20, 44 }, { "solar", 660, 40, 20 }, { "tower", 700, -36 }, { "solar", 705, 24, 40 }, { "solar", 740, -22, 34 }, { "solar", 740, 38, 24 }, { "ac", 770, 30 }, { "skylight", 790, -2 }, { "solar", 800, -40, 20 },
	{ "heli", 900, 38 }, { "sock", 870, -58 }, { "crates", 950, -30 }, { "ac", 985, -42 }, { "crates", 1000, 22 }, { "ac", 1012, 48 }, { "ramp", 1048, 0 },
	{ "planter", 1105, -22, 34 }, { "planter", 1135, 20, 34 }, { "greenhouse", 1172, -24 }, { "snowman", 1205, 26 }, { "bench", 1228, -10 }, { "potpine", 1245, 30 }, { "planter", 1262, 10, 36 }, { "potpine", 1285, -32 }, { "snowman", 1308, 12 }, { "bench", 1318, -34 },
	{ "tower", 1385, 30 }, { "antenna", 1405, -20 }, { "dish", 1422, -46 }, { "skylight", 1442, 2 }, { "skylight", 1452, 36 }, { "tower", 1490, -32 }, { "stairhut", 1520, 26 }, { "ac", 1545, -6 }, { "antenna", 1565, 42 }, { "vent", 1580, -34 }, { "chimney", 1588, 18 },
	{ "stairhut", 1650, -26 }, { "ac", 1672, 30 }, { "gantry", 1700, -50 }, { "gantry", 1700, 50 }, { "chimney", 1722, 8 }, { "vent", 1745, -36 }, { "vent", 1750, 34 }, { "ac", 1776, -12 }, { "dish", 1800, 42 }, { "duct", 1822, -14, 50 }, { "stairhut", 1850, 26 }, { "ac", 1872, -32 }, { "chimney", 1886, 8 },
	{ "cones", 1940, -14 }, { "beams", 1966, 26, 30 }, { "crane", 2000, -38 }, { "crates", 2030, 10 }, { "barrier", 2058, -28, 24 }, { "mixer", 2090, 32 }, { "beams", 2120, -4, 40 }, { "toilet", 2150, -42 }, { "cones", 2172, 20 }, { "scaffold", 2200, -30 }, { "crates", 2216, 30 }, { "barrier", 2228, -6, 30 },
	{ "xmas", 2300, 40 }, { "ac", 2330, -30 }, { "vent", 2360, 10 }, { "snowman", 2392, -26 }, { "stairhut", 2420, 30 }, { "skylight", 2450, -6 }, { "ac", 2480, 36 }, { "dish", 2510, -42 }, { "gifts", 2540, 0 }, { "chimney", 2560, -20 }, { "ac", 2590, 24 }, { "gifts", 2620, -30 }, { "vent", 2645, 30 },
}

for index, entry in ipairs(layout) do
	local kind, zm, x, length = entry[1], entry[2], entry[3], entry[4]
	local building = buildingAt(zm)
	local model = newModel(("%s_%02d"):format(kind, index), obstacleFolder)
	if kind == "ramp" then
		roofSlab(model, "RampBase", building, zm - 9, zm + 9, x, 30, 0, 0.6, C.Snow)
		local startPoint = worldPoint(x, clampedRoofY(building, zm - 9), zm - 9)
		local endPoint = worldPoint(x, clampedRoofY(building, zm + 9), zm + 9)
		local frame = CFrame.lookAt((startPoint + endPoint) / 2, endPoint) * CFrame.new(0, 2.6, 0) * CFrame.Angles(0, math.pi, 0)
		createPart(model, "Ramp", V(30, 4, (endPoint - startPoint).Magnitude), frame, C.Snow, { className = "WedgePart" })
	else
		local base = obstacleFrame(building, zm, x, halfLengths[kind])
		builders[kind](model, base, length)
	end
end

local function neonSign(parent, name, text, width, height, frame, neonColor)
	local board = createPart(parent, name, V(width, height, 0.8), frame, C.SignBack, { noStuds = true })
	for _, face in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back }) do
		local gui = Instance.new("SurfaceGui")
		gui.Face = face
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.PixelsPerStud = 20
		gui.LightInfluence = 0
		gui.Parent = board
		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextScaled = true
		label.Font = Enum.Font.FredokaOne
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextStrokeColor3 = neonColor
		label.TextStrokeTransparency = 0
		label.Parent = gui
	end
	for _, edge in ipairs({ { 0, height / 2 - 0.3, width - 0.4, 0.6 }, { 0, -height / 2 + 0.3, width - 0.4, 0.6 }, { width / 2 - 0.3, 0, 0.6, height }, { -width / 2 + 0.3, 0, 0.6, height } }) do
		createPart(parent, name .. "Neon", V(edge[3], edge[4], 1), frame * CFrame.new(edge[1], edge[2], 0), neonColor, { material = M.Neon, noShadow = true })
	end
	createPart(parent, name .. "Snow", V(width + 2, 1, 3), frame * CFrame.new(0, height / 2 + 0.5, 0), C.Snow)
	return board
end

do
	local zm = 1700
	local gantry = newModel("SlipperyGantry", decorationFolder)
	local y = roofY(zm)
	createPart(gantry, "Beam", V(108, 2.4, 2.4), CFrame.new(worldPoint(0, y + 23, zm)), C.MetalDark, { noStuds = true })
	neonSign(gantry, "SlipperySign", "¡RESBALA!", 60, 12, CFrame.new(worldPoint(0, y + 30, zm)), C.NeonPink)
end

do
	local zm = 2680
	local arch = newModel("FinishArch", decorationFolder)
	local y = roofY(zm)
	for _, side in ipairs({ -1, 1 }) do
		createPart(arch, "Pillar", V(3.6, 24, 3.6), CFrame.new(worldPoint(side * 56, y + 12, zm)), C.MetalDark, { noStuds = true })
		createPart(arch, "PillarSnow", V(4.4, 0.8, 4.4), CFrame.new(worldPoint(side * 56, y + 24.4, zm)), C.Snow)
	end
	createPart(arch, "Beam", V(116, 2.4, 2.4), CFrame.new(worldPoint(0, y + 23, zm)), C.MetalDark, { noStuds = true })
	neonSign(arch, "FinishSign", "¡META!", 44, 12, CFrame.new(worldPoint(0, y + 30, zm)), C.NeonCyan)
	local building = buildingAt(zm)
	local finishLine = roofSlab(gameplayFolder, "FinishLine", building, zm - 1.2, zm + 1.2, 0, 116, 0.25, 0.3, C.White, { material = M.Neon, noCollide = true })
	CollectionService:AddTag(finishLine, "FinishLine")
	for stripe = 0, 13 do
		roofSlab(arch, "Checker", building, zm + 1.2, zm + 3.6, -52 + stripe * 8, 4, 0.25, 0.3, C.Black, { noStuds = true, noCollide = true })
	end
end

local function stringLights(zm)
	local building = buildingAt(zm)
	local y = roofY(zm)
	local halfSpan = building.width / 2 - 2
	local model = newModel("StringLights", decorationFolder)
	for _, side in ipairs({ -1, 1 }) do
		createPart(model, "Pole", V(1, 16, 1), CFrame.new(worldPoint(side * halfSpan, y + 8, zm)), C.MetalDark, { noStuds = true })
		createPart(model, "PoleSnow", V(1.6, 0.6, 1.6), CFrame.new(worldPoint(side * halfSpan, y + 16.3, zm)), C.Snow)
	end
	createPart(model, "Wire", V(halfSpan * 2, 0.15, 0.15), CFrame.new(worldPoint(0, y + 15.3, zm)), C.Wire, { noStuds = true, noShadow = true, noCollide = true })
	local bulb = 0
	for x = -halfSpan + 4, halfSpan - 4, 4 do
		bulb += 1
		local sag = math.cos(x / halfSpan * math.pi / 2) * 2.2
		createPart(model, "Bulb", V(0.9, 0.9, 0.9), CFrame.new(worldPoint(x, y + 15 - sag, zm)), BULB_COLORS[bulb % 4 + 1], { shape = Enum.PartType.Ball, material = M.Neon, noShadow = true, noCollide = true })
	end
end
for _, zm in ipairs({ 1980, 2560, 2620 }) do stringLights(zm) end

do
	local a, b = buildings[3], buildings[4]
	local bridge = newModel("ScaffoldBridge", decorationFolder)
	local startPoint = worldPoint(0, a.top1, a.z1 - 2)
	local endPoint = worldPoint(0, b.top0, b.z0 + 2)
	local frame = CFrame.lookAt((startPoint + endPoint) / 2, endPoint)
	local length = (endPoint - startPoint).Magnitude
	createPart(bridge, "Plank", V(16, 1, length), frame * CFrame.new(0, 0.5, 0), C.Wood)
	createPart(bridge, "PlankSnow", V(15, 0.4, length - 1), frame * CFrame.new(0, 1.2, 0), C.Snow, { noShadow = true })
	for _, sx in ipairs({ -8, 8 }) do
		createPart(bridge, "Rail", V(0.5, 0.5, length), frame * CFrame.new(sx, 3.2, 0), C.Yellow, { noStuds = true })
		for _, dz in ipairs({ -length / 2 + 1, 0, length / 2 - 1 }) do
			createPart(bridge, "RailPost", V(0.5, 3, 0.5), frame * CFrame.new(sx, 1.7, dz), C.Metal, { noStuds = true })
		end
		createPart(bridge, "Support", V(0.8, 40, 0.8), frame * CFrame.new(sx - math.sign(sx) * 2, -20, 0), C.Metal, { noStuds = true })
	end
end

do
	local a, b = buildings[7], buildings[8]
	local tube = newModel("GlassSkybridge", decorationFolder)
	local z0, z1 = a.z1 - 2, b.z0 + 2
	local startPoint = worldPoint(-32, clampedRoofY(a, z0), z0)
	local endPoint = worldPoint(-32, clampedRoofY(b, z1), z1)
	local frame = CFrame.lookAt((startPoint + endPoint) / 2, endPoint)
	local length = (endPoint - startPoint).Magnitude
	createPart(tube, "Floor", V(16, 1, length), frame * CFrame.new(0, 0.5, 0), C.ConcreteDark)
	for _, sx in ipairs({ -8, 8 }) do
		createPart(tube, "GlassWall", V(0.8, 9, length), frame * CFrame.new(sx, 5, 0), C.Glass, { material = M.Glass, transparency = 0.5 })
		for dz = -length / 2 + 2, length / 2, 6 do
			createPart(tube, "Mullion", V(1, 9, 1), frame * CFrame.new(sx, 5, dz), C.MetalDark, { noStuds = true, noShadow = true })
		end
	end
	createPart(tube, "Roof", V(17, 1, length), frame * CFrame.new(0, 9.5, 0), C.MetalDark, { noStuds = true })
	createPart(tube, "RoofSnow", V(16.4, 1.2, length + 0.4), frame * CFrame.new(0, 10.6, 0), C.Snow)
	neonSign(tube, "SkybridgeSign", "PASO", 10, 3, frame * CFrame.new(0, 7, -length / 2 - 0.6), C.NeonCyan)
end

local function cityBlock(x, zm, width, depth, top, withWindows, faceSide)
	local model = newModel("CityBlock", cityFolder)
	local facade = FACADE_COLORS[random:NextInteger(1, #FACADE_COLORS)]
	local bottom = FOUNDATION_Y - BASE_Y
	createPart(model, "Body", V(width, top - bottom, depth), CFrame.new(worldPoint(x, (top + bottom) / 2, zm)), facade, { noStuds = true })
	createPart(model, "Cornice", V(width + 1.4, 1.2, depth + 1.4), CFrame.new(worldPoint(x, top - 0.2, zm)), C.ConcreteDark, { noStuds = true, noShadow = true })
	local roof = createPart(model, "RoofSnow", V(width, 1.4, depth), CFrame.new(worldPoint(x, top + 0.9, zm)), C.Snow)
	CollectionService:AddTag(roof, "Hazard")
	roof:SetAttribute("HazardKind", "Pit")
	if withWindows then
		for row = 0, 2 do
			placeWindowRow(model, "x", x + faceSide * (width / 2 + 0.3), zm - depth / 2 + 5, zm + depth / 2 - 5, top - 7 - row * 12, facade)
		end
	end
	local roll = random:NextNumber()
	if roll < 0.25 then
		local tx, tz = x + (random:NextNumber() - 0.5) * width * 0.4, zm + (random:NextNumber() - 0.5) * depth * 0.4
		createPart(model, "WaterTank", V(7, 8, 8), CFrame.new(worldPoint(tx, top + 8, tz)) * CFrame.Angles(0, 0, math.pi / 2), C.Wood, { shape = Enum.PartType.Cylinder, noStuds = true })
		createPart(model, "WaterTankSnow", V(1.4, 8.8, 8.8), CFrame.new(worldPoint(tx, top + 12.2, tz)) * CFrame.Angles(0, 0, math.pi / 2), C.Snow, { shape = Enum.PartType.Cylinder, noStuds = true })
		createPart(model, "WaterTankStand", V(6, 4, 6), CFrame.new(worldPoint(tx, top + 3, tz)), C.WoodDark, { noStuds = true })
	elseif roll < 0.5 then
		local ux, uz = x + (random:NextNumber() - 0.5) * width * 0.5, zm + (random:NextNumber() - 0.5) * depth * 0.5
		createPart(model, "RoofUnit", V(6, 5, 5), CFrame.new(worldPoint(ux, top + 4, uz)), C.Metal, { noStuds = true })
		createPart(model, "RoofUnitSnow", V(6.4, 0.8, 5.4), CFrame.new(worldPoint(ux, top + 6.9, uz)), C.Snow)
	elseif roll < 0.62 then
		createPart(model, "Antenna", V(1, 22, 1), CFrame.new(worldPoint(x, top + 12, zm)), C.Pole, { noStuds = true })
	end
end

for _, side in ipairs({ -1, 1 }) do
	local zm = -260
	while zm < 2950 do
		local building = buildingAt(zm) or buildingAt(zm + 15) or buildingAt(zm - 15)
		local half = building and building.width / 2 or 70
		local width = 34 + random:NextNumber() * 44
		local depth = 34 + random:NextNumber() * 46
		local tall = random:NextNumber() < 0.1
		local ty = trackY(math.clamp(zm, -140, 2770))
		local top = ty + (tall and 20 + random:NextNumber() * 50 or -30 - random:NextNumber() * 120)
		top = math.max(top, STREET_CLEARANCE + random:NextNumber() * 40)
		local x = side * (half + 16 + random:NextNumber() * 30 + (tall and 40 or 0) + width / 2)
		cityBlock(x, zm, width, depth, top, true, -side)
		zm += depth + 6 + random:NextNumber() * 14
	end
end
local distantCount = 0
while distantCount < 120 do
	local angle = random:NextNumber() * math.pi * 2
	local radius = 520 + random:NextNumber() * 900
	local x = math.cos(angle) * radius
	local zm = 1300 + math.sin(angle) * radius * 1.4
	if math.abs(x) > 260 then
		distantCount += 1
		local top = math.max(trackY(math.clamp(zm, -140, 2770)) - 80 - random:NextNumber() * 300, STREET_CLEARANCE + random:NextNumber() * 60)
		cityBlock(x, zm, 50 + random:NextNumber() * 70, 50 + random:NextNumber() * 70, top, false, 1)
	end
end
for tileX = -1, 1 do
	for tileZ = 0, 3 do
		createPart(cityFolder, "Street", V(1100, 10, 1000), CFrame.new(worldPoint(tileX * 1100, FOUNDATION_Y - BASE_Y - 5, -500 + tileZ * 1000)), C.Street, { noShadow = true })
	end
end

local plateauSpawn = createPart(gameplayFolder, "PlateauSpawn", V(30, 1, 30), CFrame.new(worldPoint(0, 0.5, -110)), C.Pad)
CollectionService:AddTag(plateauSpawn, "PlateauSpawn")

do
	local signFrame = CFrame.new(worldPoint(0, 26, -134))
	local signModel = newModel("CitySign", decorationFolder)
	for _, side in ipairs({ -1, 1 }) do
		createPart(signModel, "SignPole", V(1.6, 22, 1.6), CFrame.new(worldPoint(side * 26, 11, -134)), C.MetalDark, { noStuds = true })
	end
	neonSign(signModel, "CitySign", "CIUDAD NEVADA", 60, 12, signFrame, C.NeonPink)
end

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
local portalZm = 2740
portalCopy:PivotTo(portalSource:GetPivot() + V(OFFSET_X, BASE_Y + roofY(portalZm) - levelOnePlazaTop, -portalZm - portalSource:GetPivot().Position.Z))
portalCopy.Parent = root
for _, descendant in ipairs(portalCopy:GetDescendants()) do
	if descendant:GetAttribute("DestinationLevel") ~= nil then descendant:SetAttribute("DestinationLevel", nil) end
end
if levelTwo then
	for _, descendant in ipairs(levelTwo:GetDescendants()) do
		if CollectionService:HasTag(descendant, "ReturnPortal") then descendant:SetAttribute("DestinationLevel", LEVEL_ID) end
	end
end

local camera = workspace.CurrentCamera
if camera then
	camera.CFrame = CFrame.lookAt(worldPoint(160, 140, -200), worldPoint(0, -120, 500))
end

local partCount = 0
for _, descendant in ipairs(root:GetDescendants()) do
	if descendant:IsA("BasePart") then partCount += 1 end
end
print(("Level 3 built: %d parts, finish Y %.1f, portal Y %.1f"):format(partCount, BASE_Y + roofY(2680), BASE_Y + roofY(portalZm)))
