local container = workspace:FindFirstChild("PenguinSlingshotMap_v01") or workspace
for _, name in ipairs({ "Slingshot", "SlingshotDecor", "SlingshotPenguin", "WaitingPenguins" }) do
	local old = container:FindFirstChild(name)
	if old then old:Destroy() end
end

local ORIGIN = CFrame.new(0, 600, 20)
local V = Vector3.new
local M = Enum.Material

local Palette = {
	Snow = Color3.fromRGB(243, 248, 253),
	Stone = Color3.fromRGB(141, 150, 161),
	StoneDark = Color3.fromRGB(111, 120, 132),
	Wood = Color3.fromRGB(160, 108, 66),
	WoodDark = Color3.fromRGB(107, 66, 40),
	WoodLight = Color3.fromRGB(192, 138, 88),
	PlankA = Color3.fromRGB(143, 92, 56),
	PlankB = Color3.fromRGB(125, 79, 49),
	Rope = Color3.fromRGB(220, 188, 132),
	Metal = Color3.fromRGB(77, 83, 92),
	Bolt = Color3.fromRGB(184, 190, 198),
	Band = Color3.fromRGB(227, 52, 47),
	BandShade = Color3.fromRGB(187, 39, 34),
	Leather = Color3.fromRGB(91, 58, 36),
	Stitch = Color3.fromRGB(217, 176, 122),
	Ice = Color3.fromRGB(191, 233, 255),
	PenguinBlack = Color3.fromRGB(30, 40, 51),
	White = Color3.fromRGB(255, 255, 255),
	Pupil = Color3.fromRGB(11, 15, 20),
	Orange = Color3.fromRGB(243, 156, 31),
	Pink = Color3.fromRGB(255, 158, 176),
	Scarf = Color3.fromRGB(216, 48, 42),
	Flag = Color3.fromRGB(226, 35, 26),
	LanternGlow = Color3.fromRGB(255, 226, 160),
}

local function newModel(name, parent)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = parent
	return model
end

local function createPart(parent, name, size, cframe, color, material, options)
	options = options or {}
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	if options.shape then part.Shape = options.shape end
	part.Size = size
	part.CFrame = cframe
	part.Color = color
	part.Material = material or M.Plastic
	part.TopSurface = options.studs and Enum.SurfaceType.Studs or Enum.SurfaceType.Smooth
	part.BottomSurface = options.studs and Enum.SurfaceType.Inlet or Enum.SurfaceType.Smooth
	if options.transparency then part.Transparency = options.transparency end
	if options.noCollide then part.CanCollide = false end
	part.Parent = parent
	return part
end

local function offset(base, x, y, z, rx, ry, rz)
	return base * CFrame.new(x, y, z) * CFrame.Angles(rx or 0, ry or 0, rz or 0)
end

local STUDS = { studs = true }
local DETAIL = { noCollide = true }

local slingshot = newModel("Slingshot", container)

local platform = newModel("Platform", slingshot)
createPart(platform, "StoneWide", V(24, 4, 16), offset(ORIGIN, 0, 2, 0), Palette.Stone, M.Plastic, STUDS)
createPart(platform, "StoneDeep", V(16, 4, 24), offset(ORIGIN, 0, 2, 0), Palette.Stone, M.Plastic, STUDS)
for _, corner in ipairs({ { -8, -8 }, { 8, -8 }, { -8, 8 }, { 8, 8 } }) do
	createPart(platform, "StoneCorner", V(5.6, 4, 5.6), offset(ORIGIN, corner[1], 2, corner[2], 0, math.pi / 4, 0), Palette.StoneDark, M.Plastic, STUDS)
end
createPart(platform, "SnowWide", V(22, 0.8, 14), offset(ORIGIN, 0, 4.4, 0), Palette.Snow, M.Plastic, STUDS)
createPart(platform, "SnowDeep", V(14, 0.8, 22), offset(ORIGIN, 0, 4.4, 0), Palette.Snow, M.Plastic, STUDS)
for index = 0, 3 do
	createPart(platform, "Plank", V(4, 1, 16), offset(ORIGIN, -6 + index * 4, 5.2, 0), index % 2 == 1 and Palette.PlankA or Palette.PlankB, M.Plastic, STUDS)
end
for index = 0, 2 do
	createPart(platform, "Step", V(10, 1.4, 3), offset(ORIGIN, 0, 0.7 + index * 1.4, 13.5 + (2 - index) * 3 - 3), Palette.Stone, M.Plastic, STUDS)
end

