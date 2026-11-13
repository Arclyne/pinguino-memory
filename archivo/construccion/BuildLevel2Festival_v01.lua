local CollectionService = game:GetService("CollectionService")

local LEVEL = workspace:FindFirstChild("PenguinSlingshotMap_Level2")
local FOLDER_NAME = "FestivalDecoration"
local OFFSET_X = 6000
local BASE_Y = 600
local V = Vector3.new
local M = Enum.Material
local rgb = Color3.fromRGB
local random = Random.new(88)
local function roll() return random:NextNumber() end

local C = {
	Red = rgb(214, 40, 40), Gold = rgb(255, 196, 61), Wire = rgb(58, 42, 26), Wood = rgb(138, 90, 54), WoodDark = rgb(96, 60, 36),
	Snow = rgb(244, 248, 253), Pine = rgb(36, 110, 70), White = rgb(250, 250, 250), Ink = rgb(26, 24, 40), Ice = rgb(190, 235, 255),
	Teal = rgb(47, 216, 168), Pink = rgb(255, 111, 216), Blue = rgb(63, 160, 255), Purple = rgb(143, 92, 255), Orange = rgb(255, 150, 40),
}
local LANTERN_COLORS = { rgb(255, 70, 60), rgb(255, 170, 40), rgb(255, 215, 80), rgb(255, 110, 180), rgb(120, 220, 255) }
local BULBS = { rgb(255, 59, 92), rgb(255, 210, 63), rgb(63, 208, 255), rgb(125, 255, 122), rgb(255, 122, 224) }

local existing = LEVEL:FindFirstChild(FOLDER_NAME)
if existing then existing:Destroy() end
local root = Instance.new("Folder")
root.Name = FOLDER_NAME
root.Parent = LEVEL

local zones = {
	{ z0 = -140, z1 = 0, slope = 0 }, { z0 = 0, z1 = 20, cliff = true }, { z0 = 20, z1 = 228, slope = 14 },
	{ z0 = 228, z1 = 670, slope = 17 }, { z0 = 670, z1 = 826, slope = 12 }, { z0 = 826, z1 = 1164, slope = 18 },
	{ z0 = 1164, z1 = 1294, slope = 3 }, { z0 = 1294, z1 = 1684, slope = 20 }, { z0 = 1684, z1 = 1840, slope = 8 },
	{ z0 = 1840, z1 = 1910, slope = 0 },
}
local running = 0
for _, zone in ipairs(zones) do
	zone.e0 = running
	zone.e1 = zone.cliff and -40 or running - (zone.z1 - zone.z0) * math.tan(math.rad(zone.slope))
	running = zone.e1
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

local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Include
rayParams.FilterDescendantsInstances = { LEVEL:FindFirstChild("Terrain"), LEVEL:FindFirstChild("Track") }
local function groundY(x, zm)
	local top = worldPoint(x, elevationAt(zm) + 80, zm)
	local hit = workspace:Raycast(top, V(0, -200, 0), rayParams)
	return hit and hit.Position.Y or top.Y - 80
end
local function groundAt(x, zm, lift)
	return V(OFFSET_X + x, groundY(x, zm) + (lift or 0), -zm)
end

local function folder(name)
	local f = Instance.new("Folder")
	f.Name = name
	f.Parent = root
	return f
end
local function model(name, parent)
	local m = Instance.new("Model")
	m.Name = name
	m.Parent = parent
	return m
end
local function part(parent, name, size, cframe, color, options)
	options = options or {}
	local p = Instance.new(options.className or "Part")
	p.Name = name
	p.Anchored = true
	if options.shape then p.Shape = options.shape end
	p.Size = size
	p.CFrame = cframe
	p.Color = color
	p.Material = options.material or M.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if options.transparency then p.Transparency = options.transparency end
	if not options.solid then
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
	end
	if options.material == M.Neon or options.noShadow then p.CastShadow = false end
	p.Parent = parent
	return p
end
local function neon(parent, name, size, cframe, color, shape)
	return part(parent, name, size, cframe, color, { material = M.Neon, shape = shape })
end
local function light(target, color, brightness, range)
	local l = Instance.new("PointLight")
	l.Color = color
	l.Brightness = brightness
	l.Range = range
	l.Shadows = false
	l.Parent = target
	return l
