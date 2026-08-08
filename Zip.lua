-- ========================================
-- ZIP HUB - VIOLENCE DISTRICT
-- VERSION 1.0 (WITH UPDATED ANIMATION)
-- ========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- ========================================
-- VARIABEL
-- ========================================
local espObjects = {}
local autoShootActive = false
local autoGeneratorActive = false
local autoHealActive = false
local flyActive = false
local flyBV = nil
local flySpeed = 50
local menuVisible = false
local noClipActive = false
local noClipConnection = nil

-- ========================================
-- CREATE GUI
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHub"
ScreenGui.ResetOnSpawn = false

-- ========================================
-- ANIMASI INTRO PEMBUKA
-- ========================================
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

-- ASSET ID BARU MILIKMU:
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

local tweenFast = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Jalankan Animasi Pembuka di Background Thread
task.spawn(function()
    TweenService:Create(IntroLogo, tweenFast, {Size = UDim2.new(0, 180, 0, 180)}):Play()
    TweenService:Create(IntroTitle, tweenFast, {TextTransparency = 0}):Play()
    
    task.wait(1.2)
    
    local fadeBg = TweenService:Create(IntroFrame, tweenFast, {BackgroundTransparency = 1})
    TweenService:Create(IntroLogo, tweenFast, {ImageTransparency = 1}):Play()
    IntroTitle.TextTransparency = 1
    
    fadeBg:Play()
    fadeBg.Completed:Wait()
    IntroFrame:Destroy()
end)

-- ========================================
-- LOGO ZIP FRAME (DI POJOK KIRI ATAS)
-- ========================================
local Logo = Instance.new("Frame")
Logo.Parent = ScreenGui
Logo.Size = UDim2.new(0, 55, 0, 55)
Logo.Position = UDim2.new(0, 10, 0, 10)
Logo.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
Logo.BackgroundTransparency = 0.15
Logo.BorderSizePixel = 0
Logo.Visible = true
Logo.ZIndex = 100
Logo.Active = true
Logo.Draggable = true

local LogoCorner = Instance.new("UICorner")
LogoCorner.Parent = Logo
LogoCorner.CornerRadius = UDim.new(1, 0)

local LogoStroke = Instance.new("UIStroke")
LogoStroke.Parent = Logo
LogoStroke.Color = Color3.fromRGB(0, 180, 255)
LogoStroke.Thickness = 2
LogoStroke.Transparency = 0.2

local LogoText = Instance.new("TextLabel")
LogoText.Parent = Logo
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "ZIP"
LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoText.TextSize = 22
LogoText.Font = Enum.Font.GothamBlack
LogoText.TextScaled = true

local LogoGrad = Instance.new("UIGradient")
LogoGrad.Parent = Logo
LogoGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 200))
})
LogoGrad.Rotation = 45

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Parent = ScreenGui
LogoLabel.Size = UDim2.new(0, 60, 0, 16)
LogoLabel.Position = UDim2.new(0, 3, 0, 67)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "ZIP HUB"
LogoLabel.TextColor3 = Color3.fromRGB(0, 180, 255)
LogoLabel.TextSize = 10
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextTransparency = 0.3

-- BUTTON TRANSPARAN DI ATAS FRAME AGAR LOGO FRAME BISA DIKLIK
local LogoClickButton = Instance.new("TextButton")
LogoClickButton.Parent = Logo
LogoClickButton.Size = UDim2.new(1, 0, 1, 0)
LogoClickButton.BackgroundTransparency = 1
LogoClickButton.Text = ""
LogoClickButton.ZIndex = 101

-- ========================================
-- MENU UTAMA
-- ========================================
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 340, 0, 500)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 28)
MainFrame.BackgroundTransparency = 0.08
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ZIndex = 50

local UICorner = Instance.new("UICorner")
UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 14)

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 150, 255)
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3

local GlassBg = Instance.new("Frame")
GlassBg.Parent = MainFrame
GlassBg.Size = UDim2.new(1, 0, 1, 0)
GlassBg.BackgroundColor3 = Color3.fromRGB(20, 20, 55)
GlassBg.BackgroundTransparency = 0.75
GlassBg.BorderSizePixel = 0

-- Logo di menu
local LogoMenu = Instance.new("Frame")
LogoMenu.Parent = MainFrame
LogoMenu.Size = UDim2.new(0, 50, 0, 50)
LogoMenu.Position = UDim2.new(0.5, -25, 0, -25)
LogoMenu.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
LogoMenu.BackgroundTransparency = 0.2
LogoMenu.BorderSizePixel = 0