local frame = newModel("Frame", slingshot)
createPart(frame, "Collar", V(9, 2, 9), offset(ORIGIN, 0, 6.7, 0), Palette.WoodDark, M.Plastic, STUDS)
local trunk = createPart(frame, "Trunk", V(6, 13, 6), offset(ORIGIN, 0, 13.5, 0), Palette.Wood, M.Wood)
for _, height in ipairs({ 10, 17 }) do
	createPart(frame, "RopeWrap", V(6.6, 1.3, 6.6), offset(ORIGIN, 0, height, 0), Palette.Rope, M.Fabric)
end
createPart(frame, "Yoke", V(12, 5, 7), offset(ORIGIN, 0, 22.5, 0), Palette.WoodDark, M.Plastic, STUDS)
createPart(frame, "MetalPlate", V(8, 3, 0.4), offset(ORIGIN, 0, 22.5, -3.7), Palette.Metal, M.Metal, DETAIL)
for _, bolt in ipairs({ { -3.2, 23.6 }, { 3.2, 23.6 }, { -3.2, 21.4 }, { 3.2, 21.4 } }) do
	createPart(frame, "Bolt", V(0.4, 0.84, 0.84), offset(ORIGIN, bolt[1], bolt[2], -3.95, 0, math.pi / 2, 0), Palette.Bolt, M.Metal, { shape = Enum.PartType.Cylinder, noCollide = true })
end

local anchors = {}
for _, side in ipairs({ -1, 1 }) do
	local arm = newModel(side < 0 and "LeftArm" or "RightArm", frame)
	local armFrame = offset(ORIGIN, side * 4, 24.5, 0, 0, 0, -side * 0.32)
	createPart(arm, "Arm", V(5, 16, 5), offset(armFrame, 0, 8, 0), Palette.Wood, M.Wood)
	createPart(arm, "RopeWrapTop", V(5.6, 1.2, 5.6), offset(armFrame, 0, 12.5, 0), Palette.Rope, M.Fabric)
	createPart(arm, "RopeWrapBottom", V(5.6, 1.2, 5.6), offset(armFrame, 0, 4, 0), Palette.Rope, M.Fabric)
	createPart(arm, "MetalRing", V(5.4, 1.2, 5.4), offset(armFrame, 0, 15.8, 0), Palette.Metal, M.Metal)
	createPart(arm, "SnowCap", V(6.2, 1.6, 6.2), offset(armFrame, 0, 17.2, 0), Palette.Snow, M.Plastic, STUDS)
	createPart(arm, "SnowLump", V(3.2, 1.2, 3.2), offset(armFrame, side * 0.6, 18.4, 0.4), Palette.Snow, M.Plastic, STUDS)
	for index, icicle in ipairs({ { -1.8, 2.2 }, { 0, 1.4 }, { 1.6, 2.8 }, { -0.6, 1 } }) do
		createPart(arm, "Icicle", V(0.7, icicle[2], 0.7), offset(armFrame, icicle[1], 16.4 - icicle[2] / 2, -2.9 + ((index - 1) % 2) * 0.2), Palette.Ice, M.Ice, { transparency = 0.15, noCollide = true })
	end
	table.insert(anchors, (armFrame * CFrame.new(side < 0 and 2.6 or -2.6, 12.5, 0)).Position)
end

local restPoint = (anchors[1] + anchors[2]) / 2
local launchDirection = V(0, math.sin(math.rad(25)), -math.cos(math.rad(25)))
local pouchFrame = CFrame.lookAt(restPoint, restPoint + launchDirection)

local band = newModel("Band", slingshot)
createPart(band, "Pouch", V(4, 0.8, 3.2), pouchFrame, Palette.Leather, M.Fabric, DETAIL)
for _, side in ipairs({ -1, 1 }) do
	createPart(band, "PouchFlap", V(1.6, 0.8, 3.2), offset(pouchFrame, side * 2.6, 0.45, 0, 0, 0, side * 0.45), Palette.Leather, M.Fabric, DETAIL)
end
for _, z in ipairs({ -1.1, 1.1 }) do
	createPart(band, "Stitch", V(3.6, 0.1, 0.18), offset(pouchFrame, 0, 0.45, z), Palette.Stitch, M.Fabric, DETAIL)
end
local pouchEnds = { (pouchFrame * CFrame.new(-3.3, 0.7, 0)).Position, (pouchFrame * CFrame.new(3.3, 0.7, 0)).Position }
if (pouchEnds[1] - anchors[1]).Magnitude > (pouchEnds[1] - anchors[2]).Magnitude then
	pouchEnds[1], pouchEnds[2] = pouchEnds[2], pouchEnds[1]
end
local function createStrand(name, startPoint, endPoint, color)
	local length = (endPoint - startPoint).Magnitude
	createPart(band, name, V(0.75, 0.75, length), CFrame.lookAt((startPoint + endPoint) / 2, endPoint), color, M.SmoothPlastic, DETAIL)
