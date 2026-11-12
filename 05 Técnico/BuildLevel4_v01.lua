local CollectionService = game:GetService("CollectionService")

local LEVEL_FOLDER_NAME = "PenguinSlingshotMap_Level4"
local LEVEL_ID = 4
local OFFSET_X = 18000
local BASE_Y = 1200
local SLINGSHOT_LIFT = BASE_Y - 600
local MOUNTAIN_HALF_WIDTH = 220
local V = Vector3.new
local M = Enum.Material

local levelOne = workspace:FindFirstChild("PenguinSlingshotMap_v01")
local levelThree = workspace:FindFirstChild("PenguinSlingshotMap_Level3")
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
local terrainFolder = newFolder("Terrain")
local obstacleFolder = newFolder("Obstacles")
local wreckFolder = newFolder("PlaneWreck")
local wildlifeFolder = newFolder("Wildlife")
local decorationFolder = newFolder("Decoration")
local gameplayFolder = newFolder("Gameplay")
local hazardFolder = newFolder("Hazards")

local function rgb(hex)
	return Color3.fromRGB(bit32.rshift(hex, 16) % 256, bit32.rshift(hex, 8) % 256, hex % 256)
end

local C = {
	Snow = rgb(0xf4f8fd), SnowShade = rgb(0xdbe6f1), Ice = rgb(0xcfeeff), LakeIce = rgb(0x9ad6f5), Crevasse = rgb(0x1d3a5c),
	Stone = rgb(0x8d96a1), Rock = rgb(0x6f7884), RockLight = rgb(0x8d96a1), Bark = rgb(0x5a3820), BareBark = rgb(0x3a3029),
	Log = rgb(0x8a5a36), LogDark = rgb(0x6a4127), Pine = rgb(0x2d6a4a), PineDark = rgb(0x24583d), Black = rgb(0x1e2833),
	White = rgb(0xf5f5f5), Orange = rgb(0xf39c1f), OrangeDark = rgb(0xd07a10), Red = rgb(0xc8281e), Yellow = rgb(0xffc928),
	Hull = rgb(0xdfe3e8), HullShade = rgb(0xb7bec7), Steel = rgb(0x9aa3ad), SteelDark = rgb(0x5b636d), Stripe = rgb(0x2f5fa8),
	StripeRed = rgb(0xb83a2e), Seat = rgb(0x3b5a8a), SeatDark = rgb(0x2a3f63), Tire = rgb(0x22262b), Window = rgb(0x26303b),
	Tent = rgb(0xe8742c), TentDoor = rgb(0x6b2c10), Crate = rgb(0xa77a4a), Glass = rgb(0x9fd3f0), Cargo = rgb(0xb0b7bf),
	CargoRib = rgb(0x8d959e), Prop = rgb(0x30353c), Bag = rgb(0x3b6b4a), SignWood = rgb(0x7a4a2a), Pad = rgb(0xffd166),
	Antler = rgb(0xd2bf94), AntlerBase = rgb(0x8a6f4a), Hoof = rgb(0x1b1410), DeerWhite = rgb(0xf3ece0), EarInner = rgb(0xd9b49a),
}
local SUITCASE_COLORS = { rgb(0x7a2e2e), rgb(0x2f4b6e), rgb(0x3b6b4a), rgb(0x6b5a3a) }
local WIRE_COLORS = { rgb(0xd03030), rgb(0x2b6fd8), rgb(0xf0c020), rgb(0x333333) }
local DEER = {
	macho = { scale = 1, antlers = true, spots = false, coat = rgb(0x7a4b2e), dark = rgb(0x4e2f1c), belly = rgb(0xb89470), mane = rgb(0x3f2717) },
	hembra = { scale = 0.88, antlers = false, spots = false, coat = rgb(0x87573a), dark = rgb(0x5a3a24), belly = rgb(0xc6a27c), mane = rgb(0x4a2e1c) },
	cria = { scale = 0.62, antlers = false, spots = true, coat = rgb(0x9a6a44), dark = rgb(0x6a4428), belly = rgb(0xd2b48c), mane = rgb(0x5a3a22) },
}

local random = Random.new(41)
local function roll() return random:NextNumber() end

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

local zones = {
	{ z0 = -140, z1 = 0, slope = 0 }, { z0 = 0, z1 = 20, drop = 40 }, { z0 = 20, z1 = 250, slope = 14 },
	{ z0 = 250, z1 = 790, slope = 16 }, { z0 = 790, z1 = 1320, slope = 18 }, { z0 = 1320, z1 = 1480, slope = 4 },
	{ z0 = 1480, z1 = 1940, slope = 20 }, { z0 = 1940, z1 = 1960, drop = 25 }, { z0 = 1960, z1 = 2420, slope = 15 },
	{ z0 = 2420, z1 = 2900, slope = 12 }, { z0 = 2900, z1 = 3380, slope = 16 }, { z0 = 3380, z1 = 3490, slope = 7 },
	{ z0 = 3490, z1 = 3560, slope = 0 },
}
local runningElevation = 0
for _, zone in ipairs(zones) do
	zone.e0 = runningElevation
	if zone.drop then
		zone.e1 = runningElevation - zone.drop
	else
		zone.e1 = runningElevation - (zone.z1 - zone.z0) * math.tan(math.rad(zone.slope))
	end
	runningElevation = zone.e1
end
local crevasses = { { z0 = 766, z1 = 782, bridgeX = -30, bridge = "wing" }, { z0 = 2206, z1 = 2222 }, { z0 = 3236, z1 = 3252, bridgeX = 28, bridge = "snow" } }
local CANYON_START, CANYON_END = 1560, 1880

