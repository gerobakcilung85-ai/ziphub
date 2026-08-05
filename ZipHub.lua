-- ========================================
-- ZIP HUB - VIOLENCE DISTRICT EDITION
-- VERSION 1.0 (NEW GUI)
-- ========================================

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

-- ========================================
-- 🔥 KONFIGURASI ZIP HUB
-- ========================================
local HUB_NAME = "ZIP HUB"
local VERSION = "1.0"

-- ========================================
-- 🔥 WARNA ZIP
-- ========================================
local COLORS = {
    MAIN = Color3.fromRGB(0, 180, 255),      -- Biru Neon
    SECONDARY = Color3.fromRGB(255, 200, 0), -- Gold
    BACKGROUND = Color3.fromRGB(10, 10, 30),
    GLASS = Color3.fromRGB(30, 30, 60),
    TEXT = Color3.fromRGB(255, 255, 255),
    RED = Color3.fromRGB(255, 0, 0),
    GREEN = Color3.fromRGB(0, 255, 0)
}

-- ========================================
-- 🔥 VARIABEL
-- ========================================
local flyActive = false
local flyBody = nil
local flyConn = nil
local flySpeed = 50

-- ========================================
-- 🎨 GUI
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHubVD"
ScreenGui.ResetOnSpawn = false

-- ========================================
-- 🔥 LOGO ZIP (POJOK KIRI ATAS)
-- ========================================
local Logo = Instance.new("TextButton")
Logo.Parent = ScreenGui
Logo.Size = UDim2.new(0, 60, 0, 60)
Logo.Position = UDim2.new(0, 10, 0, 10)
Logo.BackgroundColor3 = COLORS.MAIN
Logo.BackgroundTransparency = 0.15
Logo.BorderSizePixel = 2
Logo.BorderColor3 = COLORS.MAIN
Logo.Text = "ZIP"
Logo.TextColor3 = COLORS.TEXT
Logo.TextSize = 25
Logo.Font = Enum.Font.GothamBlack
Logo.TextScaled = true
Logo.Active = true
Logo.Draggable = true

local LogoCorner = Instance.new("UICorner")
LogoCorner.Parent = Logo
LogoCorner.CornerRadius = UDim.new(1, 0)

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Parent = ScreenGui
LogoLabel.Size = UDim2.new(0, 60, 0, 16)
LogoLabel.Position = UDim2.new(0, 10, 0, 72)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "ZIP HUB"
LogoLabel.TextColor3 = COLORS.MAIN
LogoLabel.TextSize = 10
LogoLabel.Font = Enum.Font.GothamBold

-- ========================================
-- 🔥 MAIN MENU (MUNCUL SAAT LOGO DIKLIK)
-- ========================================
local MenuFrame = Instance.new("Frame")
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 350, 0, 450)
MenuFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MenuFrame.BackgroundColor3 = COLORS.BACKGROUND
MenuFrame.BackgroundTransparency = 0.05
MenuFrame.BorderSizePixel = 0
MenuFrame.ClipsDescendants = true
MenuFrame.Active = true
MenuFrame.Draggable = true
MenuFrame.Visible = false

local MenuCorner = Instance.new("UICorner")
MenuCorner.Parent = MenuFrame
MenuCorner.CornerRadius = UDim.new(0, 14)

-- Glass Effect
local GlassBg = Instance.new("Frame")
GlassBg.Parent = MenuFrame
GlassBg.Size = UDim2.new(1, 0, 1, 0)
GlassBg.BackgroundColor3 = COLORS.GLASS
GlassBg.BackgroundTransparency = 0.8
GlassBg.BorderSizePixel = 0

-- Border
local MenuBorder = Instance.new("UIStroke")
MenuBorder.Parent = MenuFrame
MenuBorder.Color = COLORS.MAIN
MenuBorder.Thickness = 2
MenuBorder.Transparency = 0.3

-- ========================================
-- 🔥 HEADER MENU
-- ========================================
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Parent = MenuFrame
HeaderFrame.Size = UDim2.new(1, 0, 0, 55)
HeaderFrame.Position = UDim2.new(0, 0, 0, 0)
HeaderFrame.BackgroundColor3 = COLORS.MAIN
HeaderFrame.BackgroundTransparency = 0.2
HeaderFrame.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = HeaderFrame
HeaderCorner.CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Parent = HeaderFrame
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ZIP HUB ⚡"
Title.TextColor3 = COLORS.TEXT
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = HeaderFrame
SubTitle.Size = UDim2.new(1, 0, 0, 18)
SubTitle.Position = UDim2.new(0, 0, 1, -18)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "VIOLENCE DISTRICT"
SubTitle.TextColor3 = Color3.fromRGB(255, 200, 200)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.GothamMedium

-- ========================================
-- 🔥 CLOSE BUTTON
-- ========================================
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = HeaderFrame
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0, 12)
CloseBtn.BackgroundColor3 = COLORS.RED
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = COLORS.TEXT
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseBtn
CloseCorner.CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
end)

