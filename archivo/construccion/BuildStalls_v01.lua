local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local SkinAppearance = require(ReplicatedStorage.Shared.SkinAppearance)

local LEVEL = workspace:FindFirstChild("PenguinSlingshotMap_v01")
local V = Vector3.new
local M = Enum.Material
local rgb = Color3.fromRGB
local function hex(h) return Color3.fromRGB(math.floor(h / 65536) % 256, math.floor(h / 256) % 256, h % 256) end
local INK = hex(0x1d1440)
local HALF = math.pi / 2

local function part(parent, name, size, cf, color, o)
	o = o or {}
	local p = Instance.new(o.wedge and "WedgePart" or "Part")
	p.Name = name
	p.Anchored = true
	if o.shape then p.Shape = o.shape end
	p.Size = size
	p.CFrame = cf
	p.Color = color
	p.Material = o.material or M.SmoothPlastic
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Transparency = o.transparency or 0
	p.Reflectance = o.reflect or 0
	if not o.solid then
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
	end
	if o.material == M.Neon or o.noShadow then p.CastShadow = false end
	p.Parent = parent
	return p
end
local function box(parent, name, w, h, d, cf, color, o) return part(parent, name, V(w, h, d), cf, color, o) end
local function cyl(parent, name, r, h, cf, color, o)
	o = o or {}
	o.shape = Enum.PartType.Cylinder
	return part(parent, name, V(h, r * 2, r * 2), cf * CFrame.Angles(0, 0, HALF), color, o)
end
local function disc(parent, name, r, thick, cf, color, o)
	o = o or {}
	o.shape = Enum.PartType.Cylinder
	return part(parent, name, V(thick, r * 2, r * 2), cf * CFrame.Angles(0, HALF, 0), color, o)
end
local function ball(parent, name, r, cf, color, o)
	o = o or {}
	o.shape = Enum.PartType.Ball
	return part(parent, name, V(r * 2, r * 2, r * 2), cf, color, o)
end
local function model(name, parent)
	local m = Instance.new("Model")
	m.Name = name
	m.Parent = parent
	return m
end
local function surfaceText(target, text, size, opts)
	opts = opts or {}
	local gui = Instance.new("SurfaceGui")
	gui.Face = opts.face or Enum.NormalId.Front
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = opts.ppu or 40
	gui.LightInfluence = 0
	gui.Brightness = 1.2
	gui.Parent = target
	if opts.background then
		local bg = Instance.new("Frame")
		bg.Size = UDim2.fromScale(1, 1)
		bg.BackgroundColor3 = opts.background
		bg.BorderSizePixel = 0
		bg.Parent = gui
		if opts.round then
			local c = Instance.new("UICorner")
			c.CornerRadius = UDim.new(opts.round, 0)
			c.Parent = bg
		end
		if opts.backgroundGradient then
			local g = Instance.new("UIGradient")
			g.Color = ColorSequence.new(opts.backgroundGradient[1], opts.backgroundGradient[2])
			g.Parent = bg
		end
	end
	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(opts.width or 0.92, opts.height or 0.8)
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = UDim2.fromScale(opts.x or 0.5, opts.y or 0.5)
	label.Font = opts.font or Enum.Font.FredokaOne
	label.TextScaled = true
	label.Text = text
	label.TextColor3 = Color3.new(1, 1, 1)
	label.ZIndex = 2
	label.Parent = gui
	if opts.gradient then
		local g = Instance.new("UIGradient")
		g.Rotation = 90
		g.Color = ColorSequence.new(opts.gradient[1], opts.gradient[2])
		g.Parent = label
	end
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = opts.stroke or 5
	stroke.Color = opts.strokeColor or INK
	stroke.Parent = label
	return gui, label
end
local function marquee(parent, cf, w, h, step, r)
	local points = {}
	local u = -w / 2
	while u <= w / 2 + 0.01 do
		table.insert(points, { u, h / 2 })
		table.insert(points, { u, -h / 2 })
		u += step
	end
	local v = -h / 2 + step
	while v < h / 2 - 0.01 do
		table.insert(points, { -w / 2, v })
		table.insert(points, { w / 2, v })
		v += step
	end
	table.sort(points, function(a, b) return math.atan2(a[2], a[1]) < math.atan2(b[2], b[1]) end)
	for index, pt in ipairs(points) do
		local b = ball(parent, "Bulb", r, cf * CFrame.new(pt[1], pt[2], 0), hex(0xffe9a8), { material = M.Neon })
		b:SetAttribute("ChaseIndex", index)
		CollectionService:AddTag(b, "ChaseBulb")
	end
end
local function stringLights(parent, a, b, sag, n, colors)
	local previous
	for i = 0, n do
		local k = i / n
		local p = a:Lerp(b, k) - V(0, math.sin(k * math.pi) * sag, 0)
		local bulb = ball(parent, "LightBulb", 0.28, CFrame.new(p), colors[i % #colors + 1], { material = M.Neon })
		bulb:SetAttribute("ChaseIndex", i)
		CollectionService:AddTag(bulb, "ChaseBulb")
		if previous then
			part(parent, "Wire", V(0.08, 0.08, (p - previous).Magnitude), CFrame.lookAt((p + previous) / 2, p), hex(0x2a1c14))
		end
		previous = p
	end
end
local function steam(anchor, rate, size, speed)
	local e = Instance.new("ParticleEmitter")
	e.Texture = "rbxasset://textures/particles/smoke_main.dds"
	e.Color = ColorSequence.new(Color3.new(1, 1, 1))
	e.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.55), NumberSequenceKeypoint.new(1, 1) })
	e.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, size * 0.5), NumberSequenceKeypoint.new(1, size * 1.6) })
	e.Lifetime = NumberRange.new(2, 3)
	e.Rate = rate
	e.Speed = NumberRange.new(speed * 0.7, speed)
	e.SpreadAngle = Vector2.new(12, 12)
	e.EmissionDirection = Enum.NormalId.Top
	e.RotSpeed = NumberRange.new(-20, 20)
	e.LightInfluence = 0.5
	e.Parent = anchor
	return e
