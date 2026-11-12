local CollectionService = game:GetService("CollectionService")

local MAP_NAME = "PenguinSlingshotMap_v01"
local FOLDER_NAME = "FestiveDecoration"
local MOUNTAIN_HALF_WIDTH = 160
local V = Vector3.new
local M = Enum.Material

local levelOne = workspace:FindFirstChild(MAP_NAME)
local existing = levelOne:FindFirstChild(FOLDER_NAME)
if existing then existing:Destroy() end

local root = Instance.new("Folder")
root.Name = FOLDER_NAME
root.Parent = levelOne

local function newFolder(name)
	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = root
	return folder
end
local entranceFolder = newFolder("Entrance")
local crowdFolder = newFolder("Crowd")
local lightsFolder = newFolder("Lights")
local crystalFolder = newFolder("Crystals")
local wildlifeFolder = newFolder("WildlifeAndWaterfall")
local campFolder = newFolder("LivelyCamp")
local finishFolder = newFolder("FinishParty")
local landscapeFolder = newFolder("Landscape")

local function rgb(hex)
	return Color3.fromRGB(bit32.rshift(hex, 16) % 256, bit32.rshift(hex, 8) % 256, hex % 256)
end

local C = {
	Snow = rgb(0xf0f6fc), SnowShade = rgb(0xd6e2ee), Ice = rgb(0xbfe7ff), IceDeep = rgb(0x8fd0f5), Rock = rgb(0x787e86), RockLight = rgb(0x8d96a1),
	Wood = rgb(0x785234), WoodDark = rgb(0x6a4127), Pine = rgb(0x2d6a4a), PineDark = rgb(0x24583d), PenguinBlack = rgb(0x1e2833),
	White = rgb(0xffffff), Orange = rgb(0xf39c1f), Eye = rgb(0x0b0f14), Pole = rgb(0x2a2f36), Wire = rgb(0x222222), Lantern = rgb(0xffc46b),
	BleacherA = rgb(0x4f7fbf), BleacherB = rgb(0x3b6aa8), Banner = rgb(0xff4fa3), Board = rgb(0x14306b), Cocoa = rgb(0x6b3b1f),
	AwningRed = rgb(0xd8302a), Seal = rgb(0x8d9aa8), SealLight = rgb(0x9fabb8), SealDark = rgb(0x7d8a98), Bucket = rgb(0x2f6fd6),
	Flame = rgb(0xff7a2a), FlameCore = rgb(0xffd23f), Gold = rgb(0xffd23f), Silver = rgb(0xc9d3dd), Bronze = rgb(0xd08a4a),
	CastleIce = rgb(0x9fdcff), CastleCap = rgb(0xd8f3ff), Stone = rgb(0x6f7884), Sign = rgb(0x9c6a42), SignText = rgb(0xfff3d8),
}
local BULB_COLORS = { rgb(0xff3b5c), rgb(0xffd23f), rgb(0x3fd0ff), rgb(0x7dff7a), rgb(0xff7ae0), rgb(0xff9a3f) }
local SCARF_COLORS = { rgb(0xd8302a), rgb(0x2f6fd6), rgb(0x3fae5a), rgb(0xf39c1f), rgb(0x9b4dd6), rgb(0xff6fae) }
local CRYSTAL_COLORS = { rgb(0x3fd0ff), rgb(0xb36bff), rgb(0xff6fd8), rgb(0x7dfcff) }

local CROWD_TAG = "CheeringPenguin"
local SPIN_TAG = "SpinningDecor"
local FLAME_TAG = "FlickeringFlame"
local FLIPPER_SHOULDER_X = 1.55
local FLIPPER_SHOULDER_Y = 1.1
local FLIPPER_ARM_OFFSET = CFrame.new(0.15, -1, 0)
local FLIPPER_REST_ANGLE = 0.18

local random = Random.new(11)
local function roll() return random:NextNumber() end

local function createPart(parent, name, size, cframe, color, options)
	options = options or {}
	local part = Instance.new(options.className or "Part")
	part.Name = name
	part.Anchored = options.anchored ~= false
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
	if options.noCollide then
		part.CanCollide = false
		part.CanQuery = false
		part.CanTouch = false
	end
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
	{ z0 = -160, z1 = 0, slope = 0, flat = 600 }, { z0 = 0, z1 = 20, flat = 560 }, { z0 = 20, z1 = 200, slope = 15 }, { z0 = 200, z1 = 520, slope = 18 },
	{ z0 = 520, z1 = 900, slope = 20 }, { z0 = 900, z1 = 1000, slope = 0 }, { z0 = 1000, z1 = 1400, slope = 22 }, { z0 = 1400, z1 = 1650, slope = 15 },
	{ z0 = 1650, z1 = 1800, slope = 5 },
}
local runningElevation = 600
for _, zone in ipairs(zones) do
	zone.e0 = runningElevation
	zone.e1 = zone.flat or runningElevation - (zone.z1 - zone.z0) * math.tan(math.rad(zone.slope))
	runningElevation = zone.e1
end
local FINISH_ELEVATION = runningElevation

local function elevationAt(zm)
	if zm <= -160 then return 600 end
	for _, zone in ipairs(zones) do
		if zm >= zone.z0 and zm <= zone.z1 then
			return zone.e0 + (zone.e1 - zone.e0) * (zm - zone.z0) / (zone.z1 - zone.z0)
		end
	end
	return FINISH_ELEVATION
