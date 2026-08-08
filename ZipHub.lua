-- =====================================================
-- ZIP HUB – Violence District Edition
-- ALL FEATURES: Movement, ESP, God Mode,
-- Auto Generator, Auto Escape (Auto Win)
-- Custom UI – No Rayfield
-- =====================================================

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- =====================================================
-- VARIABLES
-- =====================================================
local speedChecked = false
local speedValue = 60
local jumpChecked = false
local jumpPower = 100
local flyChecked = false
local flySpeed = 150
local flying = false
local bv, bg
local noclipChecked = false
local noclipConnection
local godModeEnabled = false
local godModeLoop = nil
local autoGenEnabled = false
local autoGenLoop = nil
local autoEscapeEnabled = false
local autoEscapeLoop = nil
local espKiller = false
local espSurvivor = false
local espGenerator = false
local espObjects = {}
local isEscaping = false

-- =====================================================
-- FIND GENERATORS
-- =====================================================
local function FindGenerators()
    local gens = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen")) then
            table.insert(gens, obj)
        end
        if obj:IsA("Model") and obj.Name:lower():find("generator") then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then table.insert(gens, part) end
            end
        end
    end
    return gens
end

-- =====================================================
-- FIND ESCAPE GATES
-- =====================================================
local function FindEscapeGates()
    local gates = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("gate") or name:find("escape") or name:find("exit") or name:find("door") then
                table.insert(gates, obj)
            end
        end
    end
    return gates
end

-- =====================================================
-- AUTO GENERATOR
-- =====================================================
local function AutoGeneratorLoop()
    while autoGenEnabled and task.wait(1.5) do
        local char = LP.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local gens = FindGenerators()
        if #gens == 0 then continue end

        table.sort(gens, function(a, b)
            return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
        end)

        local target = gens[1]
        if not target then continue end

        hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
        task.wait(0.2)

        pcall(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)

        for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                local name = obj.Name:lower()
                if name:find("generator") or name:find("gen") or name:find("repair") or name:find("complete") then
                    pcall(function() obj:FireServer(target) end)
                    break
                end
            end
        end
    end
end

-- =====================================================
-- AUTO ESCAPE (AUTO WIN)
-- =====================================================
local function TriggerAutoEscape()
    if isEscaping then return end
    isEscaping = true

    local char = LP.Character
    if not char then isEscaping = false return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then isEscaping = false return end

    -- 1. Force End Game (buka semua gate)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("gate") then
            pcall(function()
                obj:SetAttribute("Open", true)
                local click = obj:FindFirstChild("ClickDetector")
                if click then click:Click() end
            end)
        end
    end
    for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
        if remote:IsA("RemoteEvent") and remote.Name:lower():find("gate") then
            pcall(function() remote:FireServer() end)
        end
    end
    task.wait(0.3)

    -- 2. Instant Escape (teleport ke gate terdekat)
    local gates = FindEscapeGates()
    if #gates > 0 then
        table.sort(gates, function(a, b)
            local posA = a:IsA("BasePart") and a.Position or (a:FindFirstChild("HumanoidRootPart") and a.HumanoidRootPart.Position) or Vector3.new(0,0,0)
            local posB = b:IsA("BasePart") and b.Position or (b:FindFirstChild("HumanoidRootPart") and b.HumanoidRootPart.Position) or Vector3.new(0,0,0)
            return (hrp.Position - posA).Magnitude < (hrp.Position - posB).Magnitude
        end)
        local target = gates[1]
        if target then
            local pos = target:IsA("BasePart") and target.Position or (target:FindFirstChild("HumanoidRootPart") and target.HumanoidRootPart.Position)
            if pos then
                hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                task.wait(0.3)
                pcall(function()
                    local click = target:FindFirstChild("ClickDetector")
                    if click then click:Click() end
                end)
                for _, remote in pairs(ReplicatedStorage:GetDescendants()) do
                    if remote:IsA("RemoteEvent") and remote.Name:lower():find("escape") then
                        pcall(function() remote:FireServer() end)
                        break
                    end
                end
            end
        end
    end

    isEscaping = false
end

local function AutoEscapeLoop()
    while autoEscapeEnabled and task.wait(2) do
        TriggerAutoEscape()
    end
end

-- =====================================================
-- ESP
-- =====================================================
local function ClearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
end

local function AddESP(target, color)
    if not target then return end
    local hl = Instance.new("Highlight")
    hl.Parent = target
    hl.FillColor = color
    hl.FillTransparency = 0.4
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.OutlineTransparency = 0.1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    table.insert(espObjects, hl)
end

local function UpdateESP()
    ClearESP()
    if not espKiller and not espSurvivor and not espGenerator then return end

    for _, player in pairs(Players:GetPlayers()) do
        if player == LP or not player.Character then continue end
        local isKiller = player.Team and player.Team.Name == "Killer"
        if espKiller and isKiller then
            AddESP(player.Character, Color3.fromRGB(255, 0, 0))
        end
        if espSurvivor and not isKiller then
            AddESP(player.Character, Color3.fromRGB(0, 255, 0))
        end
    end

    if espGenerator then
        for _, gen in pairs(FindGenerators()) do
            AddESP(gen.Parent or gen, Color3.fromRGB(0, 255, 255))
        end
    end