end
local function light(target, color, brightness, range)
	local l = Instance.new("PointLight")
	l.Color = color
	l.Brightness = brightness
	l.Range = range
	l.Shadows = false
	l.Parent = target
end
local function prompt(anchor, panel, action, object)
	local p = Instance.new("ProximityPrompt")
	p.ActionText = action
	p.ObjectText = object
	p.KeyboardKeyCode = Enum.KeyCode.E
	p.MaxActivationDistance = 16
	p.RequiresLineOfSight = false
	p.HoldDuration = 0
	p:SetAttribute("OpensPanel", panel)
	p.Parent = anchor
end
local function mannequin(parent, skinId, cf, scale)
	local template = StarterPlayer:FindFirstChild("StarterCharacter")
	local copy = template:Clone()
	copy.Name = "Mannequin"
	local humanoid = copy:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid:Destroy() end
	for _, d in ipairs(copy:GetDescendants()) do
		if d:IsA("LuaSourceContainer") then d:Destroy() elseif d:IsA("BasePart") then d.Anchored = true d.CanCollide = false d.CanQuery = false d.CanTouch = false end
	end
	copy.PrimaryPart = copy:FindFirstChild("HumanoidRootPart")
	copy:PivotTo(CFrame.new(0, 1.7, 0))
	copy.Parent = parent
	if skinId ~= "classic" then SkinAppearance.apply(copy, skinId) end
	for _, d in ipairs(copy:GetDescendants()) do
		if d:IsA("BasePart") then d.Anchored = true end
	end
	copy:ScaleTo(scale)
	copy:PivotTo(cf * CFrame.new(0, 1.7 * scale, 0))
	return copy
end
local function awning(parent, base, aw, ad, ay, z, colors, trim)
	for i = 0, 9 do
		local x = -aw / 2 + aw / 20 + i * aw / 10
		local color = colors[i % 2 + 1]
		box(parent, "Awning", aw / 10, 0.3, ad, base * CFrame.new(x, ay, z) * CFrame.Angles(0.32, 0, 0), color)
		local edge = base * CFrame.new(x, ay - ad / 2 * math.sin(0.32), z - ad / 2 * math.cos(0.32))
		local r = aw / 20
		for k, wf in ipairs({ 1, 0.8, 0.5 }) do box(parent, "Scallop", r * 2 * wf, r * 0.32, 0.3, edge * CFrame.new(0, -r * 0.16 - (k - 1) * r * 0.32, -0.05), color) end
		if trim then ball(parent, "Bead", 0.22, edge * CFrame.new(0, -aw / 20 * 0.96 - 0.1, -0.1), trim, { material = M.Metal }) end
	end
	box(parent, "AwningTrim", aw + 0.2, 0.35, 0.35, base * CFrame.new(0, ay - ad / 2 * math.sin(0.32) + 0.05, z - ad / 2 * math.cos(0.32) + 0.12), hex(0xffd56a), { material = M.Metal })
	return ay - ad / 2 * math.sin(0.32), z - ad / 2 * math.cos(0.32)
end