end
for index = 1, 2 do
	createStrand("BandStrandUpper", anchors[index] + V(0, 0.45, 0), pouchEnds[index] + V(0, 0.4, 0), Palette.Band)
	createStrand("BandStrandLower", anchors[index] + V(0, -0.45, 0), pouchEnds[index] + V(0, -0.2, 0), Palette.BandShade)
end
slingshot.PrimaryPart = trunk

local decor = newModel("SlingshotDecor", container)
local function createCrate(x, y, z, rotation)
	local crate = newModel("Crate", decor)
	local crateFrame = offset(ORIGIN, x, y, z, 0, rotation, 0)
	createPart(crate, "Box", V(5, 5, 5), crateFrame, Palette.WoodLight, M.Plastic, STUDS)
	for _, sx in ipairs({ -1, 1 }) do
		for _, sz in ipairs({ -1, 1 }) do
			createPart(crate, "Edge", V(0.6, 5.2, 0.6), offset(crateFrame, sx * 2.3, 0, sz * 2.3), Palette.WoodDark, M.Wood, DETAIL)
		end
	end
	createPart(crate, "Brace", V(5.2, 0.6, 0.6), offset(crateFrame, 0, 0, -2.55, 0, 0, 0.78), Palette.WoodDark, M.Wood, DETAIL)
end
createCrate(16, 2.5, 6, 0)
createCrate(21.5, 2.5, 7, 0.2)
createCrate(18.5, 7.5, 6.5, 0.5)
for index = 0, 5 do
	local upper = index > 2
	createPart(decor, "Snowball", V(2.2, 2.2, 2.2), offset(ORIGIN, 14 + (index % 3) * 2.1, 1.1 + (upper and 1.7 or 0), 12 + (upper and 0.8 or 0) + ((index % 3) == 0 and 0.4 or 0)), Palette.Snow, M.Snow, { shape = Enum.PartType.Ball })
end

local lamp = newModel("Lantern", decor)
createPart(lamp, "Post", V(1.2, 12, 1.2), offset(ORIGIN, -15, 6, 6), Palette.Metal, M.Metal)
createPart(lamp, "Hook", V(4, 0.6, 1), offset(ORIGIN, -14, 11.8, 6), Palette.Metal, M.Metal, DETAIL)
createPart(lamp, "Cap", V(2.4, 0.5, 2.4), offset(ORIGIN, -12.6, 11.2, 6), Palette.Metal, M.Metal, DETAIL)
createPart(lamp, "Base", V(2.4, 0.4, 2.4), offset(ORIGIN, -12.6, 8.1, 6), Palette.Metal, M.Metal, DETAIL)
local glass = createPart(lamp, "Glass", V(1.8, 2.6, 1.8), offset(ORIGIN, -12.6, 9.6, 6), Palette.LanternGlow, M.Neon, DETAIL)
local light = Instance.new("PointLight")
light.Color = Color3.fromRGB(255, 192, 102)
light.Brightness = 1.5
light.Range = 30
light.Parent = glass

local flag = newModel("Flag", decor)
createPart(flag, "Pole", V(0.8, 22, 0.8), offset(ORIGIN, 15, 11, -8), Palette.WoodDark, M.Wood)
local clothFrame = offset(ORIGIN, 15.4, 19.8, -8)
for index, angle in ipairs({ 0.2, -0.25, 0.25, -0.2, 0.15 }) do
	local segmentFrame = clothFrame * CFrame.Angles(0, angle, 0) * CFrame.new(0.7, 0, 0)
	createPart(flag, "Cloth", V(1.4, 3.6, 0.25), segmentFrame, index % 2 == 0 and Palette.White or Palette.Flag, M.Fabric, DETAIL)
	clothFrame = segmentFrame * CFrame.new(0.7, 0, 0)
end

local sign = newModel("Sign", decor)
local signFrame = offset(ORIGIN, -16, 0, -6, 0, 0.35, 0)
for _, side in ipairs({ -1, 1 }) do
	createPart(sign, "Post", V(1, 8, 1), offset(signFrame, side * 4.5, 4, 0), Palette.WoodDark, M.Wood)
end
local board = createPart(sign, "Board", V(11, 4.3, 0.8), offset(signFrame, 0, 6.4, 0), Palette.WoodLight, M.WoodPlanks)
createPart(sign, "SnowTop", V(11.4, 0.8, 1.2), offset(signFrame, 0, 8.9, 0), Palette.Snow, M.Plastic, STUDS)
local surface = Instance.new("SurfaceGui")
surface.Face = Enum.NormalId.Back
surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
surface.PixelsPerStud = 50
surface.Parent = board
local label = Instance.new("TextLabel")
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.Text = "¡LANZA AL\nPINGÜINO!"
label.Font = Enum.Font.FredokaOne
label.TextScaled = true
label.TextColor3 = Color3.fromRGB(255, 247, 230)
label.TextStrokeColor3 = Color3.fromRGB(90, 52, 24)
label.TextStrokeTransparency = 0
label.Parent = surface