end

RunService.RenderStepped:Connect(function()
    if espKiller or espSurvivor or espGenerator then
        UpdateESP()
    else
        ClearESP()
    end
end)

-- =====================================================
-- MOVEMENT
-- =====================================================
local function applyVelocity()
    while speedChecked and task.wait() do
        local char = LP.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.MoveDirection.Magnitude > 0 then
            local currentY = hrp.Velocity.Y
            local move = hum.MoveDirection * speedValue
            hrp.Velocity = Vector3.new(move.X, currentY, move.Z)
        end
    end
end

local function applySuperJump()
    while jumpChecked and task.wait() do
        local char = LP.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Jump then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpPower, hrp.Velocity.Z)
        end
    end
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
end

local function startFly()
    if flying then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    flying = true
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e4, 9e4, 9e4)
    bv.Velocity = Vector3.zero
    bv.Parent = root
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e4, 9e4, 9e4)
    bg.P = 9e4
    bg.CFrame = root.CFrame
    bg.Parent = root
end

RunService.Heartbeat:Connect(function()
    if not flying or not bv or not bg then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local move = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end
    local cam = Workspace.CurrentCamera
    if move.Magnitude > 0 then
        move = cam.CFrame:VectorToWorldSpace(move.Unit) * flySpeed
    else
        move = Vector3.zero
    end
    bv.Velocity = move
    bg.CFrame = cam.CFrame
end)

local function stopNoclip()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
    local char = LP.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

local function startNoclip()
    if noclipConnection then return end
    noclipConnection = RunService.Stepped:Connect(function()
        if not noclipChecked and not flying then return end
        local char = LP.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
end

-- =====================================================
-- GOD MODE
-- =====================================================
local function toggleGodMode(state)
    godModeEnabled = state
    if state then
        if godModeLoop then godModeLoop:Disconnect() end
        godModeLoop = RunService.Heartbeat:Connect(function()
            if not godModeEnabled then return end
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if hum.Health < 100 and hum.Health > 0 then
                hum.Health = 100
            end
        end)
    else
        if godModeLoop then godModeLoop:Disconnect() godModeLoop = nil end
    end
end

-- =====================================================
-- RESPOND HANDLER
-- =====================================================
LP.CharacterAdded:Connect(function()
    task.wait(1)
    if speedChecked then task.spawn(applyVelocity) end
    if jumpChecked then task.spawn(applySuperJump) end
    if flyChecked then startFly() end
    if noclipChecked then startNoclip() end
    if autoGenEnabled then task.spawn(AutoGeneratorLoop) end
    if autoEscapeEnabled then task.spawn(AutoEscapeLoop) end
end)

LP.CharacterRemoving:Connect(function()
    stopFly()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
end)

-- =====================================================
-- CUSTOM UI – ZIP HUB
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZIPHUB"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 340, 0, 480)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame
MainCorner.CornerRadius = UDim.new(0, 12)

local MainBorder = Instance.new("UIStroke")
MainBorder.Parent = MainFrame
MainBorder.Color = Color3.fromRGB(0, 180, 255)
MainBorder.Thickness = 1.5
MainBorder.Transparency = 0.2

-- HEADER
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 12)

local Logo = Instance.new("Frame")
Logo.Parent = Header
Logo.Size = UDim2.new(0, 30, 0, 30)
Logo.Position = UDim2.new(0, 8, 0.5, -15)
Logo.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
Logo.BackgroundTransparency = 0
Logo.BorderSizePixel = 0
local LogoCorner = Instance.new("UICorner")
LogoCorner.Parent = Logo
LogoCorner.CornerRadius = UDim.new(1, 0)
local LogoText = Instance.new("TextLabel")
LogoText.Parent = Logo
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "Z"
LogoText.TextColor3 = Color3.fromRGB(10, 10, 25)
LogoText.TextSize = 20
LogoText.Font = Enum.Font.GothamBold

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 44, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZIP HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = Header
SubTitle.Size = UDim2.new(0.3, 0, 1, 0)
SubTitle.Position = UDim2.new(0.65, 0, 0, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "v3.0"
SubTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Right

local HideBtn = Instance.new("TextButton")
HideBtn.Parent = Header
HideBtn.Size = UDim2.new(0, 28, 0, 28)
HideBtn.Position = UDim2.new(1, -66, 0.5, -14)
HideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
HideBtn.Text = "−"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize = 18
HideBtn.Font = Enum.Font.GothamBold
HideBtn.BorderSizePixel = 0
local HideCorner = Instance.new("UICorner")
HideCorner.Parent = HideBtn
HideCorner.CornerRadius = UDim.new(1, 0)
local menuVisible = true
HideBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    HideBtn.Text = menuVisible and "−" or "+"
end)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseBtn
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- SCROLLING FRAME
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Size = UDim2.new(1, -12, 1, -65)
ScrollingFrame.Position = UDim2.new(0, 6, 0, 60)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
ScrollingFrame.BorderSizePixel = 0

