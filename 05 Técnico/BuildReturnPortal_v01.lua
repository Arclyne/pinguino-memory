local container = workspace:FindFirstChild("PenguinSlingshotMap_v01")
for _, name in ipairs({ "ReturnPortal", "ReturnPortalGate" }) do
	local old = container:FindFirstChild(name)
	if old then old:Destroy() end
end

local plazaGround = container.FinishPlaza:FindFirstChild("PlazaGround")
local groundTop = plazaGround.Position.Y + plazaGround.Size.Y / 2
local PLAZA_ORIGIN = CFrame.new(0, groundTop, -1800)
local PORTAL_ORIGIN = PLAZA_ORIGIN * CFrame.new(0, 0, -50)
local V = Vector3.new
local M = Enum.Material

local Palette = {
	Snow = Color3.fromRGB(243, 248, 253),
	Stone = Color3.fromRGB(141, 150, 161),
	StoneDark = Color3.fromRGB(111, 120, 132),
	IceStoneLight = Color3.fromRGB(159, 191, 216),
	IceStoneDark = Color3.fromRGB(127, 159, 190),
	Keystone = Color3.fromRGB(111, 146, 180),
	Rune = Color3.fromRGB(127, 232, 255),
	Emblem = Color3.fromRGB(217, 246, 255),
	Icicle = Color3.fromRGB(191, 233, 255),
	Crystal = Color3.fromRGB(191, 243, 255),
	Path = Color3.fromRGB(185, 220, 242),
	WoodDark = Color3.fromRGB(107, 66, 40),
	WoodLight = Color3.fromRGB(181, 121, 74),
	SwirlDeep = Color3.fromRGB(12, 74, 158),
	SwirlBright = Color3.fromRGB(63, 208, 255),
	SwirlWhite = Color3.fromRGB(255, 255, 255),
	Glow = Color3.fromRGB(95, 216, 255),
}

local function newModel(name, parent)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent
	return model
end

local function createPart(parent, name, size, cframe, color, material, options)
	options = options or {}
	local part = Instance.new(options.className or "Part")
	part.Name = name
	part.Anchored = true
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material or M.Plastic
	part.TopSurface = options.studs and Enum.SurfaceType.Studs or Enum.SurfaceType.Smooth
	part.BottomSurface = options.studs and Enum.SurfaceType.Inlet or Enum.SurfaceType.Smooth
	if options.transparency then part.Transparency = options.transparency end
	if options.noCollide then part.CanCollide = false end
	if options.noShadow then part.CastShadow = false end
	part.Parent = parent
	return part
end

local function offset(base, x, y, z, rx, ry, rz)
	return base * CFrame.new(x, y, z) * CFrame.Angles(rx or 0, ry or 0, rz or 0)
end

local STUDS = { studs = true }
local DETAIL = { noCollide = true }

local gate = newModel("ReturnPortalGate", container)

local platform = newModel("Platform", gate)
createPart(platform, "StoneWide", V(22, 1.6, 14), offset(PORTAL_ORIGIN, 0, 0.8, 0), Palette.Stone, M.Plastic, STUDS)
createPart(platform, "StoneDeep", V(14, 1.6, 22), offset(PORTAL_ORIGIN, 0, 0.8, 0), Palette.Stone, M.Plastic, STUDS)
for _, corner in ipairs({ { -7, -7 }, { 7, -7 }, { -7, 7 }, { 7, 7 } }) do
	createPart(platform, "StoneCorner", V(5.2, 1.6, 5.2), offset(PORTAL_ORIGIN, corner[1], 0.8, corner[2], 0, math.pi / 4, 0), Palette.StoneDark, M.Plastic, STUDS)
end
createPart(platform, "EntryStep", V(10, 0.8, 2.5), offset(PORTAL_ORIGIN, 0, 0.4, 12.25), Palette.Stone, M.Plastic, STUDS)
createPart(platform, "SnowWide", V(20, 0.5, 12), offset(PORTAL_ORIGIN, 0, 1.85, 0), Palette.Snow, M.Plastic, STUDS)
createPart(platform, "SnowDeep", V(12, 0.5, 20), offset(PORTAL_ORIGIN, 0, 1.85, 0), Palette.Snow, M.Plastic, STUDS)

local archModel = newModel("Arch", gate)
for _, side in ipairs({ -1, 1 }) do
	for index = 0, 4 do
		createPart(archModel, "PillarBlock", V(4.4, 3.4, 4.4), offset(PORTAL_ORIGIN, side * 8, 1.6 + 1.7 + index * 3.4, 0, 0, (index % 2 == 0 and 0.03 or -0.03) * side, 0),
			index % 2 == 1 and Palette.IceStoneLight or Palette.IceStoneDark, M.Plastic, STUDS)
	end
	for index = 0, 2 do
		createPart(archModel, "Rune", V(1.2, 1.2, 0.3), offset(PORTAL_ORIGIN, side * 8, 5 + index * 4.6, 2.3), Palette.Rune, M.Neon, DETAIL)
	end
