local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local StarterGui = game:GetService("StarterGui")
local StarterPack = game:GetService("StarterPack")
local StarterPlayer = game:GetService("StarterPlayer")

local LEVEL_ATTRIBUTE = "LevelId"
local INLINE_KEY_LIMIT = 2
local CHECKSUM_SEED = 7
local LINE_HASH_MODULUS = 16777216
local LISTED_CHILD_LIMIT = 6
local SECTION_ORDER = { "huella", "scripts", "etiquetas", "niveles", "mundo", "valores" }
local SUMMARIZED_PREFIXES = { "ServerStorage.Packages.", "ServerStorage.DevTools." }
local ANCHOR_TAGS = { "PlateauSpawn", "Slingshot", "LandingZone", "FinishLine", "ReturnPortal", "BoostRamp", "LobbyWheel", "LobbyLeaderboard" }
local TRACKED_SERVICES = { "DataStoreService", "MemoryStoreService", "MarketplaceService", "MessagingService", "TeleportService", "HttpService", "BadgeService", "ProximityPromptService", "HapticService", "SocialService" }
local SCRIPT_ROOTS = { ReplicatedStorage, ReplicatedFirst, ServerScriptService, ServerStorage, StarterGui, StarterPlayer, StarterPack, workspace }
local VALUE_MODULE_PATHS = {
	"ReplicatedStorage.Shared.GameConfig",
	"ReplicatedStorage.Shared.EconomyConfig",
	"StarterPlayer.StarterPlayerScripts.Client.Audio.SoundCatalog",
}
local TAG_PATTERNS = {
	'GetTagged%(%s*"([^"]+)"',
	'AddedSignal%(%s*"([^"]+)"',
	'RemovedSignal%(%s*"([^"]+)"',
	'TAG%s*=%s*"([^"]+)"',
	'Tag%s*=%s*"([^"]+)"',
	'AddTag%([^,]+,%s*"([^"]+)"',
	'HasTag%([^,]+,%s*"([^"]+)"',
}
local ATTRIBUTE_PATTERNS = {
	'[GS]etAttribute%(%s*"([^"]+)"',
	'AttributeChangedSignal%(%s*"([^"]+)"',
	'ATTRIBUTE%s*=%s*"([^"]+)"',
}

local function sortedKeys(set)
	local keys = {}
	for key in set do
		table.insert(keys, key)
	end
	table.sort(keys, function(a, b)
		return tostring(a) < tostring(b)
	end)
	return keys
end

local function joinKeys(set, limit)
	local keys = sortedKeys(set)
	if limit and #keys > limit then
		local hidden = #keys - limit
		keys = table.move(keys, 1, limit, 1, {})
		table.insert(keys, "+" .. hidden)
	end
	return table.concat(keys, ",")
end

local function collectMatches(source, pattern, into)
	for found in source:gmatch(pattern) do
		into[found] = true
	end
end

local function checksum(text, seed)
	local hash = seed
	for index = 1, #text do
		hash = (hash * 31 + string.byte(text, index)) % 4294967296
	end
	return hash
end

local function showNumber(value)
	if value == math.floor(value) and math.abs(value) < 1e15 then
		return ("%d"):format(value)
	end
	return ("%.4g"):format(value)
end

local function show(value)
	local kind = typeof(value)
	if kind == "number" then
		return showNumber(value)
	elseif kind == "Vector3" then
		return ("(%s,%s,%s)"):format(showNumber(value.X), showNumber(value.Y), showNumber(value.Z))
	elseif kind == "Color3" then
		return "#" .. value:ToHex()
	elseif kind == "CFrame" then
		return show(value.Position)
	end
	return tostring(value)
end

local function showRounded(vector)
	return ("(%d,%d,%d)"):format(math.round(vector.X), math.round(vector.Y), math.round(vector.Z))
end

local function levelLabel(instance)
	local current = instance
	while current do
		local levelId = current:GetAttribute(LEVEL_ATTRIBUTE)
		if typeof(levelId) == "number" then
			return "N" .. showNumber(levelId)
		end
		current = current.Parent
	end
	return "fuera"
end