for index, drift in ipairs({ { -12, -12, 8, 0.3 }, { 12, 13, 6, 1.1 }, { -11, 14, 7, 2 }, { 13, -14, 6, 0.7 } }) do
	createPart(decor, "SnowDrift", V(drift[3], 1.6, drift[3] * 0.7), offset(ORIGIN, drift[1], 0.4, drift[2], 0, drift[4], 0), Palette.Snow, M.Plastic, STUDS)
end

local function buildPenguin(parent, name, baseFrame)
	local penguin = newModel(name, parent)
	local body = createPart(penguin, "Body", V(3, 3, 2.8), offset(baseFrame, 0, -0.5, 0), Palette.PenguinBlack, M.Plastic)
	createPart(penguin, "Head", V(2.7, 1.9, 2.6), offset(baseFrame, 0, 1.95, 0), Palette.PenguinBlack, M.Plastic, STUDS)
	createPart(penguin, "Belly", V(2.2, 2.5, 0.2), offset(baseFrame, 0, -0.6, -1.45), Palette.White, M.Plastic, DETAIL)
	createPart(penguin, "Face", V(2.2, 1.2, 0.16), offset(baseFrame, 0, 2.05, -1.35), Palette.White, M.Plastic, DETAIL)
	for _, side in ipairs({ -1, 1 }) do
		createPart(penguin, "EyeWhite", V(0.62, 0.72, 0.12), offset(baseFrame, side * 0.58, 2.15, -1.46), Palette.White, M.SmoothPlastic, DETAIL)
		createPart(penguin, "Pupil", V(0.36, 0.46, 0.1), offset(baseFrame, side * 0.55, 2.08, -1.53), Palette.Pupil, M.SmoothPlastic, DETAIL)
		createPart(penguin, "EyeShine", V(0.13, 0.13, 0.06), offset(baseFrame, side * 0.47, 2.22, -1.59), Palette.White, M.SmoothPlastic, DETAIL)
		createPart(penguin, "Cheek", V(0.45, 0.28, 0.08), offset(baseFrame, side * 1, 1.62, -1.45), Palette.Pink, M.SmoothPlastic, DETAIL)
		createPart(penguin, "Flipper", V(0.4, 2.2, 1.5), offset(baseFrame, side * 1.7, -0.4, 0, 0, 0, side * 0.18), Palette.PenguinBlack, M.Plastic, DETAIL)
		createPart(penguin, "Foot", V(1, 0.35, 1.4), offset(baseFrame, side * 0.75, -2.15, -0.35), Palette.Orange, M.Plastic, DETAIL)
	end
	createPart(penguin, "Beak", V(0.9, 0.42, 0.95), offset(baseFrame, 0, 1.62, -1.75), Palette.Orange, M.Plastic, DETAIL)
	createPart(penguin, "Scarf", V(3.1, 0.65, 2.9), offset(baseFrame, 0, 1.05, 0), Palette.Scarf, M.Fabric, DETAIL)
	createPart(penguin, "ScarfTail", V(0.75, 1.7, 0.3), offset(baseFrame, 0.9, 0.3, -1.55), Palette.Scarf, M.Fabric, DETAIL)
	createPart(penguin, "Beanie", V(2.8, 0.7, 2.7), offset(baseFrame, 0, 3.15, 0), Palette.Scarf, M.Fabric, DETAIL)
	createPart(penguin, "Pompom", V(0.9, 0.9, 0.9), offset(baseFrame, 0, 3.8, 0), Palette.White, M.Fabric, DETAIL)
	penguin.PrimaryPart = body
	return penguin
end

buildPenguin(container, "SlingshotPenguin", CFrame.new(restPoint + V(0, 2.6, -0.6)))
local waitingLine = Instance.new("Folder")
waitingLine.Name = "WaitingPenguins"
waitingLine.Parent = container
for index = 0, 2 do
	local x = index % 2 == 1 and -1.5 or 1.5
	buildPenguin(waitingLine, "WaitingPenguin", CFrame.new(x, 602.15, 20 + 26 + index * 6) * CFrame.Angles(0, (index - 1) * 0.2, 0))
end

local camera = workspace.CurrentCamera
if camera then
	camera.CFrame = CFrame.lookAt(V(45, 640, 85), V(0, 618, 18))
end

local scriptCount = 0
for _, descendant in ipairs(container:GetDescendants()) do
	if descendant:IsA("LuaSourceContainer") then scriptCount += 1 end
end
print(("Slingshot v0.2 built at %s · scripts inside map: %d"):format(tostring(restPoint), scriptCount))
