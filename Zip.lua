local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- CREATE GUI INTRO
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZIP_IntroGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local IntroFrame = Instance.new("Frame")
IntroFrame.Parent = ScreenGui
IntroFrame.Size = UDim2.new(1, 0, 1, 0)
IntroFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
IntroFrame.BorderSizePixel = 0
IntroFrame.ZIndex = 999

local IntroLogo = Instance.new("ImageLabel")
IntroLogo.Parent = IntroFrame
IntroLogo.Size = UDim2.new(0, 0, 0, 0)
IntroLogo.Position = UDim2.new(0.5, 0, 0.45, 0)
IntroLogo.AnchorPoint = Vector2.new(0.5, 0.5)
IntroLogo.BackgroundTransparency = 1
IntroLogo.Image = "rbxassetid://127108636160194"

local IntroTitle = Instance.new("TextLabel")
IntroTitle.Parent = IntroFrame
IntroTitle.Size = UDim2.new(0, 300, 0, 40)
IntroTitle.Position = UDim2.new(0.5, 0, 0.65, 0)
IntroTitle.AnchorPoint = Vector2.new(0.5, 0.5)
IntroTitle.BackgroundTransparency = 1
IntroTitle.Text = "ZIP EXECUTOR SCRIPT HUB"
IntroTitle.TextColor3 = Color3.fromRGB(0, 225, 255)
IntroTitle.TextSize = 18
IntroTitle.Font = Enum.Font.GothamBold
IntroTitle.TextTransparency = 1

local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- JALANKAN ANIMASI
TweenService:Create(IntroLogo, tweenInfo, {Size = UDim2.new(0, 180, 0, 180)}):Play()
TweenService:Create(IntroTitle, tweenInfo, {TextTransparency = 0}):Play()

task.wait(1.5)

local fadeBg = TweenService:Create(IntroFrame, tweenInfo, {BackgroundTransparency = 1})
TweenService:Create(IntroLogo, tweenInfo, {ImageTransparency = 1}):Play()
IntroTitle.TextTransparency = 1

fadeBg:Play()
fadeBg.Completed:Wait()
ScreenGui:Destroy()