-- ========================================
-- 🔥 SCROLLING FRAME
-- ========================================
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MenuFrame
ScrollingFrame.Size = UDim2.new(1, -12, 1, -70)
ScrollingFrame.Position = UDim2.new(0, 6, 0, 65)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = COLORS.MAIN
ScrollingFrame.BorderSizePixel = 0

-- ========================================
-- 🔥 UI FUNCTIONS
-- ========================================

local function CreateCategory(text, yPos)
    local cat = Instance.new("TextLabel")
    cat.Parent = ScrollingFrame
    cat.Size = UDim2.new(1, -10, 0, 24)
    cat.Position = UDim2.new(0, 0, 0, yPos)
    cat.BackgroundTransparency = 1
    cat.Text = "▸ " .. text
    cat.TextColor3 = COLORS.MAIN
    cat.TextSize = 13
    cat.Font = Enum.Font.GothamBold
    cat.TextXAlignment = Enum.TextXAlignment.Left
    return cat
end

local function CreateDivider(yPos)
    local div = Instance.new("Frame")
    div.Parent = ScrollingFrame
    div.Size = UDim2.new(0.9, 0, 0, 1)
    div.Position = UDim2.new(0.05, 0, 0, yPos)
    div.BackgroundColor3 = COLORS.MAIN
    div.BackgroundTransparency = 0.5
    div.BorderSizePixel = 0
    return div
end

local function CreateToggle(text, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = COLORS.GLASS
    frame.BackgroundTransparency = 0.4
    frame.BorderSizePixel = 1
    frame.BorderColor3 = COLORS.MAIN

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = COLORS.TEXT
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 48, 0, 24)
    toggleBtn.Position = UDim2.new(1, -56, 0, 4)
    toggleBtn.BackgroundColor3 = COLORS.RED
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = COLORS.TEXT
    toggleBtn.TextSize = 10
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleBtn
    toggleCorner.CornerRadius = UDim.new(0, 5)

    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and COLORS.GREEN or COLORS.RED
        callback(state)
    end)

    return toggleBtn
end

local function CreateButton(text, yPos, callback, color)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollingFrame
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 70)
    btn.BackgroundTransparency = 0.3
    btn.Text = text
    btn.TextColor3 = COLORS.TEXT
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 1
    btn.BorderColor3 = COLORS.MAIN

    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ========================================
-- 🔥 FITUR-FITUR
-- ========================================
local yPos = 5

-- COMBAT
CreateCategory("⚔️ COMBAT", yPos)
yPos = yPos + 28

CreateToggle("🛡️ Auto Parry", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
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
        RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
    end
end)
yPos = yPos + 36

CreateButton("💥 One Hit Kill", yPos, function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end, Color3.fromRGB(100, 0, 0))
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- MOVEMENT
CreateCategory("🏃 MOVEMENT", yPos)
yPos = yPos + 28

CreateToggle("⚡ Speed Hack", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
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

CreateToggle("🕊️ Fly Mode", yPos, function(state)
    if state then
        if flyActive then return end
        flyActive = true
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then flyActive = false; return end
        flyBody = Instance.new("BodyVelocity")
        flyBody.MaxForce = Vector3.new(100000, 100000, 100000)
        flyBody.Velocity = Vector3.new(0, 0, 0)
        flyBody.Parent = hrp
        flyConn = RunService.RenderStepped:Connect(function()
            if not flyActive then return end
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector * Vector3.new(1,0,1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector * Vector3.new(1,0,1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector * Vector3.new(1,0,1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector * Vector3.new(1,0,1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0,-1,0) end
            if moveDir.Magnitude > 0 then flyBody.Velocity = moveDir.Unit * 50 else flyBody.Velocity = Vector3.new(0,0.5,0) end
        end)
    else
        flyActive = false
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if flyBody then flyBody:Destroy(); flyBody = nil end
    end
end)
yPos = yPos + 36

CreateToggle("🧱 No Clip", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    else
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end)
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- UTILITY
CreateCategory("🔧 UTILITY", yPos)
yPos = yPos + 28

CreateButton("🔄 Reset Karakter", yPos, function()
    if flyActive then
        flyActive = false
        if flyConn then flyConn:Disconnect(); flyConn = nil end
        if flyBody then flyBody:Destroy(); flyBody = nil end
    end
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
end, Color3.fromRGB(80, 30, 30))
yPos = yPos + 36

-- Update Canvas
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ========================================
-- 🔥 LOGO KLIK → MENU MUNCUL
-- ========================================
Logo.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
end)

-- ========================================
-- 🔥 WATERMARK
-- ========================================
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 180, 0, 18)
Watermark.Position = UDim2.new(0, 8, 1, -25)
Watermark.BackgroundTransparency = 1
Watermark.Text = "⚡ ZIP HUB"
Watermark.TextColor3 = COLORS.MAIN
Watermark.TextSize = 10
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextTransparency = 0.4

print("✅ ZIP HUB - Violence District Loaded!")
print("✅ Klik LOGO ZIP untuk buka menu!")