local function elevationAt(zm)
	if zm <= -140 then return 0 end
	for _, zone in ipairs(zones) do
		if zm >= zone.z0 and zm <= zone.z1 then
			return zone.e0 + (zone.e1 - zone.e0) * (zm - zone.z0) / (zone.z1 - zone.z0)
		end
	end
	return zones[#zones].e1
end

local function inCanyon(zm) return zm > CANYON_START and zm < CANYON_END end

local function halfTrack(zm)
	if not inCanyon(zm) then return 62 end
	return 62 - 18 * math.min(1, math.min(zm - CANYON_START, CANYON_END - zm) / 40)
end

local function worldPoint(x, y, zm)
	return V(OFFSET_X + x, BASE_Y + y, -zm)
end

local function groundFrame(x, zm, lift)
	return CFrame.new(worldPoint(x, elevationAt(zm) + (lift or 0), zm))
end

local function solidRanges(z0, z1)
	local ranges = { { z0, z1 } }
	for _, crevasse in ipairs(crevasses) do
		local nextRanges = {}
		for _, range in ipairs(ranges) do
			if crevasse.z1 <= range[1] or crevasse.z0 >= range[2] then
				table.insert(nextRanges, range)
			else
				if crevasse.z0 - range[1] > 0.5 then table.insert(nextRanges, { range[1], crevasse.z0 }) end
				if range[2] - crevasse.z1 > 0.5 then table.insert(nextRanges, { crevasse.z1, range[2] }) end
			end
		end
		ranges = nextRanges
	end
	return ranges
end

local zoneBoundaries = {}
for _, zone in ipairs(zones) do table.insert(zoneBoundaries, zone.z0) end

local function alongSlope(parent, name, z0, z1, x, width, lift, thickness, color, options)
	local cuts = { z0 }
	for _, boundary in ipairs(zoneBoundaries) do
		if boundary > z0 and boundary < z1 then table.insert(cuts, boundary) end
	end
	table.insert(cuts, z1)
	local parts = {}
	for index = 1, #cuts - 1 do
		local startPoint = worldPoint(x, elevationAt(cuts[index]), cuts[index])
		local endPoint = worldPoint(x, elevationAt(cuts[index + 1]), cuts[index + 1])
		local frame = CFrame.lookAt((startPoint + endPoint) / 2, endPoint) * CFrame.new(0, lift + thickness / 2, 0)
		table.insert(parts, createPart(parent, name, V(width, thickness, (endPoint - startPoint).Magnitude), frame, color, options))
	end
	return parts
end

local function buildGround(name, z0, z1, topColor)
	local high, low = BASE_Y + elevationAt(z0), BASE_Y + elevationAt(z1)
	createPart(terrainFolder, name .. "Base", V(MOUNTAIN_HALF_WIDTH * 2, low, z1 - z0), CFrame.new(OFFSET_X, low / 2, -(z0 + z1) / 2), C.SnowShade)
	if high - low > 0.05 then
		createPart(terrainFolder, name .. "Slope", V(MOUNTAIN_HALF_WIDTH * 2, high - low, z1 - z0), CFrame.new(OFFSET_X, (high + low) / 2, -(z0 + z1) / 2), topColor or C.Snow, { className = "WedgePart" })
	end
end

createPart(terrainFolder, "Plateau", V(260, BASE_Y, 140), CFrame.new(OFFSET_X, BASE_Y / 2, 70), C.Snow)
for index, zone in ipairs(zones) do
	if zone.drop then
		local high, low = BASE_Y + zone.e0, BASE_Y + zone.e1
		local width = index == 2 and 260 or MOUNTAIN_HALF_WIDTH * 2
		createPart(terrainFolder, "CliffBase", V(width, low, zone.z1 - zone.z0), CFrame.new(OFFSET_X, low / 2, -(zone.z0 + zone.z1) / 2), C.Rock, { noStuds = true })
		createPart(terrainFolder, "CliffSlope", V(width, high - low, zone.z1 - zone.z0), CFrame.new(OFFSET_X, (high + low) / 2, -(zone.z0 + zone.z1) / 2), C.Rock, { className = "WedgePart" })
	elseif index > 2 then
		for part, range in ipairs(solidRanges(zone.z0, zone.z1)) do
			buildGround(("Zone%d_%d"):format(index, part), range[1], range[2])
		end
	end
end
for _, tileX in ipairs({ -1000, 1000 }) do
	for _, tileZ in ipairs({ -800, -2800 }) do
		local floor = createPart(terrainFolder, "ValleyFloor", V(2000, 4, 2000), CFrame.new(OFFSET_X + tileX, -2, tileZ), C.SnowShade)
		CollectionService:AddTag(floor, "Hazard")
		floor:SetAttribute("HazardKind", "Pit")
	end
end

for _, crevasse in ipairs(crevasses) do
	local midZ = (crevasse.z0 + crevasse.z1) / 2
	local surfaceY = elevationAt(midZ)
	local depth = crevasse.z1 - crevasse.z0
	createPart(terrainFolder, "CrevasseFloor", V(MOUNTAIN_HALF_WIDTH * 2, BASE_Y + surfaceY - 40, depth), CFrame.new(OFFSET_X, (BASE_Y + surfaceY - 40) / 2, -midZ), C.Crevasse, { noStuds = true })
	for _, edgeZ in ipairs({ crevasse.z0, crevasse.z1 }) do
		createPart(terrainFolder, "CrevasseLip", V(MOUNTAIN_HALF_WIDTH * 2, 1.4, 1.6), groundFrame(0, edgeZ, -1.6), C.Ice, { noStuds = true })
	end
	for k = 0, 25 do
		local edgeZ = roll() < 0.5 and crevasse.z0 + 0.6 or crevasse.z1 - 0.6
		createPart(terrainFolder, "Icicle", V(1 + roll(), 2 + roll() * 3, 1), groundFrame(-210 + k * 16.5, edgeZ, -2.5), C.Ice, { noStuds = true, noShadow = true })
	end
	for _, side in ipairs({ -1, 1 }) do
		for _, markerZ in ipairs({ crevasse.z0 - 3, crevasse.z1 + 3 }) do
			local base = groundFrame(side * 56, markerZ)
			createPart(decorationFolder, "CrevasseMarker", V(0.5, 9, 0.5), base * CFrame.new(0, 4.5, 0), C.SteelDark, { noStuds = true })
			createPart(decorationFolder, "CrevasseFlag", V(0.3, 2, 3), base * CFrame.new(0, 8, 1.5), C.Red, { noStuds = true })
		end
	end
	local pit = createPart(hazardFolder, "CrevassePit", V(MOUNTAIN_HALF_WIDTH * 2, 4, depth), CFrame.new(worldPoint(0, surfaceY - 27, midZ)), C.Black, { transparency = 1, noStuds = true, noShadow = true })
	CollectionService:AddTag(pit, "Hazard")
	pit:SetAttribute("HazardKind", "Pit")
end

alongSlope(terrainFolder, "LakeIce", 1330, 1470, 0, 300, 0, 0.6, C.LakeIce)
for _, side in ipairs({ -62, 62 }) do
	for index = 3, #zones - 1 do
		local zone = zones[index]
		if not zone.drop then
			for _, range in ipairs(solidRanges(zone.z0, zone.z1)) do
				local a, b = range[1], range[2]
				if b <= CANYON_START or a >= CANYON_END then
					alongSlope(terrainFolder, "SnowBank", a, b, side, 4, 0, 6, C.SnowShade)
				else
					if a < CANYON_START then alongSlope(terrainFolder, "SnowBank", a, CANYON_START, side, 4, 0, 6, C.SnowShade) end
					if b > CANYON_END then alongSlope(terrainFolder, "SnowBank", CANYON_END, b, side, 4, 0, 6, C.SnowShade) end
				end
			end
		end
	end
end
do
	local endY = elevationAt(3560)
	createPart(terrainFolder, "EndWall", V(MOUNTAIN_HALF_WIDTH * 2, 10, 6), CFrame.new(worldPoint(0, endY + 5, 3563)), C.SnowShade)
end

local function piece(model, base, name, size, x, y, z, color, options, rotation)
	local frame = base * CFrame.new(x, y, z)
	if rotation then frame *= rotation end
	return createPart(model, name, size, frame, color, options)
end

local function cylinderAlongX(model, base, name, length, diameter, x, y, z, color, options, rotation)
	local opts = options and table.clone(options) or {}
	opts.shape = Enum.PartType.Cylinder
	opts.noStuds = true
	return piece(model, base, name, V(length, diameter, diameter), x, y, z, color, opts, rotation)
end

local function rockPile(parent, base, width, height, outlined)
	local model = newModel("RockPile", parent)
	local steps = math.max(2, math.round(height / 7))
	local y = -3
	local blockWidth = width
	for step = 0, steps - 1 do
		blockWidth = width * (1 - step / steps * 0.6) * (0.85 + roll() * 0.3)
		local blockHeight = height / steps + 2
		piece(model, base, "Rock", V(blockWidth, blockHeight, blockWidth * (0.8 + roll() * 0.3)), (roll() - 0.5) * width * 0.12, y + blockHeight / 2, (roll() - 0.5) * width * 0.12, step % 2 == 0 and C.Rock or C.RockLight, nil, CFrame.Angles(0, roll() * 1.2, 0))
		y += blockHeight - 1.2
		if roll() < 0.55 then piece(model, base, "RockSnow", V(blockWidth * 0.7, 1, blockWidth * 0.6), 0, y + 0.4, 0, C.Snow, nil, CFrame.Angles(0, roll(), 0)) end
	end
	piece(model, base, "RockCap", V(width * 0.42, 1.3, width * 0.4), 0, y + 0.6, 0, C.Snow)
	return model
end

local function buildPine(parent, x, zm, scale)
	local model = newModel("Pine", parent)
	local base = groundFrame(x, zm)
	piece(model, base, "Trunk", V(2.5, 12, 2.5) * scale, 0, 6 * scale, 0, C.Bark, { noStuds = true })
	for index, tier in ipairs({ { 14, 9, 13 }, { 11, 8, 20 }, { 7.5, 7, 26.5 }, { 4, 6, 32 } }) do
		local width, height, y = tier[1] * scale, tier[2] * scale, tier[3] * scale
		local spin = CFrame.Angles(0, math.pi / 4 * index, 0)
		piece(model, base, "Needles", V(width, height, width), 0, y, 0, index % 2 == 0 and C.Pine or C.PineDark, nil, spin)
		piece(model, base, "NeedleSnow", V(width * 0.82, 0.8 * scale, width * 0.82), 0, y + height / 2 + 0.3 * scale, 0, C.Snow, { noShadow = true }, spin)
	end
	return model
end

local function buildBareTree(parent, x, zm, scale)
	local model = newModel("BareTree", parent)
	local base = groundFrame(x, zm)
	piece(model, base, "Trunk", V(2, 30, 2) * scale, 0, 15 * scale, 0, C.BareBark, { noStuds = true })
	for index = 0, 3 do
		local branch = base * CFrame.new(0, (12 + index * 4.5) * scale, 0) * CFrame.Angles(0, roll() * 6, 0.9 + roll() * 0.4)
		createPart(model, "Branch", V(0.5, 7, 0.5) * scale, branch * CFrame.new(0, 3.5 * scale, 0), C.BareBark, { noStuds = true, noShadow = true })
		createPart(model, "BranchSnow", V(0.7, 0.3, 0.9) * scale, branch * CFrame.new(0.3, 5 * scale, 0), C.Snow, { noStuds = true, noShadow = true })
	end
	return model
end

local function buildDeer(parent, base, kind)
	local spec = DEER[kind]
	local k = spec.scale
	local model = newModel("Deer_" .. kind, parent)
	local function at(x, y, z) return CFrame.new(x * k, y * k, z * k) end
	local function add(name, size, frame, color, options)
		return createPart(model, name, size * k, base * frame, color, options or { noStuds = true })
	end
	for _, legSpot in ipairs({ { 3, 1.15 }, { 3, -1.15 }, { -3.1, 1.2 }, { -3.1, -1.2 } }) do
		local leg = at(legSpot[1], 6.2, legSpot[2])
		add("UpperLeg", V(1.3, 3.2, 1.3), leg * at(0, -1.4, 0), spec.coat)
		add("LowerLeg", V(0.85, 3, 0.85), leg * at(0, -4.3, 0), spec.dark)
		add("Hoof", V(1, 0.6, 1), leg * at(0, -5.9, 0), C.Hoof)
		add("HoofSnow", V(1.05, 0.35, 1.05), leg * at(0, -5.35, 0), C.Snow)
	end
	add("Body", V(7.6, 3.6, 3.3), at(0, 8, 0), spec.coat)
	add("Chest", V(3.2, 3.6, 3.1), at(3.2, 7.7, 0), spec.coat)
	add("Rump", V(2.8, 3.8, 3.5), at(-3.5, 8.1, 0), spec.coat)
	add("Belly", V(7, 0.6, 2.9), at(-0.2, 6.05, 0), spec.belly)
	add("RumpPatch", V(0.3, 2.6, 2.6), at(-5.05, 8, 0), C.DeerWhite)
	add("Tail", V(0.6, 1.5, 1.1), at(-5.3, 8.9, 0), spec.coat)
	add("TailWhite", V(0.25, 1.3, 0.9), at(-5.65, 8.85, 0), C.DeerWhite)
	if spec.spots then
		for _, spot in ipairs({ { 1.5, 0.6 }, { -0.5, -0.8 }, { -2, 0.7 }, { 0.3, 1 }, { 2.4, -0.6 }, { -1.2, 0 } }) do
			add("Spot", V(0.7, 0.12, 0.7), at(spot[1], 9.85, spot[2]), C.DeerWhite)
		end
	end
	add("BackSnow", V(5.6, 0.55, 2.6), at(-0.6, 10.05, 0), C.Snow, {})
	add("RumpSnow", V(2.4, 0.45, 2.8), at(-3.4, 10.25, 0), C.Snow, {})
	add("ShoulderSnow", V(3, 0.35, 1.6), at(1.6, 10.4, 0.2), C.Snow)
	local neck = at(3.8, 9, 0) * CFrame.Angles(0, 0, -0.62)
	add("Neck", V(2.3, 4.6, 2.2), neck * at(0, 2, 0), spec.coat)
	add("Mane", V(2.5, 3.2, 2.4), neck * at(-0.25, 1.4, 0), spec.mane)
	add("Throat", V(0.2, 1.6, 1.2), neck * at(1.1, 3.2, 0), spec.belly)
	add("NeckSnow", V(0.5, 2.6, 2), neck * at(-1.45, 2, 0), C.Snow)
	local head = neck * at(0, 4.4, 0) * CFrame.Angles(0, 0, 0.62)
	add("Skull", V(2.6, 2.2, 2.1), head * at(0.5, 0.5, 0), spec.coat)
	add("Snout", V(2.2, 1.5, 1.6), head * at(2.4, 0, 0), spec.coat)
	add("Nose", V(0.5, 0.75, 0.95), head * at(3.55, 0.15, 0), C.Hoof)
	add("Jaw", V(2, 0.4, 1.3), head * at(2.3, -0.78, 0), spec.belly)
	for _, side in ipairs({ -1, 1 }) do
		add("Eye", V(0.5, 0.5, 0.12), head * at(1.2, 0.95, side * 1.07), C.Hoof)
		add("EyeShine", V(0.62, 0.62, 0.08), head * at(1.2, 1.18, side * 1.06), C.DeerWhite)
		local ear = head * at(-0.2, 1.4, side * 0.9) * CFrame.Angles(side * 1.05, 0, 0)
		add("Ear", V(0.5, 1.45, 0.85), ear * at(0, 0.7, 0), spec.coat)
		add("EarInner", V(0.2, 1, 0.5), ear * at(0.22, 0.75, 0), C.EarInner)
		if spec.antlers then
			local antler = head * at(0.2, 1.5, side * 0.6) * CFrame.Angles(side * 0.42, 0, 0.18)
			add("AntlerBase", V(0.6, 0.7, 0.6), antler * at(0, 0.2, 0), C.AntlerBase)
			add("AntlerBeam", V(0.5, 3.6, 0.5), antler * at(0, 2.2, 0), C.Antler)
			local upper = antler * at(0, 3.9, 0) * CFrame.Angles(0, 0, 0.55)
			add("AntlerUpper", V(0.45, 2.8, 0.45), upper * at(0, 1.3, 0), C.Antler)
			local crown = upper * at(0, 2.6, 0) * CFrame.Angles(0, 0, -0.7)
			add("AntlerCrown", V(0.4, 2.2, 0.4), crown * at(0, 1, 0), C.Antler)
			add("AntlerTine", V(0.38, 1.9, 0.38), antler * at(0, 1.4, 0) * CFrame.Angles(0, 0, -1.05) * at(0, 0.9, 0), C.Antler)
			add("AntlerTine", V(0.36, 1.8, 0.36), antler * at(0, 3, 0) * CFrame.Angles(0, 0, -0.85) * at(0, 0.85, 0), C.Antler)
			add("AntlerTine", V(0.34, 1.6, 0.34), upper * at(0, 1.4, 0) * CFrame.Angles(side * 0.7, 0, 0.3) * at(0, 0.75, 0), C.Antler)
			add("AntlerSnow", V(0.55, 0.25, 0.55), upper * at(0, 2.75, 0), C.Snow)
		end
	end
	return model
end

local builders = {}
local halfLengths = {
	seats = 1.5, suitcase = 1.5, panel = 1.5, wingpiece = 4.5, engine = 6, gear = 2, propeller = 1.5, door = 1, cargo = 4,
	rock = 6, rocklow = 3, log = 1.3, icechunk = 3, tent = 5, crates = 1.7, sled = 5, snowmobile = 5, antenna = 3, flag = 1,
}

local function snowSlab(m, b, width, depth, y, x, z)
	return piece(m, b, "Snow", V(width, 0.6, depth), x or 0, y, z or 0, C.Snow, { noShadow = true })
end

builders.seats = function(m, b)
	b *= CFrame.Angles(0, (roll() - 0.5) * 0.6, 0)
	piece(m, b, "Frame", V(8, 0.6, 3), 0, 0.3, 0, C.SteelDark, { noStuds = true })
	for i = -1, 1 do
		piece(m, b, "Cushion", V(2.4, 0.9, 2.4), i * 2.6, 1.2, -0.1, C.Seat, { noStuds = true })
		piece(m, b, "Backrest", V(2.4, 2.6, 0.6), i * 2.6, 2.6, 1.1, C.Seat, { noStuds = true }, CFrame.Angles(-0.12, 0, 0))
		piece(m, b, "Headrest", V(2.2, 0.5, 0.7), i * 2.6, 3.95, 1.25, C.SeatDark, { noStuds = true })
	end
	for i = 0, 3 do piece(m, b, "Armrest", V(0.3, 0.3, 2.2), -3.9 + i * 2.6, 1.9, 0, C.Steel, { noStuds = true, noShadow = true }) end
	snowSlab(m, b, 7.4, 1.8, 4.3, 0, 0.8)
	snowSlab(m, b, 7, 1.6, 1.8, 0, -0.4)
end
builders.suitcase = function(m, b)
	local function pick() return SUITCASE_COLORS[random:NextInteger(1, #SUITCASE_COLORS)] end
	piece(m, b, "Suitcase", V(3.2, 1.4, 2.2), -1.4, 0.7, 0, pick(), { noStuds = true }, CFrame.Angles(0, 0.3, 0))
	piece(m, b, "Suitcase", V(2.6, 2, 1.2), 1.5, 1, 0.2, pick(), { noStuds = true }, CFrame.Angles(0, -0.2, 0))
	piece(m, b, "Handle", V(1, 0.3, 0.3), 1.5, 2.15, 0.2, C.Tire, { noStuds = true, noShadow = true })
	piece(m, b, "Suitcase", V(2.4, 1.2, 1.8), -1.2, 2, -0.1, pick(), { noStuds = true }, CFrame.Angles(0, 0.5, 0))
	snowSlab(m, b, 2.6, 1.6, 2.8, -1.2, -0.1)
end
builders.panel = function(m, b, length)
	local count = math.max(2, math.round(length / 6))
	for i = 0, count - 1 do
		local x = -length / 2 + (i + 0.5) * length / count
		local bend = (i / (count - 1) - 0.5) * 0.8
		piece(m, b, "HullPanel", V(length / count + 0.2, 0.5, 3), x, 1.2 + math.cos(bend * 2) * 1.3, 0, C.Hull, { noStuds = true }, CFrame.Angles(0, 0, bend * 0.3))
	end
	piece(m, b, "PanelStripe", V(length, 0.3, 0.4), 0, 1.6, 1.4, C.Stripe, { noStuds = true, noShadow = true })
	for i = 0, 2 do piece(m, b, "PanelProp", V(0.5, 2, 0.5), -length / 2 + 3 + i * (length - 6) / 2, 0.6, 0, C.HullShade, { noStuds = true }) end
	snowSlab(m, b, length * 0.6, 1.4, 2.9)
end
builders.wingpiece = function(m, b)
	b *= CFrame.Angles(0, (roll() - 0.5) * 0.3, 0)
	piece(m, b, "Wing", V(24, 1.2, 7.5), 0, 1.4, -0.75, C.HullShade)
	piece(m, b, "WingTip", V(12, 1.2, 1.5), 6, 1.4, 3.75, C.HullShade)
	piece(m, b, "Flap", V(22, 0.25, 0.5), 0, 2.05, -1.6, C.SteelDark, { noStuds = true, noShadow = true })
	for _, x in ipairs({ -8, 0, 8 }) do piece(m, b, "Rib", V(0.8, 1, 6), x, 0.4, 0, C.SteelDark, { noStuds = true }) end
	piece(m, b, "Snow", V(18, 0.8, 4), -1, 2.3, 1.5, C.Snow, { noShadow = true })
end
builders.engine = function(m, b)
	b *= CFrame.Angles(0, 0.6, 0)
	cylinderAlongX(m, b, "Nacelle", 12, 8, 0, 4, 0, C.HullShade, nil, CFrame.Angles(0, math.pi / 2, 0))
	cylinderAlongX(m, b, "Intake", 0.4, 6.4, 0, 4, 6.1, C.Tire, nil, CFrame.Angles(0, math.pi / 2, 0))
	cylinderAlongX(m, b, "Spinner", 0.6, 2, 0, 4, 6.3, C.Steel, nil, CFrame.Angles(0, math.pi / 2, 0))
	piece(m, b, "Pylon", V(1.2, 3, 6), 0, 8, 0, C.Hull, { noStuds = true })
	piece(m, b, "Snow", V(7, 1.4, 9), 0, 8.6, 0, C.Snow)
	piece(m, b, "SnowTop", V(5, 1, 6), 0, 9.8, 0, C.Snow)
	piece(m, b, "SnowDrift", V(10, 2, 14), 0, 0.6, 0, C.Snow)
end
builders.gear = function(m, b)
	piece(m, b, "Strut", V(1.2, 9, 1.2), 0, 5, 0, C.Steel, { noStuds = true }, CFrame.Angles(0.25, 0, 0))
	piece(m, b, "Axle", V(4, 1, 1.2), 0, 1.6, -0.9, C.SteelDark, { noStuds = true })
	for _, side in ipairs({ -1, 1 }) do
		cylinderAlongX(m, b, "Tire", 1.6, 4.4, side * 2.4, 2.2, -0.9, C.Tire)
		cylinderAlongX(m, b, "Hub", 1.7, 1.8, side * 2.4, 2.2, -0.9, C.Steel)
	end
	piece(m, b, "Snow", V(1.6, 0.6, 1.6), 0, 9.6, 1.1, C.Snow)
end
builders.propeller = function(m, b)
	piece(m, b, "Gearbox", V(3, 3, 3), 0, 8, 0, C.SteelDark, { noStuds = true })
	piece(m, b, "Spinner", V(2, 2, 2), 0, 8, 1.6, C.Hull, { noStuds = true })
	for i = 0, 2 do
		local blade = b * CFrame.new(0, 8, 0) * CFrame.Angles(0, 0, i * math.pi * 2 / 3 + 0.3)
		createPart(m, "Blade", V(1.4, 8, 0.4), blade * CFrame.new(0, 4.6, 0) * CFrame.Angles(0, 0.25, 0), C.Prop, { noStuds = true })
		createPart(m, "BladeTip", V(1.42, 0.9, 0.42), blade * CFrame.new(0, 8.2, 0) * CFrame.Angles(0, 0.25, 0), C.Yellow, { noStuds = true })
	end
	piece(m, b, "Snow", V(1.6, 1, 1.6), 0, 9.9, 0, C.Snow)
	piece(m, b, "SnowDrift", V(8, 2, 4), -2, 0.6, 0, C.Snow)
end
builders.door = function(m, b)
	local tilt = CFrame.Angles(0, 0, 0.12)
	piece(m, b, "Door", V(4.4, 8.6, 0.8), 0, 4.6, 0, C.Hull, { noStuds = true }, tilt)
	piece(m, b, "DoorWindow", V(1.6, 1.6, 0.9), 0.2, 6.6, 0, C.Window, { noStuds = true, noShadow = true }, tilt)
	piece(m, b, "DoorHandle", V(1.4, 0.4, 0.3), 1.2, 4.2, 0.5, C.SteelDark, { noStuds = true, noShadow = true }, tilt)
	piece(m, b, "Snow", V(4.4, 0.7, 1.4), 0.6, 9.2, 0, C.Snow, nil, tilt)
	piece(m, b, "SnowDrift", V(7, 2.4, 4), 0, 0.8, 0, C.Snow)
end
builders.cargo = function(m, b)
	b *= CFrame.Angles(0, 0.25, 0)
	piece(m, b, "Container", V(8, 8, 7), 0, 4, 0, C.Cargo, { noStuds = true })
	for i = 0, 3 do piece(m, b, "Rib", V(0.3, 7.6, 7.1), -3.6 + i * 2.4, 4, 0, C.CargoRib, { noStuds = true, noShadow = true }) end
	piece(m, b, "Snow", V(8.4, 1.2, 7.4), 0, 8.6, 0, C.Snow)
end
builders.rock = function(m, b)
	rockPile(m, b, 12, 11, true)
end
builders.rocklow = function(m, b)
	piece(m, b, "Rock", V(9, 2.4, 6), 0, 0.9, 0, C.RockLight, nil, CFrame.Angles(0, roll(), 0))
	piece(m, b, "Snow", V(7, 1, 4.6), 0, 2.5, 0, C.Snow, nil, CFrame.Angles(0, roll() * 0.5, 0))
end
builders.log = function(m, b, length)
	piece(m, b, "Log", V(length, 2.6, 2.6), 0, 1.3, 0, C.Log, { noStuds = true })
	for i = 0, math.floor(length / 6) - 1 do piece(m, b, "Ring", V(0.3, 2.7, 2.7), -length / 2 + 3 + i * 6, 1.3, 0, C.LogDark, { noStuds = true, noShadow = true }) end
	piece(m, b, "Snow", V(length - 2, 0.7, 2.2), 0, 2.9, 0, C.Snow)
end
builders.icechunk = function(m, b)
	piece(m, b, "Ice", V(7, 2.4, 6), 0, 1, 0, C.Ice, { transparency = 0.1 }, CFrame.Angles(0, roll(), 0))
	piece(m, b, "IceTop", V(4, 1.6, 3.5), 1, 2.4, 0.5, rgb(0xe6f7ff), nil, CFrame.Angles(0, roll(), 0))
end
builders.tent = function(m, b)
	piece(m, b, "TentLeft", V(10, 8.4, 5), -2.5, 4.2, 0, C.Tent, { className = "WedgePart", noStuds = true }, CFrame.Angles(0, math.pi / 2, 0))
	piece(m, b, "TentRight", V(10, 8.4, 5), 2.5, 4.2, 0, C.Tent, { className = "WedgePart", noStuds = true }, CFrame.Angles(0, -math.pi / 2, 0))
	piece(m, b, "TentDoor", V(3, 3.4, 0.2), 0, 1.7, 5.05, C.TentDoor, { noStuds = true, noShadow = true })
	piece(m, b, "TentPole", V(0.5, 9.4, 0.5), 0, 4.7, 5.3, C.SteelDark, { noStuds = true })
	piece(m, b, "RidgeSnow", V(1.2, 0.4, 10.4), 0, 8.5, 0, C.Snow)
end
builders.crates = function(m, b)
	for _, x in ipairs({ -1.8, 1.8 }) do piece(m, b, "Crate", V(3.4, 3, 3.4), x, 1.5, 0, C.Crate) end
	piece(m, b, "CrossBack", V(1.4, 1.4, 0.1), -1.8, 1.6, 1.75, C.Red, { noStuds = true, noShadow = true })
	piece(m, b, "CrossV", V(0.4, 1.4, 0.12), -1.8, 1.6, 1.78, C.White, { noStuds = true, noShadow = true })
	piece(m, b, "CrossH", V(1.4, 0.4, 0.12), -1.8, 1.6, 1.78, C.White, { noStuds = true, noShadow = true })
	snowSlab(m, b, 6.6, 3, 3.3)
end
builders.sled = function(m, b)
	piece(m, b, "Deck", V(4.4, 0.6, 9), 0, 1.4, 0, C.Red, { noStuds = true })
	for _, side in ipairs({ -1, 1 }) do
		piece(m, b, "Runner", V(0.4, 0.4, 10), side * 2, 0.3, 0, C.SteelDark, { noStuds = true })
		for _, z in ipairs({ -3, 0, 3 }) do piece(m, b, "Post", V(0.4, 1, 0.4), side * 2, 0.8, z, C.SteelDark, { noStuds = true, noShadow = true }) end
	end
	piece(m, b, "Bag", V(3.6, 1.2, 4), 0, 2.3, -1.5, C.Bag, { noStuds = true })
	snowSlab(m, b, 3.4, 3.6, 3.2, 0, -1.5)
end
builders.snowmobile = function(m, b)
	piece(m, b, "Body", V(4.4, 2, 8), 0, 1.8, 0, C.Yellow, { noStuds = true })
	piece(m, b, "Seat", V(3.8, 1.4, 4), 0, 3.3, 1.4, C.Black, { noStuds = true })
	piece(m, b, "Windshield", V(3.6, 2, 0.3), 0, 4, -1.4, C.Glass, { noStuds = true, transparency = 0.4 }, CFrame.Angles(-0.4, 0, 0))
	for _, side in ipairs({ -1, 1 }) do piece(m, b, "Ski", V(0.8, 0.4, 4), side * 1.8, 0.2, -3.8, C.SteelDark, { noStuds = true }) end
	piece(m, b, "Track", V(4, 1, 6), 0, 0.6, 1.6, C.Tire, { noStuds = true })
	piece(m, b, "FlagPole", V(0.2, 8, 0.2), 1.6, 7.6, 3, C.SteelDark, { noStuds = true, noShadow = true })
	piece(m, b, "Flag", V(0.1, 1.6, 2.4), 1.6, 10.6, 4.2, C.Orange, { noStuds = true })
	piece(m, b, "Snow", V(3.8, 0.5, 3), 0, 4.2, 2, C.Snow)
end
builders.antenna = function(m, b)
	for _, sx in ipairs({ -1, 1 }) do
		for _, sz in ipairs({ -1, 1 }) do piece(m, b, "Leg", V(0.5, 22, 0.5), sx * 1.6, 11, sz * 1.6, C.Steel, { noStuds = true }, CFrame.Angles(sz * 0.06, 0, -sx * 0.06)) end
	end
	for y = 3, 20, 4 do piece(m, b, "Brace", V(3.4, 0.3, 3.4), 0, y, 0, C.SteelDark, { noStuds = true, noShadow = true }) end
	piece(m, b, "Beacon", V(1.2, 1.2, 1.2), 0, 22.6, 0, rgb(0xff3030), { shape = Enum.PartType.Ball, material = M.Neon })
	piece(m, b, "Snow", V(1.8, 0.5, 1.8), 0, 22, 0, C.Snow)
end
builders.flag = function(m, b)
	piece(m, b, "Pole", V(0.6, 14, 0.6), 0, 7, 0, C.Steel, { noStuds = true })
	piece(m, b, "Flag", V(0.15, 3.6, 6), 0, 12, 3, C.Orange, { noStuds = true })
	piece(m, b, "FlagStripe", V(0.17, 1.2, 6), 0, 12, 3, C.White, { noStuds = true, noShadow = true })
	piece(m, b, "Snow", V(1.2, 0.4, 1.2), 0, 14.2, 0, C.Snow)
end

local deerKinds = { deerM = "macho", deerF = "hembra", deerC = "cria" }

local function placeObstacle(parent, entry)
	local kind, zm, x, extra = entry[1], entry[2], entry[3], entry[4]
	if kind == "pine" then
		return buildPine(parent, x, zm, 1)
	end
	if deerKinds[kind] then
		return buildDeer(parent, groundFrame(x, zm) * CFrame.Angles(0, extra or 0, 0), deerKinds[kind])
	end
	local model = newModel(kind, parent)
	local base = CFrame.new(worldPoint(x, elevationAt(zm + (halfLengths[kind] or 1)), zm))
	builders[kind](model, base, extra)
	return model
end

local layout = {
	{ "seats", 275, -28 }, { "suitcase", 290, 24 }, { "rocklow", 305, -5 }, { "panel", 322, 36, 18 }, { "seats", 340, -44 }, { "suitcase", 352, 8 }, { "rock", 372, -20 }, { "wingpiece", 395, 28 }, { "suitcase", 412, -40 }, { "seats", 430, 0 }, { "panel", 448, -26, 22 }, { "engine", 470, 34 }, { "rocklow", 488, -14 }, { "door", 505, 12 }, { "seats", 520, -38 }, { "suitcase", 535, 36 }, { "rock", 552, -2 }, { "panel", 572, 26, 26 }, { "seats", 590, -24 }, { "cargo", 610, 40 }, { "suitcase", 625, -6 }, { "gear", 644, -40 }, { "rocklow", 660, 20 }, { "seats", 676, -14 }, { "panel", 694, 40, 20 }, { "suitcase", 710, -30 }, { "rock", 728, 10 }, { "seats", 745, -46 },
	{ "pine", 808, -36 }, { "deerM", 825, 22, 0.35 }, { "log", 845, -10, 50 }, { "pine", 860, 40 }, { "deerF", 878, -40, -0.6 }, { "deerC", 884, -30, -0.9 }, { "pine", 900, 8 }, { "suitcase", 918, -22 }, { "pine", 935, -48 }, { "deerF", 952, 30, 2.4 }, { "log", 972, 16, 60 }, { "pine", 990, -18 }, { "door", 1008, 40 }, { "pine", 1022, 22 }, { "deerM", 1040, -30, -2.6 }, { "suitcase", 1058, 4 }, { "pine", 1075, 48 }, { "pine", 1090, -44 }, { "log", 1110, -4, 70 }, { "deerF", 1130, 26, 0.2 }, { "deerC", 1136, 36, 0.5 }, { "pine", 1152, -14 }, { "seats", 1170, 30 }, { "pine", 1185, -38 }, { "deerM", 1205, 8, 2.8 }, { "pine", 1225, 44 }, { "log", 1245, -20, 50 }, { "pine", 1262, 20 }, { "deerF", 1282, -36, -0.4 }, { "suitcase", 1300, 10 },
	{ "icechunk", 1335, -30 }, { "icechunk", 1342, 26 }, { "seats", 1362, -8 }, { "deerF", 1380, 30, 1.57 }, { "deerC", 1384, 40, 1.4 }, { "icechunk", 1398, -44 }, { "icechunk", 1410, 4 }, { "seats", 1428, 36 }, { "deerM", 1442, -24, -1.4 }, { "icechunk", 1456, 16 }, { "icechunk", 1466, -12 },
	{ "rock", 1500, -30 }, { "panel", 1515, 20, 24 }, { "rocklow", 1532, -6 }, { "gear", 1550, 34 }, { "rock", 1575, 10 }, { "panel", 1592, -28, 20 }, { "engine", 1612, 24 }, { "rocklow", 1630, -10 }, { "rock", 1650, -30 }, { "gear", 1668, 6 }, { "suitcase", 1684, 28 }, { "rock", 1704, -12 }, { "panel", 1722, 22, 22 }, { "rocklow", 1738, -26 }, { "rock", 1756, 26 }, { "seats", 1772, -6 }, { "engine", 1792, -24 }, { "rocklow", 1810, 16 }, { "rock", 1828, -4 }, { "suitcase", 1846, -28 }, { "gear", 1866, 26 }, { "rock", 1888, -20 }, { "rocklow", 1905, 10 }, { "panel", 1922, -30, 24 },
	{ "rock", 1990, 26 }, { "deerM", 2010, -30, 0.8 }, { "deerF", 2016, -14, 1.1 }, { "deerC", 2022, -22, 0.6 }, { "propeller", 2045, 30 }, { "rocklow", 2062, -4 }, { "cargo", 2085, -40 }, { "rock", 2102, 12 }, { "suitcase", 2120, 40 }, { "seats", 2138, -22 }, { "rock", 2158, -46 }, { "panel", 2176, 20, 26 }, { "rocklow", 2192, -14 }, { "deerF", 2240, 36, -2.2 }, { "rock", 2256, -8 }, { "propeller", 2276, -36 }, { "cargo", 2296, 24 }, { "rocklow", 2314, -22 }, { "deerM", 2334, 10, -1 }, { "rock", 2354, 44 }, { "suitcase", 2370, -34 }, { "seats", 2388, 14 }, { "rocklow", 2404, -4 },
	{ "flag", 2430, -46 }, { "flag", 2430, 46 }, { "tent", 2452, -28 }, { "crates", 2470, 20 }, { "sled", 2488, -4 }, { "tent", 2506, 34 }, { "snowmobile", 2526, -38 }, { "crates", 2544, -14 }, { "antenna", 2564, 16 }, { "sled", 2582, 40 }, { "tent", 2602, -30 }, { "crates", 2620, 4 }, { "snowmobile", 2640, 30 }, { "sled", 2658, -20 }, { "tent", 2678, 18 }, { "crates", 2696, -40 }, { "flag", 2714, -6 }, { "snowmobile", 2734, -28 }, { "crates", 2752, 30 }, { "tent", 2772, -10 }, { "sled", 2790, 22 }, { "crates", 2808, -32 }, { "antenna", 2828, 36 }, { "sled", 2846, -6 }, { "tent", 2866, 28 }, { "crates", 2884, -22 },
	{ "pine", 2915, -30 }, { "deerF", 2932, 24, 0.4 }, { "panel", 2950, -6, 24 }, { "pine", 2966, 40 }, { "deerM", 2984, -38, -2.7 }, { "suitcase", 3002, 10 }, { "pine", 3018, -16 }, { "engine", 3036, 30 }, { "log", 3056, -20, 50 }, { "deerC", 3074, 34, -0.3 }, { "deerF", 3080, 24, -0.6 }, { "pine", 3096, -44 }, { "seats", 3112, 4 }, { "pine", 3128, 36 }, { "rock", 3146, -24 }, { "deerM", 3164, 20, 2.5 }, { "wingpiece", 3184, -20 }, { "pine", 3202, 44 }, { "suitcase", 3220, 6 }, { "pine", 3270, -34 }, { "deerF", 3288, 16, 1.8 }, { "log", 3306, 30, 40 }, { "pine", 3322, -10 }, { "rocklow", 3340, 22 }, { "deerC", 3356, -30, 0.8 },
	{ "crates", 3400, -34 }, { "flag", 3420, 40 }, { "sled", 3442, 24 }, { "flag", 3460, -40 },
}
for _, entry in ipairs(layout) do
	placeObstacle(deerKinds[entry[1]] and wildlifeFolder or obstacleFolder, entry)
end

do
	local crevasse = crevasses[1]
	local startPoint = worldPoint(crevasse.bridgeX, elevationAt(crevasse.z0 - 4), crevasse.z0 - 4)
	local endPoint = worldPoint(crevasse.bridgeX, elevationAt(crevasse.z1 + 4), crevasse.z1 + 4)
	local frame = CFrame.lookAt((startPoint + endPoint) / 2, endPoint)
	local length = (endPoint - startPoint).Magnitude
	local bridge = newModel("WingBridge", decorationFolder)
	createPart(bridge, "Wing", V(16, 1.2, length), frame * CFrame.new(0, 0.6, 0), C.HullShade)
	createPart(bridge, "WingSnow", V(14, 0.6, length - 2), frame * CFrame.new(0, 1.5, 0), C.Snow, { noShadow = true })
	for _, side in ipairs({ -1, 1 }) do createPart(bridge, "WingEdge", V(0.6, 1.6, length), frame * CFrame.new(side * 7.6, 1.2, 0), C.Stripe, { noStuds = true }) end
end
do
	local crevasse = crevasses[3]
	local startPoint = worldPoint(crevasse.bridgeX, elevationAt(crevasse.z0 - 4), crevasse.z0 - 4)
	local endPoint = worldPoint(crevasse.bridgeX, elevationAt(crevasse.z1 + 4), crevasse.z1 + 4)
	local frame = CFrame.lookAt((startPoint + endPoint) / 2, endPoint)
	local bridge = newModel("SnowBridge", decorationFolder)
	createPart(bridge, "SnowBridge", V(14, 3, (endPoint - startPoint).Magnitude), frame * CFrame.new(0, -1.5, 0), C.Snow)
	for k = 0, 5 do createPart(bridge, "Icicle", V(1, 2 + roll() * 2, 1), groundFrame(crevasse.bridgeX - 6 + k * 2.4, (crevasse.z0 + crevasse.z1) / 2, -4.5), C.Ice, { noStuds = true, noShadow = true }) end
end

local function buildFuselage(x, zm, yaw)
	local length, radius = 88, 11
	local model = newModel("Fuselage", wreckFolder)
	local base = CFrame.new(worldPoint(x, elevationAt(zm) + 6.6, zm)) * CFrame.Angles(0, yaw, -0.06)
	cylinderAlongX(model, base, "Hull", length, radius * 2, 0, 0, 0, C.Hull)
	for i = 0, math.floor(length / 4) - 2 do
		for _, side in ipairs({ -1, 1 }) do
			piece(model, base, "Window", V(1.6, 1.9, 0.3), -length / 2 + 4 + i * 4, 1.6, side * (radius - 0.05), C.Window, { noStuds = true, noShadow = true })
		end
	end
	for _, side in ipairs({ -1, 1 }) do
		piece(model, base, "Stripe", V(length, 0.8, 0.3), 0, -0.2, side * (radius - 0.02), C.Stripe, { noStuds = true, noShadow = true })
		piece(model, base, "StripeRed", V(length, 0.35, 0.3), 0, -1, side * (radius - 0.02), C.StripeRed, { noStuds = true, noShadow = true })
	end
	for step = 0, 4 do
		cylinderAlongX(model, base, "Nose", 2.8, (radius - step * 1.7) * 2, length / 2 + 1.4 + step * 2.8, -step * 0.4, 0, C.Hull)
	end
	piece(model, base, "Cockpit", V(3.4, 1.6, 8), length / 2 + 4, 3.6, 0, C.Window, { noStuds = true }, CFrame.Angles(0, 0, -0.35))
	for i = 0, 13 do
		local angle = i / 14 * math.pi * 2
		local plateLength = 1.5 + roll() * 4
		piece(model, base, "TornPlate", V(plateLength, 1.4 + roll() * 2, 0.4), -length / 2 - plateLength / 2 + 0.6, math.sin(angle) * radius, math.cos(angle) * radius, roll() < 0.5 and C.Hull or C.HullShade, { noStuds = true }, CFrame.Angles(angle, 0, (roll() - 0.5) * 0.6))
	end
	for i = 0, 8 do
		piece(model, base, "Wire", V(0.2, 0.2, 3 + roll() * 5), -length / 2 - 1.5, (roll() - 0.5) * 10, (roll() - 0.5) * 10, WIRE_COLORS[i % 4 + 1], { noStuds = true, noShadow = true, noCollide = true }, CFrame.Angles(roll() * 3, roll() * 3, roll() * 3))
	end
	local y = radius - 1.4
	for _, layer in ipairs({ { length, 2.2, 8.5 }, { length - 6, 1.6, 6 }, { length - 14, 1.2, 3.6 } }) do
		piece(model, base, "RoofSnow", V(layer[1], layer[2], layer[3]), -2, y + layer[2] / 2, 0, C.Snow)
		y += layer[2] - 0.3
	end
	for _, side in ipairs({ -1, 1 }) do piece(model, base, "SnowDrift", V(length + 10, 5, 4), 0, -radius + 1, side * (radius - 0.5), C.Snow) end
end

local function buildTail(x, zm, yaw, lift)
	local model = newModel("TailSection", wreckFolder)
	local base = CFrame.new(worldPoint(x, elevationAt(zm) + lift, zm)) * CFrame.Angles(0, yaw, 0.18)
	for step = 0, 3 do
		cylinderAlongX(model, base, "TailCone", 5.5, (6.4 - step * 1.2) * 2, -8.25 + step * 5.5, 0, 0, C.Hull)
	end
	piece(model, base, "Fin", V(9, 17.5, 1), 5, 12.5, 0, C.Hull, { noStuds = true }, CFrame.Angles(0, 0, -0.3))
	piece(model, base, "FinStripe", V(9.2, 3, 1.1), 6.2, 11, 0, C.Stripe, { noStuds = true }, CFrame.Angles(0, 0, -0.3))
	for _, side in ipairs({ -1, 1 }) do piece(model, base, "Stabilizer", V(10, 0.6, 9), 5, 1.5, side * 6, C.HullShade, { noStuds = true }) end
	piece(model, base, "FinSnow", V(4, 1.2, 1.6), 9.5, 21, 0, C.Snow, nil, CFrame.Angles(0, 0, -0.3))
	piece(model, base, "BodySnow", V(22, 1.6, 5), 0, 5.6, 0, C.Snow)
	for i = 0, 9 do
		local angle = i / 10 * math.pi * 2
		piece(model, base, "TornPlate", V(1.6 + roll() * 2.5, 1.2, 0.4), -11.6, math.sin(angle) * 6, math.cos(angle) * 6, C.HullShade, { noStuds = true }, CFrame.Angles(angle, 0, 0))
	end
end

local function buildStuckWing(x, zm, yaw)
	local model = newModel("StuckWing", wreckFolder)
	local base = CFrame.new(worldPoint(x, elevationAt(zm) - 3, zm)) * CFrame.Angles(0, yaw, 0)
	local plate = base * CFrame.new(4, 0, 0) * CFrame.Angles(0, 0, 1.25)
	createPart(model, "Wing", V(34, 10, 1.2), plate * CFrame.new(17, 5, 0), C.HullShade)
	createPart(model, "WingTipSnow", V(3, 1, 2), plate * CFrame.new(33, 10.4, 0), C.Snow)
	piece(model, base, "SnowDrift", V(12, 3, 8), 0, 1.5, 0, C.Snow)
end

buildFuselage(-118, 450, 0.42)
buildStuckWing(100, 640, -0.6)
do
	local zm = 1720
	local ledge = groundFrame(150, zm)
	createPart(wreckFolder, "TailLedge", V(70, 46, 60), ledge * CFrame.new(0, 10, 0), C.Rock)
	createPart(wreckFolder, "TailLedgeSnow", V(66, 2, 56), ledge * CFrame.new(0, 34, 0), C.Snow)
	buildTail(150, zm, -0.9, 38)
end

for i = 1, 34 do
	local zm = 280 + roll() * 480
	local side = roll() < 0.6 and -1 or 1
	local x = side * (72 + roll() * 70)
	if not (x < -80 and x > -160 and zm > 400 and zm < 500) then
		local kinds = { "seats", "suitcase", "panel", "rocklow" }
		placeObstacle(wreckFolder, { kinds[random:NextInteger(1, #kinds)], zm, x, 14 + roll() * 10 })
	end
end
for i = 1, 18 do
	local zm = 1500 + roll() * 420
	local x = (roll() < 0.5 and -1 or 1) * (90 + roll() * 40)
	placeObstacle(wreckFolder, { roll() < 0.5 and "panel" or "suitcase", zm, x, 16 })
end

local canyonFolder = newFolder("CanyonWalls")
for _, side in ipairs({ -1, 1 }) do
	local zm = CANYON_START - 20
	while zm < CANYON_END + 20 do
		local inner = halfTrack(zm) + 2
		local width = 18 + roll() * 14
		rockPile(canyonFolder, groundFrame(side * (inner + width / 2), zm), width, 22 + roll() * 20, true)
		if roll() < 0.35 and not (side > 0 and zm > 1680 and zm < 1760) then
			rockPile(canyonFolder, groundFrame(side * (inner + width + 10 + roll() * 20), zm + 6), 26 + roll() * 20, 32 + roll() * 30, false)
		end
		zm += 14 + roll() * 8
	end
end

local forestFolder = newFolder("Forest")
local denseRanges = { { 790, 1320 }, { 2900, 3380 } }
for _, side in ipairs({ -1, 1 }) do
	local zm = 30
	while zm < 3540 do
		local dense = false
		for _, range in ipairs(denseRanges) do
			if zm > range[1] and zm < range[2] then dense = true end
		end
		local skip = inCanyon(zm) or (zm > 1300 and zm < 1480) or (not dense and roll() < 0.55)
		if not skip then
			local x = side * (74 + roll() * (dense and 70 or 120))
			local nearFuselage = x < -80 and x > -160 and zm > 390 and zm < 520
			if not nearFuselage then
				if roll() < 0.75 then buildPine(forestFolder, x, zm, 0.9 + roll() * 0.5) else buildBareTree(forestFolder, x, zm, 0.9 + roll() * 0.4) end
			end
		end
		zm += 16 + roll() * 14
	end
end
do
	local zm = 40
	while zm < 3540 do
		for _, side in ipairs({ -1, 1 }) do
			if roll() < 0.5 and not inCanyon(zm) then buildPine(forestFolder, side * (160 + roll() * 50), zm, 1 + roll() * 0.4) end
		end
		zm += 30 + roll() * 30
	end
end
for _, spot in ipairs({ { -100, -130 }, { 100, -130 }, { -110, -20 }, { 110, -20 } }) do
	buildPine(forestFolder, spot[1], spot[2], 1.1)
end
do
	local kinds = { "macho", "hembra", "cria" }
	for _, side in ipairs({ -1, 1 }) do
		local zm = 60
		while zm < 3540 do
			if roll() < 0.3 and not inCanyon(zm) then
				local x = side * (84 + roll() * 90)
				buildDeer(wildlifeFolder, groundFrame(x, zm) * CFrame.Angles(0, roll() * 6, 0), kinds[random:NextInteger(1, 3)])
			end
			zm += 70 + roll() * 50
		end
	end
end

local ridgeFolder = newFolder("Ridges")
local RIDGE_SCALES = { 1, 0.8, 0.6, 0.42, 0.26 }
for _, side in ipairs({ -1, 1 }) do
	local zm = -260
	while zm < 3800 do
		local width = 360 + roll() * 300
		local x = side * (MOUNTAIN_HALF_WIDTH + width / 2 - 20 + roll() * 120)
		local top = BASE_Y + elevationAt(math.clamp(zm, -140, 3560)) - 30 + roll() * 230
		local y = 0
		for step, scale in ipairs(RIDGE_SCALES) do
			local stepTop = step == 1 and top * 0.55 or top * (0.55 + 0.45 * (step - 1) / (#RIDGE_SCALES - 1))
			local color = step <= 2 and C.Rock or step == 3 and C.RockLight or C.Snow
			local depth = (200 + roll() * 80) * scale + 60
			local frame = CFrame.new(OFFSET_X + x + side * (step - 1) * width * 0.06, (y + stepTop) / 2, -zm + (roll() - 0.5) * 30) * CFrame.Angles(0, (roll() - 0.5) * 0.4, 0)
			createPart(ridgeFolder, "Ridge", V(width * scale, stepTop - y + 6, depth), frame, color, { noShadow = true })
			createPart(ridgeFolder, "RidgeSnow", V(width * scale * 0.8, 3, depth * 0.7), frame * CFrame.new(0, (stepTop - y + 6) / 2 + 1, 0), C.Snow, { noShadow = true })
			y = stepTop
		end
		zm += 170 + roll() * 90
	end
end
for i = 1, 10 do
	local zm = 40 + roll() * 3400
	if not inCanyon(zm) then
		rockPile(decorationFolder, groundFrame((roll() < 0.5 and -1 or 1) * (80 + roll() * 120), zm), 16 + roll() * 16, 14 + roll() * 20, false)
	end
end

local function boardWithText(parent, name, size, frame, boardColor, text, textColor, strokeColor)
	local board = createPart(parent, name, size, frame, boardColor, { noStuds = true })
	for _, face in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back }) do
		local gui = Instance.new("SurfaceGui")
		gui.Face = face
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.PixelsPerStud = 20
		gui.Parent = board
		local label = Instance.new("TextLabel")
		label.Size = UDim2.fromScale(1, 1)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextScaled = true
		label.Font = Enum.Font.FredokaOne
		label.TextColor3 = textColor
		label.TextStrokeColor3 = strokeColor
		label.TextStrokeTransparency = 0.4
		label.Parent = gui
	end
	return board
end

do
	local sign = newModel("ValleySign", decorationFolder)
	local base = CFrame.new(worldPoint(-30, 0, -60))
	for _, side in ipairs({ -1, 1 }) do piece(sign, base, "SignPost", V(1.4, 12, 1.4), side * 9, 6, 0, C.LogDark, { noStuds = true }) end
	boardWithText(sign, "SignBoard", V(22, 6, 0.8), base * CFrame.new(0, 9, 0), C.SignWood, "VALLE DEL AVIÓN", rgb(0xfff3d8), rgb(0x5a3820))
	piece(sign, base, "SignSnow", V(23, 1, 1.8), 0, 12.4, 0, C.Snow)
end

do
	local zm = 3440
	local arch = newModel("FinishArch", decorationFolder)
	local base = groundFrame(0, zm)
	for _, side in ipairs({ -1, 1 }) do
		for i = 0, 7 do piece(arch, base, "PostBlock", V(3.4, 3, 3.4), side * 62, 1.5 + i * 3, 0, i % 2 == 0 and C.Orange or C.White, { noStuds = true }) end
		piece(arch, base, "PostSnow", V(4.4, 1, 4.4), side * 62, 24.5, 0, C.Snow)
	end
	piece(arch, base, "Beam", V(128, 2, 2), 0, 23, 0, C.SteelDark, { noStuds = true })
	boardWithText(arch, "FinishBoard", V(40, 11, 0.8), base * CFrame.new(0, 29, 0), C.Orange, "¡META!", Color3.new(1, 1, 1), C.OrangeDark)
	piece(arch, base, "BoardSnow", V(42, 1, 2), 0, 35, 0, C.Snow)
	local flagColors = { C.Orange, C.White, C.Stripe }
	local index = 0
	for x = -56, 56, 8 do
		index += 1
		piece(arch, base, "Pennant", V(3, 2.4, 0.1), x, 20.6, 0, flagColors[index % 3 + 1], { noStuds = true, noShadow = true, noCollide = true })
	end
	local finishLine = alongSlope(gameplayFolder, "FinishLine", zm - 1.2, zm + 1.2, 0, 124, 0, 0.3, C.White, { material = M.Neon, noCollide = true })[1]
	CollectionService:AddTag(finishLine, "FinishLine")
end

local plateauSpawn = createPart(gameplayFolder, "PlateauSpawn", V(30, 1, 30), CFrame.new(worldPoint(0, 0.5, -110)), C.Pad)
CollectionService:AddTag(plateauSpawn, "PlateauSpawn")

local slingshotOffset = V(OFFSET_X, SLINGSHOT_LIFT, 0)
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
local portalZm = 3530
portalCopy:PivotTo(portalSource:GetPivot() + V(OFFSET_X, BASE_Y + elevationAt(portalZm) - levelOnePlazaTop, -portalZm - portalSource:GetPivot().Position.Z))
portalCopy.Parent = root
for _, descendant in ipairs(portalCopy:GetDescendants()) do
	if descendant:GetAttribute("DestinationLevel") ~= nil then descendant:SetAttribute("DestinationLevel", nil) end
end
if levelThree then
	for _, descendant in ipairs(levelThree:GetDescendants()) do
		if CollectionService:HasTag(descendant, "ReturnPortal") then descendant:SetAttribute("DestinationLevel", LEVEL_ID) end
	end
end

local camera = workspace.CurrentCamera
if camera then
	camera.CFrame = CFrame.lookAt(worldPoint(160, 160, -200), worldPoint(0, -200, 600))
end

local partCount = 0
for _, descendant in ipairs(root:GetDescendants()) do
	if descendant:IsA("BasePart") then partCount += 1 end
end
print(("Level 4 built: %d parts, finish Y %.1f, portal Y %.1f"):format(partCount, BASE_Y + elevationAt(3440), BASE_Y + elevationAt(portalZm)))
