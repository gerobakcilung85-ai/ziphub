-- ========================================
-- ZIP HUB - FULL FEATURES + FIX FLY
-- VERSION 11.0
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
local flyBV = nil
local flyLoop = nil
local flyActive = false
local noClipConn = nil
local noClipActive = false
local moonWalkConn = nil
local moonWalkActive = false
local invisibleActive = false
local invisibleConn = nil

-- ========================================
-- GUI SETUP
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHubGUI"
ScreenGui.ResetOnSpawn = false

-- ========================================
-- LOGO
-- ========================================
local Logo = Instance.new("TextButton")
Logo.Parent = ScreenGui
Logo.Size = UDim2.new(0, 60, 0, 60)
Logo.Position = UDim2.new(0, 10, 0, 10)
Logo.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Logo.BackgroundTransparency = 0
Logo.BorderSizePixel = 3
Logo.BorderColor3 = Color3.fromRGB(255, 255, 255)
Logo.Text = "ZH"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
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
LogoLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
LogoLabel.TextSize = 10
LogoLabel.Font = Enum.Font.GothamBold

-- ========================================
-- MENU UTAMA
-- ========================================
local MenuFrame = Instance.new("Frame")
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 380, 0, 520)
MenuFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
MenuFrame.BackgroundTransparency = 0
MenuFrame.BorderSizePixel = 3
MenuFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MenuFrame.Visible = false
MenuFrame.Active = true
MenuFrame.Draggable = true

local MenuCorner = Instance.new("UICorner")
MenuCorner.Parent = MenuFrame
MenuCorner.CornerRadius = UDim.new(0, 12)

-- HEADER
local MenuHeader = Instance.new("Frame")
MenuHeader.Parent = MenuFrame
MenuHeader.Size = UDim2.new(1, 0, 0, 40)
MenuHeader.Position = UDim2.new(0, 0, 0, 0)
MenuHeader.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
MenuHeader.BackgroundTransparency = 0
MenuHeader.BorderSizePixel = 0

local MenuHeaderCorner = Instance.new("UICorner")
MenuHeaderCorner.Parent = MenuHeader
MenuHeaderCorner.CornerRadius = UDim.new(0, 12)

local MenuTitle = Instance.new("TextLabel")
MenuTitle.Parent = MenuHeader
MenuTitle.Size = UDim2.new(1, 0, 1, 0)
MenuTitle.BackgroundTransparency = 1
MenuTitle.Text = "⚡ ZIP HUB ⚡"
MenuTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuTitle.TextSize = 20
MenuTitle.Font = Enum.Font.GothamBold

local MenuClose = Instance.new("TextButton")
MenuClose.Parent = MenuHeader
MenuClose.Size = UDim2.new(0, 30, 0, 30)
MenuClose.Position = UDim2.new(1, -35, 0, 5)
MenuClose.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
MenuClose.Text = "✕"
MenuClose.TextColor3 = Color3.fromRGB(255, 255, 255)
MenuClose.TextSize = 16
MenuClose.Font = Enum.Font.GothamBold
MenuClose.BorderSizePixel = 0

local MenuCloseCorner = Instance.new("UICorner")
MenuCloseCorner.Parent = MenuClose
MenuCloseCorner.CornerRadius = UDim.new(1, 0)

MenuClose.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
end)

-- SCROLLING
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MenuFrame
ScrollingFrame.Size = UDim2.new(1, -10, 1, -50)
ScrollingFrame.Position = UDim2.new(0, 5, 0, 45)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
ScrollingFrame.BorderSizePixel = 0

-- ========================================
-- FUNGSI UI
-- ========================================
local function CreateCategory(text, yPos)
    local cat = Instance.new("TextLabel")
    cat.Parent = ScrollingFrame
    cat.Size = UDim2.new(1, -10, 0, 25)
    cat.Position = UDim2.new(0, 0, 0, yPos)
    cat.BackgroundTransparency = 1
    cat.Text = "▸ " .. text
    cat.TextColor3 = Color3.fromRGB(255, 100, 100)
    cat.TextSize = 14
    cat.Font = Enum.Font.GothamBold
    cat.TextXAlignment = Enum.TextXAlignment.Left
    return cat
end

local function CreateDivider(yPos)
    local div = Instance.new("Frame")
    div.Parent = ScrollingFrame
    div.Size = UDim2.new(0.9, 0, 0, 2)
    div.Position = UDim2.new(0.05, 0, 0, yPos)
    div.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    div.BackgroundTransparency = 0
    div.BorderSizePixel = 0
    return div
end

local function CreateButton(text, yPos, callback, color)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollingFrame
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
    btn.BackgroundTransparency = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(255, 0, 0)

    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(text, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 32)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 0, 0)

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 8, 0, 0)

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 50, 0, 24)
    toggleBtn.Position = UDim2.new(1, -58, 0, 4)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleBtn
    toggleCorner.CornerRadius = UDim.new(0, 5)

    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        callback(state)
    end)
end

-- ========================================
-- 🔥 FUNGSI FLY (FIX)
-- ========================================
function StartFly()
    if flyActive then return end
    flyActive = true
    
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        flyActive = false
        return 
    end
    
    -- Matikan gravitasi
    if LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = true
    end
    
    -- Buat BodyVelocity
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.Parent = hrp
    
    -- Loop terbang
    flyLoop = RunService.RenderStepped:Connect(function()
        if not flyActive or not flyBV then return end
        if not LocalPlayer.Character then return end
        
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local moveDir = Vector3.new()
        local cam = Camera.CFrame
        
        -- Kontrol WASD
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.LookVector * Vector3.new(1, 0, 1)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.LookVector * Vector3.new(1, 0, 1)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.RightVector * Vector3.new(1, 0, 1)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.RightVector * Vector3.new(1, 0, 1)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir + Vector3.new(0, -1, 0)
        end
        
        -- Set kecepatan
        if moveDir.Magnitude > 0 then
            flyBV.Velocity = moveDir.Unit * 50
        else
            flyBV.Velocity = Vector3.new(0, 0.5, 0) -- Hover
        end
    end)
