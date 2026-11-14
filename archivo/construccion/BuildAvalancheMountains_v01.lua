local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SlingshotGeometry = require(ReplicatedStorage.Shared.SlingshotGeometry)

local FOLDER_NAME = "AvalancheMountain"
local V = Vector3.new
local M = Enum.Material
local rgb = Color3.fromRGB
local BEHIND = V(0, 0, 1)
local RIGHT = V(1, 0, 0)
local UP = V(0, 1, 0)
local SNOW = rgb(240, 246, 252)
local SNOW_SHADE = rgb(214, 228, 242)
local ROCK = rgb(110, 118, 132)
local ROCK_DARK = rgb(78, 84, 98)
local CRACK = rgb(44, 58, 86)
local WOOD = rgb(120, 78, 46)
local MOUNTAIN_WIDTH = 260
local SLOPE_RISE = 190
local SLOPE_RUN = 180
local FOOT_DROP = 40
local random = Random.new(404)

local function part(parent, name, size, cframe, color, options)
	options = options or {}
	local p = Instance.new(options.className or "Part")
	p.Name = name
	p.Anchored = true
	if options.shape then p.Shape = options.shape end
	p.Size = size
	p.CFrame = cframe
	p.Color = color
	p.Material = options.material or M.Snow
	p.TopSurface = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	if options.transparency then p.Transparency = options.transparency end
	if options.ghost then
		p.CanCollide = false
		p.CanQuery = false
		p.CanTouch = false
		p.CastShadow = false
	end
	p.Parent = parent
	return p
end

local function marker(parent, name, cframe)
	return part(parent, name, V(1, 1, 1), cframe, SNOW, { transparency = 1, ghost = true })
end

local function groundBelow(position, ignore)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = ignore
	params.RespectCanCollide = true
	local hit = workspace:Raycast(position + V(0, 30, 0), V(0, -80, 0), params)
	return hit and hit.Position.Y or nil
end

local function plateauEdge(origin, groundY, ignore)
	local distance = 0
	while distance < 320 do
		distance += 5
		local y = groundBelow(origin + BEHIND * distance, ignore)
		if not y or y < groundY - 12 then
			return distance - 5
		end
	end
	return distance
end

local function frameAt(origin, behindDistance, rightOffset, height)
	return origin + BEHIND * behindDistance + RIGHT * rightOffset + UP * height
end

local function buildPine(parent, position, scale)
	local pine = Instance.new("Model")
	pine.Name = "MountainPine"
	pine.Parent = parent
	part(pine, "Trunk", V(1.6, 7, 1.6) * scale, CFrame.new(position + UP * 3.5 * scale), WOOD, { material = M.Wood })
	for tier = 0, 2 do
		local width = (9 - tier * 2.6) * scale
		part(pine, "Canopy", V(width, 5 * scale, width), CFrame.new(position + UP * (8 + tier * 4.2) * scale) * CFrame.Angles(0, tier * 0.7, 0), tier % 2 == 0 and rgb(38, 96, 66) or rgb(46, 112, 76), { material = M.Grass })
		part(pine, "CanopySnow", V(width * 0.85, 0.7 * scale, width * 0.85), CFrame.new(position + UP * (10.7 + tier * 4.2) * scale) * CFrame.Angles(0, tier * 0.7, 0), SNOW, {})
	end
end

