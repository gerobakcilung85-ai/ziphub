-- ========================================
-- ZIP HUB - SIMPLE & STABLE
-- VERSION 10.0 (PASTI JALAN)
-- ========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera

-- ========================================
-- 1. BUAT GUI UTAMA
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHubGUI"
ScreenGui.ResetOnSpawn = false

-- ========================================
-- 2. BUAT LOGO (PASTI BISA DI KLIK)
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

-- Bikin logo jadi bulat
local LogoCorner = Instance.new("UICorner")
LogoCorner.Parent = Logo
LogoCorner.CornerRadius = UDim.new(1, 0)

-- Label kecil di bawah logo
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
-- 3. BUAT MENU (AWALNYA SEMBUNYI)
-- ========================================
local MenuFrame = Instance.new("Frame")
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 350, 0, 450)
MenuFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
MenuFrame.BackgroundTransparency = 0
MenuFrame.BorderSizePixel = 3
MenuFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MenuFrame.Visible = false  -- AWALNYA SEMBUNYI
MenuFrame.Active = true
MenuFrame.Draggable = true

local MenuCorner = Instance.new("UICorner")
MenuCorner.Parent = MenuFrame
MenuCorner.CornerRadius = UDim.new(0, 12)

-- Header menu
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

-- Tombol close menu
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

-- Scrolling frame buat isi menu
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
-- FUNGSI BUAT TOMBOL DI MENU
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

local function CreateSimpleButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollingFrame
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
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

local function CreateSimpleToggle(text, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 30)
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
    toggleBtn.Size = UDim2.new(0, 50, 0, 22)
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
-- 4. ISI MENU DENGAN FITUR
-- ========================================
local yPos = 5

-- COMBAT
CreateCategory("⚔️ COMBAT", yPos)
yPos = yPos + 28

