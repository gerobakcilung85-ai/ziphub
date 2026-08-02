-- ========================================
-- ZIP HUB - FINAL FIX
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
-- VARIABEL GLOBAL
-- ========================================
local espObjects = {}
local flySpeed = 50
local menuVisible = false

-- Status toggle
local toggles = {
    autoParry = false,
    godMode = false,
    autoHeal = false,
    autoShoot = false,
    fly = false,
    noClip = false,
    moonWalk = false,
    aimBot = false,
    silentAim = false,
    autoKiller = false,
    autoGenerator = false,
    escapeGate = false,
    antiAFK = false,
    teleportGen = false
}

local connections = {}
local flyBV = nil
local noClipConn = nil
local moonWalkConn = nil
local flyLoopConn = nil

-- ========================================
-- GUI SETUP
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHub"
ScreenGui.ResetOnSpawn = false

-- ========================================
-- 🔥 LOGO (PAKE TEXTBUTTON BIAR GAMPANG)
-- ========================================
local Logo = Instance.new("TextButton")
Logo.Parent = ScreenGui
Logo.Size = UDim2.new(0, 65, 0, 65)
Logo.Position = UDim2.new(0, 10, 0, 10)
Logo.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Logo.BackgroundTransparency = 0
Logo.BorderSizePixel = 3
Logo.BorderColor3 = Color3.fromRGB(255, 255, 255)
Logo.Text = "ZH"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 30
Logo.Font = Enum.Font.GothamBlack
Logo.TextScaled = true
Logo.Visible = true
Logo.ZIndex = 100
Logo.Active = true
Logo.Draggable = true

local LogoCorner = Instance.new("UICorner")
LogoCorner.Parent = Logo
LogoCorner.CornerRadius = UDim.new(1, 0)

-- Label "ZIP HUB"
local LogoLabel = Instance.new("TextLabel")
LogoLabel.Parent = ScreenGui
LogoLabel.Size = UDim2.new(0, 80, 0, 18)
LogoLabel.Position = UDim2.new(0, 3, 0, 77)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "ZIP HUB"
LogoLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
LogoLabel.TextSize = 11
LogoLabel.Font = Enum.Font.GothamBold

-- ========================================
-- MENU UTAMA
-- ========================================
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 430, 0, 580)
MainFrame.Position = UDim2.new(0.5, -215, 0.5, -290)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
MainFrame.BackgroundTransparency = 0
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ZIndex = 50

local UICorner = Instance.new("UICorner")
UICorner.Parent = MainFrame
UICorner.CornerRadius = UDim.new(0, 12)

-- HEADER
local HeaderFrame = Instance.new("Frame")
HeaderFrame.Parent = MainFrame
HeaderFrame.Size = UDim2.new(1, 0, 0, 55)
HeaderFrame.Position = UDim2.new(0, 0, 0, 0)
HeaderFrame.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
HeaderFrame.BackgroundTransparency = 0
HeaderFrame.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = HeaderFrame
HeaderCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Parent = HeaderFrame
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ZIP HUB ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = HeaderFrame
SubTitle.Size = UDim2.new(1, 0, 0, 18)
SubTitle.Position = UDim2.new(0, 0, 1, -20)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "VIOLENCE DISTRICT"
SubTitle.TextColor3 = Color3.fromRGB(255, 200, 200)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.GothamMedium

-- CLOSE
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = HeaderFrame
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -42, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseBtn
CloseCorner.CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    menuVisible = false
    MainFrame.Visible = false
end)

-- SCROLLING
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Size = UDim2.new(1, -16, 1, -65)
ScrollingFrame.Position = UDim2.new(0, 8, 0, 60)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 5
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
ScrollingFrame.BorderSizePixel = 0

-- ========================================
-- FUNGSI UI
-- ========================================
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

local function CreateCategory(text, yPos)
    local cat = Instance.new("TextLabel")
    cat.Parent = ScrollingFrame
    cat.Size = UDim2.new(1, -10, 0, 30)
    cat.Position = UDim2.new(0, 0, 0, yPos)
    cat.BackgroundTransparency = 1
    cat.Text = "▸ " .. text
    cat.TextColor3 = Color3.fromRGB(255, 100, 100)
    cat.TextSize = 15
    cat.Font = Enum.Font.GothamBold
    cat.TextXAlignment = Enum.TextXAlignment.Left
    return cat
end

local function CreateToggle(text, yPos, key)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 36)
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
    label.Position = UDim2.new(0, 10, 0, 0)

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 60, 0, 28)
    toggleBtn.Position = UDim2.new(1, -68, 0, 4)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleBtn
    toggleCorner.CornerRadius = UDim.new(0, 6)

    local state = false

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        
        -- Jalankan fungsi toggle
        toggles[key] = state
        if state then
            EnableFeature(key)
        else
            DisableFeature(key)
        end
    end)

    return toggleBtn