local function positionOf(instance)
	if instance:IsA("BasePart") then
		return instance.Position
	elseif instance:IsA("Model") then
		return instance:GetPivot().Position
	end
	local part = instance:FindFirstChildWhichIsA("BasePart", true)
	return part and part.Position
end

local function relativeName(instance, root)
	local names = {}
	local current = instance
	while current and current ~= root do
		table.insert(names, 1, current.Name)
		current = current.Parent
	end
	return table.concat(names, ".")
end

local function attributeList(instance)
	local pairsText = {}
	for name, value in instance:GetAttributes() do
		table.insert(pairsText, name .. "=" .. show(value))
	end
	table.sort(pairsText)
	return table.concat(pairsText, ",")
end

local function findByPath(path)
	local current = game
	for name in path:gmatch("[^%.]+") do
		current = current and current:FindFirstChild(name)
	end
	return current
end

local function isSummarized(fullName)
	for _, prefix in SUMMARIZED_PREFIXES do
		if fullName:find(prefix, 1, true) then
			return true
		end
	end
	return false
end

local function gatherScripts()
	local gathered = {}
	for _, root in SCRIPT_ROOTS do
		for _, descendant in root:GetDescendants() do
			if descendant:IsA("LuaSourceContainer") then
				local source = descendant.Source
				table.insert(gathered, {
					container = descendant,
					fullName = descendant:GetFullName(),
					source = source,
					lines = select(2, source:gsub("\n", "\n")) + 1,
				})
			end
		end
	end
	table.sort(gathered, function(a, b)
		return a.fullName < b.fullName
	end)
	return gathered
end

