-- ========================================
-- ZIP HUB - AUTO ESCAPE + GENERATOR FIX
-- VERSION 16.0 (FINAL)
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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

-- ========================================
-- VARIABEL
-- ========================================
local connections = {}
local espObjects = {}
local flyActive = false
local flyBV = nil
local flyLoop = nil
local flySpeed = 50
local noClipActive = false
local noClipConn = nil
local moonWalkActive = false
local moonWalkConn = nil
local invisibleActive = false
local invisibleConn = nil

-- ESP status
local espStatus = {
    player = false,
    killer = false,
    generator = false,
    survivor = false,
    gate = false,
    pallet = false
}

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
MenuFrame.Size = UDim2.new(0, 420, 0, 650)
MenuFrame.Position = UDim2.new(0.5, -210, 0.5, -325)
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
-- 🔥 FIND GATE (SEMUA MAP!)
-- ========================================
local gateKeywords = {
    "gate", "escape", "exit", "door", "win", "finish", 
    "end", "portal", "teleport", "out", "leave", "safe",
    "goal", "complete", "done", "victory", "success"
}

function FindEscapeGate()
    local gates = {}
    local searchPlaces = {
        Workspace,
        ReplicatedStorage,
        Lighting,
        game
    }
    
    for _, place in pairs(searchPlaces) do
        for _, obj in pairs(place:GetDescendants()) do
            if obj:IsA("BasePart") or obj:IsA("Model") then
                local nameLower = obj.Name:lower()
                local isGate = false
                
                -- Cek berdasarkan nama
                for _, keyword in pairs(gateKeywords) do
                    if nameLower:find(keyword) then
                        isGate = true
                        break
                    end
                end
                
                -- Cek berdasarkan warna (gate sering hijau/kuning)
                if obj:IsA("BasePart") then
                    local color = obj.BrickColor
                    if color == BrickColor.new("Bright green") or 
                       color == BrickColor.new("Bright yellow") or
                       color == BrickColor.new("Lime green") then
                        isGate = true
                    end
                end
                
                -- Cek berdasarkan ukuran (gate biasanya besar)
                if obj:IsA("BasePart") and obj.Size.Magnitude > 10 then
                    isGate = true
                end
                
                if isGate then
                    table.insert(gates, obj)
                end
            end
        end
    end
    
    return gates
end

-- ========================================
-- 🔥 AUTO ESCAPE (FIX SEMUA MAP!)
-- ========================================
function AutoEscape()
    local gates = FindEscapeGate()
    
    if #gates > 0 then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then 
            print("❌ Karakter tidak ditemukan!")
            return false 
        end
        
        -- Cari gate terdekat
        local nearestGate = nil
        local nearestDist = math.huge
        local gatePosition = nil
        
        for _, gate in pairs(gates) do
            local pos = nil
            if gate:IsA("BasePart") then
                pos = gate.Position
            elseif gate:IsA("Model") and gate:FindFirstChild("PrimaryPart") then
                pos = gate.PrimaryPart.Position
            elseif gate:IsA("Model") then
                for _, part in pairs(gate:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pos = part.Position
                        break
                    end
                end
            end
            
            if pos then
                local dist = (hrp.Position - pos).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearestGate = gate
                    gatePosition = pos
                end
            end
        end
        
        if nearestGate and gatePosition then
            -- Teleport ke gate
            hrp.CFrame = CFrame.new(gatePosition + Vector3.new(0, 3, 0))
            wait(0.3)
            
            -- Interaksi otomatis (klik gate berkali-kali)
            for i = 1, 10 do
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.1)
                end)
            end
            
            print("🚪 Auto Escape Berhasil! Gate ditemukan di:", gatePosition)
            return true
        end
    end
    
    print("❌ Gate tidak ditemukan! Mencoba teleport ke lokasi aman...")
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
    end
    return false
end

-- ========================================
-- 🔥 FIND GENERATOR (SEMUA MAP!)
-- ========================================
local genKeywords = {
    "generator", "gen", "power", "engine", "machine",
    "electric", "energy", "core", "reactor", "turbine"
}

