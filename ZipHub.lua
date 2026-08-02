-- ========================================
-- ZIP HUB - AUTO ESCAPE INSTANT
-- VERSION 20.0 (TELEPORT LANGSUNG!)
-- ========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ========================================
-- 🔥 FIND GATE (CEPET!)
-- ========================================
function FindGate()
    local gates = {}
    local keywords = {
        "gate", "escape", "exit", "door", "win", "finish", 
        "end", "portal", "teleport", "out", "leave", "safe",
        "goal", "complete", "done", "victory"
    }
    
    -- Cari di SEMUA tempat
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            for _, keyword in pairs(keywords) do
                if name:find(keyword) then
                    table.insert(gates, {obj = obj, pos = obj.Position})
                    break
                end
            end
        end
    end
    
    -- Cari berdasarkan warna (hijau/kuning)
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BasePart") then
            local color = obj.BrickColor
            if color == BrickColor.new("Bright green") or 
               color == BrickColor.new("Lime green") or
               color == BrickColor.new("Bright yellow") then
                table.insert(gates, {obj = obj, pos = obj.Position})
            end
        end
    end
    
    -- Cari model
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            for _, keyword in pairs(keywords) do
                if name:find(keyword) then
                    local primary = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart")
                    if primary and primary:IsA("BasePart") then
                        table.insert(gates, {obj = obj, pos = primary.Position})
                    end
                    break
                end
            end
        end
    end
    
    return gates
end

-- ========================================
-- 🔥 AUTO ESCAPE (INSTANT TELEPORT!)
-- ========================================
function AutoEscape()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        print("❌ Karakter tidak ditemukan!")
        return false
    end
    
    -- Cari gate
    local gates = FindGate()
    
    -- Filter duplicate
    local unique = {}
    local seen = {}
    for _, gate in pairs(gates) do
        local key = tostring(gate.pos.X) .. tostring(gate.pos.Y) .. tostring(gate.pos.Z)
        if not seen[key] then
            seen[key] = true
            table.insert(unique, gate)
        end
    end
    
    print("🔍 Ditemukan " .. #unique .. " gate!")
    
    if #unique > 0 then
        -- Cari gate terdekat
        local nearest = nil
        local nearestDist = math.huge
        local nearestPos = nil
        
        for _, gate in pairs(unique) do
            local dist = (hrp.Position - gate.pos).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = gate
                nearestPos = gate.pos
            end
        end
        
        if nearest and nearestPos then
            -- ========================================
            -- 🔥 LANGSUNG TELEPORT KE GATE!
            -- ========================================
            hrp.CFrame = CFrame.new(nearestPos + Vector3.new(0, 3, 0))
            wait(0.2)
            
            -- ========================================
            -- 🔥 INTERAKSI OTOMATIS (20x klik!)
            -- ========================================
            for i = 1, 20 do
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.05)
                end)
            end
            
            -- ========================================
            -- 🔥 TRIGGER SEMUA REMOTE (PASTI WIN!)
            -- ========================================
            pcall(function()
                for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then
                        pcall(function()
                            obj:FireServer()
                        end)
                    end
                end
            end)
            
            print("✅ LANGSUNG TELEPORT KE GATE! Posisi:", nearestPos)
            return true
        end
    end
    
    -- FALLBACK: Teleport ke luar map
    print("❌ Gate tidak ditemukan! Teleport ke luar map...")
    hrp.CFrame = CFrame.new(99999, 99999, 99999)
    wait(0.3)
    pcall(function()
        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                pcall(function()
                    obj:FireServer()
                end)
            end
        end
    end)
    return false
end

-- ========================================
-- 🔥 INVISIBLE REAL
-- ========================================
local invisibleActive = false
local invisibleConn = nil

function ToggleInvisible(state)
    invisibleActive = state
    
    if state then
        if invisibleConn then 
            invisibleConn:Disconnect() 
            invisibleConn = nil 
        end
        
        invisibleConn = RunService.RenderStepped:Connect(function()
            if invisibleActive and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                        part.CanCollide = false
                        part.CastShadow = false
                    end
                    if part:IsA("Humanoid") then
                        part.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        part.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                        part.NameDisplayDistance = 0
                    end
                end
            end
        end)
    else
        if invisibleConn then
            invisibleConn:Disconnect()
            invisibleConn = nil
        end
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                    part.CanCollide = true
                    part.CastShadow = true
                end
                if part:IsA("Humanoid") then
                    part.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                    part.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
                    part.NameDisplayDistance = 100
                end
            end
        end
    end
end

-- ========================================
-- GUI SETUP
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHubGUI"
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

-- MENU
local MenuFrame = Instance.new("Frame")
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 320, 0, 200)
MenuFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
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
MenuTitle.TextSize = 18
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