local function buildMountain(levelRoot, slingshot)
	local existing = levelRoot:FindFirstChild(FOLDER_NAME)
	if existing then existing:Destroy() end
	local origin = slingshot:GetPivot().Position
	local groundY = groundBelow(origin, { slingshot }) or (origin.Y - 13)
	local ground = V(origin.X, groundY, origin.Z)
	local edge = plateauEdge(ground, groundY, { slingshot })

	local root = Instance.new("Folder")
	root.Name = FOLDER_NAME
	root:SetAttribute("PlateauEdge", edge)
	root.Parent = levelRoot

	local footDistance = edge + 16
	local topDistance = footDistance + SLOPE_RUN
	local slopeCenter = frameAt(ground, (footDistance + topDistance) / 2, 0, (SLOPE_RISE - FOOT_DROP) / 2)
	local facePlateau = CFrame.lookAt(slopeCenter, slopeCenter - BEHIND)
	part(root, "Slope", V(MOUNTAIN_WIDTH, SLOPE_RISE + FOOT_DROP, SLOPE_RUN), facePlateau, SNOW, { className = "WedgePart" })
	local summitCenter = frameAt(ground, topDistance + 45, 0, (SLOPE_RISE - FOOT_DROP) / 2)
	part(root, "Massif", V(MOUNTAIN_WIDTH, SLOPE_RISE + FOOT_DROP, 90), CFrame.lookAt(summitCenter, summitCenter - BEHIND), SNOW_SHADE, {})
	for _, side in ipairs({ -1, 1 }) do
		local flankCenter = frameAt(ground, (footDistance + topDistance) / 2 + 20, side * (MOUNTAIN_WIDTH / 2 + 40), (SLOPE_RISE - FOOT_DROP) / 2 - FOOT_DROP / 2 - 30)
		part(root, "Flank", V(80, SLOPE_RISE - 20, SLOPE_RUN + 60), CFrame.lookAt(flankCenter, flankCenter - RIGHT * side), SNOW_SHADE, { className = "WedgePart" })
	end
	for index = 0, 2 do
		local peakHeight = 70 - index * 18
		local peakCenter = frameAt(ground, topDistance + 40, (index - 1) * 80, SLOPE_RISE + peakHeight / 2 - 4)
		local width = 90 - index * 10
		part(root, "PeakFront", V(width, peakHeight, 40), CFrame.lookAt(peakCenter - BEHIND * 20, peakCenter - BEHIND * 60), SNOW, { className = "WedgePart" })
		part(root, "PeakBack", V(width, peakHeight, 40), CFrame.lookAt(peakCenter + BEHIND * 20, peakCenter + BEHIND * 60), SNOW_SHADE, { className = "WedgePart" })
	end
	for index = 1, 16 do
		local along = random:NextNumber(0.15, 0.95)
		local lateral = random:NextNumber(-0.48, 0.48) * MOUNTAIN_WIDTH
		local height = -FOOT_DROP + (SLOPE_RISE + FOOT_DROP) * along
		local size = random:NextNumber(10, 26)
		local rockFrame = CFrame.new(frameAt(ground, footDistance + SLOPE_RUN * along - 6, lateral, height)) * CFrame.Angles(random:NextNumber(0, 6), random:NextNumber(0, 6), random:NextNumber(0, 6))
		part(root, "Rock", V(size, size * 0.7, size * 0.9), rockFrame, index % 3 == 0 and ROCK_DARK or ROCK, { material = M.Slate })
	end
	for index = 1, 14 do
		local side = index % 2 == 0 and -1 or 1
		local along = random:NextNumber(0.05, 0.45)
		local lateral = side * random:NextNumber(0.3, 0.5) * MOUNTAIN_WIDTH
		local height = -FOOT_DROP + (SLOPE_RISE + FOOT_DROP) * along
		buildPine(root, frameAt(ground, footDistance + SLOPE_RUN * along - 4, lateral, height), random:NextNumber(1.2, 1.9))
	end

	local cornice = Instance.new("Model")
	cornice.Name = "Cornice"
	cornice.Parent = root
	local lipHeight = SLOPE_RISE - 6
	for index = 0, 9 do
		local lateral = (index - 4.5) * 24
		local chunkFrame = CFrame.lookAt(frameAt(ground, topDistance - 8, lateral, lipHeight + 6), frameAt(ground, topDistance - 40, lateral, lipHeight + 2)) * CFrame.Angles(math.rad(random:NextNumber(-8, 4)), 0, math.rad(random:NextNumber(-4, 4)))
		local chunk = part(cornice, "Chunk", V(23, 14 + random:NextNumber(0, 6), 26), chunkFrame, index % 2 == 0 and SNOW or SNOW_SHADE, {})
		chunk:SetAttribute("ChunkIndex", index)
		part(cornice, "Crack", V(0.6, 10, 22), chunkFrame * CFrame.new(11.8, 0, 2), CRACK, { material = M.Slate, ghost = true })
		part(cornice, "Overhang", V(22, 4, 10), chunkFrame * CFrame.new(0, -5, -16) * CFrame.Angles(math.rad(-25), 0, 0), SNOW, { ghost = true })
	end
	part(cornice, "CrackLine", V(MOUNTAIN_WIDTH - 20, 0.8, 1.4), CFrame.new(frameAt(ground, topDistance + 8, 0, lipHeight + 0.6)), CRACK, { material = M.Slate, ghost = true })

	marker(root, "WaveStart", CFrame.lookAt(frameAt(ground, topDistance - 20, 0, lipHeight), frameAt(ground, edge, 0, 0)))
	marker(root, "WaveEnd", CFrame.lookAt(frameAt(ground, edge + 4, 0, 6), frameAt(ground, 0, 0, 6)))
	marker(root, "ShotCamera", CFrame.lookAt(frameAt(ground, edge - 40, 50, 16), frameAt(ground, topDistance, 0, lipHeight - 20)))

	local towerBase = frameAt(ground, math.max(edge - 16, 20), -34, 0)
	local towerGround = groundBelow(towerBase, { slingshot })
	if towerGround and math.abs(towerGround - groundY) < 4 then
		local tower = Instance.new("Model")
		tower.Name = "WatchTower"
		tower.Parent = root
		local base = CFrame.lookAt(V(towerBase.X, towerGround, towerBase.Z), V(origin.X, towerGround, origin.Z))
		for _, corner in ipairs({ { -3.5, -3.5 }, { -3.5, 3.5 }, { 3.5, -3.5 }, { 3.5, 3.5 } }) do
			part(tower, "Post", V(1, 16, 1), base * CFrame.new(corner[1], 8, corner[2]), WOOD, { material = M.Wood })
		end
		part(tower, "Platform", V(10, 1, 10), base * CFrame.new(0, 16, 0), WOOD, { material = M.WoodPlanks })
		for _, rail in ipairs({ { 0, -5, 10, 1 }, { 0, 5, 10, 1 }, { -5, 0, 1, 10 }, { 5, 0, 1, 10 } }) do
			part(tower, "Rail", V(rail[3], 2.4, rail[4]), base * CFrame.new(rail[1], 17.7, rail[2]), WOOD, { material = M.Wood })
		end
		part(tower, "Roof", V(12, 2, 12), base * CFrame.new(0, 24, 0), rgb(196, 44, 40), { material = M.SmoothPlastic })
		part(tower, "RoofSnow", V(12.6, 0.8, 12.6), base * CFrame.new(0, 25.3, 0), SNOW, {})
		for _, corner in ipairs({ { -4.5, -4.5 }, { -4.5, 4.5 }, { 4.5, -4.5 }, { 4.5, 4.5 } }) do
			part(tower, "RoofPost", V(0.6, 6, 0.6), base * CFrame.new(corner[1], 20, corner[2]), WOOD, { material = M.Wood })
		end
		local siren = part(tower, "Siren", V(2.4, 2.4, 2.4), base * CFrame.new(0, 27.2, 0), rgb(255, 120, 30), { material = M.Neon, shape = Enum.PartType.Ball, ghost = true })
		local light = Instance.new("PointLight")
		light.Color = rgb(255, 140, 50)
		light.Brightness = 2
		light.Range = 30
		light.Parent = siren
		CollectionService:AddTag(siren, "AvalancheSiren")
		local board = part(tower, "WarningSign", V(9, 4.4, 0.4), base * CFrame.new(0, 9, -4.2), rgb(255, 196, 0), { material = M.SmoothPlastic })
		local gui = Instance.new("SurfaceGui")
		gui.Face = Enum.NormalId.Front
		gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
		gui.PixelsPerStud = 30
		gui.LightInfluence = 0
		gui.Parent = board
		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Size = UDim2.fromScale(0.94, 0.9)
		label.Position = UDim2.fromScale(0.03, 0.05)
		label.Font = Enum.Font.FredokaOne
		label.TextScaled = true
		label.TextColor3 = rgb(30, 30, 40)
		label.Text = "⚠️ PELIGRO\nDE AVALANCHA"
		label.Parent = gui
		local template
		for _, candidate in ipairs(CollectionService:GetTagged("CheeringPenguin")) do
			if candidate:IsA("Model") and candidate:IsDescendantOf(workspace) then
				template = candidate
				break
			end
		end
		if template then
			local lookout = template:Clone()
			lookout.Name = "Lookout"
			lookout:SetAttribute("CheerMode", "wave")
			lookout:SetAttribute("Cheers", true)
			lookout.Parent = tower
			local spot = base * CFrame.new(0, 16.5, 0)
			lookout:PivotTo(CFrame.lookAt(spot.Position + UP * 2.3, frameAt(ground, topDistance, 0, lipHeight)))
		end
	end

	CollectionService:AddTag(root, "AvalancheMountain")
	local count = 0
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:IsA("BasePart") then count += 1 end
	end
	return edge, count
end

for _, levelRoot in ipairs(workspace:GetChildren()) do
	local levelId = levelRoot:GetAttribute("LevelId")
	if levelId == 1 then
		local slingshot = SlingshotGeometry.find(levelId)
		if slingshot then
			local edge, count = buildMountain(levelRoot, slingshot)
			print(("Avalanche mountain level %d: edge %d, %d parts"):format(levelId, edge, count))
		else
			warn("No slingshot for level " .. levelId)
		end
	end
end
