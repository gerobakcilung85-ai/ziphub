-- ========================================
-- ZIP HUB - FLY SUPPORT R6 + R15
-- VERSION 26.0 (FIX TOTAL)
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

-- ========================================
-- VARIABEL
-- ========================================
local flyActive = false
local flyBody = nil
local flyConn = nil
local flySpeed = 200
local flyChar = nil

local toggles = {
    autoParry = false,
    godMode = false,
    autoHeal = false,
    autoShoot = false,
    speedHack = false,
    fly = false,
    noClip = false,
    moonWalk = false,
    invisible = false,
    autoLoot = false,
    autoClicker = false,
    jumpBoost = false,
    antiRagdoll = false
}

local connections = {}
local espList = {}

-- ========================================
-- 🔥 FUNGSI FLY (SUPPORT R6 + R15!)
-- ========================================
function StartFly()
    if flyActive then return end
    flyActive = true
    
    local char = LocalPlayer.Character
    if not char then flyActive = false; return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        -- Coba cari Torso (buat R6)
        hrp = char:FindFirstChild("Torso")
        if not hrp then
            flyActive = false
            return
        end
    end
    
    flyChar = char
    
    -- Matikan gravitasi
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then humanoid.PlatformStand = true end
    
    -- Buat BodyVelocity
    flyBody = Instance.new("BodyVelocity")
    flyBody.MaxForce = Vector3.new(999999, 999999, 999999)
    flyBody.Velocity = Vector3.new(0, 0, 0)
    flyBody.Parent = hrp
    
    -- Loop terbang
    flyConn = RunService.RenderStepped:Connect(function()
        if not flyActive or not flyBody then return end
        if not LocalPlayer.Character then return end
        
        local char = LocalPlayer.Character
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        if not hrp then return end
        
        -- Arah kamera
        local cam = Camera.CFrame
        local forward = cam.LookVector * Vector3.new(1, 0, 1)
        local right = cam.RightVector * Vector3.new(1, 0, 1)
        
        if forward.Magnitude > 0 then forward = forward.Unit end
        if right.Magnitude > 0 then right = right.Unit end
        
        local move = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + forward end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - forward end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - right end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + right end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end
        
        if move.Magnitude > 0 then
            flyBody.Velocity = move.Unit * flySpeed
        else
            flyBody.Velocity = Vector3.new(0, 0.5, 0)
        end
    end)
end

function StopFly()
    flyActive = false
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBody then flyBody:Destroy(); flyBody = nil end
    
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
    flyChar = nil
end

-- ========================================
-- 🔥 TOGGLE FEATURE
-- ========================================
function ToggleFeature(key, state)
    toggles[key] = state
    
    if connections[key] then
        connections[key]:Disconnect()
        connections[key] = nil
    end
    
    if not state then
        if key == "fly" then StopFly() end
        return
    end
    
    if key == "autoParry" then
        connections.autoParry = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
            end
        end)
    elseif key == "godMode" then
        connections.godMode = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.Health = h.MaxHealth end
            end
        end)
    elseif key == "autoHeal" then
        connections.autoHeal = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h and h.Health < h.MaxHealth then
                    pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
                end
            end
        end)
    elseif key == "autoShoot" then
        connections.autoShoot = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                        if hrp then
                            local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
                            if myHrp then
                                local dist = (myHrp.Position - hrp.Position).Magnitude
                                if dist < 30 then
                                    pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
                                end
                            end
                        end
                    end
                end
            end
        end)
    elseif key == "speedHack" then
        connections.speedHack = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = 50 end
            end
        end)
    elseif key == "fly" then
        StartFly()
    elseif key == "noClip" then
        connections.noClip = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    elseif key == "moonWalk" then
        connections.moonWalk = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = 50; h.JumpPower = 0; h.AutoRotate = false end
            end
        end)
    elseif key == "invisible" then
        connections.invisible = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.Transparency = 1; part.CanCollide = false; part.CastShadow = false end
                end
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then
                    h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    h.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                end
            end
        end)
    elseif key == "autoLoot" then
        connections.autoLoot = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
                if myHrp then
                    for _, obj in pairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("loot") or obj.Name:lower():find("item") or obj.Name:lower():find("chest")) then
                            if (myHrp.Position - obj.Position).Magnitude < 15 then
                                pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
                            end
                        end
                    end
                end
            end
        end)
    elseif key == "autoClicker" then
        connections.autoClicker = RunService.RenderStepped:Connect(function()
            pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
        end)
    elseif key == "jumpBoost" then
        connections.jumpBoost = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.JumpPower = 100 end
            end
        end)
    elseif key == "antiRagdoll" then
        connections.antiRagdoll = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.PlatformStand = false; h.Sit = false end
            end
        end)
    end