end
local RIVER_Y = elevationAt(900)

local function slopeAt(zm)
	for _, zone in ipairs(zones) do
		if zm >= zone.z0 and zm <= zone.z1 then return zone.slope or 0 end
	end
	return 0
end

local function worldPoint(x, y, zm)
	return V(x, y, -zm)
end

local function groundFrame(x, zm, lift)
	return CFrame.new(worldPoint(x, elevationAt(zm) + (lift or 0), zm))
end

local function piece(model, base, name, size, x, y, z, color, options, rotation)
	local frame = base * CFrame.new(x, y, z)
	if rotation then frame *= rotation end
	return createPart(model, name, size, frame, color, options)
end

local function neonBulb(parent, name, position, color, size)
	return createPart(parent, name, V(size or 1, size or 1, size or 1), CFrame.new(position), color, { shape = Enum.PartType.Ball, material = M.Neon, noCollide = true, noShadow = true })
end

local function pointLight(part, color, brightness, range)
	local light = Instance.new("PointLight")
	light.Color = color
	light.Brightness = brightness
	light.Range = range
	light.Parent = part
	return light
end

local function textBoard(parent, name, size, frame, boardColor, text, textColor, strokeColor)
	local board = createPart(parent, name, size, frame, boardColor, { noStuds = true })
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
		label.TextColor3 = textColor
		label.TextStrokeColor3 = strokeColor
		label.TextStrokeTransparency = 0
		label.Parent = gui
	end
	return board
end

local function flipperOffset(side, angle)
	return CFrame.new(side * FLIPPER_SHOULDER_X, FLIPPER_SHOULDER_Y, 0) * CFrame.Angles(0, 0, side * angle) * CFrame.new(side * FLIPPER_ARM_OFFSET.X, FLIPPER_ARM_OFFSET.Y, 0)
end

