--!strict
local RunService = game:GetService("RunService")

type Tile = { holder: Frame, button: GuiObject, shine: Frame, phase: number, sparkles: { TextLabel } }
type Launch = { holder: Frame, button: GuiObject, gradient: UIGradient?, rays: Frame, glow: Frame, shine: Frame, arrows: { TextLabel }, sideArrows: { TextLabel }, bubble: Frame, bubbleScale: UIScale, sparkles: { TextLabel }, rings: { Frame } }

local rgb = Color3.fromRGB
local INK = rgb(20, 22, 40)

local tiles: { Tile } = {}
local launches: { Launch } = {}
local started = false

local HudLife = {}

local function corner(parent: Instance, scale: number)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(scale, 0)
	c.Parent = parent
end

local function stroke(parent: Instance, thickness: number, color: Color3)
	local s = Instance.new("UIStroke")
	s.Thickness = thickness
	s.Color = color
	s.Parent = parent
	return s
end

local function sparkleLabel(parent: Instance, position: UDim2, size: number, color: Color3, zIndex: number): TextLabel
	local label = Instance.new("TextLabel")
	label.AnchorPoint = Vector2.new(0.5, 0.5)
	label.Position = position
	label.Size = UDim2.fromOffset(size, size)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.FredokaOne
	label.Text = "✦"
	label.TextScaled = true
	label.TextColor3 = color
	label.ZIndex = zIndex
	label.Parent = parent
	stroke(label, 1.5, rgb(255, 170, 60)).Transparency = 0.4
	return label
end

local function newShine(button: GuiObject, zIndex: number): Frame
	button.ClipsDescendants = true
	local shine = Instance.new("Frame")
	shine.Name = "Sweep"
	shine.AnchorPoint = Vector2.new(0.5, 0.5)
	shine.Size = UDim2.new(0, 22, 2.4, 0)
	shine.Rotation = 24
	shine.BackgroundColor3 = rgb(255, 255, 255)
	shine.BackgroundTransparency = 0.45
	shine.BorderSizePixel = 0
	shine.ZIndex = zIndex
	shine.Position = UDim2.fromScale(-0.4, 0.5)
	shine.Parent = button
	local fade = Instance.new("UIGradient")
	fade.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1) })
	fade.Parent = shine
	return shine
end

local function step()
	local now = os.clock()
	for index = #tiles, 1, -1 do
		local tile = tiles[index]
		if not tile.holder.Parent then
			table.remove(tiles, index)
		else
			local t = now + tile.phase
			local hop = math.max(0, math.sin(t * 2.4))
			tile.button.Position = UDim2.fromOffset(0, -hop * hop * 5)
			tile.holder.Rotation = math.sin(t * 1.3) * 2.2
			local sweep = (t * 0.35) % 1.6
			tile.shine.Position = UDim2.fromScale(-0.4 + sweep * 1.2, 0.5)
			for sparkleIndex, sparkle in tile.sparkles do
				local pulse = math.max(0, math.sin(t * 3 + sparkleIndex * 2.1))
				sparkle.TextTransparency = 1 - pulse
				sparkle.Rotation = t * 90
				sparkle.Size = UDim2.fromOffset(10 + pulse * 12, 10 + pulse * 12)
			end
		end
	end
	for index = #launches, 1, -1 do
		local launch = launches[index]
		if not launch.holder.Parent then
			table.remove(launches, index)
		else
			local t = now
			launch.rays.Rotation = (t * 25) % 360
			launch.glow.BackgroundTransparency = 0.45 + math.sin(t * 5) * 0.2
			if launch.gradient then
				launch.gradient.Offset = Vector2.new(0, math.sin(t * 3) * 0.12)
			end
			launch.shine.Position = UDim2.fromScale(-0.3 + ((t * 0.7) % 1.4), 0.5)
			local hop = math.abs(math.sin(t * 5))
			for arrowIndex, arrow in launch.arrows do
				local on = math.floor(t * 6 - arrowIndex) % 3 == 0
				arrow.TextColor3 = if on then rgb(255, 255, 255) else rgb(255, 60, 70)
				arrow.Position = UDim2.new(0.5, 0, 0, -30 - (3 - arrowIndex) * 26 + hop * 12)
				arrow.TextTransparency = if on then 0 else 0.15
			end
			for sideIndex, arrow in launch.sideArrows do
				local direction = if sideIndex == 1 then 1 else -1
				arrow.Position = UDim2.new(if sideIndex == 1 then 0 else 1, -direction * (46 - hop * 16), 0.5, 0)
				arrow.TextTransparency = if math.floor(t * 4) % 2 == 0 then 0 else 0.6
			end
			launch.bubbleScale.Scale = 1 + math.max(0, math.sin(t * 6)) * 0.12
			launch.bubble.Rotation = math.sin(t * 9) * 4
			for sparkleIndex, sparkle in launch.sparkles do
				local pulse = math.max(0, math.sin(t * 3.5 + sparkleIndex * 1.7))
				sparkle.TextTransparency = 1 - pulse
				sparkle.Rotation = t * 120
				sparkle.Size = UDim2.fromOffset(14 + pulse * 18, 14 + pulse * 18)
			end
			for ringIndex, ring in launch.rings do
				local cycle = (t * 0.8 + ringIndex * 0.5) % 1
				ring.Size = UDim2.new(1 + cycle * 0.25, 0, 1 + cycle * 0.6, 0)
				local ringStroke = ring:FindFirstChildOfClass("UIStroke")
				if ringStroke then
					ringStroke.Transparency = cycle
				end
			end
		end
	end