end

-- ========================================
-- 🔥 AUTO ESCAPE
-- ========================================
function AutoEscape()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not hrp then return end
    
    local gates = {}
    local keywords = {"gate", "escape", "exit", "door", "win", "finish", "portal"}
    
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            for _, kw in pairs(keywords) do
                if name:find(kw) then
                    table.insert(gates, obj)
                    break
                end
            end
        end
    end
    
    if #gates > 0 then
        local nearest = nil
        local nearDist = math.huge
        for _, gate in pairs(gates) do
            local dist = (hrp.Position - gate.Position).Magnitude
            if dist < nearDist then nearDist = dist; nearest = gate end
        end
        if nearest then
            hrp.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3, 0))
            wait(0.3)
            for i = 1, 20 do
                pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()); wait(0.05) end)
            end
            pcall(function()
                for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then pcall(function() obj:FireServer() end) end
                end
            end)
        end
    else
        hrp.CFrame = CFrame.new(99999, 99999, 99999)
    end
end

-- ========================================
-- 🔥 AUTO GENERATOR
-- ========================================
function AutoGenerator()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not hrp then return end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen")) then
            if (hrp.Position - obj.Position).Magnitude > 10 then
                hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                wait(0.3)
            end
            for i = 1, 10 do
                pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()); wait(0.1) end)
            end
            break
        end
    end
end

-- ========================================
-- 💀 KILL ALL
-- ========================================
function KillAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Humanoid")
            if h then h.Health = 0 end
        end
    end
end

-- ========================================
-- 🎨 GUI
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHub"
ScreenGui.ResetOnSpawn = false

-- LOGO
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

-- MENU
local Menu = Instance.new("Frame")
Menu.Parent = ScreenGui
Menu.Size = UDim2.new(0, 350, 0, 500)
Menu.Position = UDim2.new(0.5, -175, 0.5, -250)
Menu.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
Menu.BackgroundTransparency = 0
Menu.BorderSizePixel = 3
Menu.BorderColor3 = Color3.fromRGB(255, 0, 0)
Menu.Visible = false
Menu.Active = true
Menu.Draggable = true

local MenuCorner = Instance.new("UICorner")
MenuCorner.Parent = Menu
MenuCorner.CornerRadius = UDim.new(0, 12)

-- HEADER
local Header = Instance.new("Frame")
Header.Parent = Menu
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Header.BackgroundTransparency = 0
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ZIP HUB ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseBtn
CloseCorner.CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    Menu.Visible = false
end)

-- SCROLL
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Menu
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
Scroll.BorderSizePixel = 0

-- ========================================
-- UI FUNGSI
-- ========================================
local function Cat(text, y)
    local c = Instance.new("TextLabel")
    c.Parent = Scroll
    c.Size = UDim2.new(1, -10, 0, 25)
    c.Position = UDim2.new(0, 0, 0, y)
    c.BackgroundTransparency = 1
    c.Text = "▸ " .. text
    c.TextColor3 = Color3.fromRGB(255, 100, 100)
    c.TextSize = 14
    c.Font = Enum.Font.GothamBold
    c.TextXAlignment = Enum.TextXAlignment.Left
end

local function Div(y)
    local d = Instance.new("Frame")
    d.Parent = Scroll
    d.Size = UDim2.new(0.9, 0, 0, 2)
    d.Position = UDim2.new(0.05, 0, 0, y)
    d.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    d.BackgroundTransparency = 0
    d.BorderSizePixel = 0