local function buildCheeringPenguin(parent, groundCFrame, scarfIndex, holdsFlag, cheers)
	local model = newModel("CheeringPenguin", parent)
	model.ModelStreamingMode = Enum.ModelStreamingMode.Atomic
	local rootFrame = groundCFrame * CFrame.new(0, 2.3, 0)
	local scarf = SCARF_COLORS[(scarfIndex - 1) % #SCARF_COLORS + 1]
	local looseOptions = { noStuds = true, noCollide = true, anchored = false }
	local body = createPart(model, "Body", V(3, 3, 2.8), rootFrame * CFrame.new(0, -0.5, 0), C.PenguinBlack, { noStuds = true, noCollide = true })
	model.PrimaryPart = body
	local function attach(name, size, offset, color)
		local part = createPart(model, name, size, rootFrame * offset, color, looseOptions)
		part.Massless = true
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = body
		weld.Part1 = part
		weld.Parent = part
		return part
	end
	attach("Head", V(2.7, 1.9, 2.6), CFrame.new(0, 1.95, 0), C.PenguinBlack)
	attach("Belly", V(2.2, 2.5, 0.2), CFrame.new(0, -0.6, -1.45), C.White)
	attach("Face", V(2.2, 1.2, 0.16), CFrame.new(0, 2.05, -1.35), C.White)
	attach("Beak", V(0.9, 0.42, 0.95), CFrame.new(0, 1.62, -1.75), C.Orange)
	attach("Scarf", V(3.1, 0.65, 2.9), CFrame.new(0, 1.05, 0), scarf)
	attach("Hat", V(2.8, 0.7, 2.7), CFrame.new(0, 3.15, 0), scarf)
	attach("Pompom", V(0.9, 0.9, 0.9), CFrame.new(0, 3.8, 0), C.White)
	for _, side in ipairs({ -1, 1 }) do
		attach("Eye", V(0.36, 0.46, 0.1), CFrame.new(side * 0.55, 2.08, -1.53), C.Eye)
		attach("Foot", V(1, 0.35, 1.4), CFrame.new(side * 0.75, -2.15, -0.35), C.Orange)
		local restOffset = flipperOffset(side, FLIPPER_REST_ANGLE)
		local flipper = createPart(model, side < 0 and "FlipperLeft" or "FlipperRight", V(0.4, 2.2, 1.5), body.CFrame * restOffset, C.PenguinBlack, looseOptions)
		flipper.Massless = true
		local weld = Instance.new("Weld")
		weld.Name = side < 0 and "FlipperLeftWeld" or "FlipperRightWeld"
		weld.Part0 = body
		weld.Part1 = flipper
		weld.C0 = restOffset
		weld:SetAttribute("Side", side)
		weld.Parent = body
		if holdsFlag and side > 0 then
			local function attachToFlipper(name, size, offset, color)
				local part = createPart(model, name, size, flipper.CFrame * offset, color, looseOptions)
				part.Massless = true
				local flagWeld = Instance.new("WeldConstraint")
				flagWeld.Part0 = flipper
				flagWeld.Part1 = part
				flagWeld.Parent = part
			end
			attachToFlipper("FlagPole", V(0.2, 5, 0.2), CFrame.new(0, -3.4, 0), C.Wire)
			attachToFlipper("Flag", V(0.1, 1.6, 2.4), CFrame.new(0, -5.1, 1.2), BULB_COLORS[(scarfIndex - 1) % #BULB_COLORS + 1])
		end
	end
	model:SetAttribute("CheerPhase", roll() * 6)
	model:SetAttribute("Cheers", cheers)
	CollectionService:AddTag(model, CROWD_TAG)
	return model
end

local function facingYaw(side)
	return side < 0 and -math.pi / 2 or math.pi / 2
end

local function buildBleachers(parent, innerX, zm0, length, side)
	local model = newModel("Bleachers", parent)
	for row = 0, 2 do
		local height = 1.5 + row * 2.4
		for offset = 0, length - 1, 6 do
			local zm = zm0 + offset
			local y = elevationAt(zm)
			local x = side * (innerX + row * 5)
			createPart(model, "Step", V(5, height, 6), CFrame.new(worldPoint(x, y + height / 2, zm)), row % 2 == 0 and C.BleacherB or C.BleacherA)
			if roll() < 0.8 then
				buildCheeringPenguin(crowdFolder, CFrame.new(worldPoint(x, y + height, zm)) * CFrame.Angles(0, facingYaw(side), 0), random:NextInteger(1, 6), roll() < 0.35, true)
			end
		end
	end
	for offset = 0, length - 1, 12 do
		local zm = zm0 + offset
		createPart(model, "BannerPole", V(0.5, 10, 0.5), CFrame.new(worldPoint(side * (innerX + 14), elevationAt(zm) + 5, zm)), C.Pole, { noStuds = true })
	end
	local startPoint = worldPoint(side * (innerX + 14), elevationAt(zm0) + 10, zm0)
	local endPoint = worldPoint(side * (innerX + 14), elevationAt(zm0 + length) + 10, zm0 + length)
	createPart(model, "Banner", V(0.3, 2.4, (endPoint - startPoint).Magnitude), CFrame.lookAt((startPoint + endPoint) / 2, endPoint), C.Banner, { noStuds = true, noShadow = true })
end

local function buildPine(parent, x, zm, scale, withLights)
	local model = newModel(withLights and "LitPine" or "Pine", parent)
	local base = groundFrame(x, zm)
	piece(model, base, "Trunk", V(2.5, 14, 2.5) * scale, 0, 6 * scale, 0, C.Wood, { noStuds = true })
	for index, tier in ipairs({ { 14, 10, 14 }, { 10, 9, 22 }, { 6, 8, 29 }, { 2.5, 6, 35 } }) do
		local width, height, y = tier[1] * scale, tier[2] * scale, tier[3] * scale
		local spin = CFrame.Angles(0, math.pi / 4 * index, 0)
		piece(model, base, "Needles", V(width, height, width), 0, y, 0, index % 2 == 0 and C.Pine or C.PineDark, nil, spin)
		if index < 4 then piece(model, base, "NeedleSnow", V(width * 0.8, 0.7 * scale, width * 0.8), 0, y + height / 2 + 0.3 * scale, 0, C.Snow, { noShadow = true }, spin) end
		if withLights and index < 4 then
			for bulb = 0, 3 do
				local angle = bulb * math.pi / 2 + index * 0.7
				neonBulb(model, "Bulb", (base * CFrame.new(math.cos(angle) * width * 0.52, y - height * 0.2, math.sin(angle) * width * 0.52)).Position, BULB_COLORS[(bulb + index) % #BULB_COLORS + 1], 0.9 * scale)
			end
		end
	end
	if withLights then
		piece(model, base, "Star", V(1.6, 1.6, 0.5) * scale, 0, 39 * scale, 0, C.Gold, { material = M.Neon, noCollide = true }, CFrame.Angles(0, 0, math.pi / 4))
	end
	return model
end

local function buildCrystal(parent, base, scale, color)
	local model = newModel("IceCrystal", parent)
	for _ = 1, 5 do
		local height, width = (4 + roll() * 7) * scale, (1.2 + roll() * 1.2) * scale
		piece(model, base, "Shard", V(width, height, width), (roll() - 0.5) * 3 * scale, height / 2 - 0.5, (roll() - 0.5) * 3 * scale, color, { material = M.Neon, transparency = 0.25, noStuds = true }, CFrame.Angles((roll() - 0.5) * 0.6, roll() * 3, (roll() - 0.5) * 0.6))
	end
	return model
end

do
	local arch = newModel("WelcomeArch", entranceFolder)
	local base = CFrame.new(worldPoint(0, 600, -85))
	for _, side in ipairs({ -1, 1 }) do
		for i = 0, 5 do piece(arch, base, "IceBlock", V(4, 3.4, 4), side * 24, 1.7 + i * 3.4, 0, i % 2 == 0 and C.IceDeep or C.Ice, { transparency = 0.05 }) end
		piece(arch, base, "PillarSnow", V(5, 1.2, 5), side * 24, 21, 0, C.Snow)
	end
	for i = 0, 10 do
		local angle = i / 10 * math.pi
		piece(arch, base, "ArchBlock", V(4, 3.4, 4.4), math.cos(angle) * 24, 21 + math.sin(angle) * 9, 0, i % 2 == 0 and C.IceDeep or C.Ice, { transparency = 0.05 }, CFrame.Angles(0, 0, angle - math.pi / 2))
	end
	textBoard(arch, "WelcomeSign", V(34, 7, 0.8), base * CFrame.new(0, 26, -0.2), C.Board, "PICO PINGÜINO", C.White, rgb(0x3fd0ff))
	for x = -20, 20, 5 do
		neonBulb(arch, "Bulb", (base * CFrame.new(x, 19.6 - math.cos(x / 20 * math.pi / 2) * 2, -1.4)).Position, BULB_COLORS[math.abs(x / 5) % #BULB_COLORS + 1], 1)
	end
end

local function buildIgloo(x, zm, scale)
	local model = newModel("Igloo", entranceFolder)
	local base = CFrame.new(worldPoint(x, 600, zm))
	local radius = 9 * scale
	for ring = 0, 5 do
		local ringRadius = radius * math.cos(ring / 6 * math.pi / 2)
		local y = radius * math.sin(ring / 6 * math.pi / 2)
		local count = math.max(6, math.round(ringRadius * 1.2))
		for i = 0, count - 1 do
			local angle = i / count * math.pi * 2 + ring * 0.3
			local nearDoor = ring < 2 and math.abs(angle - math.pi * 1.5) < 0.45
			if not nearDoor then
				piece(model, base, "SnowBrick", V(3.2, 1.6, 1.6) * scale, math.cos(angle) * ringRadius, y + 0.8 * scale, math.sin(angle) * ringRadius, (i + ring) % 2 == 0 and C.Snow or C.SnowShade, { noStuds = ring ~= 5 }, CFrame.Angles(0, -angle + math.pi / 2, 0))
			end
		end
	end
	piece(model, base, "Cap", V(3.4, 1.4, 3.4) * scale, 0, radius + 0.4, 0, C.Snow)
	piece(model, base, "Tunnel", V(5, 5, 6) * scale, 0, 2.5 * scale, -radius, C.Snow)
	piece(model, base, "Door", V(3, 3.6, 0.4) * scale, 0, 1.9 * scale, -radius - 3.05 * scale, rgb(0x1d2a3a), { noStuds = true })
	local window = piece(model, base, "Glow", V(1.8, 1.2, 0.3) * scale, 0, 1.9 * scale, -radius - 3.25 * scale, C.Lantern, { material = M.Neon, noCollide = true })
	pointLight(window, C.Lantern, 1.5, 18)
end
buildIgloo(-78, -120, 1)
buildIgloo(84, -100, 0.85)

do
	local stand = newModel("CocoaStand", entranceFolder)
	local base = CFrame.new(worldPoint(-70, 600, -45)) * CFrame.Angles(0, -math.pi / 2, 0)
	piece(stand, base, "Counter", V(12, 5, 6), 0, 2.5, 0, rgb(0x9c6a42))
	piece(stand, base, "CounterTop", V(12.4, 0.6, 6.4), 0, 5.3, 0, C.Snow)
	for i = 0, 5 do piece(stand, base, "Awning", V(2, 0.5, 7.6), -5 + i * 2, 10.4, 0, i % 2 == 0 and C.White or C.AwningRed, { noStuds = true }, CFrame.Angles(0.25, 0, 0)) end
	for _, x in ipairs({ -5.6, 5.6 }) do piece(stand, base, "AwningPost", V(0.6, 5, 0.6), x, 7.8, -2.6, C.WoodDark, { noStuds = true }) end
	for i = 0, 3 do
		piece(stand, base, "Mug", V(0.9, 1.1, 0.9), -3 + i * 2, 6.2, -1.6, ({ C.White, C.AwningRed, C.Bucket, rgb(0x3fae5a) })[i + 1], { noStuds = true })
		piece(stand, base, "Cocoa", V(0.7, 0.2, 0.7), -3 + i * 2, 6.8, -1.6, C.Cocoa, { noStuds = true, noShadow = true })
	end
	local sign = textBoard(stand, "CocoaSign", V(9, 2.4, 0.8), base * CFrame.new(0, 12.8, -2.9), C.Cocoa, "CHOCOLATE", C.SignText, rgb(0xff9a3f))
	pointLight(sign, rgb(0xffa040), 1, 20)
end

do
	local pennants = newModel("FencePennants", entranceFolder)
	for _, line in ipairs({ { -118, -1, -118, -159 }, { 118, -1, 118, -159 }, { -118, -159, 118, -159 } }) do
		local x0, z0, x1, z1 = line[1], line[2], line[3], line[4]
		local count = math.round(math.sqrt((x1 - x0) ^ 2 + (z1 - z0) ^ 2) / 4)
		for i = 0, count - 1 do
			local t = i / count
			local yaw = x0 == x1 and math.pi / 2 or 0
			createPart(pennants, "Pennant", V(1.8, 1.8, 0.15), CFrame.new(worldPoint(x0 + (x1 - x0) * t, 604.6, z0 + (z1 - z0) * t)) * CFrame.Angles(0, yaw, math.pi / 4), BULB_COLORS[i % #BULB_COLORS + 1], { noStuds = true, noCollide = true, noShadow = true })
		end
		local length = math.sqrt((x1 - x0) ^ 2 + (z1 - z0) ^ 2)
		createPart(pennants, "Cord", x0 == x1 and V(0.15, 0.12, length) or V(length, 0.12, 0.15), CFrame.new(worldPoint((x0 + x1) / 2, 605.5, (z0 + z1) / 2)), C.Wire, { noStuds = true, noCollide = true, noShadow = true })
	end
end

for i = 0, 8 do
	buildCheeringPenguin(crowdFolder, CFrame.new(worldPoint(-60 + i * 15, 600, -(4 + roll() * 3))), i + 1, roll() < 0.5, true)
end
for i = 0, 5 do
	local side = i % 2 == 0 and -1 or 1
	buildCheeringPenguin(crowdFolder, CFrame.new(worldPoint(side * (92 + roll() * 14), 600, -(4 + roll() * 6))) * CFrame.Angles(0, -side * 0.5, 0), i + 3, true, true)
end

do
	local ring = newModel("LaunchRing", entranceFolder)
	ring.ModelStreamingMode = Enum.ModelStreamingMode.Atomic
	local center = CFrame.new(worldPoint(0, 604.9, 20 * -1))
	for i = 0, 23 do
		local angle = i / 24 * math.pi * 2
		createPart(ring, "RingSegment", V(3.8, 0.4, 0.8), center * CFrame.Angles(0, angle, 0) * CFrame.new(0, 0, 14), rgb(0x3fd0ff), { material = M.Neon, noCollide = true, noShadow = true, transparency = 0.15 })
	end
	local pivot = createPart(ring, "Pivot", V(1, 1, 1), center, C.White, { transparency = 1, noCollide = true })
	ring.PrimaryPart = pivot
	ring:SetAttribute("SpinSpeed", 0.6)
	CollectionService:AddTag(ring, SPIN_TAG)
end

buildBleachers(finishFolder, 74, 1690, 90, -1)
buildBleachers(finishFolder, 74, 1690, 90, 1)
buildBleachers(crowdFolder, 74, 50, 110, -1)
buildBleachers(crowdFolder, 74, 50, 110, 1)
for _, side in ipairs({ -1, 1 }) do
	for i = 0, 6 do
		local zm = 902 + roll() * 14
		buildCheeringPenguin(crowdFolder, CFrame.new(worldPoint(side * (72 + roll() * 30), RIVER_Y, zm)) * CFrame.Angles(0, facingYaw(side), 0), i + 1, roll() < 0.5, true)
	end
end

do
	local target = newModel("LandingTarget", crowdFolder)
	local slope = math.rad(slopeAt(110))
	local center = groundFrame(0, 110, 0.12) * CFrame.Angles(-slope, 0, 0)
	for index, ring in ipairs({ { 30, rgb(0xff4fa3) }, { 22, C.White }, { 14, rgb(0xffd23f) }, { 6, rgb(0xff4fa3) } }) do
		createPart(target, "TargetRing", V(0.2 + index * 0.02, ring[1] * 2, ring[1] * 2), center * CFrame.new(0, index * 0.02, 0) * CFrame.Angles(0, 0, math.pi / 2), ring[2], { shape = Enum.PartType.Cylinder, noStuds = true, noCollide = true, noShadow = true, transparency = 0.4 })
	end
end

for _, side in ipairs({ -1, 1 }) do
	local lampIndex = 0
	for zm = 30, 1790, 50 do
		local inCanyon = zm > 1000 and zm < 1400
		local inRiver = zm > 895 and zm < 1003
		if not inCanyon and not inRiver then
			lampIndex += 1
			local lamp = newModel("LampPost", lightsFolder)
			local base = groundFrame(side * 70, zm)
			piece(lamp, base, "Post", V(1, 14, 1), 0, 7, 0, C.Pole, { noStuds = true })
			piece(lamp, base, "Arm", V(3, 0.6, 0.6), -side * 1.2, 13.6, 0, C.Pole, { noStuds = true })
			local lantern = piece(lamp, base, "Lantern", V(1.8, 2.2, 1.8), -side * 2.4, 12.4, 0, C.Lantern, { material = M.Neon, noCollide = true })
			piece(lamp, base, "LanternSnow", V(2.4, 0.5, 2.4), -side * 2.4, 13.8, 0, C.Snow)
			if lampIndex % 2 == 0 then pointLight(lantern, C.Lantern, 1.2, 22) end
		end
	end
end

for _, zm in ipairs({ 130, 520, 880, 1430, 1600 }) do
	local garland = newModel("Garland", lightsFolder)
	local y = elevationAt(zm)
	for _, side in ipairs({ -1, 1 }) do
		createPart(garland, "GarlandPole", V(1.2, 26, 1.2), CFrame.new(worldPoint(side * 66, y + 13, zm)), C.Pole, { noStuds = true })
		createPart(garland, "PoleSnow", V(2, 0.6, 2), CFrame.new(worldPoint(side * 66, y + 26.3, zm)), C.Snow)
	end
	createPart(garland, "GarlandWire", V(132, 0.15, 0.15), CFrame.new(worldPoint(0, y + 24.6, zm)), C.Wire, { noStuds = true, noCollide = true, noShadow = true })
	for x = -60, 60, 4 do
		neonBulb(garland, "Bulb", worldPoint(x, y + 24 - math.cos(x / 66 * math.pi / 2) * 3.2, zm), BULB_COLORS[math.abs(math.round(x / 4)) % #BULB_COLORS + 1], 1)
	end
end
do
	local zm = 40
	while zm < 1780 do
		if not (zm > 895 and zm < 1003) then
			for _, side in ipairs({ -1, 1 }) do
				if roll() < 0.28 then buildPine(lightsFolder, side * (110 + roll() * 40), zm, 1 + roll() * 0.3, true) end
			end
		end
		zm += 40 + roll() * 30
	end
end

for i = 1, 16 do
	local side = roll() < 0.5 and -1 or 1
	local zm = 210 + roll() * 300
	buildCrystal(crystalFolder, groundFrame(side * (72 + roll() * 70), zm), 1 + roll() * 0.6, CRYSTAL_COLORS[(i - 1) % 3 + 1])
end
for _, side in ipairs({ -1, 1 }) do
	local zm = 1010
	while zm < 1395 do
		buildCrystal(crystalFolder, groundFrame(side * (48 + roll() * 20), zm, 40), 1.2 + roll() * 0.8, CRYSTAL_COLORS[random:NextInteger(1, #CRYSTAL_COLORS)])
		for k = 0, 2 do
			local length = 3 + roll() * 6
			createPart(crystalFolder, "Icicle", V(1, length, 1), groundFrame(side * 39.4, zm + k * 5, 40 - length / 2 - 0.3), C.Ice, { noStuds = true, noCollide = true, noShadow = true, transparency = 0.15 })
		end
		zm += 22 + roll() * 14
	end
end

local function buildSeal(x, y, zm, yaw)
	local model = newModel("Seal", wildlifeFolder)
	local base = CFrame.new(worldPoint(x, y, zm)) * CFrame.Angles(0, yaw, 0)
	piece(model, base, "Body", V(6, 2.6, 3), 0, 1.3, 0, C.Seal, { noStuds = true })
	piece(model, base, "Head", V(2.8, 2.4, 2.6), 3.6, 2.4, 0, C.SealLight, { noStuds = true })
	piece(model, base, "Tail", V(1.6, 0.6, 1.2), -3.6, 0.4, 0, C.SealDark, { noStuds = true })
	piece(model, base, "Nose", V(0.5, 0.4, 0.6), 5, 2.3, 0, C.Wire, { noStuds = true })
	for _, side in ipairs({ -1, 1 }) do
		piece(model, base, "Eye", V(0.4, 0.4, 0.1), 4.6, 3, side * 0.7, C.Eye, { noStuds = true })
		piece(model, base, "Flipper", V(1.4, 0.3, 1), 1.2, 0.3, side * 1.8, C.SealDark, { noStuds = true })
	end
end
buildSeal(-88, RIVER_Y, 905, 0.3)
buildSeal(-104, RIVER_Y, 912, 2.7)
buildSeal(96, RIVER_Y, 996, -0.5)
buildSeal(-120, RIVER_Y - 4, 950, 1.2)
buildSeal(118, RIVER_Y - 4, 965, -2)
for _, spot in ipairs({ { 132, 998 }, { -140, 996 } }) do
	local x, zm = spot[1], spot[2]
	buildCheeringPenguin(wildlifeFolder, CFrame.new(worldPoint(x, RIVER_Y, zm)) * CFrame.Angles(0, math.pi, 0), 5, false, false)
	createPart(wildlifeFolder, "FishingRod", V(0.2, 0.2, 12), CFrame.new(worldPoint(x, RIVER_Y + 6, zm - 5)) * CFrame.Angles(-0.5, 0, 0), C.WoodDark, { noStuds = true, noCollide = true })
	createPart(wildlifeFolder, "FishingLine", V(0.06, 7, 0.06), CFrame.new(worldPoint(x, RIVER_Y + 0.5, zm - 10)), C.White, { noStuds = true, noCollide = true, noShadow = true })
	createPart(wildlifeFolder, "Bucket", V(2, 2, 2), CFrame.new(worldPoint(x + 3, RIVER_Y + 1, zm)), C.Bucket, { noStuds = true })
end
do
	local waterfall = newModel("FrozenWaterfall", wildlifeFolder)
	local cliffTop = RIVER_Y + 85
	createPart(waterfall, "Cliff", V(40, cliffTop, 40), CFrame.new(worldPoint(-164, cliffTop / 2, 930)), C.Stone, { noStuds = true })
	createPart(waterfall, "CliffSnow", V(36, 4, 36), CFrame.new(worldPoint(-164, cliffTop + 2, 930)), C.Snow)
	for i = 0, 13 do
		local height, width = 40 + roll() * 45, 3 + roll() * 4
		createPart(waterfall, "IceColumn", V(width, height, 3 + roll() * 3), CFrame.new(worldPoint(-144 + roll() * 3, RIVER_Y + height / 2 - 6, 930 + 14 - i * 2.1)), rgb(0xbfefff), { material = M.Glass, transparency = 0.25 })
	end
	createPart(waterfall, "IcePool", V(30, 3, 34), CFrame.new(worldPoint(-136, RIVER_Y - 5, 930)), C.Ice, { transparency = 0.1 })
end

do
	local fire = newModel("Campfire", campFolder)
	local base = groundFrame(-92, 1500)
	for i = 0, 7 do
		local angle = i / 8 * math.pi * 2
		piece(fire, base, "Stone", V(1.6, 1, 1.6), math.cos(angle) * 3, 0.5, math.sin(angle) * 3, C.Stone, { noStuds = true })
	end
	for i = 0, 2 do piece(fire, base, "Firewood", V(4, 0.8, 0.8), 0, 0.9, 0, C.Wood, { noStuds = true }, CFrame.Angles(0, i * 1.05, 0)) end
	local flame = piece(fire, base, "Flame", V(2, 3, 2), 0, 2.6, 0, C.Flame, { material = M.Neon, noCollide = true, transparency = 0.1 })
	piece(fire, base, "FlameCore", V(1.2, 2, 1.2), 0, 3.4, 0, C.FlameCore, { material = M.Neon, noCollide = true, transparency = 0.1 })
	pointLight(flame, rgb(0xff8a3a), 3, 40)
	local embers = Instance.new("ParticleEmitter")
	embers.Color = ColorSequence.new(rgb(0xffb347), rgb(0xff5a1f))
	embers.LightEmission = 1
	embers.Size = NumberSequence.new(0.3, 0)
	embers.Lifetime = NumberRange.new(1, 2)
	embers.Rate = 12
	embers.Speed = NumberRange.new(3, 6)
	embers.SpreadAngle = Vector2.new(15, 15)
	embers.Parent = flame
	CollectionService:AddTag(flame, FLAME_TAG)
	for i, tent in ipairs({ { -112, 1470, 0.4, rgb(0x3fae5a) }, { -118, 1530, -0.3, rgb(0xf39c1f) }, { -78, 1560, 0.8, rgb(0x2f6fd6) } }) do
		local model = newModel("Tent", campFolder)
		local tentBase = groundFrame(tent[1], tent[2]) * CFrame.Angles(0, tent[3], 0)
		piece(model, tentBase, "TentLeft", V(9, 7, 5), -2.5, 3.5, 0, tent[4], { className = "WedgePart", noStuds = true }, CFrame.Angles(0, math.pi / 2, 0))
		piece(model, tentBase, "TentRight", V(9, 7, 5), 2.5, 3.5, 0, tent[4], { className = "WedgePart", noStuds = true }, CFrame.Angles(0, -math.pi / 2, 0))
		piece(model, tentBase, "RidgeSnow", V(1, 0.5, 9.4), 0, 7.2, 0, C.Snow)
		buildCheeringPenguin(crowdFolder, groundFrame(-92 + math.cos(i * 1.6) * 9, 1500 - math.sin(i * 1.6) * 9) * CFrame.Angles(0, i * 1.6 - math.pi / 2, 0), i, false, i % 2 == 0)
	end
	buildCheeringPenguin(crowdFolder, groundFrame(-92 + math.cos(6.4) * 9, 1500 - math.sin(6.4) * 9) * CFrame.Angles(0, 6.4 - math.pi / 2, 0), 4, false, false)
	local signBase = groundFrame(-68, 1645)
	local sign = newModel("FinishSign", campFolder)
	piece(sign, signBase, "SignPost", V(1, 9, 1), 0, 4.5, 0, C.Wood, { noStuds = true })
	textBoard(sign, "SignBoard", V(12, 3, 0.8), signBase * CFrame.new(0, 8, 0), C.Sign, "META →", C.SignText, rgb(0xffd23f))
	for x = -110, -70, 4 do
		neonBulb(campFolder, "Bulb", worldPoint(x, elevationAt(1500) + 11 - math.sin((x + 110) / 40 * math.pi) * 2, 1500 + (x + 90) * 0.2), BULB_COLORS[math.abs(math.round(x / 4)) % #BULB_COLORS + 1], 0.8)
	end
end

do
	local arch = newModel("BalloonArch", finishFolder)
	local base = groundFrame(0, 1700)
	for i = 0, 40 do
		local angle = i / 40 * math.pi
		local x, y = math.cos(angle) * 64, math.sin(angle) * 30 + 4
		for k = 0, 1 do
			local offset = k == 0 and -1 or 1
			piece(arch, base, "Balloon", V(4.4, 4.4, 4.4), x + offset * 0.9, y + offset, offset * 1.2, BULB_COLORS[(i + k) % #BULB_COLORS + 1], { shape = Enum.PartType.Ball, noStuds = true, noCollide = true })
		end
	end
	local podium = newModel("Podium", finishFolder)
	local podiumBase = groundFrame(40, 1830)
	for place, step in ipairs({ { 0, 7, C.Gold }, { -8, 5, C.Silver }, { 8, 3.4, C.Bronze } }) do
		piece(podium, podiumBase, "Step" .. place, V(8, step[2], 8), step[1], step[2] / 2, 0, step[3])
		buildCheeringPenguin(crowdFolder, podiumBase * CFrame.new(step[1], step[2], 0) * CFrame.Angles(0, math.pi, 0), place + 1, place == 1, true)
	end
	piece(podium, podiumBase, "TrophyCup", V(2.6, 2.6, 2.6), 0, 13.8, 0, C.Gold, { noStuds = true, material = M.Neon })
	piece(podium, podiumBase, "TrophyStem", V(1, 1.2, 1), 0, 12, 0, C.Gold, { noStuds = true })
	piece(podium, podiumBase, "TrophyBase", V(2, 0.5, 2), 0, 11.4, 0, C.Gold, { noStuds = true })
	local rainbow = ColorSequence.new({
		ColorSequenceKeypoint.new(0, BULB_COLORS[1]), ColorSequenceKeypoint.new(0.25, BULB_COLORS[2]), ColorSequenceKeypoint.new(0.5, BULB_COLORS[3]),
		ColorSequenceKeypoint.new(0.75, BULB_COLORS[4]), ColorSequenceKeypoint.new(1, BULB_COLORS[5]),
	})
	for index, x in ipairs({ -50, 0, 50 }) do
		local launcher = createPart(finishFolder, "FireworksLauncher", V(2, 1, 2), groundFrame(x, 1760, 70 + index * 6), C.White, { transparency = 1, noCollide = true })
		local fireworks = Instance.new("ParticleEmitter")
		fireworks.Name = "Fireworks"
		fireworks.Color = rainbow
		fireworks.LightEmission = 1
		fireworks.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1.4), NumberSequenceKeypoint.new(1, 0) })
		fireworks.Lifetime = NumberRange.new(1.2, 1.8)
		fireworks.Rate = 35
		fireworks.Speed = NumberRange.new(28, 46)
		fireworks.SpreadAngle = Vector2.new(180, 180)
		fireworks.Acceleration = V(0, -18, 0)
		fireworks.Drag = 1.6
		fireworks.Parent = launcher
	end
	for index, color in ipairs(BULB_COLORS) do
		local cloud = createPart(finishFolder, "ConfettiCloud", V(130, 1, 110), groundFrame(0, 1745, 50 + index), C.White, { transparency = 1, noCollide = true })
		local confetti = Instance.new("ParticleEmitter")
		confetti.Name = "Confetti"
		confetti.Color = ColorSequence.new(color)
		confetti.Size = NumberSequence.new(0.45)
		confetti.Lifetime = NumberRange.new(5, 7)
		confetti.Rate = 14
		confetti.Speed = NumberRange.new(2, 5)
		confetti.EmissionDirection = Enum.NormalId.Bottom
		confetti.SpreadAngle = Vector2.new(25, 25)
		confetti.Rotation = NumberRange.new(0, 360)
		confetti.RotSpeed = NumberRange.new(-180, 180)
		confetti.Parent = cloud
	end
end

for _, side in ipairs({ -1, 1 }) do
	local zm = -300
	while zm < 2400 do
		local width = 300 + roll() * 260
		local x = side * (MOUNTAIN_HALF_WIDTH + width / 2 - 20 + roll() * 100)
		local top = elevationAt(math.clamp(zm, -160, 1800)) - 20 + roll() * 220
		local y = 0
		for step, scale in ipairs({ 1, 0.8, 0.6, 0.42, 0.26 }) do
			local stepTop = step == 1 and top * 0.55 or top * (0.55 + 0.45 * (step - 1) / 4)
			local depth = (200 + roll() * 80) * scale + 60
			local frame = CFrame.new(x + side * (step - 1) * width * 0.06, (y + stepTop) / 2, -zm + (roll() - 0.5) * 30) * CFrame.Angles(0, (roll() - 0.5) * 0.4, 0)
			createPart(landscapeFolder, "Ridge", V(width * scale, stepTop - y + 6, depth), frame, step <= 2 and C.Stone or step == 3 and C.RockLight or C.Snow, { noShadow = true })
			createPart(landscapeFolder, "RidgeSnow", V(width * scale * 0.8, 3, depth * 0.7), frame * CFrame.new(0, (stepTop - y + 6) / 2 + 1, 0), C.Snow, { noShadow = true })
			y = stepTop
		end
		zm += 150 + roll() * 100
	end
end
do
	local castle = newModel("IceCastle", landscapeFolder)
	local base = CFrame.new(worldPoint(0, 0, 2600))
	piece(castle, base, "Island", V(360, 20, 220), 0, -10, 0, C.Snow)
	for _, tower in ipairs({ { 0, 0, 60, 260 }, { -70, -10, 34, 200 }, { 70, -10, 34, 200 }, { -130, -30, 26, 150 }, { 130, -30, 26, 150 }, { -35, 30, 22, 300 }, { 35, 30, 22, 300 } }) do
		local x, z, width, height = tower[1], tower[2], tower[3], tower[4]
		piece(castle, base, "Tower", V(width, height, width), x, height / 2, z, C.CastleIce, { material = M.Glass, transparency = 0.1 })
		for step = 1, 3 do
			local capWidth = width * (1.1 - step * 0.28)
			piece(castle, base, "Roof", V(capWidth, width * 0.35, capWidth), x, height + width * 0.35 * (step - 0.5), z, C.CastleCap, nil, CFrame.Angles(0, math.pi / 4, 0))
		end
		piece(castle, base, "FlagPole", V(0.6, 12, 0.6), x, height + width * 1.05 + 6, z, C.White, { noStuds = true })
		piece(castle, base, "Flag", V(0.2, 5, 8), x, height + width * 1.05 + 10, z - 4, rgb(0xff4fa3), { material = M.Neon, noStuds = true })
	end
end

local partCount = 0
for _, descendant in ipairs(root:GetDescendants()) do
	if descendant:IsA("BasePart") then partCount += 1 end
end
print(("Festive decoration built: %d parts, %d cheering penguins"):format(partCount, #CollectionService:GetTagged(CROWD_TAG)))
