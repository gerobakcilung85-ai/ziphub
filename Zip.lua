local Zip = {}
Zip.__index = Zip

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- FUNGSI UNTUK INTRO ANIMASI LOGO ZIP
function Zip:PlayIntro()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ZIP_Intro"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Background = Instance.new("Frame")
    Background.Size = UDim2.new(1, 0, 1, 0)
    Background.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    Background.BorderSizePixel = 0
    Background.Parent = ScreenGui

    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0, 0, 0, 0)
    Logo.Position = UDim2.new(0.5, 0, 0.45, 0)
    Logo.AnchorPoint = Vector2.new(0.5, 0.5)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://116320933958553"
    Logo.Parent = Background

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 300, 0, 40)
    Title.Position = UDim2.new(0.5, 0, 0.65, 0)
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.BackgroundTransparency = 1
    Title.Text = "ZIP EXECUTOR SCRIPT HUB"
    Title.TextColor3 = Color3.fromRGB(0, 225, 255)
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextTransparency = 1
    Title.Parent = Background

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    
    TweenService:Create(Logo, tweenInfo, {Size = UDim2.new(0, 200, 0, 200)}):Play()
    TweenService:Create(Title, tweenInfo, {TextTransparency = 0}):Play()

    task.wait(1.2)

    local fadeBg = TweenService:Create(Background, tweenInfo, {BackgroundTransparency = 1})
    TweenService:Create(Logo, tweenInfo, {ImageTransparency = 1}):Play()
    Title.TextTransparency = 1

    fadeBg:Play()
    fadeBg.Completed:Wait()
    ScreenGui:Destroy()
end

-- CARA PEMANGGILAN DENGAN NAMA 'Zip':
Zip:PlayIntro() -- Menjalankan Animasi Intro ZIP

-- Nanti di bawah ini kamu tinggal lanjutin struktur window library Zip kamu:
-- function Zip:CreateWindow(title)
--     ...
-- end

return Zip