CreateSimpleToggle("🛡️ Auto Parry", yPos, function(state)
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
yPos = yPos + 34

CreateSimpleToggle("💀 God Mode", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
    end
end)
yPos = yPos + 34

CreateSimpleToggle("💚 Auto Heal", yPos, function(state)
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
yPos = yPos + 34

CreateSimpleToggle("🔫 Auto Shoot", yPos, function(state)
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
yPos = yPos + 34

CreateSimpleButton("💥 One Hit Kill", yPos, function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end)
yPos = yPos + 34

-- DIVIDER
local divider = Instance.new("Frame")
divider.Parent = ScrollingFrame
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0, yPos)
divider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
divider.BackgroundTransparency = 0
divider.BorderSizePixel = 0
yPos = yPos + 12

-- KILL ALL
CreateCategory("💀 KILL ALL", yPos)
yPos = yPos + 28

CreateSimpleButton("💀 Kill All Instant", yPos, function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
            pcall(function()
                player.Character:BreakJoints()
            end)
        end
    end
    print("💀 Semua player/survivor telah dibunuh!")
end)
yPos = yPos + 34

-- DIVIDER
local divider2 = Instance.new("Frame")
divider2.Parent = ScrollingFrame
divider2.Size = UDim2.new(0.9, 0, 0, 2)
divider2.Position = UDim2.new(0.05, 0, 0, yPos)
divider2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
divider2.BackgroundTransparency = 0
divider2.BorderSizePixel = 0
yPos = yPos + 12

-- MOVEMENT
CreateCategory("🏃 MOVEMENT", yPos)
yPos = yPos + 28

CreateSimpleToggle("⚡ Speed Hack", yPos, function(state)
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
yPos = yPos + 34

CreateSimpleToggle("🕊️ Fly Mode", yPos, function(state)
    if state then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(10000, 10000, 10000)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
        RunService.RenderStepped:Connect(function()
            if not state then return end
            if not LocalPlayer.Character then return end
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local moveDir = Vector3.new()
            local cam = Camera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            if moveDir.Magnitude > 0 then bv.Velocity = moveDir.Unit * 50 else bv.Velocity = Vector3.new(0, 0.5, 0) end
        end)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity")
            if bv then bv:Destroy() end
        end
    end
end)
yPos = yPos + 34

CreateSimpleToggle("🧱 No Clip", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)
yPos = yPos + 34

CreateSimpleToggle("🌙 Moon Walk", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 50
                    humanoid.JumpPower = 0
                    humanoid.AutoRotate = false
                end
            end
        end)
    else-- ========================================
-- ZIP HUB - SIMPLE & STABLE
-- VERSION 10.0 (PASTI JALAN)
-- ========================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera

-- ========================================
-- 1. BUAT GUI UTAMA
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHubGUI"
ScreenGui.ResetOnSpawn = false

-- ========================================
-- 2. BUAT LOGO (PASTI BISA DI KLIK)
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

-- Bikin logo jadi bulat
local LogoCorner = Instance.new("UICorner")
LogoCorner.Parent = Logo
LogoCorner.CornerRadius = UDim.new(1, 0)

-- Label kecil di bawah logo
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
-- 3. BUAT MENU (AWALNYA SEMBUNYI)
-- ========================================
local MenuFrame = Instance.new("Frame")
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 350, 0, 450)
MenuFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
MenuFrame.BackgroundTransparency = 0
MenuFrame.BorderSizePixel = 3
MenuFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MenuFrame.Visible = false  -- AWALNYA SEMBUNYI
MenuFrame.Active = true
MenuFrame.Draggable = true

local MenuCorner = Instance.new("UICorner")
MenuCorner.Parent = MenuFrame
MenuCorner.CornerRadius = UDim.new(0, 12)

-- Header menu
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

-- Tombol close menu
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

-- Scrolling frame buat isi menu
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
-- FUNGSI BUAT TOMBOL DI MENU
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

local function CreateSimpleButton(text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = ScrollingFrame
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
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

local function CreateSimpleToggle(text, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 30)
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
    toggleBtn.Size = UDim2.new(0, 50, 0, 22)
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
-- 4. ISI MENU DENGAN FITUR
-- ========================================
local yPos = 5

-- COMBAT
CreateCategory("⚔️ COMBAT", yPos)
yPos = yPos + 28

CreateSimpleToggle("🛡️ Auto Parry", yPos, function(state)
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
yPos = yPos + 34

CreateSimpleToggle("💀 God Mode", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end
        end)
    end
end)
yPos = yPos + 34

CreateSimpleToggle("💚 Auto Heal", yPos, function(state)
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
yPos = yPos + 34

CreateSimpleToggle("🔫 Auto Shoot", yPos, function(state)
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
yPos = yPos + 34

CreateSimpleButton("💥 One Hit Kill", yPos, function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
        end
    end
end)
yPos = yPos + 34

-- DIVIDER
local divider = Instance.new("Frame")
divider.Parent = ScrollingFrame
divider.Size = UDim2.new(0.9, 0, 0, 2)
divider.Position = UDim2.new(0.05, 0, 0, yPos)
divider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
divider.BackgroundTransparency = 0
divider.BorderSizePixel = 0
yPos = yPos + 12

-- KILL ALL
CreateCategory("💀 KILL ALL", yPos)
yPos = yPos + 28

CreateSimpleButton("💀 Kill All Instant", yPos, function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.Health = 0
            pcall(function()
                player.Character:BreakJoints()
            end)
        end
    end
    print("💀 Semua player/survivor telah dibunuh!")
end)
yPos = yPos + 34

-- DIVIDER
local divider2 = Instance.new("Frame")
divider2.Parent = ScrollingFrame
divider2.Size = UDim2.new(0.9, 0, 0, 2)
divider2.Position = UDim2.new(0.05, 0, 0, yPos)
divider2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
divider2.BackgroundTransparency = 0
divider2.BorderSizePixel = 0
yPos = yPos + 12

-- MOVEMENT
CreateCategory("🏃 MOVEMENT", yPos)
yPos = yPos + 28

CreateSimpleToggle("⚡ Speed Hack", yPos, function(state)
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
yPos = yPos + 34

CreateSimpleToggle("🕊️ Fly Mode", yPos, function(state)
    if state then
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(10000, 10000, 10000)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp
        RunService.RenderStepped:Connect(function()
            if not state then return end
            if not LocalPlayer.Character then return end
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local moveDir = Vector3.new()
            local cam = Camera.CFrame
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            if moveDir.Magnitude > 0 then bv.Velocity = moveDir.Unit * 50 else bv.Velocity = Vector3.new(0, 0.5, 0) end
        end)
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("BodyVelocity")
            if bv then bv:Destroy() end
        end
    end
end)
yPos = yPos + 34

CreateSimpleToggle("🧱 No Clip", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)
yPos = yPos + 34

CreateSimpleToggle("🌙 Moon Walk", yPos, function(state)
    if state then
        RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 50
                    humanoid.JumpPower = 0
                    humanoid.AutoRotate = false
                end
            end
        end)
    else
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
yPos = yPos + 34

-- Update Canvas biar bisa di-scroll
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ========================================
-- 5. HUBUNGKAN LOGO DENGAN MENU
-- ========================================
Logo.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
    print("Logo ZH diklik! Menu Visible:", MenuFrame.Visible)
end)

print("✅ ZIP HUB - SIMPLE & STABLE Loaded!")
print("✅ Klik LOGO ZH di pojok kiri atas untuk buka/tutup menu!")
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
yPos = yPos + 34

-- Update Canvas biar bisa di-scroll
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- ========================================
-- 5. HUBUNGKAN LOGO DENGAN MENU
-- ========================================
Logo.MouseButton1Click:Connect(function()
    MenuFrame.Visible = not MenuFrame.Visible
    print("Logo ZH diklik! Menu Visible:", MenuFrame.Visible)
end)

print("✅ ZIP HUB - SIMPLE & STABLE Loaded!")
print("✅ Klik LOGO ZH di pojok kiri atas untuk buka/tutup menu!")