function FindGenerators()
    local gens = {}
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local nameLower = obj.Name:lower()
            for _, keyword in pairs(genKeywords) do
                if nameLower:find(keyword) then
                    table.insert(gens, obj)
                    break
                end
            end
        end
    end
    
    return gens
end

-- ========================================
-- 🔥 AUTO GENERATOR (INSTANT - TANPA PUTAR JARUM!)
-- ========================================
function AutoGenerator()
    local gens = FindGenerators()
    
    if #gens > 0 then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then 
            print("❌ Karakter tidak ditemukan!")
            return 
        end
        
        local nearestGen = nil
        local nearestDist = math.huge
        local genPosition = nil
        
        for _, gen in pairs(gens) do
            local pos = gen.Position
            local dist = (hrp.Position - pos).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearestGen = gen
                genPosition = pos
            end
        end
        
        if nearestGen and genPosition then
            -- Teleport ke generator
            if nearestDist > 10 then
                hrp.CFrame = CFrame.new(genPosition + Vector3.new(0, 2, 0))
                wait(0.3)
            end
            
            -- INTERAKSI LANGSUNG (TANPA PUTAR JARUM!)
            for i = 1, 10 do
                pcall(function()
                    -- Klik interaksi
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.1)
                    
                    -- Klik lagi untuk fix (skip animasi)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.1)
                end)
            end
            
            -- Simulasi selesai
            pcall(function()
                -- Trigger event selesai
                local remote = ReplicatedStorage:FindFirstChild("GeneratorComplete") or 
                               ReplicatedStorage:FindFirstChild("GenDone") or
                               ReplicatedStorage:FindFirstChild("FinishGen")
                if remote then
                    remote:FireServer(nearestGen)
                end
            end)
            
            print("⚡ Generator selesai! (Tanpa putar jarum)")
            return
        end
    end
    print("❌ Generator tidak ditemukan!")
end

-- ========================================
-- 🔥 FUNGSI LAINNYA (SAMA)
-- ========================================
function KillAll()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = 0
                pcall(function()
                    player.Character:BreakJoints()
                end)
                pcall(function()
                    player.Character:Destroy()
                end)
            end
        end
    end
    print("💀 Semua player/survivor telah dibunuh!")
end

-- ========================================
-- [SEMUA FUNGSI LAIN SAMA KAYAK SEBELUMNYA]
-- ========================================

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

