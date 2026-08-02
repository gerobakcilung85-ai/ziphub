-- ========================================
-- ZIP HUB - VIOLENCE DISTRICT
-- VERSION 3.0 (FIX LAYAR)
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
-- LOGO (TextButton biar gampang diklik)
-- ========================================
local Logo = Instance.new("TextButton")
Logo.Parent = ScreenGui
Logo.Size = UDim2.new(0, 55, 0, 55)
Logo.Position = UDim2.new(0, 10, 0, 10)
Logo.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Logo.BackgroundTransparency = 0
Logo.BorderSizePixel = 2
Logo.BorderColor3 = Color3.fromRGB(255, 255, 255)
Logo.Visible = true
Logo.ZIndex = 100
Logo.Text = "ZH"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 22
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
LogoLabel.Position = UDim2.new(0, 3, 0, 67)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "ZIP HUB"
LogoLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
LogoLabel.TextSize = 10
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.TextTransparency = 0

-- ========================================
-- MENU UTAMA (TERANG & JELAS)
-- ========================================
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 380, 0, 520)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 50, 50)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ZIndex = 50

local UICorner = Instance.new("UICorner")
UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 8)

-- Header Merah
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Parent = MainFrame
HeaderFrame.Size = UDim2.new(1, 0, 0, 50)
HeaderFrame.Position = UDim2.new(0, 0, 0, 0)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
HeaderFrame.BackgroundTransparency = 0.8
HeaderFrame.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = HeaderFrame
HeaderCorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = HeaderFrame
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ZIP HUB ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = HeaderFrame
SubTitle.Size = UDim2.new(1, 0, 0, 18)
SubTitle.Position = UDim2.new(0, 0, 1, -20)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "VIOLENCE DISTRICT"
SubTitle.TextColor3 = Color3.fromRGB(255, 200, 200)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.GothamMedium

-- Tombol Close (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = HeaderFrame
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 9)
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

-- Scrolling Frame
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Size = UDim2.new(1, -16, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 8, 0, 55)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 4
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
ScrollingFrame.BorderSizePixel = 0

-- ========================================
-- FUNGSI UI (TERANG & JELAS)
-- ========================================

local function CreateDivider(yPos)
    local div = Instance.new("Frame")
    div.Parent = ScrollingFrame
    div.Size = UDim2.new(0.9, 0, 0, 2)
    div.Position = UDim2.new(0.05, 0, 0, yPos)
    div.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    div.BackgroundTransparency = 0
    div.BorderSizePixel = 0
    return div
end

local function CreateCategory(text, yPos)
    local cat = Instance.new("TextLabel")
    cat.Parent = ScrollingFrame
    cat.Size = UDim2.new(1, -10, 0, 28)
    cat.Position = UDim2.new(0, 0, 0, yPos)
    cat.BackgroundTransparency = 1
    cat.Text = "▸ " .. text
    cat.TextColor3 = Color3.fromRGB(255, 80, 80)
    cat.TextSize = 14
    cat.Font = Enum.Font.GothamBold
    cat.TextXAlignment = Enum.TextXAlignment.Left
    return cat
end