end
for index = 0, 8 do
	if index ~= 4 then
		local angle = index / 8 * math.pi
		createPart(archModel, "ArchBlock", V(3.8, 3, 4.4), offset(PORTAL_ORIGIN, math.cos(angle) * 8, 18.6 + math.sin(angle) * 8, 0, 0, 0, angle - math.pi / 2),
			index % 2 == 1 and Palette.IceStoneLight or Palette.IceStoneDark, M.Plastic, STUDS)
		createPart(archModel, "ArchSnow", V(3.4, 0.7, 4.6), offset(PORTAL_ORIGIN, math.cos(angle) * 9.8, 18.6 + math.sin(angle) * 9.8, 0, 0, 0, angle - math.pi / 2),
			Palette.Snow, M.Plastic, { studs = true, noShadow = true })
	end
end
local keystoneFrame = offset(PORTAL_ORIGIN, 0, 26.8, 0)
createPart(archModel, "Keystone", V(4.6, 4.2, 5), keystoneFrame, Palette.Keystone, M.Plastic, STUDS)
createPart(archModel, "KeystoneSnow", V(5.2, 1, 5.4), offset(PORTAL_ORIGIN, 0, 29.3, 0), Palette.Snow, M.Plastic, STUDS)
local emblemFrame = keystoneFrame * CFrame.new(0, 0, 2.55)
for armIndex = 0, 5 do
	local armFrame = emblemFrame * CFrame.Angles(0, 0, armIndex * math.pi / 3)
	createPart(archModel, "EmblemArm", V(0.32, 1.6, 0.1), armFrame * CFrame.new(0, 0.8, 0), Palette.Emblem, M.Neon, DETAIL)
	for _, branch in ipairs({ -1, 1 }) do
		createPart(archModel, "EmblemBranch", V(0.26, 0.6, 0.1), armFrame * CFrame.new(branch * 0.22, 1.15, 0) * CFrame.Angles(0, 0, -branch * 0.8), Palette.Emblem, M.Neon, DETAIL)
	end
end
for _, icicle in ipairs({ { -4.5, 2.2 }, { -2, 1.4 }, { 0, 2.8 }, { 2.3, 1.6 }, { 4.6, 2.4 }, { -6.2, 1.2 }, { 6.3, 1.3 } }) do
	local x = icicle[1]
	local angle = math.acos(math.clamp(x / 6.1, -1, 1))
	local y = 18.6 + math.sin(angle) * 6.1
	createPart(archModel, "Icicle", V(0.6, icicle[2], 0.6), offset(PORTAL_ORIGIN, x, y - icicle[2] / 2, 1.6), Palette.Icicle, M.Ice, { transparency = 0.2, noCollide = true })
end

local swirlModel = newModel("Swirl", gate)
local COLUMNS, ROWS = 16, 32
local cellWidth, cellHeight = 11.6 / COLUMNS, 23 / ROWS
local SWIRL_TIME = 1.2
local function mixColor(a, b, t)
	return Color3.new(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t)
end
local function smoothstep(edge0, edge1, x)
	local t = math.clamp((x - edge0) / (edge1 - edge0), 0, 1)
	return t * t * (3 - 2 * t)
end
for column = 0, COLUMNS - 1 do
	for row = 0, ROWS - 1 do
		local qx = -5.8 + (column + 0.5) * cellWidth
		local qy = -11.5 + (row + 0.5) * cellHeight
		local inside, edge
		if qy < 5.5 then
			inside = math.abs(qx) <= 5.8
			edge = 5.8 - math.abs(qx)
		else
			local distance = math.sqrt(qx * qx + (qy - 5.5) ^ 2)
			inside = distance <= 5.8
			edge = 5.8 - distance
		end
		if inside then
			edge = math.min(edge, qy + 11.5)
			local cy = qy - 1.5
			local radius = math.sqrt(qx * qx + cy * cy) / 10
			local angle = math.atan2(cy, qx)
			local wave = math.sin(angle * 3 + radius * 13 - SWIRL_TIME * 2.4) * 0.5 + 0.5
			local ripple = math.sin(angle * 2 - radius * 19 + SWIRL_TIME * 3.6) * 0.5 + 0.5
			local color = mixColor(Palette.SwirlDeep, Palette.SwirlBright, wave)
			color = mixColor(color, Palette.SwirlWhite, (ripple ^ 6) * 0.75)
			color = mixColor(color, Palette.SwirlWhite, smoothstep(0.55, 0, radius) * 0.45)
			color = mixColor(Palette.SwirlWhite, color, smoothstep(0, 1.4, edge))
			local brightness = (color.R + color.G + color.B) / 3
			createPart(swirlModel, "SwirlCell", V(cellWidth, cellHeight, 0.2), offset(PORTAL_ORIGIN, qx, 13.1 + qy, 0), color,
				brightness > 0.82 and M.Neon or M.SmoothPlastic, { noCollide = true, noShadow = true, transparency = 0.04 })
		end
	end