local function buildContext()
	local scripts = gatherScripts()
	local codeHash, totalLines = 7, 0
	local tagSet, attributeSet = {}, {}
	for index, entry in scripts do
		codeHash = checksum(entry.fullName .. entry.source, codeHash)
		totalLines += entry.lines
		if not isSummarized(entry.fullName) then
			for _, pattern in TAG_PATTERNS do
				collectMatches(entry.source, pattern, tagSet)
			end
			for _, pattern in ATTRIBUTE_PATTERNS do
				collectMatches(entry.source, pattern, attributeSet)
			end
		end
		if index % 20 == 0 then
			task.wait()
		end
	end
	local worldTagCounts = {}
	for _, tag in CollectionService:GetAllTags() do
		local count = 0
		for _, instance in CollectionService:GetTagged(tag) do
			if instance:IsDescendantOf(workspace) then
				count += 1
			end
		end
		if count > 0 then
			tagSet[tag] = true
			worldTagCounts[tag] = count
		end
	end
	local workspaceDescendants = workspace:GetDescendants()
	for index, descendant in workspaceDescendants do
		for name in descendant:GetAttributes() do
			attributeSet[name] = true
		end
		if index % 8000 == 0 then
			task.wait()
		end
	end
	local levels = {}
	for _, child in workspace:GetChildren() do
		if typeof(child:GetAttribute(LEVEL_ATTRIBUTE)) == "number" then
			table.insert(levels, child)
		end
	end
	table.sort(levels, function(a, b)
		return a:GetAttribute(LEVEL_ATTRIBUTE) < b:GetAttribute(LEVEL_ATTRIBUTE)
	end)
	local worldHash = 11
	for _, level in levels do
		worldHash = checksum(level.Name .. #level:GetDescendants(), worldHash)
	end
	for _, tag in sortedKeys(worldTagCounts) do
		worldHash = checksum(tag .. worldTagCounts[tag], worldHash)
	end
	return {
		scripts = scripts,
		codeHash = codeHash,
		totalLines = totalLines,
		tagSet = tagSet,
		attributeSet = attributeSet,
		worldTagCounts = worldTagCounts,
		workspaceInstances = #workspaceDescendants,
		levels = levels,
		worldHash = worldHash,
	}
end

local sections = {}

function sections.huella(context, emit)
	emit(("place=%s placeId=%d universeId=%d generado=%s"):format(game.Name, game.PlaceId, game.GameId, os.date("%Y-%m-%d %H:%M")))
	emit(("huella: scripts=%d lineas=%d codigo=%08x instancias=%d mundo=%08x"):format(#context.scripts, context.totalLines, context.codeHash, context.workspaceInstances, context.worldHash))
end

function sections.scripts(context, emit)
	local currentParent
	local summarized = {}
	for _, entry in context.scripts do
		local container = entry.container
		if isSummarized(entry.fullName) then
			local group = entry.fullName:match("^ServerStorage%.[%w_]+%.[%w_]+") or entry.fullName
			summarized[group] = summarized[group] or { scripts = 0, lines = 0 }
			summarized[group].scripts += 1
			summarized[group].lines += entry.lines
			continue
		end
		local parentName = container.Parent:GetFullName()
		if parentName ~= currentParent then
			currentParent = parentName
			emit("## " .. parentName)
		end
		local source = entry.source
		local api, requires, remotes, keys, tags, attributes, services = {}, {}, {}, {}, {}, {}, {}
		collectMatches(source, "function%s+[%w_]+[%.:]([%w_]+)%s*%(", api)
		for argument in source:gmatch("require%(([^%)]+)%)") do
			local last
			for word in argument:gmatch("[%w_]+") do
				last = word
			end
			if last then
				requires[last] = true
			end
		end
		collectMatches(source, "Remotes%.([%w_]+)", remotes)
		collectMatches(source, "Enum%.KeyCode%.([%w_]+)", keys)
		for tag in context.tagSet do
			if source:find('"' .. tag .. '"', 1, true) then
				tags[tag] = true
			end
		end
		for name in context.attributeSet do
			if source:find('"' .. name .. '"', 1, true) then
				attributes[name] = true
			end
		end
		for _, service in TRACKED_SERVICES do
			if source:find(service, 1, true) then
				services[(service:gsub("Service$", ""))] = true
			end
		end
		local kind = if container:IsA("ModuleScript") then "M" elseif container:IsA("LocalScript") then "L" else "S"
		local fields = { ("%s %s%d"):format(container.Name, kind, entry.lines) }
		local function field(label, set, limit)
			local text = joinKeys(set, limit)
			if text ~= "" then
				table.insert(fields, label .. ":" .. text)
			end
		end
		field("api", api, 14)
		field("req", requires, 16)
		field("rem", remotes)
		field("tag", tags)
		field("attr", attributes)
		field("key", keys)
		field("svc", services)
		emit(table.concat(fields, " | "))
	end
	emit("## sin detalle")
	for _, group in sortedKeys(summarized) do
		emit(("%s scripts=%d lineas=%d"):format(group, summarized[group].scripts, summarized[group].lines))
	end
end

function sections.etiquetas(context, emit)
	for _, tag in sortedKeys(context.tagSet) do
		local perLevel, classes, attributes = {}, {}, {}
		local total = 0
		for _, instance in CollectionService:GetTagged(tag) do
			if instance:IsDescendantOf(workspace) then
				total += 1
				local label = levelLabel(instance)
				perLevel[label] = (perLevel[label] or 0) + 1
				classes[instance.ClassName] = true
				for name, value in instance:GetAttributes() do
					attributes[name] = attributes[name] or {}
					attributes[name][show(value)] = true
				end
			end
		end
		if total == 0 then
			emit(tag .. " 0 | solo en ejecucion o sin usar")
			continue
		end
		local levelText = {}
		for _, label in sortedKeys(perLevel) do
			table.insert(levelText, label .. "=" .. perLevel[label])
		end
		local attributeText = {}
		for _, name in sortedKeys(attributes) do
			local values = sortedKeys(attributes[name])
			if #values > 5 then
				table.insert(attributeText, name .. "{" .. #values .. " valores}")
			else
				table.insert(attributeText, name .. "{" .. table.concat(values, "/") .. "}")
			end
		end
		emit(("%s %d | %s | %s | %s"):format(tag, total, table.concat(levelText, " "), joinKeys(classes), table.concat(attributeText, " ")))
	end
end

function sections.niveles(context, emit)
	for _, level in context.levels do
		local minimum = Vector3.new(math.huge, math.huge, math.huge)
		local maximum = -minimum
		local partCount, collidingCount = 0, 0
		local descendants = level:GetDescendants()
		for index, descendant in descendants do
			if descendant:IsA("BasePart") then
				partCount += 1
				if descendant.CanCollide then
					collidingCount += 1
				end
				minimum = minimum:Min(descendant.Position)
				maximum = maximum:Max(descendant.Position)
			end
			if index % 6000 == 0 then
				task.wait()
			end
		end
		emit(("## %s %s | instancias=%d partes=%d conColision=%d | min%s max%s"):format(levelLabel(level), level.Name, #descendants, partCount, collidingCount, showRounded(minimum), showRounded(maximum)))
		local children = {}
		for _, child in level:GetChildren() do
			table.insert(children, ("%s[%s]%d"):format(child.Name, child.ClassName, #child:GetDescendants()))
		end
		table.sort(children)
		emit("hijos: " .. table.concat(children, " · "))
		for _, tag in ANCHOR_TAGS do
			for _, instance in CollectionService:GetTagged(tag) do
				if instance:IsDescendantOf(level) then
					local position = positionOf(instance)
					local size = if instance:IsA("BasePart") then " size" .. showRounded(instance.Size) else ""
					emit(("%s: %s [%s] pos%s%s %s"):format(tag, relativeName(instance, level), instance.ClassName, if position then showRounded(position) else "?", size, attributeList(instance)))
				end
			end
		end
		local hazards = {}
		for _, instance in CollectionService:GetTagged("Hazard") do
			if instance:IsDescendantOf(level) then
				local hazardKind = tostring(instance:GetAttribute("HazardKind"))
				hazards[hazardKind] = (hazards[hazardKind] or 0) + 1
			end
		end
		local hazardText = {}
		for _, hazardKind in sortedKeys(hazards) do
			table.insert(hazardText, hazardKind .. "=" .. hazards[hazardKind])
		end
		emit("Hazard: " .. (if #hazardText > 0 then table.concat(hazardText, " ") else "ninguno"))
		local lobby = level:FindFirstChild("Lobby")
		if lobby then
			local lobbyChildren = {}
			for _, child in lobby:GetChildren() do
				local position = positionOf(child)
				table.insert(lobbyChildren, ("%s%s"):format(child.Name, if position then showRounded(position) else ""))
			end
			table.sort(lobbyChildren)
			emit("Lobby: " .. table.concat(lobbyChildren, " · "))
		end
		task.wait()
	end
end

function sections.mundo(context, emit)
	emit(("workspace: StreamingEnabled=%s MinRadius=%s TargetRadius=%s IntegrityMode=%s Gravity=%s FallenPartsDestroyHeight=%s"):format(tostring(workspace.StreamingEnabled), show(workspace.StreamingMinRadius), show(workspace.StreamingTargetRadius), workspace.StreamingIntegrityMode.Name, show(workspace.Gravity), show(workspace.FallenPartsDestroyHeight)))
	local outside = {}
	for _, child in workspace:GetChildren() do
		if typeof(child:GetAttribute(LEVEL_ATTRIBUTE)) ~= "number" and not child:IsA("Terrain") and not child:IsA("Camera") then
			local position = positionOf(child)
			table.insert(outside, ("%s[%s]%s"):format(child.Name, child.ClassName, if position then showRounded(position) else ""))
		end
	end
	emit("fuera de niveles: " .. table.concat(outside, " · "))
	emit("## prompts")
	for _, descendant in workspace:GetDescendants() do
		if descendant:IsA("ProximityPrompt") then
			emit(("%s %s | %s · %s | tecla=%s dist=%s %s"):format(levelLabel(descendant), relativeName(descendant.Parent, workspace), descendant.ActionText, descendant.ObjectText, descendant.KeyboardKeyCode.Name, show(descendant.MaxActivationDistance), attributeList(descendant)))
		end
	end
	emit("## StarterGui")
	for _, gui in StarterGui:GetChildren() do
		local children = {}
		for _, child in gui:GetChildren() do
			table.insert(children, child.Name)
		end
		emit(("%s[%s] hijos: %s"):format(gui.Name, gui.ClassName, table.concat(children, ",")))
	end
	emit("## StarterCharacter")
	local character = StarterPlayer:FindFirstChild("StarterCharacter")
	if character then
		local parts, joints = {}, {}
		for _, descendant in character:GetDescendants() do
			if descendant:IsA("BasePart") then
				table.insert(parts, ("%s%s%s"):format(descendant.Name, show(descendant.Size), if descendant.Transparency >= 1 then "invisible" else ""))
			elseif descendant:IsA("JointInstance") then
				table.insert(joints, ("%s[%s]:%s>%s"):format(descendant.Name, descendant.ClassName, if descendant.Part0 then descendant.Part0.Name else "?", if descendant.Part1 then descendant.Part1.Name else "?"))
			end
		end
		table.sort(parts)
		table.sort(joints)
		emit("partes: " .. table.concat(parts, " · "))
		emit("uniones: " .. table.concat(joints, " · "))
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			emit(("Humanoid: RigType=%s HipHeight=%s WalkSpeed=%s JumpPower=%s UseJumpPower=%s RequiresNeck=%s"):format(humanoid.RigType.Name, show(humanoid.HipHeight), show(humanoid.WalkSpeed), show(humanoid.JumpPower), tostring(humanoid.UseJumpPower), tostring(humanoid.RequiresNeck)))
		end
	end
	emit("## ajustes")
	emit(("Players: CharacterAutoLoads=%s RespawnTime=%s"):format(tostring(Players.CharacterAutoLoads), show(Players.RespawnTime)))
	emit(("StarterPlayer: WalkSpeed=%s JumpHeight=%s CameraMaxZoomDistance=%s"):format(show(StarterPlayer.CharacterWalkSpeed), show(StarterPlayer.CharacterJumpHeight), show(StarterPlayer.CameraMaxZoomDistance)))
	local lightingChildren = {}
	for _, child in Lighting:GetChildren() do
		table.insert(lightingChildren, child.Name .. "[" .. child.ClassName .. "]")
	end
	emit(("Lighting: ClockTime=%s Brightness=%s hijos: %s"):format(show(Lighting.ClockTime), show(Lighting.Brightness), table.concat(lightingChildren, ",")))
	emit("## ServerStorage")
	for _, child in ServerStorage:GetChildren() do
		local grandchildren = child:GetChildren()
		local childNames = {}
		for index = 1, math.min(#grandchildren, LISTED_CHILD_LIMIT) do
			table.insert(childNames, grandchildren[index].Name)
		end
		if #grandchildren > LISTED_CHILD_LIMIT then
			table.insert(childNames, "+" .. (#grandchildren - LISTED_CHILD_LIMIT))
		end
		emit(("%s[%s] %s"):format(child.Name, child.ClassName, table.concat(childNames, ",")))
	end
end

local function flatten(prefix, value, emit)
	if typeof(value) ~= "table" then
		emit(prefix .. "=" .. show(value))
		return
	end
	if #value > 0 then
		local scalarItems = {}
		for _, item in value do
			if typeof(item) == "table" then
				scalarItems = nil
				break
			end
			table.insert(scalarItems, show(item))
		end
		if scalarItems then
			emit(prefix .. "={" .. table.concat(scalarItems, ",") .. "}")
			return
		end
	end
	local keys = {}
	local onlyScalars = true
	for _, key in sortedKeys(value) do
		if typeof(value[key]) ~= "function" then
			table.insert(keys, key)
			if typeof(value[key]) == "table" then
				onlyScalars = false
			end
		end
	end
	if #keys == 0 then
		emit(prefix .. "={}")
	elseif onlyScalars and #keys <= INLINE_KEY_LIMIT then
		local inlinePairs = {}
		for _, key in keys do
			table.insert(inlinePairs, tostring(key) .. "=" .. show(value[key]))
		end
		emit(prefix .. ": " .. table.concat(inlinePairs, " "))
	else
		for _, key in keys do
			flatten(prefix .. "." .. tostring(key), value[key], emit)
		end
	end
end

local function freshRequire(module)
	local succeeded, result = pcall(require, module:Clone())
	return if succeeded then result else nil
end

function sections.valores(_context, emit)
	for _, path in VALUE_MODULE_PATHS do
		local module = findByPath(path)
		local value = module and freshRequire(module)
		if value then
			flatten(module.Name, value, emit)
		else
			emit(path .. "=NO SE PUDO LEER")
		end
	end
	local skinModule = findByPath("ReplicatedStorage.Shared.SkinCatalog")
	local skinCatalog = skinModule and freshRequire(skinModule)
	if skinCatalog then
		emit("SkinCatalog.DefaultSkin=" .. tostring(skinCatalog.DefaultSkin))
		for _, skin in skinCatalog.list() do
			emit(("SkinCatalog.%s: nombre=%s rareza=%s precio=%s orden=%s"):format(skin.id, skin.name, skin.rarity, show(skin.price), show(skin.order)))
		end
	end
	local wheelModule = findByPath("ReplicatedStorage.Shared.WheelCatalog")
	local wheelCatalog = wheelModule and freshRequire(wheelModule)
	if wheelCatalog then
		emit(("WheelCatalog: SkinPrize=%s ChestRange=%s-%s SkinDuplicateFish=%s pesoTotal=%s"):format(tostring(wheelCatalog.SkinPrize), show(wheelCatalog.ChestRange.min), show(wheelCatalog.ChestRange.max), show(wheelCatalog.SkinDuplicateFish), show(wheelCatalog.totalWeight())))
		for index, prize in wheelCatalog.list() do
			emit(("WheelCatalog.%d: %s | tipo=%s cantidad=%s peso=%s prob=%.1f%%"):format(index, prize.title, prize.kind, show(prize.amount), show(prize.weight), wheelCatalog.chance(index) * 100))
		end
	end
	local profileModule = findByPath("ServerScriptService.Server.Data.PlayerProfile")
	local playerProfile = profileModule and freshRequire(profileModule)
	if playerProfile then
		emit("PlayerProfile.Name=" .. tostring(playerProfile.Name))
		flatten("PlayerProfile.Template", playerProfile.Template, emit)
	end
end

local function lineHash(line)
	return ("%06x"):format(checksum(line, CHECKSUM_SEED) % LINE_HASH_MODULUS)
end

local function commonLengths(baseHashes, newHashes)
	local rows, columns = #baseHashes, #newHashes
	local lengths = table.create(rows + 1)
	for row = 1, rows + 1 do
		lengths[row] = table.create(columns + 1, 0)
	end
	for row = rows, 1, -1 do
		local current, below = lengths[row], lengths[row + 1]
		for column = columns, 1, -1 do
			if baseHashes[row] == newHashes[column] then
				current[column] = below[column + 1] + 1
			else
				current[column] = math.max(below[column], current[column + 1])
			end
		end
	end
	return lengths
end

local function buildPatch(baseHashes, newLines)
	local newHashes = table.create(#newLines)
	for index, line in newLines do
		newHashes[index] = lineHash(line)
	end
	local lengths = commonLengths(baseHashes, newHashes)
	local operations = {}
	local copyStart, copyEnd
	local function flushCopy()
		if copyStart then
			table.insert(operations, ("=%d-%d"):format(copyStart, copyEnd))
			copyStart, copyEnd = nil, nil
		end
	end
	local row, column = 1, 1
	while column <= #newLines do
		if row <= #baseHashes and baseHashes[row] == newHashes[column] then
			if copyStart and copyEnd == row - 1 then
				copyEnd = row
			else
				flushCopy()
				copyStart, copyEnd = row, row
			end
			row += 1
			column += 1
		elseif row <= #baseHashes and lengths[row + 1][column] >= lengths[row][column + 1] then
			row += 1
		else
			flushCopy()
			table.insert(operations, "+" .. newLines[column])
			column += 1
		end
	end
	flushCopy()
	return operations
end

return function(requested, baseHashText)
	local context = buildContext()
	local lines = {}
	local function emit(line)
		table.insert(lines, (line:gsub("%s+$", "")))
	end
	for _, name in requested or SECTION_ORDER do
		local section = sections[name]
		if section then
			emit("# " .. name)
			section(context, emit)
		end
	end
	local text = table.concat(lines, "\n")
	if not baseHashText then
		return text
	end
	local baseHashes = {}
	for hash in baseHashText:gmatch("%x%x%x%x%x%x") do
		table.insert(baseHashes, hash)
	end
	local operations = buildPatch(baseHashes, lines)
	table.insert(operations, 1, ("@parche base=%d nuevas=%d suma=%08x"):format(#baseHashes, #lines, checksum(text, CHECKSUM_SEED)))
	return table.concat(operations, "\n")
end
