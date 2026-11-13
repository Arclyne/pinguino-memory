--!strict
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local HudIcons = require(script.Parent.HudIcons)

local ICON_NAME = "EmojiIcon"
local GAP_SPACES = "      "
local MAX_ICON_PIXELS = 48
local VARIATION_SELECTOR = "\u{FE0F}"

type Tracked = { label: TextLabel | TextButton, applied: string?, busy: boolean, connections: { RBXScriptConnection } }

local tokens: { { text: string, kind: string } } = {}
for text, kind in HudIcons.KindByEmoji do
	table.insert(tokens, { text = text, kind = kind })
end
table.sort(tokens, function(a, b)
	return #a.text > #b.text
end)

local tracked: { [Instance]: Tracked } = {}

local IconText = {}

local function extract(text: string): (string, string?)
	local firstKind: string? = nil
	local firstAt = math.huge
	local cleaned = text
	for _, token in tokens do
		local at = cleaned:find(token.text, 1, true)
		while at do
			if at < firstAt then
				firstAt = at
				firstKind = token.kind
			end
			cleaned = cleaned:sub(1, at - 1) .. cleaned:sub(at + #token.text)
			at = cleaned:find(token.text, 1, true)
		end
	end
	if not firstKind then
		return text, nil
	end
	cleaned = cleaned:gsub(VARIATION_SELECTOR, ""):gsub("  +", " "):gsub("^%s+", ""):gsub("%s+$", "")
	return cleaned, firstKind
end

local function removeIcon(label: Instance)
	local existing = label:FindFirstChild(ICON_NAME)
	if existing then
		existing:Destroy()
	end
end

local function layout(label: TextLabel | TextButton, holder: Frame, pure: boolean)
	local size = label.AbsoluteSize
	if size.X <= 0 or size.Y <= 0 then
		return
	end
	if pure then
		holder.AnchorPoint = Vector2.new(0.5, 0.5)
		holder.Position = UDim2.fromScale(0.5, 0.5)
		holder.Size = UDim2.fromScale(1.15, 1.15)
		return
	end
	local bounds = label.TextBounds
	local lineHeight = math.min(bounds.Y, MAX_ICON_PIXELS * (size.Y / math.max(size.Y, 1)))
	if bounds.Y > lineHeight * 1.6 then
		lineHeight = math.min(lineHeight, size.Y * 0.4)
	end
	local iconPixels = math.max(lineHeight * 1.25, 12)
	local startX: number
	if label.TextXAlignment == Enum.TextXAlignment.Left then
		startX = 0
	elseif label.TextXAlignment == Enum.TextXAlignment.Right then
		startX = size.X - bounds.X
	else
		startX = (size.X - bounds.X) / 2
	end
	local topY: number
	if label.TextYAlignment == Enum.TextYAlignment.Top then
		topY = 0
	elseif label.TextYAlignment == Enum.TextYAlignment.Bottom then
		topY = size.Y - bounds.Y
	else
		topY = (size.Y - bounds.Y) / 2
	end
	holder.AnchorPoint = Vector2.new(0, 0.5)
	holder.Position = UDim2.fromScale((startX + iconPixels * 0.05) / size.X, (topY + math.min(bounds.Y, lineHeight) / 2) / size.Y)
	holder.Size = UDim2.fromScale(iconPixels / size.X, iconPixels / size.Y)
end

local function ensureHolder(label: TextLabel | TextButton, kind: string): Frame
	local holder = label:FindFirstChild(ICON_NAME) :: Frame?
	if holder then
		local image = holder:FindFirstChildOfClass("ImageLabel")
		if image then
			HudIcons.setKind(image, kind)
		end
		return holder
	end
	local frame = Instance.new("Frame")
	frame.Name = ICON_NAME
	frame.BackgroundTransparency = 1
	frame.ZIndex = label.ZIndex + 1
	frame.Parent = label
	HudIcons.create(frame, kind)
	return frame
end

local function process(entry: Tracked)
	if entry.busy then
		return
	end
	local label = entry.label
	local text = label.Text
	if text == entry.applied then
		local holder = label:FindFirstChild(ICON_NAME) :: Frame?
		if holder then
			layout(label, holder, label:GetAttribute("EmojiPure") == true)
		end
		return
	end
	local cleaned, kind = extract(text)
	if not kind then
		if label:FindFirstChild(ICON_NAME) and text ~= entry.applied then
			removeIcon(label)
		end
		entry.applied = text
		return
	end
	local pure = cleaned == ""
	local display = if pure then "" else GAP_SPACES .. cleaned
	entry.busy = true
	label.Text = display
	entry.busy = false
	entry.applied = display
	label:SetAttribute("EmojiPure", pure)
	local holder = ensureHolder(label, kind)
	if pure then
		local aspect = holder:FindFirstChildOfClass("UIAspectRatioConstraint") or Instance.new("UIAspectRatioConstraint")
		aspect.AspectRatio = 1
		aspect.Parent = holder
	end
	task.defer(function()
		if holder.Parent then
			layout(label, holder, pure)
		end
	end)
end

local function track(instance: Instance)
	if tracked[instance] or not (instance:IsA("TextLabel") or instance:IsA("TextButton")) then
		return
	end
	local label = instance :: TextLabel | TextButton
	local entry: Tracked = { label = label, applied = nil, busy = false, connections = {} }
	tracked[instance] = entry
	table.insert(entry.connections, label:GetPropertyChangedSignal("Text"):Connect(function()
		process(entry)
	end))
	table.insert(entry.connections, label:GetPropertyChangedSignal("TextBounds"):Connect(function()
		process(entry)
	end))
	table.insert(entry.connections, label:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		process(entry)
	end))
	table.insert(entry.connections, label.AncestryChanged:Connect(function(_, parent)
		if not parent then
			for _, connection in entry.connections do
				connection:Disconnect()
			end
			tracked[instance] = nil
		end
	end))
	process(entry)
end

local function watch(root: Instance)
	for _, descendant in root:GetDescendants() do
		track(descendant)
	end
	root.DescendantAdded:Connect(track)
end

function IconText.init()
	watch(Players.LocalPlayer:WaitForChild("PlayerGui"))
	task.defer(function()
		watch(Workspace)
	end)
end

return IconText