end

function StopFly()
    flyActive = false
    if flyLoop then
        flyLoop:Disconnect()
        flyLoop = nil
    end
    if flyBV then
        flyBV:Destroy()
        flyBV = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

-- ========================================
-- 🔥 FUNGSI NO CLIP
-- ========================================
function StartNoClip()
    if noClipActive then return end
    noClipActive = true
    noClipConn = RunService.RenderStepped:Connect(function()
        if noClipActive and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function StopNoClip()
    noClipActive = false
    if noClipConn then
        noClipConn:Disconnect()
        noClipConn = nil
    end
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- ========================================
-- 🔥 FUNGSI MOON WALK
-- ========================================
function StartMoonWalk()
    if moonWalkActive then return end
    moonWalkActive = true
    moonWalkConn = RunService.RenderStepped:Connect(function()
        if moonWalkActive and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 50
                humanoid.JumpPower = 0
                humanoid.AutoRotate = false
            end
        end
    end)
end

function StopMoonWalk()
    moonWalkActive = false
    if moonWalkConn then
        moonWalkConn:Disconnect()
        moonWalkConn = nil
    end
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
            humanoid.AutoRotate = true
        end
    end
end

-- ========================================
-- 👻 FUNGSI INVISIBLE (BARU!)
-- ========================================
function StartInvisible()
    if invisibleActive then return end
    invisibleActive = true
    
    -- Bikin karakter transparan
    invisibleConn = RunService.RenderStepped:Connect(function()
        if invisibleActive and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
                if part:IsA("Accessory") then
                    part.Handle.Transparency = 1
                end
            end
            -- Sembunyiin nametag
            if LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            end
        end
    end)
end

function StopInvisible()
    invisibleActive = false
    if invisibleConn then
        invisibleConn:Disconnect()
        invisibleConn = nil
    end
    -- Balikin transparansi
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
            if part:IsA("Accessory") then
                part.Handle.Transparency = 0
            end
        end
        if LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
        end
    end
end

-- ========================================
-- 🔄 AUTO GENERATOR
-- ========================================
function AutoGenerator()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen")) then
            local dist = (hrp.Position - obj.Position).Magnitude
            if dist < 15 then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.5)
                end)
            else
                pcall(function()
                    hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                end)
            end
            break
        end
    end
end

-- ========================================
-- 🚪 AUTO ESCAPE
-- ========================================
function AutoEscape()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("gate") or obj.Name:lower():find("escape") or obj.Name:lower():find("door")) then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                wait(0.5)
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
                return
            end
        end
    end
end

-- ========================================
-- 💀 KILL ALL
-- ========================================
function KillAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
            pcall(function()
                player.Character:BreakJoints()
            end)
        end
    end
    print("💀 Semua player/survivor telah dibunuh!")
end

-- ========================================
-- 📋 MENU FITUR
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

CreateToggle("💚 Auto Heal", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            end
        end)
    end
end)
yPos = yPos + 36

CreateToggle("🔫 Auto Shoot", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 30 then
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton2(Vector2.new())
                        end)
                    end
                end
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

-- GENERATOR
CreateCategory("⚡ GENERATOR", yPos)
yPos = yPos + 28

CreateToggle("🔄 Auto Generator", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
            if state then
                AutoGenerator()
            end
        end)
    end
end)
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- ESCAPE
CreateCategory("🚪 ESCAPE", yPos)
yPos = yPos + 28

CreateToggle("🚪 Auto Escape", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
            if state then
                AutoEscape()
            end
        end)
    end
end)
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

CreateToggle("🕊️ Fly Mode (FIX)", yPos, function(state)
    if state then
        StartFly()
    else
        StopFly()
    end
end)
yPos = yPos + 36

CreateToggle("🧱 No Clip", yPos, function(state)
    if state then
        StartNoClip()
    else
        StopNoClip()
    end
end)
yPos = yPos + 36

CreateToggle("🌙 Moon Walk", yPos, function(state)
    if state then
        StartMoonWalk()
    else
        StopMoonWalk()
    end
end)
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- STEALTH
CreateCategory("👻 STEALTH", yPos)
yPos = yPos + 28

CreateToggle("👻 Invisible", yPos, function(state)
    if state then
        StartInvisible()
    else
        StopInvisible()
    end
end)
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- KILL ALL
CreateCategory("💀 KILL ALL", yPos)
yPos = yPos + 28

CreateButton("💀 Kill All Instant", yPos, function()
    KillAll()
end, Color3.fromRGB(150, 0, 0))
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- UTILITY
CreateCategory("🔧 UTILITY", yPos)
yPos = yPos + 28

CreateButton("🔄 Reset Karakter", yPos, function()
    if flyActive then StopFly() end
    if noClipActive then StopNoClip() end
    if moonWalkActive then StopMoonWalk() end
    if invisibleActive then StopInvisible() end
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end, Color3.fromRGB(100, 0, 0))
yPos = yPos + 36

-- Update Canvas
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ========================================
-- LOGO KLIK → MENU MUNCUL
-- ========================================
Logo.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
    print("Logo ZH diklik! Menu Visible:", MenuFrame.Visible)
end)

print("✅ ZIP HUB - FULL FEATURES + FIX FLY Loaded!")
print("✅ Fitur: Auto Generator, Auto Escape, Invisible, Fly FIX!")
print("✅ Klik LOGO ZH di pojok kiri atas untuk buka menu!")