end
local function chaseBulb(parent, position, index, size)
	local b = neon(parent, "Bulb", V(size, size, size), CFrame.new(position), BULBS[index % #BULBS + 1], Enum.PartType.Ball)
	b:SetAttribute("ChaseIndex", index)
	CollectionService:AddTag(b, "ChaseBulb")
	return b
end
local function sign(parent, name, size, cframe, text, background, textColor)
	local board = part(parent, name, size, cframe, background, {})
	for _, face in ipairs({ Enum.NormalId.Front, Enum.NormalId.Back }) do
		local gui = Instance.new("SurfaceGui")
		gui.Face = face
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.PixelsPerStud = 20
		gui.LightInfluence = 0
		gui.Parent = board
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromScale(0.94, 0.86)
		label.Position = UDim2.fromScale(0.03, 0.07)
		label.Font = Enum.Font.FredokaOne
		label.TextScaled = true
		label.TextColor3 = textColor
		label.Text = text
		local stroke = Instance.new("UIStroke")
		stroke.Thickness = 3
		stroke.Color = C.Ink
		stroke.Parent = label
		label.Parent = gui
	end
	return board
end

local function paperLantern(parent, top, scale, color, stringLength)
	local m = model("PaperLantern", parent)
	part(m, "String", V(0.12, stringLength, 0.12), CFrame.new(top - V(0, stringLength / 2, 0)), C.Wire, {})
	local bodyCenter = top - V(0, stringLength + 1.2 * scale, 0)
	part(m, "Cap", V(1.1 * scale, 0.3 * scale, 1.1 * scale), CFrame.new(bodyCenter + V(0, 1.1 * scale, 0)), C.Gold, {})
	local body = neon(m, "Body", V(1.9 * scale, 2 * scale, 1.9 * scale), CFrame.new(bodyCenter), color, Enum.PartType.Ball)
	part(m, "Cap", V(1.1 * scale, 0.3 * scale, 1.1 * scale), CFrame.new(bodyCenter - V(0, 1.1 * scale, 0)), C.Gold, {})
	part(m, "Tassel", V(0.25 * scale, 1 * scale, 0.25 * scale), CFrame.new(bodyCenter - V(0, 1.8 * scale, 0)), C.Red, {})
	m.WorldPivot = CFrame.new(top)
	return m, body
end

local function stringLights(parent, a, b, sag, count, startIndex)
	for i = 0, count do
		local t = i / count
		local p = a:Lerp(b, t) - V(0, math.sin(t * math.pi) * sag, 0)
		chaseBulb(parent, p, startIndex + i, 0.8)
		if i < count then
			local t2 = (i + 1) / count
			local q = a:Lerp(b, t2) - V(0, math.sin(t2 * math.pi) * sag, 0)
			part(parent, "Wire", V(0.1, 0.1, (q - p).Magnitude), CFrame.lookAt((p + q) / 2, q), C.Wire, {})
		end
	end
end

local penguinTemplate
for _, candidate in ipairs(CollectionService:GetTagged("CheeringPenguin")) do
	if candidate:IsA("Model") and candidate:IsDescendantOf(workspace) then
		penguinTemplate = candidate
		break
	end
end
local function penguin(parent, position, lookAt, mode, scale)
	if not penguinTemplate then return nil end
	local copy = penguinTemplate:Clone()
	copy:SetAttribute("CheerMode", mode)
	copy:SetAttribute("Cheers", mode ~= "idle")
	copy:SetAttribute("CheerPhase", roll() * 6)
	if mode == "ride" then CollectionService:RemoveTag(copy, "CheeringPenguin") end
	copy.Parent = parent
	if scale and scale ~= 1 then copy:ScaleTo(scale) end
	local flat = V(lookAt.X, position.Y, lookAt.Z)
	copy:PivotTo(CFrame.lookAt(position + V(0, 2.3 * (scale or 1), 0), flat + V(0, 2.3 * (scale or 1), 0)))
	return copy
end

-- Houses: chimney smoke, door wreaths, warm windows
do
	local houses = folder("HouseDetails")
	local village = LEVEL:FindFirstChild("Village")
	local windowCount = 0
	for _, house in ipairs(village and village:GetChildren() or {}) do
		if house:IsA("Model") then
			local chimney = house:FindFirstChild("Chimney", true)
			if chimney and chimney:IsA("BasePart") then
				local anchor = part(houses, "SmokeAnchor", V(1, 1, 1), chimney.CFrame + V(0, chimney.Size.Y / 2 + 0.5, 0), C.White, { transparency = 1 })
				local smoke = Instance.new("ParticleEmitter")
				smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
				smoke.Color = ColorSequence.new(rgb(235, 235, 240), rgb(190, 195, 205))
				smoke.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.4), NumberSequenceKeypoint.new(1, 1) })
				smoke.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 2), NumberSequenceKeypoint.new(1, 7) })
				smoke.Lifetime = NumberRange.new(4, 6)
				smoke.Rate = 3
				smoke.Speed = NumberRange.new(3, 5)
				smoke.SpreadAngle = Vector2.new(10, 10)
				smoke.Acceleration = V(1.5, 0.5, 0)
				smoke.RotSpeed = NumberRange.new(-20, 20)
				smoke.LightInfluence = 0.6
				smoke.Parent = anchor
			end
			local door = house:FindFirstChild("Door", true)
			if door and door:IsA("BasePart") then
				local dx = door.Position.X - OFFSET_X
				local toward = V(dx > 0 and -1 or 1, 0, 0)
				local depth = math.min(door.Size.X, door.Size.Z)
				local center = door.Position + toward * (depth / 2 + 0.35) + V(0, door.Size.Y * 0.18, 0)
				local wreath = model("Wreath", houses)
				for i = 0, 9 do
					local a = i / 10 * math.pi * 2
					part(wreath, "Leaf", V(0.9, 0.9, 0.9), CFrame.new(center + V(0, math.sin(a) * 1.3, 0) + V(toward.Z, 0, -toward.X) * math.cos(a) * 1.3), C.Pine, { shape = Enum.PartType.Ball })
				end
				for i = 0, 3 do
					local a = i / 4 * math.pi * 2 + 0.4
					neon(wreath, "Berry", V(0.4, 0.4, 0.4), CFrame.new(center + toward * 0.3 + V(0, math.sin(a) * 1.3, 0) + V(toward.Z, 0, -toward.X) * math.cos(a) * 1.3), C.Red, Enum.PartType.Ball)
				end
				part(wreath, "Bow", V(1.2, 0.6, 1.2), CFrame.new(center + toward * 0.4 - V(0, 1.4, 0)), C.Red, {})
			end
			for _, descendant in ipairs(house:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.Name == "Window" and windowCount < 140 then
					windowCount += 1
					if windowCount % 2 == 0 then light(descendant, rgb(255, 190, 110), 1.2, 14) end
					descendant.Material = M.Neon
				end
			end
		end
	end
end

-- Pavilion: floating lantern canopy and rising sky lanterns
do
	local sky = folder("Lanterns")
	for i = 0, 35 do
		local x = -48 + (i % 6) * 19 + roll() * 4
		local zm = 700 + math.floor(i / 6) * 17 + roll() * 4
		local top = worldPoint(x, elevationAt(zm) + 34 + roll() * 4, zm)
		local lantern, body = paperLantern(sky, top, 1.1 + roll() * 0.5, LANTERN_COLORS[i % #LANTERN_COLORS + 1], 3 + roll() * 3)
		if i % 4 == 0 then light(body, rgb(255, 170, 90), 1.5, 16) end
		lantern:SetAttribute("SwingAmplitude", 0.08 + roll() * 0.08)
		CollectionService:AddTag(lantern, "SwingingDecor")
	end
	for i = 0, 27 do
		local zm = 120 + i * 62
		local x = (i % 2 == 0 and -1 or 1) * (20 + roll() * 60)
		local lantern = model("SkyLantern", sky)
		local base = worldPoint(x, elevationAt(zm) + 22 + roll() * 20, zm)
		part(lantern, "Paper", V(2, 2.6, 2), CFrame.new(base), rgb(255, 180, 90), { material = M.Neon, transparency = 0.1 })
		part(lantern, "Flame", V(0.6, 0.6, 0.6), CFrame.new(base - V(0, 1.2, 0)), rgb(255, 120, 30), { material = M.Neon, shape = Enum.PartType.Ball })
		lantern.WorldPivot = CFrame.new(base)
		lantern:SetAttribute("RiseHeight", 120 + roll() * 80)
		lantern:SetAttribute("RiseSpeed", 4 + roll() * 3)
		CollectionService:AddTag(lantern, "SkyLantern")
	end
	for index, zm in ipairs({ 260, 420, 560, 960, 1120, 1360, 1520, 1650 }) do
		local y = elevationAt(zm)
		for _, side in ipairs({ -1, 1 }) do
			part(sky, "LightPole", V(0.8, 22, 0.8), CFrame.new(worldPoint(side * 66, y + 11, zm)), C.WoodDark, { solid = true })
		end
		stringLights(sky, worldPoint(-66, y + 21, zm), worldPoint(66, y + 21, zm), 6, 22, index * 7)
	end
end

-- Market stalls, carousel and accordion player
do
	local market = folder("Market")
	local awningColors = { C.Red, C.Teal, C.Purple, C.Orange, C.Blue, C.Pink }
	local goods = { "🐟", "☕", "🍪", "🧣", "🏮", "🎁" }
	for i = 0, 5 do
		local side = i % 2 == 0 and -1 or 1
		local zm = 300 + i * 52
		local x = side * 80
		local base = CFrame.lookAt(groundAt(x, zm), groundAt(0, zm))
		local stall = model("Stall", market)
		part(stall, "Counter", V(10, 4, 4), base * CFrame.new(0, 2, 0), C.Wood, { solid = true })
		part(stall, "CounterTop", V(10.4, 0.5, 4.4), base * CFrame.new(0, 4.25, 0), C.Snow, {})
		for j = 0, 4 do
			part(stall, "Awning", V(2, 0.4, 6), base * CFrame.new(-4 + j * 2, 9, 0.5) * CFrame.Angles(-0.35, 0, 0), j % 2 == 0 and C.White or awningColors[i + 1], {})
		end
		for _, s in ipairs({ -1, 1 }) do
			part(stall, "Post", V(0.5, 6, 0.5), base * CFrame.new(s * 4.8, 6.5, 2), C.WoodDark, {})
		end
		sign(stall, "StallSign", V(5, 2, 0.3), base * CFrame.new(0, 11.4, -0.4), goods[i + 1], awningColors[i + 1], C.White)
		for j = 0, 2 do
			neon(stall, "Goods", V(1.2, 1.2, 1.2), base * CFrame.new(-3 + j * 3, 5, -0.8), LANTERN_COLORS[(i + j) % #LANTERN_COLORS + 1], Enum.PartType.Ball)
		end
		stringLights(stall, (base * CFrame.new(-5, 8.2, -2.4)).Position, (base * CFrame.new(5, 8.2, -2.4)).Position, 0.8, 6, i * 3)
		penguin(market, (base * CFrame.new(0, 0, 3)).Position, (base * CFrame.new(0, 0, -10)).Position, i % 2 == 0 and "wave" or "cheer", 1)
	end
	do
		local x, zm = 84, 1000
		local center = groundAt(x, zm)
		part(market, "CarouselBase", V(1.4, 22, 22), CFrame.new(center + V(0, 0.7, 0)) * CFrame.Angles(0, 0, math.pi / 2), C.Gold, { shape = Enum.PartType.Cylinder, solid = true })
		local spinner = model("Carousel", market)
		part(spinner, "Pole", V(1.2, 16, 1.2), CFrame.new(center + V(0, 8, 0)), C.Gold, { material = M.Metal })
		part(spinner, "Roof", V(2, 22, 22), CFrame.new(center + V(0, 16.5, 0)) * CFrame.Angles(0, 0, math.pi / 2), C.Red, { shape = Enum.PartType.Cylinder })
		part(spinner, "RoofTop", V(6, 6, 6), CFrame.new(center + V(0, 18.5, 0)), C.White, { shape = Enum.PartType.Ball })
		for i = 0, 5 do
			local a = i / 6 * math.pi * 2
			local p = center + V(math.cos(a) * 8, 0, math.sin(a) * 8)
			part(spinner, "Rod", V(0.4, 15, 0.4), CFrame.new(p + V(0, 8.5, 0)), C.Gold, { material = M.Metal })
			penguin(spinner, p + V(0, 2.2, 0), p + V(-math.sin(a), 0, math.cos(a)) * 5, "ride", 1)
		end
		for i = 0, 23 do
			local a = i / 24 * math.pi * 2
			chaseBulb(spinner, center + V(math.cos(a) * 10.6, 15.5, math.sin(a) * 10.6), i, 0.7)
		end
		spinner.WorldPivot = CFrame.new(center)
		spinner:SetAttribute("SpinSpeed", 0.5)
		CollectionService:AddTag(spinner, "SpinningDecor")
	end
	penguin(market, groundAt(74, 330), groundAt(0, 330), "music", 1)
end

-- Ice rink with skaters
do
	local rink = folder("IceRink")
	local x, zm = 82, 1230
	local center = groundAt(x, zm, 0.2)
	part(rink, "Ice", V(0.4, 34, 34), CFrame.new(center) * CFrame.Angles(0, 0, math.pi / 2), C.Ice, { shape = Enum.PartType.Cylinder, material = M.Ice, solid = true })
	for i = 0, 27 do
		local a = i / 28 * math.pi * 2
		part(rink, "Rail", V(1, 2, 3.8), CFrame.new(center + V(math.cos(a) * 17.5, 1, math.sin(a) * 17.5)) * CFrame.Angles(0, -a, 0), i % 2 == 0 and C.Red or C.White, {})
	end
	local skaters = model("Skaters", rink)
	for i = 0, 4 do
		local a = i / 5 * math.pi * 2
		local p = center + V(math.cos(a) * (8 + (i % 2) * 4), 0, math.sin(a) * (8 + (i % 2) * 4))
		penguin(skaters, p, p + V(-math.sin(a), 0, math.cos(a)) * 5, "ride", 1)
	end
	skaters.WorldPivot = CFrame.new(center)
	skaters:SetAttribute("SpinSpeed", -0.35)
	CollectionService:AddTag(skaters, "SpinningDecor")
	sign(rink, "RinkSign", V(10, 2.6, 0.4), CFrame.lookAt(center + V(-18, 6, 0), center + V(-40, 6, 0)), "⛸️ PISTA DE HIELO", C.Blue, C.White)
end

-- Forest: lanterns on pines, fireflies, owls, cabin, windmill
do
	local forest = folder("Forest")
	local decoration = LEVEL:FindFirstChild("Decoration")
	local count = 0
	for _, pine in ipairs(decoration and decoration:GetChildren() or {}) do
		if pine:IsA("Model") and pine.Name == "Pine" then
			count += 1
			local pivot = pine:GetBoundingBox()
			if count % 3 == 0 then
				local _, size = pine:GetBoundingBox()
				local top = pivot.Position + V(size.X * 0.32, -size.Y * 0.05, 0)
				local lantern, body = paperLantern(forest, top, 0.8, LANTERN_COLORS[count % #LANTERN_COLORS + 1], 1.5)
				if count % 9 == 0 then light(body, rgb(255, 170, 90), 1.2, 12) end
				lantern:SetAttribute("SwingAmplitude", 0.1)
				CollectionService:AddTag(lantern, "SwingingDecor")
			end
			if count % 14 == 0 then
				local _, size = pine:GetBoundingBox()
				local owl = model("Owl", forest)
				local p = pivot.Position + V(-size.X * 0.25, size.Y * 0.05, 0)
				part(owl, "Body", V(1.4, 1.8, 1.2), CFrame.new(p), rgb(140, 100, 70), { shape = Enum.PartType.Ball })
				for _, s in ipairs({ -1, 1 }) do
					neon(owl, "Eye", V(0.45, 0.45, 0.2), CFrame.new(p + V(s * 0.35, 0.4, -0.55)), rgb(255, 220, 60), Enum.PartType.Ball)
				end
			end
		end
	end
	for i = 0, 7 do
		local zm = 1320 + i * 46
		local anchor = part(forest, "FireflyArea", V(60, 10, 40), CFrame.new(worldPoint((i % 2 == 0 and -1 or 1) * 100, elevationAt(zm) + 8, zm)), C.White, { transparency = 1 })
		local flies = Instance.new("ParticleEmitter")
		flies.Shape = Enum.ParticleEmitterShape.Box
		flies.Color = ColorSequence.new(rgb(255, 240, 120))
		flies.LightEmission = 1
		flies.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.5, 0.35), NumberSequenceKeypoint.new(1, 0) })
		flies.Lifetime = NumberRange.new(3, 5)
		flies.Rate = 6
		flies.Speed = NumberRange.new(0.5, 1.5)
		flies.SpreadAngle = Vector2.new(180, 180)
		flies.Parent = anchor
	end
	do
		local x, zm = -112, 1450
		local base = CFrame.lookAt(groundAt(x, zm), groundAt(0, zm))
		local cabin = model("Cabin", forest)
		part(cabin, "Walls", V(14, 9, 12), base * CFrame.new(0, 4.5, 0), C.Wood, { solid = true })
		part(cabin, "Roof", V(16, 2, 14), base * CFrame.new(0, 10, 0), C.Snow, { solid = true })
		local window = neon(cabin, "Window", V(3, 2.4, 0.3), base * CFrame.new(2.5, 5, -6.1), rgb(255, 200, 110))
		light(window, rgb(255, 190, 110), 1.6, 18)
		part(cabin, "Door", V(2.6, 5, 0.3), base * CFrame.new(-3, 2.5, -6.1), C.WoodDark, {})
	end
	do
		local x, zm = 130, 1560
		local base = CFrame.lookAt(groundAt(x, zm), groundAt(0, zm))
		local mill = model("Windmill", forest)
		part(mill, "Tower", V(8, 24, 8), base * CFrame.new(0, 12, 0), C.Snow, { solid = true })
		part(mill, "Cap", V(9, 4, 9), base * CFrame.new(0, 26, 0), C.Red, {})
		local blades = model("Blades", mill)
		local hub = base * CFrame.new(0, 24, -5)
		part(blades, "Hub", V(1.6, 1.6, 1.6), hub, C.Gold, { shape = Enum.PartType.Ball })
		for i = 0, 3 do
			part(blades, "Blade", V(2.2, 11, 0.3), hub * CFrame.Angles(0, 0, i * math.pi / 2) * CFrame.new(0, 6, 0), i % 2 == 0 and C.White or C.Red, {})
		end
		blades.WorldPivot = hub
		blades:SetAttribute("SpinSpeed", 0.9)
		blades:SetAttribute("SpinAxis", "Z")
		CollectionService:AddTag(blades, "SpinningDecor")
	end
end

-- Finish festival: dragon parade, drummers, gong, pagoda, streamers
do
	local finale = folder("Finale")
	local y = elevationAt(1875)
	local dragon = model("DragonParade", finale)
	local center = worldPoint(-62, y + 4, 1875)
	for i = 1, 12 do
		local seg = model("Segment", dragon)
		local p = center + V(0, 0, i * 3)
		local color = i == 1 and C.Red or (i % 2 == 0 and C.Gold or C.Red)
		local body = part(seg, "Body", V(3.2, 3, 3.2) * (i == 1 and 1.4 or 1), CFrame.new(p), color, { shape = Enum.PartType.Ball })
		if i == 1 then
			for _, s in ipairs({ -1, 1 }) do
				neon(seg, "Eye", V(0.8, 0.8, 0.8), CFrame.new(p + V(s * 1, 1, -2)), C.White, Enum.PartType.Ball)
				part(seg, "Horn", V(0.4, 2, 0.4), CFrame.new(p + V(s * 1, 2.6, 0.5)) * CFrame.Angles(0.4, 0, 0), C.Gold, {})
			end
		else
			part(seg, "Fin", V(0.3, 1.4, 1.6), CFrame.new(p + V(0, 2, 0)), C.Gold, {})
		end
		part(seg, "Pole", V(0.3, 4, 0.3), CFrame.new(p - V(0, 3.4, 0)), C.WoodDark, {})
		seg.PrimaryPart = body
		seg:SetAttribute("SegmentIndex", i)
	end
	dragon:SetAttribute("PathCenter", center)
	dragon:SetAttribute("PathRadiusX", 22)
	dragon:SetAttribute("PathRadiusZ", 24)
	dragon:SetAttribute("PathSpeed", 0.45)
	CollectionService:AddTag(dragon, "DragonParade")
	for i = 0, 5 do
		local side = i % 2 == 0 and -1 or 1
		local zm = 1786 + math.floor(i / 2) * 5
		local p = groundAt(side * (58 + (i % 3) * 3), zm)
		local drumFrame = CFrame.lookAt(p, groundAt(0, zm))
		part(finale, "Drum", V(2.4, 3.6, 3.6), drumFrame * CFrame.new(0, 1.8, -2.4) * CFrame.Angles(0, 0, math.pi / 2), C.Red, { shape = Enum.PartType.Cylinder })
		penguin(finale, p, groundAt(0, zm), "drum", 1)
	end
	do
		local p = groundAt(46, 1862)
		local frame = CFrame.lookAt(p, groundAt(0, 1862))
		for _, s in ipairs({ -1, 1 }) do
			part(finale, "GongPost", V(0.8, 12, 0.8), frame * CFrame.new(s * 5, 6, 0), C.Red, { solid = true })
		end
		part(finale, "GongBar", V(11, 0.8, 0.8), frame * CFrame.new(0, 12, 0), C.Red, {})
		local gong = model("Gong", finale)
		part(gong, "Disc", V(0.6, 7, 7), frame * CFrame.new(0, 7, 0) * CFrame.Angles(0, math.pi / 2, 0), C.Gold, { shape = Enum.PartType.Cylinder, material = M.Metal })
		gong.WorldPivot = frame * CFrame.new(0, 11.6, 0)
		gong:SetAttribute("SwingAmplitude", 0.06)
		CollectionService:AddTag(gong, "SwingingDecor")
	end
	do
		local p = groundAt(110, 1880)
		local frame = CFrame.lookAt(p, groundAt(0, 1880))
		local pagoda = model("Pagoda", finale)
		for tier = 0, 3 do
			local w = 18 - tier * 3.4
			local base = frame * CFrame.new(0, tier * 8, 0)
			part(pagoda, "Floor", V(w - 3, 6, w - 3), base * CFrame.new(0, 3, 0), tier % 2 == 0 and C.Red or rgb(180, 30, 30), { solid = true })
			part(pagoda, "Roof", V(w + 3, 1.2, w + 3), base * CFrame.new(0, 6.6, 0), C.Ink, {})
			part(pagoda, "RoofSnow", V(w + 2, 0.5, w + 2), base * CFrame.new(0, 7.4, 0), C.Snow, {})
			for _, corner in ipairs({ { -1, -1 }, { -1, 1 }, { 1, -1 }, { 1, 1 } }) do
				local lantern, body = paperLantern(pagoda, (base * CFrame.new(corner[1] * (w / 2 + 1.2), 6, corner[2] * (w / 2 + 1.2))).Position, 0.6, LANTERN_COLORS[tier + 1], 1)
				if tier == 0 then light(body, rgb(255, 150, 80), 1, 10) end
				local _ = lantern
			end
		end
		neon(pagoda, "Spire", V(1, 5, 1), frame * CFrame.new(0, 34.5, 0), C.Gold)
	end
	for i = 0, 15 do
		local zm = 1808 + (i % 4) * 2
		local x = -56 + i * 7.4
		local top = worldPoint(x, elevationAt(zm) + 26, zm)
		local streamer = model("Streamer", finale)
		for j = 0, 5 do
			part(streamer, "Ribbon", V(0.15, 1.6, 0.8), CFrame.new(top - V(0, 0.8 + j * 1.6, 0)) * CFrame.Angles(0, j * 0.6, 0), BULBS[(i + j) % #BULBS + 1], {})
		end
		streamer.WorldPivot = CFrame.new(top)
		streamer:SetAttribute("SwingAmplitude", 0.25)
		CollectionService:AddTag(streamer, "SwingingDecor")
	end
end

-- Crowd along the track and distant village lights
do
	local crowd = folder("Crowd")
	local modes = { "cheer", "wave", "cheer", "music", "shovel" }
	for i = 0, 29 do
		local side = i % 2 == 0 and -1 or 1
		local zm = 80 + i * 58 + roll() * 20
		local p = groundAt(side * (74 + roll() * 6), zm)
		penguin(crowd, p, groundAt(0, zm), modes[i % #modes + 1], 1)
	end
	local distant = folder("DistantLights")
	for i = 0, 59 do
		local side = i % 2 == 0 and -1 or 1
		local zm = i * 32
		neon(distant, "FarLight", V(1.4, 1.4, 1.4), CFrame.new(worldPoint(side * (260 + roll() * 120), elevationAt(zm) - 30 + roll() * 20, zm)), roll() < 0.7 and rgb(255, 200, 110) or LANTERN_COLORS[i % #LANTERN_COLORS + 1], Enum.PartType.Ball)
	end
end

local count = 0
for _, d in ipairs(root:GetDescendants()) do
	if d:IsA("BasePart") then count += 1 end
end
print(("Festival de Faroles built: %d parts, penguin template: %s"):format(count, tostring(penguinTemplate ~= nil)))