-- ===================== CHOCOLATE =====================
local function buildChocolate(root, base)
	local W, D = 17, 9
	local WOOD, WOOD_D, WOOD_L, CHOC, CREAM, RED = hex(0x9a5f33), hex(0x6e3f1f), hex(0xc98a52), hex(0x4e2614), hex(0xfff1d6), hex(0xe0313d)
	local L = function(x, y, z) return base * CFrame.new(x, y, z) end
	for i = 0, 8 do box(root, "Deck", W + 3, 0.5, 1.15, L(0, 0.25, -D / 2 - 0.6 + i * 1.15), i % 2 == 1 and hex(0xa86a3c) or hex(0x96592f), { material = M.WoodPlanks, solid = true }) end
	for i = 0, 9 do box(root, "BackPlank", 1.7, 9.5, 0.5, L(-W / 2 + 0.85 + i * 1.7, 5.25, D / 2 - 0.3), i % 2 == 1 and hex(0x8a5530) or hex(0x7c4a29), { material = M.Wood, solid = true }) end
	for _, y in ipairs({ 3.6, 5.6, 7.6 }) do box(root, "Shelf", W - 1, 0.35, 1.4, L(0, y, D / 2 - 1.1), WOOD_L, { material = M.Wood }) end
	local jars = { hex(0x7a3d1f), hex(0xb8732f), hex(0xe8c08a), hex(0x5a2b14) }
	for i = 0, 6 do
		local x = -W / 2 + 2 + i * 2.2
		cyl(root, "Jar", 0.5, 1.3, L(x, 4.45, D / 2 - 1.1), hex(0xe9f6ff), { material = M.Glass, transparency = 0.5 })
		cyl(root, "JarFill", 0.42, 1, L(x, 4.35, D / 2 - 1.1), jars[i % 4 + 1])
		cyl(root, "JarLid", 0.55, 0.25, L(x, 5.2, D / 2 - 1.1), RED)
	end
	for i = 0, 5 do
		local x = -W / 2 + 2.4 + i * 2.5
		cyl(root, "Tin", 0.65, 1.1, L(x, 6.35, D / 2 - 1.1), ({ hex(0xd8323a), hex(0x2c8a4a), hex(0xf1b12a) })[i % 3 + 1])
		cyl(root, "TinLid", 0.68, 0.12, L(x, 6.95, D / 2 - 1.1), hex(0xffd56a), { material = M.Metal })
	end
	for i = 0, 4 do for k = 0, 2 do cyl(root, "Cookie", 0.55, 0.2, L(-W / 2 + 3 + i * 3, 7.95 + k * 0.22, D / 2 - 1.1), hex(0xc98a4a)) end end
	local posts = { { -W / 2, -D / 2 + 0.6 }, { W / 2, -D / 2 + 0.6 }, { -W / 2, D / 2 - 0.4 }, { W / 2, D / 2 - 0.4 } }
	for i, p in ipairs(posts) do
		cyl(root, "Post", 0.45, 11, L(p[1], 6, p[2]), WOOD, { material = M.Wood, solid = true })
		for k = 0, 5 do cyl(root, "PostRing", 0.5, 0.18, L(p[1], 1.6 + k * 1.8, p[2]), WOOD_D) end
		if i <= 2 then for k = 0, 9 do cyl(root, "CandyWrap", 0.53, 0.5, L(p[1], 1.2 + k * 0.55, p[2]), k % 2 == 1 and Color3.new(1, 1, 1) or RED) end end
	end
	local cy = 3.6
	box(root, "Counter", W, cy - 0.5, 3.2, L(0, 0.5 + (cy - 0.5) / 2, -D / 2 + 1.2), WOOD_L, { material = M.Wood, solid = true })
	box(root, "CounterTop", W + 0.6, 0.45, 3.8, L(0, cy + 0.2, -D / 2 + 1.2), CHOC, { solid = true })
	box(root, "CounterTrim", W + 0.7, 0.12, 3.9, L(0, cy - 0.05, -D / 2 + 1.2), hex(0xffd56a), { material = M.Metal })
	local panel = box(root, "FrontPanel", W - 2, 2.2, 0.25, L(0, 2.15, -D / 2 - 0.42), CREAM)
	surfaceText(panel, "CHOCOLATE CALIENTE", 1, { y = 0.62, height = 0.5, width = 0.86, gradient = { Color3.new(1, 1, 1), hex(0xffe2b8) }, strokeColor = CHOC, stroke = 4 })
	box(root, "DripBand", W - 2, 0.55, 0.32, L(0, 3, -D / 2 - 0.46), CHOC)
	for i = 0, 13 do
		local x = -W / 2 + 1.6 + i * (W - 3.2) / 13
		local h = 0.3 + ((i * 37) % 7) / 7 * 0.55
		box(root, "Drip", 0.55, h, 0.3, L(x, 2.75 - h / 2, -D / 2 - 0.46), CHOC)
		ball(root, "DripDrop", 0.3, L(x, 2.72 - h, -D / 2 - 0.46), CHOC)
	end
	local AW, AD, ay = W + 2.6, 6.2, 10.6
	local edgeY, edgeZ = awning(root, base, AW, AD, ay, -D / 2 + 1.2, { RED, Color3.new(1, 1, 1) })
	box(root, "AwningSnow", AW + 0.2, 0.45, AD * 0.38, L(0, ay + 0.75, -D / 2 + 1.2 + AD * 0.3) * CFrame.Angles(0.32, 0, 0), Color3.new(1, 1, 1), { material = M.Snow })
	for i = 0, 11 do
		local lump = ball(root, "SnowLump", 0.75, L(-AW / 2 + 0.9 + i * AW / 12, ay + 1.15, -D / 2 + 1.2 + AD * 0.3), Color3.new(1, 1, 1), { material = M.Snow })
		lump.Size = V(1.5, 0.8, 1.5)
	end
	for i = 0, 15 do
		local len = 0.8 + ((i * 53) % 9) / 9 * 1.2
		part(root, "Icicle", V(0.22, len, 0.22), L(-AW / 2 + 0.4 + (AW - 0.8) * (i + 0.5) / 16, edgeY - 1.1 - len / 2, edgeZ - 0.1), hex(0xcfefff), { material = M.Ice, transparency = 0.15 })
	end
	local signFrame = L(0, 14.2, -D / 2 + 2.2)
	local board = box(root, "SignBoard", 13.6, 3.8, 0.7, signFrame, CHOC)
	surfaceText(board, "CHOCOLATE", 1, { gradient = { hex(0xfff6e2), hex(0xffc77a) }, stroke = 6, strokeColor = hex(0x2a1208), height = 0.78 })
	for _, y in ipairs({ 1.95, -1.95 }) do box(root, "SignTrim", 14.2, 0.35, 0.9, signFrame * CFrame.new(0, y, 0), hex(0xffd56a), { material = M.Metal }) end
	marquee(root, signFrame * CFrame.new(0, 0, -0.42), 13.4, 3.6, 0.85, 0.2)
	for _, s in ipairs({ -1, 1 }) do cyl(root, "SignPost", 0.18, 3.2, signFrame * CFrame.new(s * 5.5, -3.4, 0), WOOD_D) end
	local mug = model("GiantMug", root)
	local mugBase = L(0, 18.6, -D / 2 + 2.2)
	cyl(mug, "Cup", 2.2, 3.6, mugBase, RED)
	cyl(mug, "Stripe", 2.25, 0.55, mugBase * CFrame.new(0, 0.6, 0), Color3.new(1, 1, 1))
	cyl(mug, "Rim", 2.27, 0.25, mugBase * CFrame.new(0, 1.75, 0), hex(0xffd56a), { material = M.Metal })
	cyl(mug, "Cocoa", 2.05, 0.2, mugBase * CFrame.new(0, 1.72, 0), CHOC)
	for _, h in ipairs({ { 2.4, 0.9, 0 }, { 2.4, -0.9, 0 } }) do box(mug, "Handle", 0.7, 0.7, 0.7, mugBase * CFrame.new(h[1], h[2], 0), RED) end
	box(mug, "Handle", 0.7, 2.5, 0.7, mugBase * CFrame.new(3.05, 0, 0), RED)
	for _, c in ipairs({ { 0, 2.3, 0, 1.2 }, { -0.8, 2.1, 0.4, 0.9 }, { 0.8, 2.1, -0.3, 0.9 }, { 0.2, 3, 0, 0.8 }, { 0, 3.6, 0, 0.5 } }) do ball(mug, "Cream", c[4], mugBase * CFrame.new(c[1], c[2], c[3]), hex(0xfffaf0)) end
	ball(mug, "Cherry", 0.32, mugBase * CFrame.new(0, 4.05, 0), RED)
	for _, c in ipairs({ { -1.3, 2, 0.6, 0xffc0d8 }, { 1.2, 2, 0.8, 0xffffff }, { 1, 2.1, -0.9, 0xffc0d8 }, { -1, 2, -1, 0xffffff } }) do box(mug, "Marshmallow", 0.6, 0.6, 0.6, mugBase * CFrame.new(c[1], c[2], c[3]) * CFrame.Angles(0.4, 0.6, 0.2), hex(c[4])) end
	steam(part(mug, "SteamAnchor", V(2, 0.2, 2), mugBase * CFrame.new(0, 3.4, 0), Color3.new(1, 1, 1), { transparency = 1 }), 6, 2, 3)
	mug.WorldPivot = mugBase
	mug:SetAttribute("SpinSpeed", 0.4)
	CollectionService:AddTag(mug, "SpinningDecor")
	local potBase = L(-5.5, cy + 0.45, -D / 2 + 1.2)
	cyl(root, "Pot", 1.4, 1.7, potBase * CFrame.new(0, 0.85, 0), hex(0xd27a3a), { material = M.Metal })
	cyl(root, "PotRim", 1.55, 0.2, potBase * CFrame.new(0, 1.7, 0), hex(0xf0a060), { material = M.Metal })
	cyl(root, "PotCocoa", 1.38, 0.1, potBase * CFrame.new(0, 1.62, 0), CHOC)
	local ladle = model("Ladle", root)
	cyl(ladle, "Handle", 0.08, 3.2, potBase * CFrame.new(0.5, 2.6, 0) * CFrame.Angles(0, 0, -0.35), hex(0x8a8f9c), { material = M.Metal })
	ladle.WorldPivot = potBase * CFrame.new(0, 1.6, 0)
	ladle:SetAttribute("SpinSpeed", 0.9)
	CollectionService:AddTag(ladle, "SpinningDecor")
	local bubbles = part(root, "Bubbles", V(2.2, 0.2, 2.2), potBase * CFrame.new(0, 1.7, 0), Color3.new(1, 1, 1), { transparency = 1 })
	local be = steam(bubbles, 4, 1.2, 2)
	be.Lifetime = NumberRange.new(1.5, 2.2)
	local mugColors = { 0xff6b6b, 0x56c2ff, 0x7fe08a, 0xffd34a, 0xc58bff }
	for i, c in ipairs(mugColors) do
		local mb = L(-2.2 + (i - 1) * 1.75, cy + 0.45, -D / 2 + 0.3)
		cyl(root, "Mug", 0.52, 1, mb * CFrame.new(0, 0.5, 0), hex(c))
		box(root, "MugHandle", 0.18, 0.6, 0.18, mb * CFrame.new(0.65, 0.5, 0), hex(c))
		cyl(root, "MugCocoa", 0.48, 0.06, mb * CFrame.new(0, 0.98, 0), CHOC)
		ball(root, "MugCream", 0.42, mb * CFrame.new(0, 1.15, 0), hex(0xfffaf0))
		ball(root, "MugCream", 0.25, mb * CFrame.new(0, 1.45, 0), hex(0xfffaf0))
		cyl(root, "Cinnamon", 0.06, 0.9, mb * CFrame.new(0.25, 1.3, 0.1) * CFrame.Angles(0, 0, 0.4), hex(0x8a4a22))
	end
	local jar = L(6.8, cy + 0.45, -D / 2 + 1.4)
	cyl(root, "CookieJar", 0.95, 2, jar * CFrame.new(0, 1, 0), hex(0xe9f6ff), { material = M.Glass, transparency = 0.55 })
	cyl(root, "CookieJarLid", 1, 0.3, jar * CFrame.new(0, 2.1, 0), RED)
	ball(root, "CookieJarKnob", 0.35, jar * CFrame.new(0, 2.45, 0), hex(0xffd56a), { material = M.Metal })
	for k = 0, 4 do cyl(root, "JarCookie", 0.6, 0.18, jar * CFrame.new((k % 2 - 0.5) * 0.3, 0.3 + k * 0.33, 0) * CFrame.Angles(0.5 * (k % 2), 0, 0.3), hex(0xd99a52)) end
	local cup = L(4.8, cy + 0.45, -D / 2 + 0.2)
	cyl(root, "CaneCup", 0.48, 0.9, cup * CFrame.new(0, 0.45, 0), hex(0x2c8a4a))
	for k = 0, 2 do
		local cane = cup * CFrame.new((k - 1) * 0.25, 0.9, 0) * CFrame.Angles(0, 0, (k - 1) * 0.2)
		for s = 0, 5 do cyl(root, "Cane", 0.09, 0.3, cane * CFrame.new(0, s * 0.3, 0), s % 2 == 1 and Color3.new(1, 1, 1) or RED) end
		box(root, "CaneHook", 0.45, 0.18, 0.18, cane * CFrame.new(0.2, 1.75, 0), RED)
	end
	local vendor = mannequin(root, "classic", L(0, 0.5, -D / 2 + 3.6), 1.9)
	local head = vendor:GetPivot() * CFrame.new(0, 2.75, 0)
	cyl(root, "ChefHatBand", 1.3, 0.5, head, Color3.new(1, 1, 1))
	for _, c in ipairs({ { 0, 0.9, 0 }, { -0.6, 0.8, 0.2 }, { 0.6, 0.8, -0.2 }, { 0, 1.2, 0.5 } }) do ball(root, "ChefHat", 0.75, head * CFrame.new(c[1], c[2], c[3]), Color3.new(1, 1, 1)) end
	for i, p in ipairs({ { -W / 2 + 0.2, -D / 2 - 1.2 }, { W / 2 - 0.2, -D / 2 - 1.2 } }) do
		local lantern = model("Lantern", root)
		local top = L(p[1], ay - 1.6, p[2])
		cyl(lantern, "String", 0.05, 1.2, top * CFrame.new(0, -0.6, 0), hex(0x2a1c14))
		local body = ball(lantern, "Body", 0.75, top * CFrame.new(0, -1.8, 0), hex(0xff8a3a), { material = M.Neon })
		body.Size = V(1.5, 1.8, 1.5)
		light(body, hex(0xffa04a), 1.2, 14)
		cyl(lantern, "Cap", 0.4, 0.2, top * CFrame.new(0, -0.9, 0), hex(0xffd56a), { material = M.Metal })
		cyl(lantern, "Cap", 0.4, 0.2, top * CFrame.new(0, -2.7, 0), hex(0xffd56a), { material = M.Metal })
		lantern.WorldPivot = top
		lantern:SetAttribute("SwingAmplitude", 0.12)
		CollectionService:AddTag(lantern, "SwingingDecor")
		local _ = i
	end
	stringLights(root, L(-W / 2, 9.6, -D / 2 + 0.6).Position, L(W / 2, 9.6, -D / 2 + 0.6).Position, 1.2, 16, { hex(0xff4f6d), hex(0xffc93a), hex(0x3ad1ff), hex(0x7be35a), hex(0xb46bff) })
	light(part(root, "WarmLight", V(1, 1, 1), L(0, 7, -D / 2 + 1), Color3.new(1, 1, 1), { transparency = 1 }), hex(0xffb066), 1.2, 22)
	local easel = L(W / 2 + 3.4, 0, -D / 2 - 1.5) * CFrame.Angles(0, -0.35, 0)
	box(root, "EaselLeg", 0.25, 6, 0.25, easel * CFrame.new(-1.6, 3, 0) * CFrame.Angles(-0.1, 0, 0.08), WOOD_D)
	box(root, "EaselLeg", 0.25, 6, 0.25, easel * CFrame.new(1.6, 3, 0) * CFrame.Angles(-0.1, 0, -0.08), WOOD_D)
	box(root, "EaselLeg", 0.25, 5.5, 0.25, easel * CFrame.new(0, 2.7, 0.9) * CFrame.Angles(0.3, 0, 0), WOOD_D)
	box(root, "EaselFrame", 3.8, 4.6, 0.25, easel * CFrame.new(0, 3.6, -0.15) * CFrame.Angles(-0.1, 0, 0), WOOD, { material = M.Wood })
	local chalk = box(root, "Chalkboard", 3.4, 4.2, 0.1, easel * CFrame.new(0, 3.6, -0.3) * CFrame.Angles(-0.1, 0, 0), hex(0x22352a), { material = M.Slate })
	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	gui.PixelsPerStud = 60
	gui.LightInfluence = 0
	gui.Parent = chalk
	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Parent = gui
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, 14)
	pad.Parent = gui
	local function line(text, color, height, font)
		local l = Instance.new("TextLabel")
		l.BackgroundTransparency = 1
		l.Size = UDim2.new(0.86, 0, 0, height)
		l.Font = font or Enum.Font.GothamBold
		l.TextScaled = true
		l.TextColor3 = color
		l.Text = text
		l.Parent = gui
	end
	line("MENÚ", hex(0xffe9a8), 46, Enum.Font.FredokaOne)
	for _, row in ipairs({ { "Chocolate", "5" }, { "Con malvavisco", "8" }, { "Galleta", "3" }, { "Bastón", "2" } }) do line(row[1] .. " · " .. row[2] .. " 🐟", Color3.new(1, 1, 1), 30) end
	for i, p in ipairs({ { -W / 2 - 2.6, -D / 2 + 0.6 }, { -W / 2 - 2.2, -D / 2 + 3.4 } }) do
		local b = L(p[1], 0, p[2])
		cyl(root, "Barrel", 1.15, 2.6, b * CFrame.new(0, 1.3, 0), hex(0x8a5530), { material = M.Wood, solid = true })
		for _, y in ipairs({ 0.4, 1.3, 2.2 }) do cyl(root, "BarrelHoop", 1.2, 0.16, b * CFrame.new(0, y, 0), hex(0x4a4f5c), { material = M.Metal }) end
		if i == 1 then
			cyl(root, "BarrelMug", 0.48, 0.9, b * CFrame.new(-0.3, 3.05, 0), hex(0xffd34a))
			ball(root, "BarrelCream", 0.4, b * CFrame.new(-0.3, 3.6, 0), hex(0xfffaf0))
		end
	end
	for _, s in ipairs({ { -W / 2 - 1, -D / 2 - 2.4, 1.6 }, { W / 2 + 1, D / 2 + 0.6, 2 }, { -3, -D / 2 - 3.2, 1 } }) do
		local pile = ball(root, "SnowPile", s[3], L(s[1], 0, s[2]), Color3.new(1, 1, 1), { material = M.Snow })
		pile.Size = V(s[3] * 2, s[3] * 0.9, s[3] * 2)
	end