end

local function Btn(text, y, cb, color)
    local b = Instance.new("TextButton")
    b.Parent = Scroll
    b.Size = UDim2.new(1, -10, 0, 30)
    b.Position = UDim2.new(0, 0, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(50, 50, 80)
    b.BackgroundTransparency = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 12
    b.Font = Enum.Font.GothamMedium
    b.BorderSizePixel = 2
    b.BorderColor3 = Color3.fromRGB(255, 0, 0)
    local c = Instance.new("UICorner")
    c.Parent = b
    c.CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
end

local function Tog(text, y, key)
    local frame = Instance.new("Frame")
    frame.Parent = Scroll
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.Position = UDim2.new(0, 0, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
    local c = Instance.new("UICorner")
    c.Parent = frame
    c.CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0, 50, 0, 22)
    btn.Position = UDim2.new(1, -56, 0, 4)
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    local tc = Instance.new("UICorner")
    tc.Parent = btn
    tc.CornerRadius = UDim.new(0, 5)

    btn.MouseButton1Click:Connect(function()
        local state = not toggles[key]
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        ToggleFeature(key, state)
    end)
end

-- ========================================
-- 📋 MENU
-- ========================================
local y = 5

Cat("⚔️ COMBAT", y); y = y + 28
Tog("🛡️ Auto Parry", y, "autoParry"); y = y + 34
Tog("💀 God Mode", y, "godMode"); y = y + 34
Tog("💚 Auto Heal", y, "autoHeal"); y = y + 34
Tog("🔫 Auto Shoot", y, "autoShoot"); y = y + 34
Btn("💥 One Hit Kill", y, function()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Humanoid")
            if h then h.Health = 0 end
        end
    end
end, Color3.fromRGB(100, 0, 0))
y = y + 34
Div(y); y = y + 12

Cat("⚡ GENERATOR", y); y = y + 28
Btn("⚡ Auto Generator", y, AutoGenerator, Color3.fromRGB(0, 100, 0))
y = y + 34
Div(y); y = y + 12

Cat("🚪 ESCAPE", y); y = y + 28
Btn("🏆 Auto Escape", y, AutoEscape, Color3.fromRGB(0, 150, 255))
y = y + 34
Div(y); y = y + 12

Cat("🏃 MOVEMENT", y); y = y + 28
Tog("⚡ Speed Hack", y, "speedHack"); y = y + 34
Tog("🕊️ Fly Mode (R6/R15)", y, "fly"); y = y + 34
Tog("🧱 No Clip", y, "noClip"); y = y + 34
Tog("🌙 Moon Walk", y, "moonWalk"); y = y + 34
Div(y); y = y + 12

Cat("👻 STEALTH", y); y = y + 28
Tog("👻 Invisible", y, "invisible"); y = y + 34
Div(y); y = y + 12

Cat("🔥 NEW", y); y = y + 28
Tog("📦 Auto Loot", y, "autoLoot"); y = y + 34
Tog("🖱️ Auto Clicker", y, "autoClicker"); y = y + 34
Tog("🦘 Jump Boost", y, "jumpBoost"); y = y + 34
Tog("🧘 Anti Ragdoll", y, "antiRagdoll"); y = y + 34
Div(y); y = y + 12

Cat("💀 KILL ALL", y); y = y + 28
Btn("💀 Kill All", y, KillAll, Color3.fromRGB(150, 0, 0))
y = y + 34
Div(y); y = y + 12

Cat("🔧 UTILITY", y); y = y + 28
Btn("🔄 Reset", y, function()
    for k, _ in pairs(toggles) do
        toggles[k] = false
        if connections[k] then connections[k]:Disconnect(); connections[k] = nil end
    end
    StopFly()
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
end, Color3.fromRGB(100, 0, 0))
y = y + 34

Scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- ========================================
-- LOGO KLIK → MENU
-- ========================================
Logo.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

print("✅ ZIP HUB - FLY SUPPORT R6 + R15 Loaded!")
print("✅ Klik LOGO ZH untuk buka menu!")
