--!strict
local RunService = game:GetService("RunService")

type Sheet = { image: string, cell: number, columns: number, order: { string } }

local SHEETS: { Sheet } = {
	{ image = "rbxassetid://106021550852364", cell = 204, columns = 5, order = { "cart", "palette", "skins", "rocket", "invite", "chest", "crown", "gift", "map", "trophy", "rebirth", "wheel", "fish", "avalanche", "bolt", "fire", "diamond" } },
	{ image = "__ATLAS2__", cell = 170, columns = 6, order = { "astronaut", "basket", "chat", "check", "city", "clock", "coffee", "cookie", "cross", "flag", "handshake", "hourglass", "icecube", "lantern", "lock", "medal", "medal1", "medal2", "medal3", "ninja", "party", "people", "pirate", "plane", "rainbow", "santa", "scarf", "skate", "ticket", "tophat", "tree", "truck", "unlock", "warning" } },
}
local ALIASES: { [string]: string } = { penguin = "skins", crate = "chest", star = "rebirth", snowflake = "avalanche", flame = "fire" }

type Icon = { image: ImageLabel, scale: UIScale, phase: number, rest: number }

local entryByName: { [string]: { sheet: Sheet, index: number } } = {}
for _, sheet in SHEETS do
	for index, name in sheet.order do
		entryByName[name] = { sheet = sheet, index = index - 1 }
	end
end

local icons: { Icon } = {}
local started = false

local HudIcons = {}

local function applyKind(image: ImageLabel, kind: string): boolean
	local entry = entryByName[ALIASES[kind] or kind]
	if not entry then
		return false
	end
	local sheet = entry.sheet
	image.Image = sheet.image
	image.ImageRectOffset = Vector2.new((entry.index % sheet.columns) * sheet.cell, math.floor(entry.index / sheet.columns) * sheet.cell)
	image.ImageRectSize = Vector2.new(sheet.cell, sheet.cell)
	return true
end

function HudIcons.has(kind: string): boolean
	return entryByName[ALIASES[kind] or kind] ~= nil
end

local function step()
	local now = os.clock()
	for index = #icons, 1, -1 do
		local icon = icons[index]
		if not icon.image.Parent then
			table.remove(icons, index)
		else
			local t = now + icon.phase
			local cycle = t % 3.2
			local pop = if cycle < 0.45 then math.sin(cycle / 0.45 * math.pi) else 0
			icon.scale.Scale = 1 + math.sin(t * 2.4) * 0.03 + pop * 0.14
			icon.image.Rotation = icon.rest + math.sin(t * 1.7) * 4 + pop * math.sin(cycle * 40) * 6
			icon.image.Position = UDim2.new(0.5, 0, 0.5, -math.abs(math.sin(t * 2.4)) * 3)
		end
	end
end

local function ensureLoop()
	if not started then
		started = true
		RunService.RenderStepped:Connect(step)
	end
end

function HudIcons.create(parent: GuiObject, kind: string, phase: number?, rest: number?): ImageLabel?
	local image = Instance.new("ImageLabel")
	image.Name = "IconImage"
	image.BackgroundTransparency = 1
	image.AnchorPoint = Vector2.new(0.5, 0.5)
	image.Position = UDim2.fromScale(0.5, 0.5)
	image.Size = UDim2.fromScale(1, 1)
	image.ScaleType = Enum.ScaleType.Fit
	image.ZIndex = parent.ZIndex + 1
	if not applyKind(image, kind) then
		image:Destroy()
		return nil
	end
	local scale = Instance.new("UIScale")
	scale.Parent = image
	image.Parent = parent
	table.insert(icons, { image = image, scale = scale, phase = phase or math.random() * 6, rest = rest or 0 })
	ensureLoop()
	return image
end

function HudIcons.setKind(image: ImageLabel, kind: string)
	applyKind(image, kind)
end

function HudIcons.replaceTextIcon(label: TextLabel, kind: string, phase: number?, grow: number?): ImageLabel?
	local parent = label.Parent
	if not parent or not parent:IsA("GuiObject") then
		return nil
	end
	local factor = grow or 1.35
	local holder = Instance.new("Frame")
	holder.Name = "IconHolder"
	holder.BackgroundTransparency = 1
	holder.AnchorPoint = Vector2.new(0.5, 0.5)
	holder.Position = UDim2.new(
		label.Position.X.Scale + label.Size.X.Scale * (0.5 - label.AnchorPoint.X),
		label.Position.X.Offset + label.Size.X.Offset * (0.5 - label.AnchorPoint.X),
		label.Position.Y.Scale + label.Size.Y.Scale * (0.5 - label.AnchorPoint.Y),
		label.Position.Y.Offset + label.Size.Y.Offset * (0.5 - label.AnchorPoint.Y)
	)
	holder.Size = UDim2.new(label.Size.X.Scale * factor, label.Size.X.Offset * factor, label.Size.Y.Scale * factor, label.Size.Y.Offset * factor)
	holder.Rotation = label.Rotation
	holder.ZIndex = label.ZIndex
	holder.Parent = parent
	local aspect = Instance.new("UIAspectRatioConstraint")
	aspect.AspectRatio = 1
	aspect.Parent = holder
	local image = HudIcons.create(holder, kind, phase)
	if not image then
		holder:Destroy()
		return nil
	end
	image.ZIndex = label.ZIndex
	label.Text = ""
	label.Visible = false
	return image
end

HudIcons.KindByEmoji = {
	["🛒"] = "cart",
	["🎨"] = "palette",
	["🐧"] = "skins",
	["🚀"] = "rocket",
	["🐧➕"] = "invite",
	["📦"] = "chest",
	["👑"] = "crown",
	["🎁"] = "gift",
	["🗺️"] = "map",
	["🏆"] = "trophy",
	["⭐"] = "rebirth",
	["🎡"] = "wheel",
	["🐟"] = "fish",
	["❄️"] = "icecube",
	["⚡"] = "bolt",
	["🔥"] = "fire",
	["💎"] = "diamond",
	["🧑‍🚀"] = "astronaut",
	["🧺"] = "basket",
	["💬"] = "chat",
	["✓"] = "check",
	["🏙️"] = "city",
	["⏱️"] = "clock",
	["☕"] = "coffee",
	["🍪"] = "cookie",
	["✖️"] = "cross",
	["🏁"] = "flag",
	["🤝"] = "handshake",
	["⏳"] = "hourglass",
	["🧊"] = "icecube",
	["❄"] = "icecube",
	["🏮"] = "lantern",
	["🔒"] = "lock",
	["🏅"] = "medal",
	["🥇"] = "medal1",
	["🥈"] = "medal2",
	["🥉"] = "medal3",
	["🥷"] = "ninja",
	["🎉"] = "party",
	["👥"] = "people",
	["🏴‍☠️"] = "pirate",
	["✈️"] = "plane",
	["🌈"] = "rainbow",
	["🎅"] = "santa",
	["🧣"] = "scarf",
	["⛸️"] = "skate",
	["🎟️"] = "ticket",
	["🎩"] = "tophat",
	["🎄"] = "tree",
	["🚚"] = "truck",
	["🔓"] = "unlock",
	["⚠️"] = "warning",
	["🏔️"] = "avalanche",
	["🐧💨"] = "rocket",
	["🐟🐟"] = "fish",
}

return HudIcons
