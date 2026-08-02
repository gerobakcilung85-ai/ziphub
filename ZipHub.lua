-- ========================================
-- ZIP HUB - FULL FEATURES + FLY SPEED 200
-- VERSION 23.0 (FINAL)
-- ========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- ========================================
-- VARIABEL
-- ========================================
local connections = {}
local espObjects = {}
local flyActive = false
local flyBV = nil
local flyLoop = nil
local flySpeed = 200  -- 🔥 SPEED 200!
local noClipActive = false
local noClipConn = nil
local moonWalkActive = false
local moonWalkConn = nil
local invisibleActive = false
local invisibleConn = nil
local autoLootActive = false
local autoClickerActive = false
local jumpBoostActive = false
local antiRagdollActive = false

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
MenuFrame.Size = UDim2.new(0, 440, 0, 680)
MenuFrame.Position = UDim2.new(0.5, -220, 0.5, -340)
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

local function CreateToggle(text, yPos, key, callback)
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
    label.Size = UDim2.new(0.55, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
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
        
        if connections[key] then
            connections[key]:Disconnect()
            connections[key] = nil
        end
        
        callback(state)
    end)
end

-- ========================================
-- 🔥 FIND GATE (10 METODE!)
-- ========================================
local gateKeywords = {
    "gate", "escape", "exit", "door", "win", "finish", 
    "end", "portal", "teleport", "out", "leave", "safe",
    "goal", "complete", "done", "victory", "success", "finishline"
}

function FindEscapeGate()
    local gates = {}
    local searchPlaces = {Workspace, ReplicatedStorage, Lighting, game}
    
    for _, place in pairs(searchPlaces) do
        for _, obj in pairs(place:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local nameLower = obj.Name:lower()
                for _, keyword in pairs(gateKeywords) do
                    if nameLower:find(keyword) then
                        table.insert(gates, obj)
                        break
                    end
                end
                if obj:IsA("BasePart") then
                    local color = obj.BrickColor
                    if color == BrickColor.new("Bright green") or 
                       color == BrickColor.new("Bright yellow") or
                       color == BrickColor.new("Lime green") then
                        table.insert(gates, obj)
                    end
                end
            end
        end
    end
    return gates
end

-- ========================================
-- 🔥 AUTO ESCAPE (TELEPORT KE GATE!)
-- ========================================
function AutoEscape()
    local gates = FindEscapeGate()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then print("❌ Karakter tidak ditemukan!"); return false end

    if #gates > 0 then
        local nearest = nil
        local nearestDist = math.huge
        local gatePos = nil
        
        for _, gate in pairs(gates) do
            local pos = nil
            if gate:IsA("BasePart") then pos = gate.Position
            elseif gate:IsA("Model") and gate:FindFirstChild("PrimaryPart") then pos = gate.PrimaryPart.Position
            elseif gate:IsA("Model") then
                for _, part in pairs(gate:GetDescendants()) do
                    if part:IsA("BasePart") then pos = part.Position; break end
                end
            end
            if pos then
                local dist = (hrp.Position - pos).Magnitude
                if dist < nearestDist then nearestDist = dist; nearest = gate; gatePos = pos end
            end
        end

        if nearest and gatePos then
            hrp.CFrame = CFrame.new(gatePos + Vector3.new(0, 3, 0))
            wait(0.3)
            for i = 1, 20 do
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.05)
                end)
            end
            pcall(function()
                for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then pcall(function() obj:FireServer() end) end
                end
            end)
            print("🚪 Auto Escape Berhasil! Gate di:", gatePos)
            return true
        end
    end
    
    print("❌ Gate tidak ditemukan! Teleport ke luar map...")
    hrp.CFrame = CFrame.new(99999, 99999, 99999)
    return false
end