end

-- ===================== SHOP =====================
local function buildShop(root, base)
	local W, D = 17, 9
	local TEAL, TEAL_D, TEAL_L, WHITE, GOLD, PINK = hex(0x1fc7b4), hex(0x0f8f86), hex(0x7ff0de), Color3.new(1, 1, 1), hex(0xffcf3a), hex(0xff5fb0)
	local L = function(x, y, z) return base * CFrame.new(x, y, z) end
	box(root, "Platform", W + 4, 0.6, D + 3, L(0, 0.3, 0), hex(0x2b2f52), { solid = true })
	box(root, "PlatformTrim", W + 4.4, 0.2, D + 3.4, L(0, 0.65, 0), GOLD, { material = M.Metal })
	for i = 0, 7 do box(root, "FloorTile", (W + 4) / 8 - 0.1, 0.05, D + 2.6, L(-(W + 4) / 2 + (W + 4) / 16 + i * (W + 4) / 8, 0.63, 0), i % 2 == 1 and hex(0x3a3f6e) or hex(0x323764), { solid = true }) end
	box(root, "BackWall", W, 10, 0.6, L(0, 5.6, D / 2 - 0.3), hex(0xeafffb), { solid = true })
	for i = 0, 8 do box(root, "WallStripe", 0.15, 10, 0.62, L(-W / 2 + 1 + i * 1.9, 5.6, D / 2 - 0.32), TEAL_L) end
	local shelfY = { 3.8, 6.1, 8.4 }
	for _, y in ipairs(shelfY) do
		box(root, "Shelf", W - 1, 0.3, 1.5, L(0, y, D / 2 - 1.1), WHITE)
		box(root, "ShelfTrim", W - 1, 0.2, 0.16, L(0, y - 0.1, D / 2 - 1.86), GOLD, { material = M.Metal })
	end
	local potions = { 0xff4f8a, 0x3ad1ff, 0x7be35a, 0xffc93a, 0xb46bff, 0xff8a3a }
	for i = 0, 6 do
		local b = L(-W / 2 + 2 + i * 2.15, shelfY[1] + 0.15, D / 2 - 1.1)
		ball(root, "PotionGlass", 0.6, b * CFrame.new(0, 0.6, 0), hex(0xeaf8ff), { material = M.Glass, transparency = 0.55 })
		local liquid = ball(root, "Potion", 0.5, b * CFrame.new(0, 0.55, 0), hex(potions[i % 6 + 1]), { material = M.Neon })
		CollectionService:AddTag(liquid, "PulseGlow")
		cyl(root, "PotionNeck", 0.2, 0.6, b * CFrame.new(0, 1.35, 0), hex(0xeaf8ff), { material = M.Glass, transparency = 0.5 })
		cyl(root, "PotionCork", 0.22, 0.22, b * CFrame.new(0, 1.7, 0), hex(0x8a5530))
	end
	for i = 0, 5 do
		local b = L(-W / 2 + 2.4 + i * 2.5, shelfY[2] + 0.15, D / 2 - 1.1)
		box(root, "GiftBox", 1.4, 1.2, 1.2, b * CFrame.new(0, 0.6, 0), hex(potions[(i + 2) % 6 + 1]))
		box(root, "GiftRibbon", 1.45, 0.3, 1.25, b * CFrame.new(0, 0.6, 0), WHITE)
		box(root, "GiftRibbon", 0.3, 1.25, 1.25, b * CFrame.new(0, 0.6, 0), WHITE)
		ball(root, "GiftBow", 0.25, b * CFrame.new(0, 1.3, 0), GOLD, { material = M.Metal })
	end
	for i = 0, 4 do for k = 0, 3 do cyl(root, "Coin", 0.6, 0.22, L(-W / 2 + 3 + i * 3 + (k % 2) * 0.12, shelfY[3] + 0.3 + k * 0.24, D / 2 - 1.1), GOLD, { material = M.Metal }) end end
	for _, p in ipairs({ { -W / 2, -D / 2 + 0.6 }, { W / 2, -D / 2 + 0.6 }, { -W / 2, D / 2 - 0.4 }, { W / 2, D / 2 - 0.4 } }) do
		cyl(root, "Pillar", 0.47, 11, L(p[1], 6.1, p[2]), WHITE, { solid = true })
		for k = 0, 4 do cyl(root, "PillarRing", 0.55, 0.3, L(p[1], 1.4 + k * 2.3, p[2]), GOLD, { material = M.Metal }) end
		ball(root, "PillarTop", 0.75, L(p[1], 11.8, p[2]), GOLD, { material = M.Metal })
	end
	local cy = 3.6
	box(root, "Counter", W, cy - 0.6, 3, L(0, 0.6 + (cy - 0.6) / 2, -D / 2 + 1.2), WHITE, { solid = true })
	for i = 0, 3 do
		box(root, "CounterPanel", 3.4, 1.9, 0.12, L(-W / 2 + 2.6 + i * 3.95, 2.1, -D / 2 - 0.32), TEAL)
		box(root, "CounterPanelTrim", 3.6, 0.16, 0.14, L(-W / 2 + 2.6 + i * 3.95, 3.1, -D / 2 - 0.34), GOLD, { material = M.Metal })
	end
	box(root, "CounterTop", W + 0.6, 0.4, 3.6, L(0, cy + 0.1, -D / 2 + 1.2), TEAL_D, { solid = true })
	box(root, "CounterTopTrim", W + 0.7, 0.12, 3.7, L(0, cy - 0.12, -D / 2 + 1.2), GOLD, { material = M.Metal })
	box(root, "DisplayGlass", 10, 2.2, 2.4, L(-1.5, cy + 1.4, -D / 2 + 1.2), hex(0xdff8ff), { material = M.Glass, transparency = 0.7 })
	box(root, "DisplayTop", 10.2, 0.15, 2.6, L(-1.5, cy + 2.55, -D / 2 + 1.2), GOLD, { material = M.Metal })
	for i, c in ipairs({ 0x5fd3ff, 0xff5fb0, 0x7be35a, 0xffc93a, 0xb46bff }) do
		local x = -5.5 + (i - 1) * 2
		cyl(root, "GemStand", 0.55, 0.3, L(x, cy + 0.45, -D / 2 + 1.2), WHITE)
		local gem = model("Gem", root)
		box(gem, "Gem", 0.8, 0.8, 0.8, L(x, cy + 1.35, -D / 2 + 1.2) * CFrame.Angles(math.rad(45), 0, math.rad(35)), hex(c), { material = M.Neon })
		gem.WorldPivot = L(x, cy + 1.35, -D / 2 + 1.2)
		gem:SetAttribute("SpinSpeed", 1.2 + i * 0.1)
		CollectionService:AddTag(gem, "SpinningDecor")
	end
	local reg = L(6, cy + 0.3, -D / 2 + 1.3)
	box(root, "Register", 2.2, 1.2, 1.8, reg * CFrame.new(0, 0.6, 0), PINK)
	box(root, "RegisterKeys", 2.2, 0.3, 1.2, reg * CFrame.new(0, 1.25, -0.2) * CFrame.Angles(0.4, 0, 0), WHITE)
	local screen = box(root, "RegisterScreen", 1.6, 0.9, 0.2, reg * CFrame.new(0, 1.9, 0.5) * CFrame.Angles(0.2, 0, 0), INK)
	surfaceText(screen, "¡OFERTA!", 1, { background = hex(0x0b2a2a), gradient = { hex(0x7dffde), hex(0x7dffde) }, stroke = 1, ppu = 60 })
	local AW, AD, ay = W + 2.6, 6.2, 10.8
	awning(root, base, AW, AD, ay, -D / 2 + 1.2, { TEAL, WHITE }, GOLD)
	for i = 0, 13 do
		local x = -W / 2 + 0.6 + i * (W - 1.2) / 13
		part(root, "Pennant", V(0.9, 0.9, 0.12), L(x, 9.2 - math.sin(i / 13 * math.pi) * 0.8, -D / 2 + 0.6), hex(potions[i % 6 + 1]), { wedge = true }).CFrame = L(x, 9.2 - math.sin(i / 13 * math.pi) * 0.8, -D / 2 + 0.6) * CFrame.Angles(0, HALF, math.pi)
	end
	local signFrame = L(0, 14.6, -D / 2 + 2.2)
	box(root, "SignBack", 15.2, 3.8, 0.8, signFrame, INK)
	local face = box(root, "SignFace", 14.4, 3.4, 0.1, signFrame * CFrame.new(0, 0, -0.45), TEAL)
	surfaceText(face, "🛒 TIENDA", 1, { background = TEAL, backgroundGradient = { TEAL, hex(0x14a2d6) }, round = 0.3, gradient = { Color3.new(1, 1, 1), hex(0xd6fff6) }, stroke = 7, height = 0.82 })
	marquee(root, signFrame * CFrame.new(0, 0, -0.5), 15, 3.6, 0.8, 0.2)
	local top = model("FloatingDiamond", root)
	local diamondFrame = L(0, 19.2, -D / 2 + 2.2)
	local dia = box(top, "Diamond", 2.2, 2.2, 2.2, diamondFrame * CFrame.Angles(math.rad(45), 0, math.rad(45)), hex(0x7fe4ff), { material = M.Glass, transparency = 0.15 })
	box(top, "DiamondCore", 1.2, 1.2, 1.2, diamondFrame * CFrame.Angles(math.rad(45), 0, math.rad(45)), hex(0xbff3ff), { material = M.Neon })
	local sparkle = Instance.new("ParticleEmitter")
	sparkle.Texture = "rbxasset://textures/particles/sparkles_main.dds"
	sparkle.Color = ColorSequence.new(hex(0xffffff), hex(0x7fe4ff))
	sparkle.Size = NumberSequence.new(0.6, 0)
	sparkle.Lifetime = NumberRange.new(1, 1.6)
	sparkle.Rate = 14
	sparkle.Speed = NumberRange.new(2, 4)
	sparkle.SpreadAngle = Vector2.new(180, 180)
	sparkle.LightEmission = 1
	sparkle.Parent = dia
	light(dia, hex(0x7fe4ff), 1.5, 14)
	top.WorldPivot = diamondFrame
	top:SetAttribute("SpinSpeed", 1.2)
	CollectionService:AddTag(top, "SpinningDecor")
	local burstFrame = L(W / 2 - 0.5, 12.6, -D / 2 - 0.9) * CFrame.Angles(0, 0, -0.25)
	local burst = model("OffersBurst", root)
	for k = 0, 3 do box(burst, "Burst", 3.4, 3.4, 0.2, burstFrame * CFrame.Angles(0, 0, k * math.pi / 8), hex(0xff3b55)) end
	local burstFace = box(burst, "BurstFace", 3.2, 3.2, 0.05, burstFrame * CFrame.new(0, 0, -0.14), hex(0xff3b55))
	surfaceText(burstFace, "¡OFERTAS!\n-20%", 1, { gradient = { Color3.new(1, 1, 1), hex(0xffe6a8) }, stroke = 4, width = 0.9, height = 0.7 })
	burst.WorldPivot = burstFrame
	burst:SetAttribute("SwingAmplitude", 0.08)
	CollectionService:AddTag(burst, "SwingingDecor")
	for _, data in ipairs({ { "fire", -W / 2 - 4.2, 0xff5a1a, "2,500 🐟" }, { "ice", W / 2 + 4.2, 0x3fb6ff, "1,800 🐟" } }) do
		local pb = L(data[2], 0, -D / 2 + 1)
		cyl(root, "Pedestal", 2.4, 1.2, pb * CFrame.new(0, 0.6, 0), WHITE, { solid = true })
		cyl(root, "PedestalTrim", 2.45, 0.25, pb * CFrame.new(0, 1.25, 0), GOLD, { material = M.Metal })
		local ring = cyl(root, "PedestalGlow", 2.6, 0.15, pb * CFrame.new(0, 1.42, 0), hex(data[3]), { material = M.Neon })
		CollectionService:AddTag(ring, "PulseGlow")
		cyl(root, "LightBeam", 2.1, 9, pb * CFrame.new(0, 5.9, 0), hex(data[3]), { material = M.Neon, transparency = 0.88 })
		local holder = model("SkinDisplay", root)
		mannequin(holder, data[1], pb * CFrame.new(0, 1.35, 0), 1.6)
		holder.WorldPivot = pb * CFrame.new(0, 1.35, 0)
		holder:SetAttribute("SpinSpeed", 0.5)
		CollectionService:AddTag(holder, "SpinningDecor")
		local tag = box(root, "PriceTag", 3.4, 1.1, 0.1, pb * CFrame.new(0, 0.6, -2.5), INK)
		surfaceText(tag, data[4], 1, { gradient = { hex(0xffe06a), hex(0xffe06a) }, stroke = 2 })
	end
	local keeper = mannequin(root, "classic", L(0, 0.7, -D / 2 + 3.6), 1.9)
	local head = keeper:GetPivot() * CFrame.new(0, 2.75, 0)
	cyl(root, "HatBrim", 1.1, 0.2, head, INK)
	cyl(root, "HatTop", 0.8, 1.6, head * CFrame.new(0, 0.85, 0), INK)
	cyl(root, "HatBand", 0.82, 0.3, head * CFrame.new(0, 0.25, 0), PINK)
	light(part(root, "CoolLight", V(1, 1, 1), L(0, 7, -D / 2 + 1), WHITE, { transparency = 1 }), hex(0x7fffe8), 1, 22)
	prompt(part(root, "PromptAnchor", V(2, 2, 2), L(0, 3, -D / 2 - 2.5), WHITE, { transparency = 1 }), "shop", "Abrir", "Tienda")
	for _, s in ipairs({ { -W / 2 - 1.5, -D / 2 - 2.6, 1.4 }, { W / 2 + 1.6, D / 2 + 0.4, 1.8 } }) do
		local pile = ball(root, "SnowPile", s[3], L(s[1], 0, s[2]), WHITE, { material = M.Snow })
		pile.Size = V(s[3] * 2, s[3] * 0.9, s[3] * 2)
	end
end

local entrance = LEVEL:FindFirstChild("FestiveDecoration") and LEVEL.FestiveDecoration:FindFirstChild("Entrance")
local oldCocoa = entrance and entrance:FindFirstChild("CocoaStand")
if oldCocoa then oldCocoa:Destroy() end
local existingChoco = LEVEL:FindFirstChild("ChocolateStall", true)
if existingChoco then existingChoco:Destroy() end
local chocoRoot = model("ChocolateStall", entrance or LEVEL)
buildChocolate(chocoRoot, CFrame.new(-70, 600, 45) * CFrame.Angles(0, -math.pi / 2, 0))

local lobby = LEVEL:FindFirstChild("Lobby")
local oldShop = lobby:FindFirstChild("Shop")
if oldShop then oldShop:Destroy() end
local shopRoot = Instance.new("Folder")
shopRoot.Name = "Shop"
shopRoot.Parent = lobby
buildShop(shopRoot, CFrame.lookAt(V(62, 600, 136), V(0, 600, 104)))

local count = 0
for _, r in ipairs({ chocoRoot, shopRoot }) do for _, d in ipairs(r:GetDescendants()) do if d:IsA("BasePart") then count += 1 end end end
print(("Stalls built: %d parts"):format(count))