-- TOGGLE CREATOR
local function CreateToggle(text, desc, key, yPos)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(0, 180, 255)
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7, 0, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left

    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = frame
    descLabel.Size = UDim2.new(0.7, 0, 0, 16)
    descLabel.Position = UDim2.new(0, 10, 0, 26)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc or ""
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.GothamMedium
    descLabel.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 50, 0, 26)
    toggleBtn.Position = UDim2.new(1, -60, 0, 12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = toggleBtn
    btnCorner.CornerRadius = UDim.new(0, 4)

    local state = false
    local function setState(val)
        state = val
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(200, 40, 40)
        if key == "speed" then speedChecked = state; if state then task.spawn(applyVelocity) end
        elseif key == "jump" then jumpChecked = state; if state then task.spawn(applySuperJump) end
        elseif key == "fly" then flyChecked = state; if state then startFly() else stopFly() end
        elseif key == "noclip" then noclipChecked = state; if state then startNoclip() else stopNoclip() end
        elseif key == "godmode" then toggleGodMode(state)
        elseif key == "autogen" then autoGenEnabled = state; if state then task.spawn(AutoGeneratorLoop) end
        elseif key == "autoescape" then autoEscapeEnabled = state; if state then task.spawn(AutoEscapeLoop) end
        elseif key == "espkiller" then espKiller = state
        elseif key == "espsurvivor" then espSurvivor = state
        elseif key == "espgen" then espGenerator = state
        end
    end

    toggleBtn.MouseButton1Click:Connect(function()
        setState(not state)
    end)

    return yPos + 54, setState
end

-- SLIDER CREATOR
local function CreateSlider(text, desc, key, min, max, default, yPos)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 55)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(0, 180, 255)
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 0, 18)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. " (" .. default .. ")"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left

    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = frame
    descLabel.Size = UDim2.new(0.6, 0, 0, 16)
    descLabel.Position = UDim2.new(0, 10, 0, 26)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc or ""
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.GothamMedium
    descLabel.TextXAlignment = Enum.TextXAlignment.Left

    local val = default
    local slider = Instance.new("Frame")
    slider.Parent = frame
    slider.Size = UDim2.new(0, 100, 0, 6)
    slider.Position = UDim2.new(0.6, 10, 0.5, -3)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    slider.BorderSizePixel = 0
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.Parent = slider
    sliderCorner.CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Parent = slider
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    fill.BorderSizePixel = 0
    local fillCorner = Instance.new("UICorner")
    fillCorner.Parent = fill
    fillCorner.CornerRadius = UDim.new(1, 0)

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.Size = UDim2.new(0, 40, 0, 20)
    valueLabel.Position = UDim2.new(0.9, 0, 0.5, -10)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.GothamBold

    local dragging = false
    local function updateSlider(mouseX)
        local relX = math.clamp((mouseX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        val = math.floor(min + (max - min) * relX)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        valueLabel.Text = tostring(val)
        label.Text = text .. " (" .. val .. ")"
        if key == "speed" then speedValue = val
        elseif key == "jump" then jumpPower = val
        elseif key == "flyspeed" then flySpeed = val
        end
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input.Position.X)
        end
    end)
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input.Position.X)
        end
    end)

    return yPos + 59
end

-- =====================================================
-- BUILD UI
-- =====================================================
local yPos = 2
yPos = CreateToggle("⚡ Speed Glitch", "Run faster", "speed", yPos)
yPos = CreateSlider("Speed Multiplier", "Speed value", "speed", 16, 300, 60, yPos)
yPos = CreateToggle("🦘 Super Jump", "Jump higher", "jump", yPos)
yPos = CreateSlider("Jump Power", "Jump height", "jump", 50, 500, 100, yPos)
yPos = CreateToggle("✈️ Fly", "WASD + Space/Shift", "fly", yPos)
yPos = CreateSlider("Fly Speed", "Flying speed", "flyspeed", 10, 500, 150, yPos)
yPos = CreateToggle("🚪 No Clip", "Walk through walls", "noclip", yPos)
yPos = CreateToggle("🛡️ God Mode", "Infinite health (anti-freeze)", "godmode", yPos)
yPos = CreateToggle("⚡ Auto Generator", "Auto repair generators", "autogen", yPos)
yPos = CreateToggle("🏃 Auto Escape", "Auto win as survivor", "autoescape", yPos)
yPos = CreateToggle("🔴 Killer ESP", "Highlight killer", "espkiller", yPos)
yPos = CreateToggle("🟢 Survivor ESP", "Highlight survivors", "espsurvivor", yPos)
yPos = CreateToggle("⚡ Generator ESP", "Highlight generators", "espgen", yPos)

ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- WATERMARK
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 160, 0, 16)
Watermark.Position = UDim2.new(0, 8, 1, -22)
Watermark.BackgroundTransparency = 1
Watermark.Text = "⚡ ZIP HUB v3.0 ⚡"
Watermark.TextColor3 = Color3.fromRGB(0, 180, 255)
Watermark.TextSize = 10
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextTransparency = 0.4

print("✅ ZIP HUB v3.0 Loaded – All features ready!")
print("✅ Auto Escape (Auto Win) included!")