end

local function CreateButton(text, yPos, callback, color)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollingFrame
    btn.Size = UDim2.new(1, -10, 0, 36)
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

-- ========================================
-- 🎯 FITUR-FITUR (FUNGSI UTAMA)
-- ========================================

-- ENABLE FEATURE
function EnableFeature(key)
    if key == "autoParry" then
        connections.autoParry = RunService.RenderStepped:Connect(function()
            if toggles.autoParry and LocalPlayer.Character then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        end)
    elseif key == "godMode" then
        connections.godMode = RunService.RenderStepped:Connect(function()
            if toggles.godMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
    elseif key == "autoHeal" then
        connections.autoHeal = RunService.RenderStepped:Connect(function()
            if toggles.autoHeal and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            end
        end)
    elseif key == "autoShoot" then
        connections.autoShoot = RunService.RenderStepped:Connect(function()
            if toggles.autoShoot then
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
    elseif key == "fly" then
        StartFly()
    elseif key == "noClip" then
        StartNoClip()
    elseif key == "moonWalk" then
        StartMoonWalk()
    elseif key == "aimBot" then
        connections.aimBot = RunService.RenderStepped:Connect(function()
            if toggles.aimBot then
                local target = GetClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
                end
            end
        end)
    elseif key == "silentAim" then
        connections.silentAim = RunService.RenderStepped:Connect(function()
            if toggles.silentAim then
                local target = GetClosestPlayer()
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    local targetPos = target.Character.HumanoidRootPart.Position
                    local direction = (targetPos - Camera.CFrame.Position).Unit
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + direction * 100)
                end
            end
        end)
    elseif key == "autoKiller" then
        connections.autoKiller = RunService.RenderStepped:Connect(function()
            if toggles.autoKiller then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, player.Character.HumanoidRootPart.Position)
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton2(Vector2.new())
                        end)
                        break
                    end
                end
            end
        end)
    elseif key == "autoGenerator" then
        connections.autoGenerator = RunService.RenderStepped:Connect(function()
            if toggles.autoGenerator then
                AutoGenerator()
            end
        end)
    elseif key == "escapeGate" then
        connections.escapeGate = RunService.RenderStepped:Connect(function()
            if toggles.escapeGate then
                EscapeGate()
            end
        end)
    elseif key == "antiAFK" then
        connections.antiAFK = RunService.RenderStepped:Connect(function()
            if toggles.antiAFK then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                wait(60)
            end
        end)
    end
end

-- DISABLE FEATURE
function DisableFeature(key)
    if connections[key] then
        connections[key]:Disconnect()
        connections[key] = nil
    end
    
    if key == "fly" then
        StopFly()
    elseif key == "noClip" then
        StopNoClip()
    elseif key == "moonWalk" then
        StopMoonWalk()
    end
end

-- ========================================
-- FUNGSI-FUNGSI
-- ========================================