-- ISI MENU
local frame = Instance.new("Frame")
frame.Parent = MenuFrame
frame.Size = UDim2.new(1, 0, 1, -50)
frame.Position = UDim2.new(0, 0, 0, 45)
frame.BackgroundTransparency = 1

-- Tombol Auto Escape
local btnEscape = Instance.new("TextButton")
btnEscape.Parent = frame
btnEscape.Size = UDim2.new(0.9, 0, 0, 45)
btnEscape.Position = UDim2.new(0.05, 0, 0.02, 0)
btnEscape.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
btnEscape.BackgroundTransparency = 0
btnEscape.Text = "🚪 LANGSUNG TELEPORT KE GATE!"
btnEscape.TextColor3 = Color3.fromRGB(255, 255, 255)
btnEscape.TextSize = 14
btnEscape.Font = Enum.Font.GothamBold
btnEscape.BorderSizePixel = 2
btnEscape.BorderColor3 = Color3.fromRGB(255, 255, 255)

local btnCorner = Instance.new("UICorner")
btnCorner.Parent = btnEscape
btnCorner.CornerRadius = UDim.new(0, 8)

btnEscape.MouseButton1Click:Connect(function()
    AutoEscape()
end)

-- Toggle Invisible
local frameInvis = Instance.new("Frame")
frameInvis.Parent = frame
frameInvis.Size = UDim2.new(0.9, 0, 0, 40)
frameInvis.Position = UDim2.new(0.05, 0, 0.28, 0)
frameInvis.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
frameInvis.BackgroundTransparency = 0
frameInvis.BorderSizePixel = 2
frameInvis.BorderColor3 = Color3.fromRGB(255, 0, 0)

local cornerInvis = Instance.new("UICorner")
cornerInvis.Parent = frameInvis
cornerInvis.CornerRadius = UDim.new(0, 8)

local labelInvis = Instance.new("TextLabel")
labelInvis.Parent = frameInvis
labelInvis.Size = UDim2.new(0.6, 0, 1, 0)
labelInvis.Position = UDim2.new(0, 10, 0, 0)
labelInvis.BackgroundTransparency = 1
labelInvis.Text = "👻 Invisible (REAL)"
labelInvis.TextColor3 = Color3.fromRGB(255, 255, 255)
labelInvis.TextSize = 13
labelInvis.Font = Enum.Font.GothamMedium
labelInvis.TextXAlignment = Enum.TextXAlignment.Left

local toggleInvis = Instance.new("TextButton")
toggleInvis.Parent = frameInvis
toggleInvis.Size = UDim2.new(0, 50, 0, 30)
toggleInvis.Position = UDim2.new(1, -58, 0, 5)
toggleInvis.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
toggleInvis.Text = "OFF"
toggleInvis.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleInvis.TextSize = 12
toggleInvis.Font = Enum.Font.GothamBold
toggleInvis.BorderSizePixel = 0

local toggleCorner = Instance.new("UICorner")
toggleCorner.Parent = toggleInvis
toggleCorner.CornerRadius = UDim.new(0, 5)

local invisState = false
toggleInvis.MouseButton1Click:Connect(function()
    invisState = not invisState
    toggleInvis.Text = invisState and "ON" or "OFF"
    toggleInvis.BackgroundColor3 = invisState and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    ToggleInvisible(invisState)
end)

-- Reset
local btnReset = Instance.new("TextButton")
btnReset.Parent = frame
btnReset.Size = UDim2.new(0.9, 0, 0, 40)
btnReset.Position = UDim2.new(0.05, 0, 0.50, 0)
btnReset.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
btnReset.BackgroundTransparency = 0
btnReset.Text = "🔄 Reset & Matikan Semua"
btnReset.TextColor3 = Color3.fromRGB(255, 255, 255)
btnReset.TextSize = 13
btnReset.Font = Enum.Font.GothamMedium
btnReset.BorderSizePixel = 2
btnReset.BorderColor3 = Color3.fromRGB(255, 255, 255)

local btnCorner2 = Instance.new("UICorner")
btnCorner2.Parent = btnReset
btnCorner2.CornerRadius = UDim.new(0, 8)

btnReset.MouseButton1Click:Connect(function()
    if invisState then
        invisState = false
        toggleInvis.Text = "OFF"
        toggleInvis.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        ToggleInvisible(false)
    end
    if LocalPlayer.Character then
        LocalPlayer.Character:BreakJoints()
    end
end)

-- ========================================
-- LOGO KLIK → MENU MUNCUL
-- ========================================
Logo.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
    print("Logo ZH diklik! Menu Visible:", MenuFrame.Visible)
end)

print("✅ ZIP HUB - INSTANT TELEPORT TO GATE Loaded!")
print("✅ Klik LOGO ZH di pojok kiri atas untuk buka menu!")
print("✅ Klik tombol hijau untuk LANGSUNG TELEPORT KE GATE!")
