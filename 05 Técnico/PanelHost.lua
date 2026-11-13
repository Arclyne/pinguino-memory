--!strict
local TweenService = game:GetService("TweenService")

local UiKit = require(script.Parent.UiKit)
local ProfileStore = require(script.Parent.ProfileStore)
local HudIcons = require(script.Parent.HudIcons)

export type Builder = (body: Frame, host: any) -> (() -> ())?

local PanelHost = {}
PanelHost.__index = PanelHost

export type PanelHost = typeof(setmetatable({} :: {
	_root: Frame,
	_window: Frame,
	_title: TextLabel,
	_header: Frame,
	_headerGradient: UIGradient,
	_body: Frame,
	_fishLabel: TextLabel,
	_cleanup: (() -> ())?,
	_scale: UIScale,
	openName: string?,
}, PanelHost))

function PanelHost.new(screen: ScreenGui): PanelHost
	local root = UiKit.new("Frame", { Name = "PanelRoot", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Visible = false, ZIndex = 20, Parent = screen })
	local dim = UiKit.new("TextButton", { Name = "Dim", Text = "", AutoButtonColor = false, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(10, 12, 30), BackgroundTransparency = 0.45, ZIndex = 20, Parent = root })
	local window = UiKit.new("Frame", {
		Name = "Window",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.52),
		Size = UDim2.fromScale(0.86, 0.84),
		BackgroundColor3 = UiKit.PanelColor,
		ZIndex = 21,
		Parent = root,
	})
	UiKit.new("UISizeConstraint", { MaxSize = Vector2.new(1180, 720), Parent = window })
	UiKit.corner(window, 22)
	UiKit.border(window, 4)
	local scale = UiKit.new("UIScale", { Parent = window })
	local header = UiKit.new("Frame", { Name = "Header", Size = UDim2.new(1, 0, 0, 78), BackgroundColor3 = UiKit.White, ZIndex = 22, Parent = window })
	UiKit.corner(header, 20)
	UiKit.new("Frame", { Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 1, -20), BackgroundColor3 = UiKit.White, BorderSizePixel = 0, ZIndex = 22, Parent = header })
	local headerGradient = UiKit.gradient(header, UiKit.Palettes.rainbow, 0)
	headerGradient.Name = "HeaderGradient"
	for _, child in header:GetChildren() do
		if child:IsA("Frame") then
			UiKit.gradient(child, UiKit.Palettes.rainbow, 0).Name = "HeaderGradient"
		end
	end
	UiKit.new("Frame", { Size = UDim2.new(1, 0, 0, 4), Position = UDim2.new(0, 0, 1, 0), BackgroundColor3 = UiKit.Ink, BorderSizePixel = 0, ZIndex = 23, Parent = header })
	local title = UiKit.label(header, "", { Size = UDim2.new(0.55, 0, 0, 56), Position = UDim2.fromOffset(24, 11), TextXAlignment = Enum.TextXAlignment.Left, MaxTextSize = 52, StrokeThickness = 3.5, ZIndex = 24 })
	local fishChip = UiKit.new("Frame", { Size = UDim2.fromOffset(190, 50), Position = UDim2.new(1, -96, 0, 14), AnchorPoint = Vector2.new(1, 0), BackgroundColor3 = UiKit.Ink, ZIndex = 24, Parent = header })
	UiKit.corner(fishChip, 14)
	local fishLabel = UiKit.label(fishChip, "0", { Size = UDim2.new(1, -66, 1, -10), Position = UDim2.fromOffset(58, 5), ZIndex = 25, MaxTextSize = 34 })
	local fishIconFrame = UiKit.new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromOffset(58, 58), Position = UDim2.fromOffset(0, -4), ZIndex = 25, Parent = fishChip })
	HudIcons.create(fishIconFrame, "fish", 0.5)
	local closeButton = UiKit.button({ parent = header, size = UDim2.fromOffset(58, 58), position = UDim2.new(1, -14, 0, 9), anchor = Vector2.new(1, 0), palette = UiKit.Palettes.red, text = "X", radius = 14, textSize = 34 })
	local body = UiKit.new("Frame", { Name = "Body", Size = UDim2.new(1, -36, 1, -100), Position = UDim2.fromOffset(18, 92), BackgroundTransparency = 1, ZIndex = 22, ClipsDescendants = false, Parent = window })

	local self = setmetatable({
		_root = root,
		_window = window,
		_title = title,
		_header = header,
		_headerGradient = headerGradient,
		_body = body,
		_fishLabel = fishLabel,
		_cleanup = nil,
		_scale = scale,
		openName = nil,
	}, PanelHost)
	dim.MouseButton1Click:Connect(function()
		self:close()
	end)
	closeButton.MouseButton1Click:Connect(function()
		self:close()
	end)
	local function refreshFish(snapshot: any)
		fishLabel.Text = UiKit.formatNumber(if snapshot then snapshot.fish else 0)
	end
	ProfileStore.Changed:Connect(refreshFish)
	refreshFish(ProfileStore.get())
	return self
end

function PanelHost.open(self: PanelHost, name: string, titleText: string, palette: { Color3 }, build: Builder)
	self:close()
	self.openName = name
	self._title.Text = titleText
	for _, gradient in self._header:GetDescendants() do
		if gradient:IsA("UIGradient") and gradient.Name == "HeaderGradient" then
			gradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, palette[1]),
				ColorSequenceKeypoint.new(0.5, palette[2]),
				ColorSequenceKeypoint.new(1, palette[3]),
			})
		end
	end
	self._root.Visible = true
	self._scale.Scale = 0.7
	TweenService:Create(self._scale, TweenInfo.new(0.3, Enum.EasingStyle.Back), { Scale = 1 }):Play()
	self._cleanup = build(self._body, self)
end

function PanelHost.close(self: PanelHost)
	local cleanup = self._cleanup
	self._cleanup = nil
	if cleanup then
		cleanup()
	end
	for _, child in self._body:GetChildren() do
		child:Destroy()
	end
	self._root.Visible = false
	self.openName = nil
end

function PanelHost.isOpen(self: PanelHost): boolean
	return self._root.Visible
end

return PanelHost
