local m = game.StarterPlayer.StarterPlayerScripts.Client.AvalancheCinematic local src = m.Source local n = 0
local function rep(a, b) local i, j = src:find(a, 1, true) if i then src = src:sub(1, i - 1) .. b .. src:sub(j + 1) n += 1 else warn("MISS " .. a:sub(1, 40)) end end
rep("{ { 0, 75 }, { 1.4, 56 }, { 2.4, 32 }, { 3.2, 30 }, { 4.4, 58 }, { 5.8, 50 }, { 6.8, 29 }, { 7.6, 31 }, { 8.8, 62 }, { 11.5, 120 } }", "{ { 0, 82 }, { 1.4, 64 }, { 2.4, 47 }, { 3.2, 45 }, { 4.4, 66 }, { 5.8, 60 }, { 6.8, 46 }, { 7.6, 47 }, { 8.8, 70 }, { 11.5, 95 } }")
rep("\tshadow.Transparency = 0.75", "\tshadow.Transparency = 1")
rep("math.clamp((52 - distance) / 22, 0, 1)", "math.clamp((68 - distance) / 20, 0, 1)")
rep("\twave.shadow.CFrame = frame * CFrame.new(0, -4, -20) * CFrame.Angles(0, 0, math.pi / 2)\n", "\twave.shadow.CFrame = frame * CFrame.new(0, -4, -20) * CFrame.Angles(0, 0, math.pi / 2)\n\tlocal camera = Workspace.CurrentCamera\n\tif camera then\n\t\tlocal eye = camera.CFrame.Position\n\t\tfor _, ball in wave.balls do\n\t\t\tlocal gap = (ball.part.Position - eye).Magnitude - ball.part.Size.X * 0.5\n\t\t\tball.part.LocalTransparencyModifier = math.clamp(1 - (gap - 4) / 18, 0, 1)\n\t\tend\n\t\tfor _, piece in wave.debris do\n\t\t\tlocal gap = (piece.part.Position - eye).Magnitude\n\t\t\tpiece.part.LocalTransparencyModifier = math.clamp(1 - (gap - 6) / 10, 0, 1)\n\t\tend\n\tend\n")
game:GetService("ScriptEditorService"):UpdateSourceAsync(m, function() return src end) print("AVALANCHE FIX", n)
local L = game:GetService("Lighting") local removed = {}
for _, c in ipairs(L:GetChildren()) do if c:IsA("PostEffect") or c:IsA("Atmosphere") then table.insert(removed, c.ClassName .. ":" .. c.Name) c:Destroy() end end
print("REMOVED", table.concat(removed, ", "), "Brightness was", L.Brightness, "Exposure", L.ExposureCompensation, "Ambient", L.Ambient, "Outdoor", L.OutdoorAmbient)
L.Brightness = 2.4 L.ClockTime = 14.2 L.GeographicLatitude = 30 L.ExposureCompensation = 0 L.Ambient = Color3.fromRGB(96, 108, 130) L.OutdoorAmbient = Color3.fromRGB(150, 160, 182) L.EnvironmentDiffuseScale = 0.55 L.EnvironmentSpecularScale = 0.35 L.GlobalShadows = true L.ShadowSoftness = 0.35 L.ColorShift_Top = Color3.fromRGB(255, 246, 232) L.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
local a = Instance.new("Atmosphere") a.Name = "PenguinAtmosphere" a.Density = 0.26 a.Offset = 0.12 a.Color = Color3.fromRGB(205, 225, 244) a.Decay = Color3.fromRGB(118, 150, 186) a.Glare = 0.12 a.Haze = 0.9 a.Parent = L
local cc = Instance.new("ColorCorrectionEffect") cc.Name = "PenguinColor" cc.Saturation = 0.06 cc.Contrast = 0.07 cc.Brightness = 0.01 cc.TintColor = Color3.fromRGB(255, 252, 247) cc.Parent = L
local b = Instance.new("BloomEffect") b.Name = "PenguinBloom" b.Intensity = 0.32 b.Size = 20 b.Threshold = 1.55 b.Parent = L
local r = Instance.new("SunRaysEffect") r.Name = "PenguinSunRays" r.Intensity = 0.035 r.Spread = 0.55 r.Parent = L
print("LIGHTING SET")