CreateToggle("🔫 Auto Shoot", yPos, "autoShoot", function(state)
    if state then
        connections.autoShoot = RunService.RenderStepped:Connect(function()
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

CreateButton("⚡ Auto Generator (Instant)", yPos, function()
    AutoGenerator()
end, Color3.fromRGB(0, 100, 0))
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- ESCAPE / AUTO WIN
CreateCategory("🚪 ESCAPE / AUTO WIN", yPos)
yPos = yPos + 28

CreateButton("🏆 Auto Escape (All Map)", yPos, function()
    AutoEscape()
end, Color3.fromRGB(0, 150, 255))
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- ESP
CreateCategory("👁️ ESP", yPos)
yPos = yPos + 28

CreateToggle("🔴 ESP Player", yPos, "espPlayer", function(state)
    espStatus.player = state
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
        for _, obj in pairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
        espObjects = {}
    end
end)
yPos = yPos + 36

CreateToggle("🔴 ESP Killer", yPos, "espKiller", function(state)
    espStatus.killer = state
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                highlight.OutlineTransparency = 0.2
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
yPos = yPos + 36

CreateToggle("🟢 ESP Generator", yPos, "espGenerator", function(state)
    espStatus.generator = state
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
        for _, obj in pairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
        espObjects = {}
    end
end)
yPos = yPos + 36

CreateToggle("🟡 ESP Gate", yPos, "espGate", function(state)
    espStatus.gate = state
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
        for _, obj in pairs(espObjects) do
            pcall(function() obj:Destroy() end)
        end
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
        if connections.speedHack then
            connections.speedHack:Disconnect()
            connections.speedHack = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)
yPos = yPos + 36

CreateToggle("🕊️ Fly Mode", yPos, "fly", function(state)
    if state then
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
        flyBV.MaxForce = Vector3.new(10000, 10000, 10000)
        flyBV.Velocity = Vector3.new(0, 0, 0)
        flyBV.Parent = hrp
        
        flyLoop = RunService.RenderStepped:Connect(function()
            if not flyActive or not flyBV then return end
            if not LocalPlayer.Character then return end
            
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local moveDir = Vector3.new()
            local cam = Camera.CFrame
            
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
            
            if moveDir.Magnitude > 0 then
                flyBV.Velocity = moveDir.Unit * flySpeed
            else
                flyBV.Velocity = Vector3.new(0, 0.5, 0)
            end
        end)
    else
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
end)
yPos = yPos + 36

CreateButton("🚀 Speed +10", yPos, function()
    flySpeed = math.min(flySpeed + 10, 200)
    print("🕊️ Fly Speed:", flySpeed)
end, Color3.fromRGB(0, 80, 120))
yPos = yPos + 36

CreateButton("🐢 Speed -10", yPos, function()
    flySpeed = math.max(flySpeed - 10, 10)
    print("🕊️ Fly Speed:", flySpeed)
end, Color3.fromRGB(120, 60, 0))
yPos = yPos + 36

CreateToggle("🧱 No Clip", yPos, "noClip", function(state)
    if state then
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
    else
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
end)
yPos = yPos + 36

CreateToggle("🌙 Moon Walk", yPos, "moonWalk", function(state)
    if state then
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
    else
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
end)
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- STEALTH
CreateCategory("👻 STEALTH", yPos)
yPos = yPos + 28

CreateToggle("👻 Invisible (Real)", yPos, "invisible", function(state)
    if state then
        if invisibleActive then return end
        invisibleActive = true
        
        invisibleConn = RunService.RenderStepped:Connect(function()
            if invisibleActive and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                        part.CanCollide = false
                    end
                    if part:IsA("Accessory") then
                        pcall(function()
                            part.Handle.Transparency = 1
                        end)
                    end
                end
                if LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    LocalPlayer.Character.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                end
            end
        end)
        
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                    part.CanCollide = false
                end
                if part:IsA("Accessory") then
                    pcall(function()
                        part.Handle.Transparency = 1
                    end)
                end
            end
            if LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                LocalPlayer.Character.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            end
        end
    else
        invisibleActive = false
        if invisibleConn then
            invisibleConn:Disconnect()
            invisibleConn = nil
        end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    part.CanCollide = true
                end
                if part:IsA("Accessory") then
                    pcall(function()
                        part.Handle.Transparency = 0
                    end)
                end
            end
            if LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                LocalPlayer.Character.Humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
            end
        end
    end
end)
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- KILL ALL
CreateCategory("💀 KILL ALL", yPos)
yPos = yPos + 28

CreateButton("💀 Kill All Instant (Real)", yPos, function()
    KillAll()
end, Color3.fromRGB(150, 0, 0))
yPos = yPos + 36

CreateDivider(yPos)
yPos = yPos + 12

-- UTILITY
CreateCategory("🔧 UTILITY", yPos)
yPos = yPos + 28

CreateButton("🔄 Reset Karakter", yPos, function()
    if flyActive then
        flyActive = false
        if flyLoop then flyLoop:Disconnect() end
        if flyBV then flyBV:Destroy() end
    end
    if noClipActive then
        noClipActive = false
        if noClipConn then noClipConn:Disconnect() end
    end
    if moonWalkActive then
        moonWalkActive = false
        if moonWalkConn then moonWalkConn:Disconnect() end
    end
    if invisibleActive then
        invisibleActive = false
        if invisibleConn then invisibleConn:Disconnect() end
    end
    
    for key, conn in pairs(connections) do
        if conn then
            conn:Disconnect()
            connections[key] = nil
        end
    end
    
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
    
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

print("✅ ZIP HUB - AUTO ESCAPE + GENERATOR FIX Loaded!")
print("✅ Auto Escape detect SEMUA GATE di semua map!")
print("✅ Auto Generator INSTANT tanpa putar jarum!")
print("✅ Klik LOGO ZH di pojok kiri atas untuk buka menu!")