-- ========================================
-- 🔥 AUTO GENERATOR (INSTANT)
-- ========================================
function AutoGenerator()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen")) then
            local dist = (hrp.Position - obj.Position).Magnitude
            if dist > 10 then hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0)); wait(0.3) end
            for i = 1, 10 do
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.1)
                end)
            end
            pcall(function()
                for _, obj2 in pairs(ReplicatedStorage:GetDescendants()) do
                    if obj2:IsA("RemoteEvent") and obj2.Name:lower():find("generator") then
                        pcall(function() obj2:FireServer(obj) end)
                    end
                end
            end)
            print("⚡ Generator selesai!")
            break
        end
    end
end

-- ========================================
-- 🔥 KILL ALL
-- ========================================
function KillAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = 0
                pcall(function() player.Character:BreakJoints() end)
            end
        end
    end
    print("💀 Semua player/survivor telah dibunuh!")
end

-- ========================================
-- 🔥 FLY MODE (SPEED 200 - BENERAN CEPAT!)
-- ========================================
function StartFly()
    if flyActive then return end
    flyActive = true
    
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        flyActive = false
        return 
    end
    
    if LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = true
    end
    
    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(999999, 999999, 999999)  -- 🔥 FORCE MAX!
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.Parent = hrp
    
    flyLoop = RunService.RenderStepped:Connect(function()
        if not flyActive or not flyBV then return end
        if not LocalPlayer.Character then return end
        
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local cam = Camera.CFrame
        local forward = cam.LookVector * Vector3.new(1, 0, 1)
        local right = cam.RightVector * Vector3.new(1, 0, 1)
        
        if forward.Magnitude > 0 then forward = forward.Unit end
        if right.Magnitude > 0 then right = right.Unit end
        
        local moveDir = Vector3.new()
        local speed = 200  -- 🔥 SPEED 200!
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + forward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - forward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - right
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + right
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir + Vector3.new(0, -1, 0)
        end
        
        if moveDir.Magnitude > 0 then
            flyBV.Velocity = moveDir.Unit * speed
        else
            flyBV.Velocity = Vector3.new(0, 0.5, 0)
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
-- 🔥 INVISIBLE (REAL)
-- ========================================
function StartInvisible()
    if invisibleActive then return end
    invisibleActive = true
    invisibleConn = RunService.RenderStepped:Connect(function()
        if invisibleActive and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1; part.CanCollide = false; part.CastShadow = false
                end
                if part:IsA("Humanoid") then
                    part.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    part.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                end
            end
        end
    end)
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 1; part.CanCollide = false; part.CastShadow = false end
            if part:IsA("Humanoid") then
                part.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                part.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            end
        end
    end
end

function StopInvisible()
    invisibleActive = false
    if invisibleConn then invisibleConn:Disconnect(); invisibleConn = nil end
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.Transparency = 0; part.CanCollide = true; part.CastShadow = true end
            if part:IsA("Humanoid") then
                part.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                part.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
            end
        end
    end
end

-- ========================================
-- 🔥 NO CLIP
-- ========================================
function StartNoClip()
    if noClipActive then return end
    noClipActive = true
    noClipConn = RunService.RenderStepped:Connect(function()
        if noClipActive and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

function StopNoClip()
    noClipActive = false
    if noClipConn then noClipConn:Disconnect(); noClipConn = nil end
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- ========================================
-- 🔥 MOON WALK
-- ========================================
function StartMoonWalk()
    if moonWalkActive then return end
    moonWalkActive = true
    moonWalkConn = RunService.RenderStepped:Connect(function()
        if moonWalkActive and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then humanoid.WalkSpeed = 50; humanoid.JumpPower = 0; humanoid.AutoRotate = false end
        end
    end)
end

function StopMoonWalk()
    moonWalkActive = false
    if moonWalkConn then moonWalkConn:Disconnect(); moonWalkConn = nil end
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.WalkSpeed = 16; humanoid.JumpPower = 50; humanoid.AutoRotate = true end
    end
end

-- ========================================
-- 🔥 FITUR BARU: AUTO LOOT
-- ========================================
function StartAutoLoot()
    if autoLootActive then return end
    autoLootActive = true
    connections.autoLoot = RunService.RenderStepped:Connect(function()
        if autoLootActive and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("loot") or obj.Name:lower():find("item") or obj.Name:lower():find("chest") or obj.Name:lower():find("box")) then
                        local dist = (hrp.Position - obj.Position).Magnitude
                        if dist < 15 then
                            pcall(function()
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton2(Vector2.new())
                                wait(0.2)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

function StopAutoLoot()
    autoLootActive = false
    if connections.autoLoot then
        connections.autoLoot:Disconnect()
        connections.autoLoot = nil
    end
end

-- ========================================
-- 🔥 FITUR BARU: AUTO CLICKER
-- ========================================
function StartAutoClicker()
    if autoClickerActive then return end
    autoClickerActive = true
    connections.autoClicker = RunService.RenderStepped:Connect(function()
        if autoClickerActive then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                wait(0.05)
            end)
        end
    end)
end

function StopAutoClicker()
    autoClickerActive = false
    if connections.autoClicker then
        connections.autoClicker:Disconnect()
        connections.autoClicker = nil
    end
end

-- ========================================
-- 🔥 FITUR BARU: JUMP BOOST
-- ========================================
function StartJumpBoost()
    if jumpBoostActive then return end
    jumpBoostActive = true
    connections.jumpBoost = RunService.RenderStepped:Connect(function()
        if jumpBoostActive and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = 100
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    humanoid.Sit = false
                end
            end
        end
    end)
end

function StopJumpBoost()
    jumpBoostActive = false
    if connections.jumpBoost then
        connections.jumpBoost:Disconnect()
        connections.jumpBoost = nil
    end
    if LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then humanoid.JumpPower = 50 end
    end
end

-- ========================================
-- 🔥 FITUR BARU: ANTI RAGDOLL
-- ========================================
function StartAntiRagdoll()
    if antiRagdollActive then return end
    antiRagdollActive = true
    connections.antiRagdoll = RunService.RenderStepped:Connect(function()
        if antiRagdollActive and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.Sit = false
            end
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.AssemblyLinearVelocity = Vector3.new(0, part.AssemblyLinearVelocity.Y, 0)
                end
            end
        end
    end)
end

function StopAntiRagdoll()
    antiRagdollActive = false
    if connections.antiRagdoll then
        connections.antiRagdoll:Disconnect()
        connections.antiRagdoll = nil
    end
end

-- ========================================
-- 📋 MENU FITUR
-- ========================================
local yPos = 5

-- COMBAT
CreateCategory("⚔️ COMBAT", yPos)
yPos = yPos + 28

CreateToggle("🛡️ Auto Parry", yPos, "autoParry", function(state)
    if state then
        connections.autoParry = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then pcall(function()
                VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new())
            end) end
        end)
    end
end)
yPos = yPos + 36