end

local function ensureLoop()
	if started then
		return
	end
	started = true
	RunService.RenderStepped:Connect(step)
end

function HudLife.tile(holder: Frame, button: GuiObject, hasRibbon: boolean)
	local sparkles: { TextLabel } = {}
	if hasRibbon then
		table.insert(sparkles, sparkleLabel(holder, UDim2.new(0, -4, 0, 10), 16, rgb(255, 245, 160), 9))
		table.insert(sparkles, sparkleLabel(holder, UDim2.new(1, 6, 1, -14), 14, rgb(255, 255, 255), 9))
		table.insert(sparkles, sparkleLabel(holder, UDim2.new(0.5, 0, 0, -8), 12, rgb(255, 220, 120), 9))
	end
	table.insert(tiles, { holder = holder, button = button, shine = newShine(button, 3), phase = math.random() * 6, sparkles = sparkles })
	ensureLoop()
end

function HudLife.launch(holder: Frame, button: GuiObject)
	holder.ZIndex = 2
	local rays = Instance.new("Frame")
	rays.Name = "Rays"
	rays.AnchorPoint = Vector2.new(0.5, 0.5)
	rays.Position = UDim2.fromScale(0.5, 0.5)
	rays.Size = UDim2.fromOffset(300, 300)
	rays.BackgroundTransparency = 1
	rays.ZIndex = 0
	rays.Parent = holder
	for index = 0, 11 do
		local ray = Instance.new("Frame")
		ray.AnchorPoint = Vector2.new(0.5, 1)
		ray.Position = UDim2.fromScale(0.5, 0.5)
		ray.Size = UDim2.new(0, 34, 0.5, 0)
		ray.Rotation = index * 30
		ray.BackgroundColor3 = if index % 2 == 0 then rgb(255, 236, 140) else rgb(255, 180, 60)
		ray.BackgroundTransparency = 0.55
		ray.BorderSizePixel = 0
		ray.ZIndex = 0
		ray.Parent = rays
		local fade = Instance.new("UIGradient")
		fade.Rotation = 90
		fade.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.2) })
		fade.Parent = ray
	end
	local glow = Instance.new("Frame")
	glow.Name = "Glow"
	glow.AnchorPoint = Vector2.new(0.5, 0.5)
	glow.Position = UDim2.fromScale(0.5, 0.5)
	glow.Size = UDim2.new(1, 36, 1, 30)
	glow.BackgroundColor3 = rgb(255, 210, 60)
	glow.BackgroundTransparency = 0.5
	glow.BorderSizePixel = 0
	glow.ZIndex = 0
	glow.Parent = holder
	corner(glow, 0.5)
	local rings: { Frame } = {}
	for _ = 1, 2 do
		local ring = Instance.new("Frame")
		ring.AnchorPoint = Vector2.new(0.5, 0.5)
		ring.Position = UDim2.fromScale(0.5, 0.5)
		ring.Size = UDim2.fromScale(1, 1)
		ring.BackgroundTransparency = 1
		ring.ZIndex = 0
		ring.Parent = holder
		corner(ring, 0.5)
		stroke(ring, 5, rgb(255, 230, 120))
		table.insert(rings, ring)
	end

	local gradient = button:FindFirstChildOfClass("UIGradient")
	if gradient then
		gradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, rgb(255, 246, 120)),
			ColorSequenceKeypoint.new(0.45, rgb(255, 196, 30)),
			ColorSequenceKeypoint.new(1, rgb(255, 120, 20)),
		})
	end
	local label = button:FindFirstChild("Label")
	if label and label:IsA("TextLabel") then
		label.TextColor3 = rgb(255, 255, 255)
		local labelStroke = label:FindFirstChildOfClass("UIStroke")
		if labelStroke then
			labelStroke.Thickness = 4.5
			labelStroke.Color = rgb(140, 50, 0)
		end
	end
	local shine = newShine(button, 4)
	shine.Size = UDim2.new(0, 40, 2.6, 0)

	local arrows: { TextLabel } = {}
	for index = 1, 3 do
		local arrow = Instance.new("TextLabel")
		arrow.AnchorPoint = Vector2.new(0.5, 1)
		arrow.Size = UDim2.fromOffset(70, 46)
		arrow.BackgroundTransparency = 1
		arrow.Font = Enum.Font.FredokaOne
		arrow.Text = "▼"
		arrow.TextScaled = true
		arrow.TextColor3 = rgb(255, 60, 70)
		arrow.ZIndex = 12
		arrow.Parent = holder
		stroke(arrow, 4, INK)
		table.insert(arrows, arrow)
	end
	local sideArrows: { TextLabel } = {}
	for index, glyph in { "▶", "◀" } do
		local arrow = Instance.new("TextLabel")
		arrow.AnchorPoint = Vector2.new(0.5, 0.5)
		arrow.Size = UDim2.fromOffset(52, 60)
		arrow.BackgroundTransparency = 1
		arrow.Font = Enum.Font.FredokaOne
		arrow.Text = glyph
		arrow.TextScaled = true
		arrow.TextColor3 = if index == 1 then rgb(255, 255, 255) else rgb(255, 255, 255)
		arrow.ZIndex = 12
		arrow.Parent = holder
		stroke(arrow, 4, rgb(220, 40, 60))
		table.insert(sideArrows, arrow)
	end

	local bubble = Instance.new("Frame")
	bubble.AnchorPoint = Vector2.new(0.5, 0.5)
	bubble.Position = UDim2.new(1, -10, 0, -6)
	bubble.Size = UDim2.fromOffset(150, 40)
	bubble.BackgroundColor3 = rgb(255, 255, 255)
	bubble.ZIndex = 13
	bubble.Parent = holder
	corner(bubble, 0.5)
	stroke(bubble, 3.5, INK)
	local bubbleGradient = Instance.new("UIGradient")
	bubbleGradient.Rotation = 90
	bubbleGradient.Color = ColorSequence.new(rgb(255, 90, 110), rgb(220, 30, 60))
	bubbleGradient.Parent = bubble
	local bubbleLabel = Instance.new("TextLabel")
	bubbleLabel.BackgroundTransparency = 1
	bubbleLabel.Size = UDim2.new(1, -12, 1, -8)
	bubbleLabel.Position = UDim2.fromOffset(6, 4)
	bubbleLabel.Font = Enum.Font.FredokaOne
	bubbleLabel.Text = "¡JUEGA YA!"
	bubbleLabel.TextScaled = true
	bubbleLabel.TextColor3 = rgb(255, 255, 255)
	bubbleLabel.ZIndex = 14
	bubbleLabel.Parent = bubble
	stroke(bubbleLabel, 2.5, rgb(90, 0, 20))
	local bubbleScale = Instance.new("UIScale")
	bubbleScale.Parent = bubble

	local sparkles: { TextLabel } = {}
	for _, spot in { UDim2.new(0, 10, 0, 6), UDim2.new(0.3, 0, 1, 4), UDim2.new(0.75, 0, 0, -4), UDim2.new(1, -8, 1, -10), UDim2.new(0.55, 0, 1, 8) } do
		table.insert(sparkles, sparkleLabel(holder, spot, 20, rgb(255, 255, 230), 11))
	end

	table.insert(launches, {
		holder = holder,
		button = button,
		gradient = gradient,
		rays = rays,
		glow = glow,
		shine = shine,
		arrows = arrows,
		sideArrows = sideArrows,
		bubble = bubble,
		bubbleScale = bubbleScale,
		sparkles = sparkles,
		rings = rings,
	})
	ensureLoop()
end

return HudLife
