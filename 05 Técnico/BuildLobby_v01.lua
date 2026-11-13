local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local SkinAppearance = require(ReplicatedStorage.Shared.SkinAppearance)
local WheelCatalog = require(ReplicatedStorage.Shared.WheelCatalog)

local LEVEL_ONE = workspace:FindFirstChild("PenguinSlingshotMap_v01")
local FOLDER_NAME = "Lobby"
local TOP = 600
local V = Vector3.new
local M = Enum.Material
local rgb = Color3.fromRGB
local INK = rgb(20, 24, 42)
local BULBS = { rgb(255, 59, 92), rgb(255, 210, 63), rgb(63, 208, 255), rgb(125, 255, 122), rgb(255, 122, 224) }

local existing = LEVEL_ONE:FindFirstChild(FOLDER_NAME)
if existing then existing:Destroy() end
local root = Instance.new("Folder")
root.Name = FOLDER_NAME
root.Parent = LEVEL_ONE

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
	p.Material = options.material or M.Plastic
	local smooth = options.material == M.Neon or options.smooth
	p.TopSurface = smooth and Enum.SurfaceType.Smooth or Enum.SurfaceType.Studs
	p.BottomSurface = smooth and Enum.SurfaceType.Smooth or Enum.SurfaceType.Inlet
	if options.transparency then p.Transparency = options.transparency end
	if options.decor then
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
	end
	if options.noShadow then p.CastShadow = false end
	p.Parent = parent
	return p
end

local function neon(parent, name, size, cframe, color, shape)
	return part(parent, name, size, cframe, color, { material = M.Neon, decor = true, noShadow = true, shape = shape })
end

local function sign(parent, name, size, cframe, text, background, textColor, strokeColor, options)
	options = options or {}
	local board = part(parent, name, size, cframe, background, { smooth = true, decor = options.decor })
	for _, face in ipairs(options.bothSides and { Enum.NormalId.Front, Enum.NormalId.Back } or { Enum.NormalId.Front }) do
		local gui = Instance.new("SurfaceGui")
		gui.Face = face
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.PixelsPerStud = 24
		gui.LightInfluence = 0
		gui.Brightness = 1.3
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
		stroke.Color = strokeColor or INK
		stroke.Thickness = 4
		stroke.Parent = label
		label.Parent = gui
	end
	return board
end

local function prompt(anchor, panel, actionText, objectText, distance)
	local proximity = Instance.new("ProximityPrompt")
	proximity.ActionText = actionText
	proximity.ObjectText = objectText
	proximity.KeyboardKeyCode = Enum.KeyCode.E
	proximity.MaxActivationDistance = distance or 18
	proximity.RequiresLineOfSight = false
	proximity.HoldDuration = 0
	proximity:SetAttribute("OpensPanel", panel)
	proximity.Parent = anchor
	return proximity
end