local LogoMenuCorner = Instance.new("UICorner")
LogoMenuCorner.Parent = LogoMenu
LogoMenuCorner.CornerRadius = UDim.new(1, 0)

local LogoMenuText = Instance.new("TextLabel")
LogoMenuText.Parent = LogoMenu
LogoMenuText.Size = UDim2.new(1, 0, 1, 0)
LogoMenuText.BackgroundTransparency = 1
LogoMenuText.Text = "ZIP"
LogoMenuText.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoMenuText.TextSize = 20
LogoMenuText.Font = Enum.Font.GothamBlack
LogoMenuText.TextScaled = true

local LogoMenuGrad = Instance.new("UIGradient")
LogoMenuGrad.Parent = LogoMenu
LogoMenuGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 200))
})
LogoMenuGrad.Rotation = 45

-- Tombol Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 8)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseBtn
CloseCorner.CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    menuVisible = false
    MainFrame.Visible = false
end)

-- Header
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Parent = MainFrame
HeaderFrame.Size = UDim2.new(1, 0, 0, 55)
HeaderFrame.Position = UDim2.new(0, 0, 0, 20)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(0, 30, 70)
HeaderFrame.BackgroundTransparency = 0.3
HeaderFrame.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = HeaderFrame
HeaderCorner.CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Parent = HeaderFrame
Title.Size = UDim2.new(1, 0, 0, 20)
Title.Position = UDim2.new(0, 0, 0, 32)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ZIP HUB"
Title.TextColor3 = Color3.fromRGB(100, 200, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

-- Scrolling Frame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Size = UDim2.new(1, -16, 1, -90)
ScrollingFrame.Position = UDim2.new(0, 8, 0, 75)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 255)
ScrollingFrame.BorderSizePixel = 0

-- ========================================
-- FUNGSI UI
-- ========================================

local function CreateDivider(yPos)
    local div = Instance.new("Frame")
    div.Parent = ScrollingFrame
    div.Size = UDim2.new(0.9, 0, 0, 1)
    div.Position = UDim2.new(0.05, 0, 0, yPos)
    div.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    div.BackgroundTransparency = 0.7
    div.BorderSizePixel = 0
    return div
end

local function CreateCategory(text, yPos)
    local cat = Instance.new("TextLabel")
    cat.Parent = ScrollingFrame
    cat.Size = UDim2.new(1, -10, 0, 24)
    cat.Position = UDim2.new(0, 0, 0, yPos)
    cat.BackgroundTransparency = 1
    cat.Text = "▸ " .. text
    cat.TextColor3 = Color3.fromRGB(0, 200, 255)
    cat.TextSize = 13
    cat.Font = Enum.Font.GothamBold
    cat.TextXAlignment = Enum.TextXAlignment.Left
    return cat
end

local function CreateToggle(text, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 255)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 8, 0, 0)

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 48, 0, 24)
    toggleBtn.Position = UDim2.new(1, -56, 0, 4)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 10
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleBtn
    toggleCorner.CornerRadius = UDim.new(0, 5)

    local state = false
    local connection

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(180, 40, 40)

        if state then
            local result = callback(state)
            if type(result) == "RBXScriptConnection" then
                connection = result
            end
        else
            if connection then
                connection:Disconnect()
                connection = nil
            end
            callback(state)
        end
    end)

    return toggleBtn
end

local function CreateButton(text, yPos, callback, color)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollingFrame
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(30, 30, 60)
    btn.BackgroundTransparency = 0.4
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==========================================
-- FITUR SCRIPT
-- ==========================================
local yPos = 2

CreateCategory("⚔️ COMBAT", yPos)
yPos = yPos + 28

CreateToggle("🛡️ Auto Parry", yPos, function(state)
    if state then
        return RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        end)
    end
end)
yPos = yPos + 36

CreateToggle("💀 God Mode", yPos, function(state)
    if state then
        return RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
    end
end)
yPos = yPos + 36

CreateToggle("⚡ Speed Hack", yPos, function(state)
    if state then
        return RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
        end)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)
yPos = yPos + 36

ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)

-- ========================================
-- EFEK ANIMASI LOGO FRAME SAAT DIKLIK
-- ========================================
LogoClickButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible

    TweenService:Create(Logo, TweenInfo.new(0.15), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    task.wait(0.15)
    TweenService:Create(Logo, TweenInfo.new(0.15), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)

print("✅ ZIP HUB Loaded Successfully!")