local function CreateToggle(text, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 34)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(255, 50, 50)

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
    label.Position = UDim2.new(0, 10, 0, 0)

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 55, 0, 26)
    toggleBtn.Position = UDim2.new(1, -62, 0, 4)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleBtn
    toggleCorner.CornerRadius = UDim.new(0, 6)

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
    btn.Size = UDim2.new(1, -10, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color or Color3.fromRGB(50, 50, 75)
    btn.BackgroundTransparency = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(255, 50, 50)

    local corner = Instance.new("UICorner")
    corner.Parent = btn
    corner.CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ========================================
-- FUNGSI ESP
-- ========================================
local function CreateESP(player, espType)
    if not player.Character then return end

    local highlight = Instance.new("Highlight")
    highlight.Parent = player.Character
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0.2

    if espType == "killer" then
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    elseif espType == "generator" then
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
    else
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end

    table.insert(espObjects, highlight)
end

-- ========================================
-- FUNGSI FLY
-- ========================================
local function StartFly()
    if flyActive then return end
    flyActive = true

    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.Parent = hrp

    RunService.RenderStepped:Connect(function()
        if not flyActive or not flyBV then return end
        if not LocalPlayer.Character then return end

        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local moveDir = Vector3.new()
        local cameraCF = Camera.CFrame
        local forward = cameraCF.LookVector
        local right = cameraCF.RightVector

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + Vector3.new(forward.X, 0, forward.Z).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - Vector3.new(forward.X, 0, forward.Z).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - Vector3.new(right.X, 0, right.Z).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + Vector3.new(right.X, 0, right.Z).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir + Vector3.new(0, -1, 0)
        end

        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * flySpeed
        end

        flyBV.Velocity = moveDir
    end)
end

local function StopFly()
    flyActive = false
    if flyBV then
        flyBV:Destroy()
        flyBV = nil
    end
end

-- ========================================
-- FUNGSI NO CLIP
-- ========================================
local function StartNoClip()
    if noClipActive then return end
    noClipActive = true

    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    noClipConnection = RunService.RenderStepped:Connect(function()
        if noClipActive and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function StopNoClip()
    noClipActive = false
    if noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
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
-- FITUR-FITUR
-- ========================================
local yPos = 2

-- COMBAT
CreateCategory("⚔️ COMBAT", yPos)
yPos = yPos + 30

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
yPos = yPos + 38

CreateToggle("💀 God Mode", yPos, function(state)
    if state then
        return RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
    end
end)
yPos = yPos + 38

CreateToggle("💚 Auto Heal", yPos, function(state)
    autoHealActive = state
    if state then
        RunService.RenderStepped:Connect(function()
            if autoHealActive and LocalPlayer.Character then
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
yPos = yPos + 38

CreateToggle("🔫 Auto Shoot", yPos, function(state)
    autoShootActive = state
    if state then
        return RunService.RenderStepped:Connect(function()
            if autoShootActive then
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
            end
        end)
    end
end)
yPos = yPos + 38

CreateButton("💥 One Hit Kill", yPos, function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end, Color3.fromRGB(80, 30, 30))
yPos = yPos + 38

CreateDivider(yPos)
yPos = yPos + 12

-- TELEPORT
CreateCategory("📦 TELEPORT", yPos)
yPos = yPos + 30

CreateButton("🎯 Ke Player Terdekat", yPos, function()
    local nearest = nil
    local shortDist = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortDist then
                shortDist = dist
                nearest = player
            end
        end
    end
    if nearest and nearest.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = nearest.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, -3)
    end
end, Color3.fromRGB(30, 50, 90))
yPos = yPos + 38

CreateButton("⚡ Ke Generator", yPos, function()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen")) then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
            return
        end
    end
end, Color3.fromRGB(30, 70, 50))
yPos = yPos + 38

CreateButton("🏠 Ke Spawn", yPos, function()
    local spawn = Workspace:FindFirstChild("SpawnLocation")
    if spawn then
        LocalPlayer.Character.HumanoidRootPart.CFrame = spawn.CFrame * CFrame.new(0, 3, 0)
    end
end, Color3.fromRGB(50, 50, 90))
yPos = yPos + 38

CreateDivider(yPos)
yPos = yPos + 12

-- ESP
CreateCategory("👁️ ESP", yPos)
yPos = yPos + 30

CreateToggle("🔴 ESP Player", yPos, function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateESP(player, "normal")
            end
        end
    else
        for _, obj in pairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
        espObjects = {}
    end
end)
yPos = yPos + 38

CreateToggle("🔴 ESP Killer", yPos, function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                CreateESP(player, "killer")
            end
        end
    else
        for _, obj in pairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
        espObjects = {}
    end
end)
yPos = yPos + 38

CreateToggle("🟢 ESP Generator", yPos, function(state)
    if state then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen")) then
                local highlight = Instance.new("Highlight")
                highlight.Parent = obj.Parent or obj
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.FillTransparency = 0.4
                highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
                table.insert(espObjects, highlight)
            end
        end
    else
        for _, obj in pairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
        espObjects = {}
    end
end)
yPos = yPos + 38

CreateDivider(yPos)
yPos = yPos + 12

-- GENERATOR
CreateCategory("⚡ GENERATOR", yPos)
yPos = yPos + 30

CreateToggle("🔄 Auto Generator", yPos, function(state)
    autoGeneratorActive = state
    if state then
        return RunService.RenderStepped:Connect(function()
            if autoGeneratorActive then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen")) then
                        if obj.Parent and obj.Parent:FindFirstChild("Humanoid") == nil then
                            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                            if dist < 10 then
                                pcall(function()
                                    VirtualUser:CaptureController()
                                    VirtualUser:ClickButton2(Vector2.new())
                                    wait(0.5)
                                end)
                            else
                                pcall(function()
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                                end)
                            end
                        end
                    end
                end
            end
        end)
    end
end)
yPos = yPos + 38

CreateButton("📦 Drop All Palette", yPos, function()
    local inventory = LocalPlayer:FindFirstChild("Inventory")
    if inventory then
        for _, item in pairs(inventory:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Palette") then
                pcall(function()
                    item.Parent = Workspace
                end)
            end
        end
    end
end, Color3.fromRGB(90, 50, 30))
yPos = yPos + 38

CreateDivider(yPos)
yPos = yPos + 12

-- MOVEMENT
CreateCategory("🏃 MOVEMENT", yPos)
yPos = yPos + 30

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
yPos = yPos + 38

CreateToggle("🕊️ Fly Mode (WASD+Spasi/Shift)", yPos, function(state)
    if state then
        StartFly()
    else
        StopFly()
    end
end)
yPos = yPos + 38

CreateToggle("🧱 No Clip", yPos, function(state)
    if state then
        StartNoClip()
    else
        StopNoClip()
    end
end)
yPos = yPos + 38

CreateButton("🚀 Speed +10", yPos, function()
    flySpeed = math.min(flySpeed + 10, 150)
end, Color3.fromRGB(30, 70, 90))
yPos = yPos + 38

CreateButton("🐢 Speed -10", yPos, function()
    flySpeed = math.max(flySpeed - 10, 10)
end, Color3.fromRGB(90, 50, 30))
yPos = yPos + 38

CreateDivider(yPos)
yPos = yPos + 12

-- FARM
CreateCategory("🌾 FARM", yPos)
yPos = yPos + 30

CreateToggle("🤖 Auto Farm", yPos, function(state)
    if state then
        return RunService.RenderStepped:Connect(function()
            local nearest = nil
            local shortDist = math.huge
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist < shortDist and dist < 50 then
                        shortDist = dist
                        nearest = player.Character
                    end
                end
            end
            if nearest then
                LocalPlayer.Character.HumanoidRootPart.CFrame = nearest.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                wait(0.1)
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        end)
    end
end)
yPos = yPos + 38

CreateDivider(yPos)
yPos = yPos + 12

-- UTILITY
CreateCategory("🔧 UTILITY", yPos)
yPos = yPos + 30

CreateButton("🔄 Reset Karakter", yPos, function()
    if noClipActive then
        StopNoClip()
    end
    LocalPlayer.Character:BreakJoints()
end, Color3.fromRGB(80, 40, 40))
yPos = yPos + 38

-- Update Canvas
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ========================================
-- 🔥 LOGO KLIK → MENU MUNCUL
-- ========================================
Logo.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    print("Logo ZH diklik! Menu:", menuVisible)

    TweenService:Create(Logo, TweenInfo.new(0.15), {Size = UDim2.new(0, 60, 0, 60)}):Play()
    task.wait(0.15)
    TweenService:Create(Logo, TweenInfo.new(0.15), {Size = UDim2.new(0, 55, 0, 55)}):Play()
end)

-- ========================================
-- WATERMARK
-- ========================================
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 180, 0, 18)
Watermark.Position = UDim2.new(0, 8, 1, -25)
Watermark.BackgroundTransparency = 1
Watermark.Text = "⚡ ZIP HUB"
Watermark.TextColor3 = Color3.fromRGB(255, 50, 50)
Watermark.TextSize = 11
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextTransparency = 0

print("✅ ZIP HUB FIX Loaded!")
print("✅ Klik LOGO ZH di pojok kiri atas untuk buka menu!")