CreateToggle("💀 God Mode", yPos, "godMode", function(state)
    if state then
        connections.godMode = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
    end
end)
yPos = yPos + 36

CreateToggle("💚 Auto Heal", yPos, "autoHeal", function(state)
    if state then
        connections.autoHeal = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
                end
            end
        end)
    end
end)
yPos = yPos + 36

CreateToggle("🔫 Auto Shoot", yPos, "autoShoot", function(state)
    if state then
        connections.autoShoot = RunService.RenderStepped:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 30 then pcall(function()
                        VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new())
                    end) end
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

CreateButton("⚡ Auto Generator (Instant)", yPos, function() AutoGenerator() end, Color3.fromRGB(0, 100, 0))
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- ESCAPE
CreateCategory("🚪 ESCAPE", yPos)
yPos = yPos + 28

CreateButton("🏆 Auto Escape (Teleport Gate)", yPos, function() AutoEscape() end, Color3.fromRGB(0, 150, 255))
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- ESP
CreateCategory("👁️ ESP", yPos)
yPos = yPos + 28

CreateToggle("🔴 ESP Player", yPos, "espPlayer", function(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0.2
                table.insert(espObjects, highlight)
            end
        end
    else
        for _, obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
        espObjects = {}
    end
end)
yPos = yPos + 36

CreateToggle("🟢 ESP Generator", yPos, "espGenerator", function(state)
    if state then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen")) then
                local highlight = Instance.new("Highlight")
                highlight.Parent = obj.Parent or obj
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
                highlight.OutlineTransparency = 0.2
                table.insert(espObjects, highlight)
            end
        end
    else
        for _, obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
        espObjects = {}
    end
end)
yPos = yPos + 36

CreateToggle("🟡 ESP Gate", yPos, "espGate", function(state)
    if state then
        local gates = FindEscapeGate()
        for _, gate in pairs(gates) do
            local target = gate:IsA("BasePart") and gate or gate.Parent
            local highlight = Instance.new("Highlight")
            highlight.Parent = target or gate
            highlight.FillColor = Color3.fromRGB(255, 255, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0.2
            table.insert(espObjects, highlight)
        end
    else
        for _, obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
        espObjects = {}
    end
end)
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- MOVEMENT
CreateCategory("🏃 MOVEMENT", yPos)
yPos = yPos + 28

CreateToggle("⚡ Speed Hack", yPos, "speedHack", function(state)
    if state then
        connections.speedHack = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
        end)
    else
        if connections.speedHack then connections.speedHack:Disconnect(); connections.speedHack = nil end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)
yPos = yPos + 36

CreateToggle("🕊️ Fly Mode (Speed 200!)", yPos, "fly", function(state)
    if state then StartFly() else StopFly() end
end)
yPos = yPos + 36

CreateToggle("🧱 No Clip", yPos, "noClip", function(state)
    if state then StartNoClip() else StopNoClip() end
end)
yPos = yPos + 36

CreateToggle("🌙 Moon Walk", yPos, "moonWalk", function(state)
    if state then StartMoonWalk() else StopMoonWalk() end
end)
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- STEALTH
CreateCategory("👻 STEALTH", yPos)
yPos = yPos + 28

CreateToggle("👻 Invisible (REAL)", yPos, "invisible", function(state)
    if state then StartInvisible() else StopInvisible() end
end)
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- 🔥 FITUR BARU
CreateCategory("🔥 NEW FEATURES", yPos)
yPos = yPos + 28

CreateToggle("📦 Auto Loot", yPos, "autoLoot", function(state)
    if state then StartAutoLoot() else StopAutoLoot() end
end)
yPos = yPos + 36

CreateToggle("🖱️ Auto Clicker", yPos, "autoClicker", function(state)
    if state then StartAutoClicker() else StopAutoClicker() end
end)
yPos = yPos + 36

CreateToggle("🦘 Jump Boost", yPos, "jumpBoost", function(state)
    if state then StartJumpBoost() else StopJumpBoost() end
end)
yPos = yPos + 36

CreateToggle("🧘 Anti Ragdoll", yPos, "antiRagdoll", function(state)
    if state then StartAntiRagdoll() else StopAntiRagdoll() end
end)
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- KILL ALL
CreateCategory("💀 KILL ALL", yPos)
yPos = yPos + 28

CreateButton("💀 Kill All Instant", yPos, function() KillAll() end, Color3.fromRGB(150, 0, 0))
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
    if autoLootActive then StopAutoLoot() end
    if autoClickerActive then StopAutoClicker() end
    if jumpBoostActive then StopJumpBoost() end
    if antiRagdollActive then StopAntiRagdoll() end
    for key, conn in pairs(connections) do
        if conn then conn:Disconnect(); connections[key] = nil end
    end
    for _, obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
    espObjects = {}
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
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

print("✅ ZIP HUB - FULL FEATURES + FLY SPEED 200 Loaded!")
print("🕊️ Fly Mode: Speed 200 + Gerak Bebas (WASD + Spasi/Shift)")
print("✅ Klik LOGO ZH di pojok kiri atas untuk buka menu!")
