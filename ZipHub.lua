-- Denoting2 HUB -- UI สวยขึ้น + เปิดปิดเมนู + เอฟเฟกต์เนียนๆ local Players = 
game:GetService("Players") local Lighting = game:GetService("Lighting") local 
RunService = game:GetService("RunService") local TweenService = 
game:GetService("TweenService") local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer local Camera = workspace.CurrentCamera 
-- STATES local ESP_ON = false local TRACER_ON = false local FULLBRIGHT_ON = 
false local ALERT_ON = false local highlights = {} local tracers = {} local 
lastAlert = 0 -- GUI local gui = Instance.new("ScreenGui") gui.Parent = 
game.CoreGui gui.Name = "Denoting2" -- ปุ่มเปิดเมนู local openBtn = 
Instance.new("TextButton") openBtn.Parent = gui openBtn.Size = 
UDim2.new(0,55,0,55) openBtn.Position = UDim2.new(0,15,0.5,-27) 
openBtn.BackgroundColor3 = Color3.fromRGB(25,25,35) openBtn.Text = "☰" 
openBtn.TextColor3 = Color3.new(1,1,1) openBtn.Font = Enum.Font.GothamBold 
openBtn.TextSize = 24 openBtn.Active = true openBtn.Draggable = true 
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(1,0) -- Glow local 
stroke = Instance.new("UIStroke", openBtn) stroke.Color = 
Color3.fromRGB(120,120,255) stroke.Thickness = 2 -- Main local frame = 
Instance.new("Frame") frame.Parent = gui frame.Size = UDim2.new(0,260,0,370) 
frame.Position = UDim2.new(0,80,0.5,-185) frame.BackgroundColor3 = 
Color3.fromRGB(18,18,28) frame.Visible = true frame.Active = true 
frame.Draggable = true Instance.new("UICorner", frame).CornerRadius = 
UDim.new(0,16) local frameStroke = Instance.new("UIStroke", frame) 
frameStroke.Color = Color3.fromRGB(90,90,255) frameStroke.Thickness = 2 -- 
Gradient local grad = Instance.new("UIGradient", frame) grad.Color = 
ColorSequence.new{ ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,35)), 
ColorSequenceKeypoint.new(1, Color3.fromRGB(35,35,60)) } -- Title local title = 
Instance.new("TextLabel") title.Parent = frame title.Size = UDim2.new(1,0,0,45) 
title.BackgroundTransparency = 1 title.Text = " Denoting2 HUB" title.TextColor3 
= Color3.fromRGB(255,255,255) title.Font = Enum.Font.GothamBlack title.TextSize 
= 24 -- Divider local line = Instance.new("Frame") line.Parent = frame line.Size
= UDim2.new(0.85,0,0,2) line.Position = UDim2.new(0.075,0,0,45) 
line.BackgroundColor3 = Color3.fromRGB(100,100,255) line.BorderSizePixel = 0 -- 
Layout local holder = Instance.new("Frame") holder.Parent = frame 
holder.BackgroundTransparency = 1 holder.Size = UDim2.new(1,0,1,-55) 
holder.Position = UDim2.new(0,0,0,55) local layout = 
Instance.new("UIListLayout", holder) layout.Padding = UDim.new(0,8) 
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center -- เปิดปิดเมนู 
openBtn.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible 
end) -- Button Creator function CreateButton(text, callback) local btn = ...