end
local glowAnchor = createPart(swirlModel, "GlowSource", V(10, 1, 1), offset(PORTAL_ORIGIN, 0, 3, 0.5), Palette.Glow, M.SmoothPlastic, { transparency = 1, noCollide = true, noShadow = true })
local glow = Instance.new("PointLight")
glow.Color = Palette.Glow
glow.Brightness = 2
glow.Range = 40
glow.Parent = glowAnchor
local sparkles = Instance.new("ParticleEmitter")
sparkles.Rate = 14
sparkles.Lifetime = NumberRange.new(1.8, 2.6)
sparkles.Speed = NumberRange.new(3, 6)
sparkles.SpreadAngle = Vector2.new(15, 15)
sparkles.EmissionDirection = Enum.NormalId.Top
sparkles.LightEmission = 1
sparkles.Color = ColorSequence.new(Palette.SwirlBright, Palette.SwirlWhite)
sparkles.Size = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.35), NumberSequenceKeypoint.new(1, 0) })
sparkles.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1) })
sparkles.Parent = glowAnchor

local crystalsModel = newModel("Crystals", gate)
for _, side in ipairs({ -1, 1 }) do
	createPart(crystalsModel, "Pedestal", V(3, 6, 3), offset(PORTAL_ORIGIN, side * 14, 3, 4), Palette.Stone, M.Plastic, STUDS)
	createPart(crystalsModel, "PedestalSnow", V(3.6, 0.6, 3.6), offset(PORTAL_ORIGIN, side * 14, 6.3, 4), Palette.Snow, M.Plastic, STUDS)
	local crystal = createPart(crystalsModel, "Crystal", V(2.2, 2.2, 2.2), offset(PORTAL_ORIGIN, side * 14, 9.5, 4, math.rad(45), 0, math.rad(35)), Palette.Crystal, M.Neon, { transparency = 0.15, noCollide = true })
	local crystalLight = Instance.new("PointLight")
	crystalLight.Color = Palette.Rune
	crystalLight.Brightness = 1
	crystalLight.Range = 14
	crystalLight.Parent = crystal
end

local pathModel = newModel("ArrivalPath", gate)
for z = -2, -34, -4 do
	createPart(pathModel, "PathTile", V(6, 0.3, 3.8), offset(PLAZA_ORIGIN, 0, 0.15, z), Palette.Path, M.Plastic, STUDS)
end

local sign = newModel("Sign", gate)
local signFrame = offset(PLAZA_ORIGIN, -15, 0, -8, 0, 0.3, 0)
for _, side in ipairs({ -1, 1 }) do
	createPart(sign, "Post", V(1, 7.5, 1), offset(signFrame, side * 4.5, 3.75, 0), Palette.WoodDark, M.Wood)
end
local board = createPart(sign, "Board", V(11, 4.3, 0.8), offset(signFrame, 0, 6, 0), Palette.WoodLight, M.WoodPlanks)
createPart(sign, "SnowTop", V(11.4, 0.8, 1.2), offset(signFrame, 0, 8.5, 0), Palette.Snow, M.Plastic, STUDS)
local surface = Instance.new("SurfaceGui")
surface.Face = Enum.NormalId.Back
surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
surface.PixelsPerStud = 50
surface.Parent = board
local label = Instance.new("TextLabel")
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.Text = "VOLVER A\nLA CIMA ▲"
label.Font = Enum.Font.FredokaOne
label.TextScaled = true
label.TextColor3 = Color3.fromRGB(255, 247, 230)
label.TextStrokeColor3 = Color3.fromRGB(90, 52, 24)
label.TextStrokeTransparency = 0
label.Parent = surface

gate.PrimaryPart = platform:FindFirstChild("StoneWide")

local camera = workspace.CurrentCamera
if camera then
	camera.CFrame = CFrame.lookAt((PORTAL_ORIGIN * CFrame.new(18, 16, 46)).Position, (PORTAL_ORIGIN * CFrame.new(0, 12, 0)).Position)
end

local partCount = 0
for _, descendant in ipairs(gate:GetDescendants()) do
	if descendant:IsA("BasePart") then partCount += 1 end
end
print(("ReturnPortalGate built: %d parts at Y %.1f"):format(partCount, groundTop))