local function bulb(parent, position, index, size)
	local b = neon(parent, "Bulb", V(size or 1, size or 1, size or 1), CFrame.new(position), BULBS[index % #BULBS + 1], Enum.PartType.Ball)
	b:SetAttribute("ChaseIndex", index)
	CollectionService:AddTag(b, "ChaseBulb")
	return b
end

local function triangle(parent, a, b, c, color, thickness, material)
	local ab, ac, bc = b - a, c - a, c - b
	local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc)
	if abd > acd and abd > bcd then
		c, a = a, c
	elseif acd > bcd and acd > abd then
		a, b = b, a
	end
	ab, ac, bc = b - a, c - a, c - b
	local right = ac:Cross(ab).Unit
	local up = bc:Cross(right).Unit
	local back = bc.Unit
	local height = math.abs(ab:Dot(up))
	local w1 = part(parent, "Segment", V(thickness, height, math.abs(ab:Dot(back))), CFrame.fromMatrix((a + b) / 2, right, up, back), color, { className = "WedgePart", material = material, smooth = true, decor = true })
	local w2 = part(parent, "Segment", V(thickness, height, math.abs(ac:Dot(back))), CFrame.fromMatrix((a + c) / 2, -right, up, -back), color, { className = "WedgePart", material = material, smooth = true, decor = true })
	return w1, w2
end

local function mannequin(parent, skinId, cframe, scale, rank)
	local template = StarterPlayer:FindFirstChild("StarterCharacter")
	local copy = template:Clone()
	copy.Name = "Mannequin"
	local humanoid = copy:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid:Destroy() end
	for _, descendant in ipairs(copy:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.Anchored = true
			descendant.CanCollide = false
			descendant.CanQuery = false
			descendant.CanTouch = false
		end
	end
	copy.PrimaryPart = copy:FindFirstChild("HumanoidRootPart")
	copy:PivotTo(CFrame.new(0, 1.7, 0))
	copy.Parent = parent
	SkinAppearance.apply(copy, skinId)
	for _, descendant in ipairs(copy:GetDescendants()) do
		if descendant:IsA("BasePart") then descendant.Anchored = true end
	end
	copy:ScaleTo(scale)
	copy:PivotTo(cframe * CFrame.new(0, 1.7 * scale, 0))
	if rank then
		copy:SetAttribute("Rank", rank)
		CollectionService:AddTag(copy, "PodiumMannequin")
	end
	return copy
end

local function nameTag(target, text, color, offset)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "NameTag"
	billboard.Size = UDim2.new(9, 0, 1.8, 0)
	billboard.StudsOffsetWorldSpace = offset or V(0, 6, 0)
	billboard.MaxDistance = 120
	billboard.LightInfluence = 0
	billboard.Parent = target
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)
	label.Font = Enum.Font.FredokaOne
	label.TextScaled = true
	label.TextColor3 = color
	label.Text = text
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 3
	stroke.Color = INK
	stroke.Parent = label
	label.Parent = billboard
	return billboard
end

local function wheelLabel(parent, origin, look, d, prize, radius)
	local function surface(name, size, frame)
		local holder = Instance.new("Part")
		holder.Name = name
		holder.Anchored = true
		holder.CanCollide = false
		holder.CanQuery = false
		holder.CanTouch = false
		holder.Transparency = 1
		holder.Size = size
		holder.CFrame = frame
		holder.Parent = parent
		local gui = Instance.new("SurfaceGui")
		gui.Face = Enum.NormalId.Front
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.PixelsPerStud = 40
		gui.LightInfluence = 0
		gui.Parent = holder
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromScale(1, 1)
		label.Font = Enum.Font.FredokaOne
		label.TextScaled = true
		label.Parent = gui
		return label
	end
	local icon = surface("LabelIcon", Vector3.new(2.6, 2.6, 0.1), CFrame.fromMatrix(origin + d * radius * 0.8 + look * 0.3, look:Cross(d), d))
	icon.Text = prize.icon
	local reading = if d:Dot(look:Cross(Vector3.yAxis)) < -0.01 then -d else d
	local text = surface("LabelText", Vector3.new(radius * 0.36, radius * 0.13, 0.1), CFrame.fromMatrix(origin + d * radius * 0.5 + look * 0.3, reading, reading:Cross(look)))
	text.Text = prize.label
	text.TextXAlignment = Enum.TextXAlignment.Center
	text.TextColor3 = if prize.amount >= 10000 then Color3.fromRGB(255, 227, 110) else Color3.fromRGB(255, 255, 255)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 3
	stroke.Color = Color3.fromRGB(20, 24, 42)
	stroke.Parent = text
end

-- Chevron road from the spawn to the slingshot
do
	local road = folder("ChevronRoad")
	local zStart, zEnd = 98, 34
	local length = zStart - zEnd
	part(road, "Road", V(10, 0.4, length + 6), CFrame.new(0, TOP + 0.2, (zStart + zEnd) / 2), rgb(61, 75, 112))
	for _, side in ipairs({ -1, 1 }) do
		part(road, "RoadEdge", V(0.7, 0.5, length + 6), CFrame.new(side * 5.3, TOP + 0.25, (zStart + zEnd) / 2), rgb(255, 210, 31), { smooth = true })
	end
	local index = 0
	for z = zStart - 2, zEnd + 2, -5.5 do
		index += 1
		local chevron = model("ChevronArrow", road)
		local base = CFrame.new(0, TOP + 0.6, z) * CFrame.Angles(0, 0, 0)
		for _, side in ipairs({ -1, 1 }) do
			local arm = base * CFrame.new(side * 1.25, 0, 0.25) * CFrame.Angles(0, -side * 0.785, 0)
			part(chevron, "Back", V(4.4, 0.35, 1.4), arm, INK, { smooth = true, decor = true })
			part(chevron, "Face", V(4.0, 0.45, 1.0), arm * CFrame.new(0, 0.12, 0), rgb(255, 255, 255), { smooth = true, decor = true, noShadow = true })
		end
		chevron:SetAttribute("ChevronIndex", index)
		CollectionService:AddTag(chevron, "ChevronArrow")
	end
	sign(road, "RoadSign", V(16, 4, 0.6), CFrame.new(0, TOP + 9, 100) * CFrame.Angles(0, math.pi, 0), "¡CAMINA A LA RESORTERA!", rgb(255, 210, 31), rgb(255, 255, 255), INK, { bothSides = true })
	for _, side in ipairs({ -1, 1 }) do
		part(road, "SignPost", V(0.8, 9, 0.8), CFrame.new(side * 7.5, TOP + 4.5, 100), rgb(107, 66, 40), { smooth = true })
	end
end

-- Lucky wheel
do
	local wheelFolder = folder("LuckyWheel")
	local wheel = model("LobbyWheel", wheelFolder)
	local center = V(-92, TOP, 72)
	local facing = CFrame.lookAlong(center, V(1, 0, 0))
	local hubHeight = 21
	local radius = 13
	local hubFrame = facing * CFrame.new(0, hubHeight, 0)
	local basePart = part(wheel, "Base", V(2.4, 26, 26), CFrame.new(center + V(0, 1.2, 0)) * CFrame.Angles(0, 0, math.pi / 2), rgb(59, 42, 138), { shape = Enum.PartType.Cylinder, smooth = true })
	part(wheel, "BaseTop", V(2, 20, 20), CFrame.new(center + V(0, 3.2, 0)) * CFrame.Angles(0, 0, math.pi / 2), rgb(90, 63, 208), { shape = Enum.PartType.Cylinder, smooth = true })
	part(wheel, "BaseGold", V(1.6, 15, 15), CFrame.new(center + V(0, 4.8, 0)) * CFrame.Angles(0, 0, math.pi / 2), rgb(255, 194, 26), { shape = Enum.PartType.Cylinder, material = M.Metal, smooth = true })
	local bulbs = Instance.new("Folder")
	bulbs.Name = "Bulbs"
	bulbs.Parent = wheel
	for index = 0, 31 do
		local angle = index / 32 * math.pi * 2
		bulb(wheelFolder, center + V(math.cos(angle) * 12.6, 2.6, math.sin(angle) * 12.6), index, 0.8)
	end
	for _, side in ipairs({ -1, 1 }) do
		local pillarBase = facing * CFrame.new(side * 17, 0, 0.8)
		for segment = 0, 21 do
			part(wheel, "CandyStripe", V(1.6, 1.6, 3.2), pillarBase * CFrame.new(0, 2 + segment * 1.6, 0) * CFrame.Angles(0, 0, math.pi / 2), segment % 2 == 0 and rgb(255, 255, 255) or rgb(232, 32, 46), { shape = Enum.PartType.Cylinder, smooth = true })
		end
		part(wheel, "PillarTop", V(5, 5, 5), pillarBase * CFrame.new(0, 38.4, 0), rgb(255, 210, 63), { shape = Enum.PartType.Ball, material = M.Metal, smooth = true })
		local star = model("PillarStar", wheelFolder)
		neon(star, "Star", V(2.6, 2.6, 2.6), pillarBase * CFrame.new(0, 42.6, 0) * CFrame.Angles(0, 0, math.pi / 4), rgb(255, 227, 110))
		star:SetAttribute("SpinSpeed", 2 * side)
		CollectionService:AddTag(star, "SpinningDecor")
	end
	part(wheel, "BackPost", V(4, hubHeight, 3), facing * CFrame.new(0, hubHeight / 2 + 1, 3), rgb(59, 42, 138))
	part(wheel, "BackPlate", V(1.2, 29, 29), hubFrame * CFrame.new(0, 0, 1.6) * CFrame.Angles(0, math.pi / 2, 0), INK, { shape = Enum.PartType.Cylinder, smooth = true })
	for index = 0, 47 do
		local a0 = index / 48 * math.pi * 2
		local mid = hubFrame * CFrame.Angles(0, 0, a0 + math.pi / 48) * CFrame.new(0, radius + 1.2, 0.2)
		part(wheel, "Rim", V(1.9, 1.6, 1.8), mid, rgb(255, 194, 26), { material = M.Metal, smooth = true, decor = true })
	end
	for index = 0, 39 do
		local angle = index / 40 * math.pi * 2
		local b = neon(bulbs, "RimBulb", V(0.8, 0.8, 0.8), hubFrame * CFrame.new(math.cos(angle) * (radius + 1.2), math.sin(angle) * (radius + 1.2), -0.9), rgb(194, 122, 0), Enum.PartType.Ball)
		b:SetAttribute("ChaseIndex", index)
	end
	local disc = model("Disc", wheel)
	local discCenter = hubFrame * CFrame.new(0, 0, -0.3)
	local prizes = WheelCatalog.list()
	local step = 360 / #prizes
	local function direction(degrees)
		local theta = math.rad(degrees)
		return discCenter.UpVector * math.cos(theta) - discCenter.RightVector * math.sin(theta)
	end
	for index, prize in ipairs(prizes) do
		local startDegrees = (index - 1) * step
		local origin = discCenter.Position
		for half = 0, 1 do
			local a = startDegrees + half * step / 2
			local b = a + step / 2
			triangle(disc, origin, origin + direction(a) * radius, origin + direction(b) * radius, prize.color, 0.4, M.SmoothPlastic)
		end
		local centerDirection = direction(startDegrees + step / 2)
		wheelLabel(disc, origin, discCenter.LookVector, centerDirection, prize, radius)
		local divider = direction(startDegrees)
		part(disc, "Divider", V(0.35, radius, 0.5), CFrame.fromMatrix(origin + divider * radius / 2 + discCenter.LookVector * 0.25, discCenter.LookVector:Cross(divider), divider), rgb(255, 255, 255), { smooth = true, decor = true })
		part(disc, "Peg", V(0.7, 0.7, 1.2), CFrame.new(origin + divider * (radius - 0.6) + discCenter.LookVector * 0.5), rgb(255, 210, 63), { shape = Enum.PartType.Ball, material = M.Metal, decor = true })
	end
	part(disc, "Hub", V(1.4, 5.6, 5.6), discCenter * CFrame.new(0, 0, -0.6) * CFrame.Angles(0, math.pi / 2, 0), rgb(255, 59, 59), { shape = Enum.PartType.Cylinder, smooth = true, decor = true })
	sign(disc, "HubLabel", V(4, 2, 0.1), discCenter * CFrame.new(0, 0, -1.35), "GIRA", rgb(255, 59, 59), rgb(255, 255, 255), INK, { decor = true })
	disc.PrimaryPart = nil
	disc.WorldPivot = discCenter
	local pointer = model("Pointer", wheel)
	local hinge = hubFrame * CFrame.new(0, radius + 3.4, -1.2)
	part(pointer, "PointerBody", V(1, 3.6, 2.4), hinge * CFrame.new(0, -1.4, 0) * CFrame.Angles(0, math.pi / 2, 0), rgb(255, 59, 59), { className = "WedgePart", smooth = true, decor = true })
	part(pointer, "PointerCap", V(1.4, 1.4, 1.4), hinge, rgb(255, 210, 63), { shape = Enum.PartType.Ball, material = M.Metal, decor = true })
	pointer.WorldPivot = hinge
	local topSign = sign(wheel, "WheelSign", V(34, 7, 1), hubFrame * CFrame.new(0, radius + 13, 0.5), "RULETA DE LA SUERTE", rgb(26, 18, 64), rgb(255, 227, 110), rgb(255, 79, 163))
	for index = 0, 23 do
		local x = -16 + index * (32 / 23)
		local b = bulb(wheelFolder, (hubFrame * CFrame.new(x, radius + 17, -0.2)).Position, index, 0.7)
		b.Name = "SignBulb"
	end
	local banner = part(wheel, "BannerAnchor", V(1, 1, 1), hubFrame * CFrame.new(0, radius + 6, -6), rgb(255, 255, 255), { transparency = 1, decor = true })
	local rays = part(wheel, "Glow", V(0.2, 40, 40), hubFrame * CFrame.new(0, 0, 2.4) * CFrame.Angles(0, math.pi / 2, 0), rgb(255, 210, 63), { shape = Enum.PartType.Cylinder, material = M.Neon, decor = true, transparency = 0.7, noShadow = true })
	local light = Instance.new("PointLight")
	light.Color = rgb(255, 214, 120)
	light.Brightness = 2
	light.Range = 40
	light.Parent = rays
	prompt(basePart, "wheel", "Girar", "Ruleta de la suerte", 26)
	wheel:SetAttribute("SegmentCount", #prizes)
	CollectionService:AddTag(wheel, "LobbyWheel")
	local _ = topSign
	local _ = banner
end

-- Hall of fame leaderboard
do
	local hall = folder("HallOfFame")
	local board = model("LobbyLeaderboard", hall)
	local width, height, bottom = 40, 26.7, 14
	local frame = CFrame.lookAlong(V(100, TOP + bottom + height / 2, 62), V(-1, 0, 0))
	part(board, "Frame", V(width + 3, height + 3, 1.6), frame * CFrame.new(0, 0, 1), INK, { smooth = true })
	local screen = part(board, "Screen", V(width, height, 0.4), frame * CFrame.new(0, 0, 0), rgb(18, 12, 58), { smooth = true, decor = true })
	local _ = screen
	for _, edge in ipairs({ { 0, height / 2 + 1.2, width + 2.4, 0.7, rgb(255, 79, 163) }, { 0, -height / 2 - 1.2, width + 2.4, 0.7, rgb(255, 79, 163) }, { -width / 2 - 1.2, 0, 0.7, height + 2.9, rgb(63, 208, 255) }, { width / 2 + 1.2, 0, 0.7, height + 2.9, rgb(63, 208, 255) } }) do
		local n = neon(board, "Neon", V(edge[3], edge[4], 0.7), frame * CFrame.new(edge[1], edge[2], -0.3), edge[5])
		CollectionService:AddTag(n, "PulseGlow")
	end
	for index = 0, 31 do
		local x = -width / 2 + index * (width / 31)
		bulb(hall, (frame * CFrame.new(x, height / 2 + 2.6, -0.3)).Position, index, 0.8)
		bulb(hall, (frame * CFrame.new(x, -height / 2 - 2.6, -0.3)).Position, index + 2, 0.8)
	end
	for _, side in ipairs({ -1, 1 }) do
		part(board, "Leg", V(3.4, bottom, 3.4), frame * CFrame.new(side * (width / 2 - 6), -height / 2 - bottom / 2, 1), rgb(59, 42, 138))
	end
	sign(board, "HallSign", V(28, 6, 1), frame * CFrame.new(0, height / 2 + 7.4, 0.4), "SALÓN DE LA FAMA", INK, rgb(255, 227, 110), rgb(255, 79, 163))
	local crown = model("Crown", hall)
	local crownBase = frame * CFrame.new(0, height / 2 + 15, 0)
	part(crown, "Band", V(6.4, 1.6, 6.4), crownBase, rgb(255, 194, 26), { material = M.Metal, decor = true, smooth = true })
	for index = 0, 4 do
		local angle = index / 5 * math.pi * 2
		part(crown, "Spike", V(1.4, 2.6, 1.4), crownBase * CFrame.new(math.cos(angle) * 2.6, 1.9, math.sin(angle) * 2.6), rgb(255, 194, 26), { material = M.Metal, decor = true, smooth = true })
		neon(crown, "Jewel", V(0.9, 0.9, 0.9), crownBase * CFrame.new(math.cos(angle) * 3.25, 0, math.sin(angle) * 3.25), BULBS[index + 1], Enum.PartType.Ball)
	end
	crown:SetAttribute("SpinSpeed", 0.8)
	CollectionService:AddTag(crown, "SpinningDecor")
	local podium = model("Podium", hall)
	local podiumFrame = frame * CFrame.new(0, -height / 2 - bottom, -14)
	for rank, step in ipairs({ { 0, 6, rgb(255, 194, 26) }, { -10, 4.4, rgb(200, 210, 222) }, { 10, 3, rgb(208, 138, 74) } }) do
		local stepFrame = podiumFrame * CFrame.new(step[1], step[2] / 2, 0)
		local block = part(podium, "Step" .. rank, V(9, step[2], 9), stepFrame, step[3], { material = M.Metal })
		sign(podium, "Number", V(3.4, 3, 0.2), stepFrame * CFrame.new(0, 0, -4.6), tostring(rank), step[3], rgb(255, 255, 255), INK, { decor = true })
		local figure = mannequin(podium, "classic", podiumFrame * CFrame.new(step[1], step[2], 0), rank == 1 and 2.6 or 2.2, rank)
		nameTag(figure, "¿Serás tú?", rank == 1 and rgb(255, 227, 110) or rgb(255, 255, 255), V(0, rank == 1 and 9 or 7.5, 0))
		local _ = block
	end
	local promptAnchor = part(hall, "PromptAnchor", V(2, 2, 2), podiumFrame * CFrame.new(0, 3, -8), rgb(255, 255, 255), { transparency = 1, decor = true })
	prompt(promptAnchor, "leaderboard", "Ver tabla", "Salón de la fama", 22)
	for _, side in ipairs({ -1, 1 }) do
		local beam = part(hall, "LightBeam", V(60, 10, 10), frame * CFrame.new(side * (width / 2 + 4), 10, -6) * CFrame.Angles(0, 0, math.pi / 2 + side * 0.25), side < 0 and rgb(255, 111, 216) or rgb(94, 225, 255), { shape = Enum.PartType.Cylinder, material = M.Neon, decor = true, transparency = 0.85, noShadow = true })
		local _ = beam
	end
	CollectionService:AddTag(board, "LobbyLeaderboard")
end

-- Shop stall
do
	local shop = folder("Shop")
	local base = CFrame.lookAt(V(62, TOP, 136), V(0, TOP, 104))
	part(shop, "Counter", V(16, 5, 6), base * CFrame.new(0, 2.5, 0), rgb(47, 216, 168))
	part(shop, "CounterTop", V(16.4, 0.6, 6.4), base * CFrame.new(0, 5.3, 0), rgb(255, 255, 255))
	for index = 0, 7 do
		part(shop, "Awning", V(2, 0.5, 8), base * CFrame.new(-7 + index * 2, 10.6, 0.6) * CFrame.Angles(-0.3, 0, 0), index % 2 == 0 and rgb(255, 255, 255) or rgb(47, 216, 168), { smooth = true })
	end
	for _, side in ipairs({ -1, 1 }) do
		part(shop, "Post", V(0.6, 7, 0.6), base * CFrame.new(side * 7.6, 7.5, -2.8), rgb(107, 66, 40), { smooth = true })
	end
	sign(shop, "ShopSign", V(14, 3.4, 0.8), base * CFrame.new(0, 14, -1) * CFrame.Angles(0, math.pi, 0), "🛒 TIENDA", rgb(47, 216, 168), rgb(255, 255, 255), INK, { bothSides = true })
	for index = 0, 4 do
		local gift = model("ShopGift", shop)
		local giftFrame = base * CFrame.new(-6 + index * 3, 7, -1.4)
		part(gift, "Box", V(1.8, 1.8, 1.8), giftFrame, BULBS[index + 1], { smooth = true, decor = true })
		part(gift, "Ribbon", V(1.9, 0.4, 1.9), giftFrame, rgb(255, 255, 255), { smooth = true, decor = true })
		gift:SetAttribute("SpinSpeed", 1.2)
		CollectionService:AddTag(gift, "SpinningDecor")
	end
	local keeper = mannequin(shop, "classic", base * CFrame.new(0, 0, 4), 1.6)
	local _ = keeper
	prompt(part(shop, "PromptAnchor", V(2, 2, 2), base * CFrame.new(0, 3, -5), rgb(255, 255, 255), { transparency = 1, decor = true }), "shop", "Abrir", "Tienda", 16)
end

-- Event pedestal
do
	local event = folder("EventPedestal")
	local center = V(-56, TOP, 128)
	local facing = CFrame.lookAt(center, V(0, TOP, 104))
	part(event, "IceFloor", V(0.4, 26, 26), CFrame.new(center + V(0, 0.2, 0)) * CFrame.Angles(0, 0, math.pi / 2), rgb(127, 227, 255), { shape = Enum.PartType.Cylinder, material = M.Neon, decor = true, transparency = 0.35 })
	part(event, "Pedestal", V(10, 2, 10), facing * CFrame.new(0, 1, 0), rgb(91, 111, 168))
	part(event, "PedestalTop", V(8.4, 2.4, 8.4), facing * CFrame.new(0, 3.2, 0), rgb(127, 168, 224))
	for index = 0, 11 do
		local angle = index / 12 * math.pi * 2
		local shard = part(event, "IceShard", V(1.6, 2 + (index % 3), 1.6), CFrame.new(center + V(math.cos(angle) * 11, 1.2, math.sin(angle) * 11)) * CFrame.Angles(0.3, angle, 0.2), rgb(191, 239, 255), { material = M.Glass, transparency = 0.3, decor = true })
		local _ = shard
	end
	local display = model("EventDisplay", event)
	mannequin(display, "ice", facing * CFrame.new(0, 4.4, 0), 2.4)
	display:SetAttribute("SpinSpeed", 0.6)
	CollectionService:AddTag(display, "SpinningDecor")
	sign(event, "EventSign", V(14, 6, 0.8), facing * CFrame.new(0, 17, 2) * CFrame.Angles(0, math.pi, 0), "❄️ EVENTO AVALANCHA · PRONTO", rgb(74, 42, 20), rgb(94, 225, 255), INK, { bothSides = true })
	local arrow = model("EventArrow", event)
	neon(arrow, "Arrow", V(2, 2, 2), facing * CFrame.new(0, 22, 0) * CFrame.Angles(math.pi / 4, 0, math.pi / 4), rgb(255, 255, 255))
	arrow:SetAttribute("SpinSpeed", 2)
	CollectionService:AddTag(arrow, "SpinningDecor")
	prompt(part(event, "PromptAnchor", V(2, 2, 2), facing * CFrame.new(0, 3, -6), rgb(255, 255, 255), { transparency = 1, decor = true }), "event", "Ver", "Skin del evento", 18)
end

-- Most popular skins
do
	local popular = folder("MostPopular")
	local base = CFrame.lookAt(V(54, TOP, 32), V(54, TOP, 80))
	for rank, data in ipairs({ { 0, 6, "fire" }, { -10, 4.4, "santa" }, { 10, 3, "reindeer" } }) do
		local stepFrame = base * CFrame.new(data[1], data[2] / 2, 0)
		part(popular, "Step", V(9, data[2], 9), stepFrame, rgb(216, 48, 42))
		sign(popular, "Number", V(3, 3, 0.2), stepFrame * CFrame.new(0, 0, -4.6), "#" .. rank, rgb(216, 48, 42), rgb(255, 255, 255), INK, { decor = true })
		local figure = mannequin(popular, data[3], base * CFrame.new(data[1], data[2], 0), 2)
		local _ = figure
	end
	sign(popular, "PopularSign", V(30, 6, 0.8), base * CFrame.new(0, 21, 4) * CFrame.Angles(0, math.pi, 0), "MÁS POPULARES", INK, rgb(255, 210, 63), rgb(216, 48, 42), { bothSides = true })
	for _, side in ipairs({ -1, 1 }) do
		part(popular, "SignPost", V(0.8, 21, 0.8), base * CFrame.new(side * 14, 10.5, 4.4), INK, { smooth = true })
	end
	prompt(part(popular, "PromptAnchor", V(2, 2, 2), base * CFrame.new(0, 3, -7), rgb(255, 255, 255), { transparency = 1, decor = true }), "skins", "Ver skins", "Más populares", 18)
end

-- Levels portal
do
	local portal = folder("LevelsPortal")
	local base = CFrame.lookAt(V(0, TOP, 150), V(0, TOP, 100))
	for _, side in ipairs({ -1, 1 }) do
		for index = 0, 5 do
			part(portal, "IceBlock", V(4, 3.6, 4), base * CFrame.new(side * 10, 1.8 + index * 3.6, 0), index % 2 == 0 and rgb(127, 159, 190) or rgb(159, 191, 216))
		end
	end
	for index = 0, 10 do
		local angle = index / 10 * math.pi
		part(portal, "ArchBlock", V(4, 3.4, 4.4), base * CFrame.new(math.cos(angle) * 10, 23 + math.sin(angle) * 10, 0) * CFrame.Angles(0, 0, angle - math.pi / 2), index % 2 == 0 and rgb(159, 191, 216) or rgb(127, 159, 190))
	end
	local swirl = part(portal, "Swirl", V(0.6, 30, 16), base * CFrame.new(0, 16, 0) * CFrame.Angles(0, math.pi / 2, 0), rgb(63, 208, 255), { material = M.Neon, decor = true, transparency = 0.25 })
	CollectionService:AddTag(swirl, "PulseGlow")
	local light = Instance.new("PointLight")
	light.Color = rgb(95, 216, 255)
	light.Brightness = 3
	light.Range = 30
	light.Parent = swirl
	sign(portal, "PortalSign", V(20, 4.6, 0.8), base * CFrame.new(0, 37, 0) * CFrame.Angles(0, math.pi, 0), "🗺️ NIVELES", rgb(255, 79, 163), rgb(255, 255, 255), INK, { bothSides = true })
	prompt(swirl, "levels", "Elegir nivel", "Portal de niveles", 18)
end

local count = 0
for _, descendant in ipairs(root:GetDescendants()) do
	if descendant:IsA("BasePart") then count += 1 end
end
print(("Lobby built: %d parts"):format(count))