function GetClosestPlayer()
    local closest = nil
    local shortest = math.huge
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (hrp.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = player
            end
        end
    end
    return closest
end

function StartFly()
    if flyLoopConn then return end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = true
    end

    flyBV = Instance.new("BodyVelocity")
    flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.Parent = hrp

    flyLoopConn = RunService.RenderStepped:Connect(function()
        if not toggles.fly or not flyBV then return end
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
        else
            moveDir = Vector3.new(0, 0.5, 0)
        end

        flyBV.Velocity = moveDir
    end)
end

function StopFly()
    if flyLoopConn then
        flyLoopConn:Disconnect()
        flyLoopConn = nil
    end
    if flyBV then
        flyBV:Destroy()
        flyBV = nil
    end
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end

function StartNoClip()
    if noClipConn then return end
    if LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    noClipConn = RunService.RenderStepped:Connect(function()
        if toggles.noClip and LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

function StopNoClip()
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

function StartMoonWalk()
    if moonWalkConn then return end
    moonWalkConn = RunService.RenderStepped:Connect(function()
        if toggles.moonWalk and LocalPlayer.Character then
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

function AutoGenerator()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen")) then
            -- Cek killer di dekat generator
            local killerNear = false
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (obj.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist < 20 then
                        killerNear = true
                        break
                    end
                end
            end

            if killerNear and toggles.teleportGen then
                hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 3, 0))
            end

            local dist = (hrp.Position - obj.Position).Magnitude
            if dist < 10 then
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

function EscapeGate()
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
-- 🔥 FITUR-FITUR MENU
-- ========================================
local yPos = 2

-- COMBAT
CreateCategory("⚔️ COMBAT", yPos)
yPos = yPos + 32

CreateToggle("🛡️ Auto Parry", yPos, "autoParry")
yPos = yPos + 40

CreateToggle("💀 God Mode", yPos, "godMode")
yPos = yPos + 40

CreateToggle("💚 Auto Heal", yPos, "autoHeal")
yPos = yPos + 40

CreateToggle("🔫 Auto Shoot", yPos, "autoShoot")
yPos = yPos + 40

CreateButton("💥 One Hit Kill", yPos, function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end, Color3.fromRGB(100, 0, 0))
yPos = yPos + 40

CreateDivider(yPos)
yPos = yPos + 12

-- AIM
CreateCategory("🎯 AIM", yPos)
yPos = yPos + 32

CreateToggle("🎯 Aim Bot", yPos, "aimBot")
yPos = yPos + 40

CreateToggle("🤫 Silent Aim", yPos, "silentAim")
yPos = yPos + 40

CreateToggle("🔪 Auto Aim Killer", yPos, "autoKiller")
yPos = yPos + 40

CreateDivider(yPos)
yPos = yPos + 12

-- GENERATOR
CreateCategory("⚡ GENERATOR", yPos)
yPos = yPos + 32

CreateToggle("🔄 Auto Generator", yPos, "autoGenerator")
yPos = yPos + 40

CreateToggle("🚀 Teleport ke Gen (Auto)", yPos, "teleportGen")
yPos = yPos + 40

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
end, Color3.fromRGB(120, 60, 0))
yPos = yPos + 40

CreateDivider(yPos)
yPos = yPos + 12

-- ESCAPE
CreateCategory("🚪 ESCAPE", yPos)
yPos = yPos + 32

CreateToggle("🚪 Escape Gate (Auto Win)", yPos, "escapeGate")
yPos = yPos + 40

CreateDivider(yPos)
yPos = yPos + 12

-- MOVEMENT
CreateCategory("🏃 MOVEMENT", yPos)
yPos = yPos + 32

CreateToggle("⚡ Speed Hack", yPos, function(state)
    if state then
        connections.speedHack = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 50
            end
        end)
    else
        if connections.speedHack then
            connections.speedHack:Disconnect()
            connections.speedHack = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)
yPos = yPos + 40

CreateToggle("🕊️ Fly Mode (Seimbang)", yPos, "fly")
yPos = yPos + 40

CreateToggle("🧱 No Clip", yPos, "noClip")
yPos = yPos + 40

CreateToggle("🌙 Moon Walk", yPos, "moonWalk")
yPos = yPos + 40

CreateButton("🚀 Speed +10", yPos, function()
    flySpeed = math.min(flySpeed + 10, 150)
end, Color3.fromRGB(0, 80, 120))
yPos = yPos + 40

CreateButton("🐢 Speed -10", yPos, function()
    flySpeed = math.max(flySpeed - 10, 10)
end, Color3.fromRGB(120, 60, 0))
yPos = yPos + 40

CreateDivider(yPos)
yPos = yPos + 12

-- FARM
CreateCategory("🌾 FARM", yPos)
yPos = yPos + 32

CreateToggle("🤖 Auto Farm", yPos, function(state)
    if state then
        connections.autoFarm = RunService.RenderStepped:Connect(function()
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
    else
        if connections.autoFarm then
            connections.autoFarm:Disconnect()
            connections.autoFarm = nil
        end
    end
end)
yPos = yPos + 40

CreateDivider(yPos)
yPos = yPos + 12

-- UTILITY
CreateCategory("🔧 UTILITY", yPos)
yPos = yPos + 32

CreateToggle("🚫 Anti AFK", yPos, "antiAFK")
yPos = yPos + 40

CreateButton("🔄 Reset Karakter", yPos, function()
    -- Matikan semua fitur
    for key, _ in pairs(toggles) do
        if toggles[key] then
            toggles[key] = false
            DisableFeature(key)
        end
    end
    -- Reset karakter
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end, Color3.fromRGB(100, 0, 0))
yPos = yPos + 40

-- Update Canvas
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ========================================
-- 🔥 LOGO KLIK → MENU MUNCUL
-- ========================================
Logo.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    print("Logo diklik! Menu Visible:", menuVisible)
    
    TweenService:Create(Logo, TweenInfo.new(0.15), {Size = UDim2.new(0, 70, 0, 70)}):Play()
    task.wait(0.15)
    TweenService:Create(Logo, TweenInfo.new(0.15), {Size = UDim2.new(0, 65, 0, 65)}):Play()
end)

-- ========================================
-- WATERMARK
-- ========================================
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 180, 0, 20)
Watermark.Position = UDim2.new(0, 8, 1, -28)
Watermark.BackgroundTransparency = 1
Watermark.Text = "⚡ ZIP HUB"
Watermark.TextColor3 = Color3.fromRGB(255, 0, 0)
Watermark.TextSize = 12
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextTransparency = 0

print("✅ ZIP HUB - FINAL FIX Loaded!")
print("✅ Klik LOGO ZH di pojok kiri atas untuk buka menu!")
