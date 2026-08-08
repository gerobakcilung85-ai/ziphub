-- =====================================================
-- ZIP UI LIBRARY v1.0 (Custom Animations)
-- =====================================================
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local ZIP = {}
local Theme = {
    Background = Color3.fromRGB(15, 15, 35),
    Section = Color3.fromRGB(25, 25, 50),
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 200),
    ButtonOff = Color3.fromRGB(200, 40, 40),
    ButtonOn = Color3.fromRGB(40, 200, 40),
    Border = Color3.fromRGB(0, 180, 255),
}

local function Animate(obj, props, duration, style)
    style = style or Enum.EasingStyle.Quad
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.3, style, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function Notify(title, content, duration)
    duration = duration or 3
    local gui = Instance.new("ScreenGui")
    gui.Parent = CoreGui
    gui.Name = "ZIPNotify"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(0.5, -150, 1, 20)
    frame.BackgroundColor3 = Theme.Background
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Theme.Accent
    frame.ClipsDescendants = true
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 10)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = frame
    titleLabel.Size = UDim2.new(1, -20, 0, 22)
    titleLabel.Position = UDim2.new(0, 10, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Accent
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Parent = frame
    contentLabel.Size = UDim2.new(1, -20, 0, 20)
    contentLabel.Position = UDim2.new(0, 10, 0, 30)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = Theme.Text
    contentLabel.TextSize = 13
    contentLabel.Font = Enum.Font.GothamMedium
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left

    Animate(frame, {Position = UDim2.new(0.5, -150, 0.9, 0)}, 0.4, Enum.EasingStyle.Back)
    task.wait(duration)
    Animate(frame, {Position = UDim2.new(0.5, -150, 1.2, 0)}, 0.3)
    task.wait(0.3)
    gui:Destroy()
end

function ZIP:CreateWindow(config)
    local window = {}
    local gui = Instance.new("ScreenGui")
    gui.Parent = CoreGui
    gui.Name = "ZIPUI"
    gui.ResetOnSpawn = false

    local main = Instance.new("Frame")
    main.Parent = gui
    main.Size = UDim2.new(0, 340, 0, 480)
    main.Position = UDim2.new(0.5, -170, 0.5, -240)
    main.BackgroundColor3 = Theme.Background
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 1
    main.BorderColor3 = Theme.Border
    main.ClipsDescendants = true
    main.Active = true
    main.Draggable = true
    local corner = Instance.new("UICorner")
    corner.Parent = main
    corner.CornerRadius = UDim.new(0, 12)

    local header = Instance.new("Frame")
    header.Parent = main
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Theme.Accent
    header.BackgroundTransparency = 0.2
    header.BorderSizePixel = 0
    local headerCorner = Instance.new("UICorner")
    headerCorner.Parent = header
    headerCorner.CornerRadius = UDim.new(0, 12)

    local logo = Instance.new("Frame")
    logo.Parent = header
    logo.Size = UDim2.new(0, 30, 0, 30)
    logo.Position = UDim2.new(0, 8, 0.5, -15)
    logo.BackgroundColor3 = Theme.Accent
    logo.BackgroundTransparency = 0
    logo.BorderSizePixel = 0
    local logoCorner = Instance.new("UICorner")
    logoCorner.Parent = logo
    logoCorner.CornerRadius = UDim.new(1, 0)
    local logoText = Instance.new("TextLabel")
    logoText.Parent = logo
    logoText.Size = UDim2.new(1, 0, 1, 0)
    logoText.BackgroundTransparency = 1
    logoText.Text = "Z"
    logoText.TextColor3 = Color3.fromRGB(10, 10, 25)
    logoText.TextSize = 20
    logoText.Font = Enum.Font.GothamBold

    local title = Instance.new("TextLabel")
    title.Parent = header
    title.Size = UDim2.new(0.6, 0, 1, 0)
    title.Position = UDim2.new(0, 44, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = config.Name or "ZIP HUB"
    title.TextColor3 = Theme.Text
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left

    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = header
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -34, 0.5, -14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    local closeCorner = Instance.new("UICorner")
    closeCorner.Parent = closeBtn
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeBtn.MouseButton1Click:Connect(function()
        Animate(main, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        gui:Destroy()
    end)

    local tabContainer = Instance.new("Frame")
    tabContainer.Parent = main
    tabContainer.Size = UDim2.new(1, 0, 0, 30)
    tabContainer.Position = UDim2.new(0, 0, 0, 45)
    tabContainer.BackgroundTransparency = 1

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Parent = tabContainer
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local content = Instance.new("Frame")
    content.Parent = main
    content.Size = UDim2.new(1, -12, 1, -85)
    content.Position = UDim2.new(0, 6, 0, 80)
    content.BackgroundTransparency = 1
    content.ClipsDescendants = true

    local scroll = Instance.new("ScrollingFrame")
    scroll.Parent = content
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = Theme.Accent
    scroll.BorderSizePixel = 0

    window._gui = gui
    window._main = main
    window._scroll = scroll
    window._tabs = {}
    window._tabButtons = {}
    window._currentTab = nil

    function window:CreateTab(name)
        local tab = {}
        local btn = Instance.new("TextButton")
        btn.Parent = tabContainer
        btn.Size = UDim2.new(0, 80, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = name
        btn.TextColor3 = Theme.TextDark
        btn.TextSize = 13
        btn.Font = Enum.Font.GothamBold
        btn.BorderSizePixel = 0

        local contentFrame = Instance.new("Frame")
        contentFrame.Parent = scroll
        contentFrame.Size = UDim2.new(1, 0, 0, 0)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Visible = false
        contentFrame.ClipsDescendants = true

        local yPos = 0

        local function selectTab()
            for _, b in pairs(window._tabButtons) do
                b.TextColor3 = Theme.TextDark
            end
            btn.TextColor3 = Theme.Accent
            for _, c in pairs(window._tabs) do
                c._content.Visible = false
            end
            contentFrame.Visible = true
            window._currentTab = name
            local totalHeight = 0
            for _, child in pairs(contentFrame:GetChildren()) do
                if child:IsA("Frame") then
                    totalHeight = totalHeight + child.Size.Y.Offset + 6
                end
            end
            contentFrame.Size = UDim2.new(1, 0, 0, totalHeight)
            scroll.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        end

        btn.MouseButton1Click:Connect(selectTab)
        table.insert(window._tabButtons, btn)
        table.insert(window._tabs, {_content = contentFrame, _name = name})

        if #window._tabButtons == 1 then
            selectTab()
        end

        function tab:CreateSection(title)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Parent = contentFrame
            sectionFrame.Size = UDim2.new(1, 0, 0, 30)
            sectionFrame.Position = UDim2.new(0, 0, 0, yPos)
            sectionFrame.BackgroundTransparency = 1

            local label = Instance.new("TextLabel")
            label.Parent = sectionFrame
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = title
            label.TextColor3 = Theme.Accent
            label.TextSize = 14
            label.Font = Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Left

            yPos = yPos + 34
            return {
                _addToggle = function(self, text, desc, callback)
                    local frame = Instance.new("Frame")
                    frame.Parent = contentFrame
                    frame.Size = UDim2.new(1, 0, 0, 50)
                    frame.Position = UDim2.new(0, 0, 0, yPos)
                    frame.BackgroundColor3 = Theme.Section
                    frame.BackgroundTransparency = 0.2
                    frame.BorderSizePixel = 1
                    frame.BorderColor3 = Theme.Border
                    local corner = Instance.new("UICorner")
                    corner.Parent = frame
                    corner.CornerRadius = UDim.new(0, 6)

                    local label = Instance.new("TextLabel")
                    label.Parent = frame
                    label.Size = UDim2.new(0.7, 0, 0, 18)
                    label.Position = UDim2.new(0, 10, 0, 4)
                    label.BackgroundTransparency = 1
                    label.Text = text
                    label.TextColor3 = Theme.Text
                    label.TextSize = 13
                    label.Font = Enum.Font.GothamBold
                    label.TextXAlignment = Enum.TextXAlignment.Left

                    local descLabel = Instance.new("TextLabel")
                    descLabel.Parent = frame
                    descLabel.Size = UDim2.new(0.7, 0, 0, 16)
                    descLabel.Position = UDim2.new(0, 10, 0, 26)
                    descLabel.BackgroundTransparency = 1
                    descLabel.Text = desc or ""
                    descLabel.TextColor3 = Theme.TextDark
                    descLabel.TextSize = 10
                    descLabel.Font = Enum.Font.GothamMedium
                    descLabel.TextXAlignment = Enum.TextXAlignment.Left

                    local toggleBtn = Instance.new("TextButton")
                    toggleBtn.Parent = frame
                    toggleBtn.Size = UDim2.new(0, 50, 0, 26)
                    toggleBtn.Position = UDim2.new(1, -60, 0, 12)
                    toggleBtn.BackgroundColor3 = Theme.ButtonOff
                    toggleBtn.Text = "OFF"
                    toggleBtn.TextColor3 = Theme.Text
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
                        local targetColor = state and Theme.ButtonOn or Theme.ButtonOff
                        Animate(toggleBtn, {BackgroundColor3 = targetColor}, 0.2)
                        callback(state)
                    end

                    toggleBtn.MouseButton1Click:Connect(function()
                        setState(not state)
                    end)

                    yPos = yPos + 54
                    return {SetValue = setState, GetValue = function() return state end}
                end,
                _addSlider = function(self, text, desc, min, max, default, callback)
                    local frame = Instance.new("Frame")
                    frame.Parent = contentFrame
                    frame.Size = UDim2.new(1, 0, 0, 55)
                    frame.Position = UDim2.new(0, 0, 0, yPos)
                    frame.BackgroundColor3 = Theme.Section
                    frame.BackgroundTransparency = 0.2
                    frame.BorderSizePixel = 1
                    frame.BorderColor3 = Theme.Border
                    local corner = Instance.new("UICorner")
                    corner.Parent = frame
                    corner.CornerRadius = UDim.new(0, 6)

                    local label = Instance.new("TextLabel")
                    label.Parent = frame
                    label.Size = UDim2.new(0.6, 0, 0, 18)
                    label.Position = UDim2.new(0, 10, 0, 4)
                    label.BackgroundTransparency = 1
                    label.Text = text .. " (" .. default .. ")"
                    label.TextColor3 = Theme.Text
                    label.TextSize = 13
                    label.Font = Enum.Font.GothamBold
                    label.TextXAlignment = Enum.TextXAlignment.Left

                    local descLabel = Instance.new("TextLabel")
                    descLabel.Parent = frame
                    descLabel.Size = UDim2.new(0.6, 0, 0, 16)
                    descLabel.Position = UDim2.new(0, 10, 0, 26)
                    descLabel.BackgroundTransparency = 1
                    descLabel.Text = desc or ""
                    descLabel.TextColor3 = Theme.TextDark
                    descLabel.TextSize = 10
                    descLabel.Font = Enum.Font.GothamMedium
                    descLabel.TextXAlignment = Enum.TextXAlignment.Left

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
                    fill.BackgroundColor3 = Theme.Accent
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
                    valueLabel.TextColor3 = Theme.Text
                    valueLabel.TextSize = 12
                    valueLabel.Font = Enum.Font.GothamBold

                    local val = default
                    local dragging = false
                    local function updateSlider(mouseX)
                        local relX = math.clamp((mouseX - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                        val = math.floor(min + (max - min) * relX)
                        fill.Size = UDim2.new(relX, 0, 1, 0)
                        valueLabel.Text = tostring(val)
                        label.Text = text .. " (" .. val .. ")"
                        callback(val)
                    end

                    slider.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            updateSlider(input.Position.X)
                        end
                    end)
                    slider.InputEnded:Connect(function()
                        dragging = false
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            updateSlider(input.Position.X)
                        end
                    end)

                    yPos = yPos + 59
                    return {SetValue = function(v) val = v; callback(v); fill.Size = UDim2.new((v-min)/(max-min),0,1,0); valueLabel.Text=tostring(v); label.Text=text.." ("..v..")" end, GetValue = function() return val end}
                end,
                _addColorPicker = function(self, text, default, callback)
                    local frame = Instance.new("Frame")
                    frame.Parent = contentFrame
                    frame.Size = UDim2.new(1, 0, 0, 40)
                    frame.Position = UDim2.new(0, 0, 0, yPos)
                    frame.BackgroundColor3 = Theme.Section
                    frame.BackgroundTransparency = 0.2
                    frame.BorderSizePixel = 1
                    frame.BorderColor3 = Theme.Border
                    local corner = Instance.new("UICorner")
                    corner.Parent = frame
                    corner.CornerRadius = UDim.new(0, 6)

                    local label = Instance.new("TextLabel")
                    label.Parent = frame
                    label.Size = UDim2.new(0.7, 0, 1, 0)
                    label.Position = UDim2.new(0, 10, 0, 0)
                    label.BackgroundTransparency = 1
                    label.Text = text
                    label.TextColor3 = Theme.Text
                    label.TextSize = 13
                    label.Font = Enum.Font.GothamBold
                    label.TextXAlignment = Enum.TextXAlignment.Left

                    local colorDisplay = Instance.new("Frame")
                    colorDisplay.Parent = frame
                    colorDisplay.Size = UDim2.new(0, 30, 0, 26)
                    colorDisplay.Position = UDim2.new(1, -40, 0.5, -13)
                    colorDisplay.BackgroundColor3 = default
                    colorDisplay.BorderSizePixel = 1
                    colorDisplay.BorderColor3 = Theme.Border
                    local colorCorner = Instance.new("UICorner")
                    colorCorner.Parent = colorDisplay
                    colorCorner.CornerRadius = UDim.new(0, 4)

                    local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0), Color3.fromRGB(255,165,0), Color3.fromRGB(255,20,147)}
                    local index = 1
                    colorDisplay.MouseButton1Click:Connect(function()
                        index = index % #colors + 1
                        colorDisplay.BackgroundColor3 = colors[index]
                        callback(colors[index])
                    end)

                    yPos = yPos + 44
                    return {SetValue = function(c) colorDisplay.BackgroundColor3 = c; callback(c) end}
                end
            }
        end

        function tab:CreateToggle(config)
            local section = self:CreateSection("")
            local toggle = section._addToggle(config.Name, config.Desc or "", function(v)
                if config.Callback then config.Callback(v) end
            end)
            if config.CurrentValue then toggle:SetValue(config.CurrentValue) end
            return toggle
        end

        function tab:CreateSlider(config)
            local section = self:CreateSection("")
            local slider = section._addSlider(config.Name, config.Desc or "", config.Range[1], config.Range[2], config.CurrentValue or config.Range[1], function(v)
                if config.Callback then config.Callback(v) end
            end)
            return slider
        end

        function tab:CreateColorPicker(config)
            local section = self:CreateSection("")
            local picker = section._addColorPicker(config.Name, config.Color or Color3.fromRGB(255,255,255), function(c)
                if config.Callback then config.Callback(c) end
            end)
            return picker
        end

        return tab
    end

    function window:Notify(config)
        Notify(config.Title or "Notification", config.Content or "", config.Duration or 3)
    end

    return window
end
-- =====================================================
-- AKHIR LIBRARY ZIP UI
-- =====================================================

-- =====================================================
-- ZIP HUB – Violence District Edition
-- Menggunakan ZIP UI Library (tanpa Rayfield)
-- =====================================================

local Window = ZIP:CreateWindow({
   Name = "ZIP HUB – Violence District",
})

local LP = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

-- =====================================================
-- TAB 1: MOVEMENT (Speed, Jump, Fly, NoClip)
-- =====================================================
local MoveTab = Window:CreateTab("Movement")

-- Speed Glitch Variables
local speedChecked = false
local speedValue = 60

-- Super Jump Variables
local jumpChecked = false
local jumpPower = 100

-- Fly Variables
local flyChecked = false
local flySpeed = 150
local flying = false
local bv, bg

-- NoClip Variables
local noclipChecked = false
local noclipConnection

-- ===== SPEED GLITCH =====
local function applyVelocity()
    while speedChecked and task.wait() do
        local character = LP.Character
        if not character then continue end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if hrp and humanoid and humanoid.MoveDirection.Magnitude > 0 then
            local currentY = hrp.Velocity.Y
            local move = humanoid.MoveDirection * speedValue
            hrp.Velocity = Vector3.new(move.X, currentY, move.Z)
        end
    end
end

-- ===== SUPER JUMP =====
local function applySuperJump()
    while jumpChecked and task.wait() do
        local character = LP.Character
        if not character then continue end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if hrp and humanoid and humanoid.Jump then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, jumpPower, hrp.Velocity.Z)
        end
    end
end

-- ===== FLY =====
local function stopFly()
    flying = false
    if bv then bv:Destroy() bv = nil end
    if bg then bg:Destroy() bg = nil end
end

local function startFly()
    if flying then return end
    local character = LP.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
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

-- Fly Control Loop
RunService.Heartbeat:Connect(function()
    if not flying or not bv or not bg then return end
    local character = LP.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local root = character.HumanoidRootPart
    local move = Vector3.new()
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end
    local cam = workspace.CurrentCamera
    if move.Magnitude > 0 then
        move = cam.CFrame:VectorToWorldSpace(move.Unit) * flySpeed
    else
        move = Vector3.zero
    end
    bv.Velocity = move
    bg.CFrame = cam.CFrame
end)

-- ===== NOCLIP =====
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

-- ===== GUI MOVEMENT =====
MoveTab:CreateSection("Speed Settings")
MoveTab:CreateToggle({
   Name = "Speed Glitch",
   CurrentValue = false,
   Callback = function(Value)
       speedChecked = Value
       if speedChecked then task.spawn(applyVelocity) end
   end,
})
MoveTab:CreateSlider({
   Name = "Speed Multiplier",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Velocity",
   CurrentValue = 60,
   Callback = function(Value) speedValue = Value end,
})

MoveTab:CreateSection("Jump Settings")
MoveTab:CreateToggle({
   Name = "Super Jump",
   CurrentValue = false,
   Callback = function(Value)
       jumpChecked = Value
       if jumpChecked then task.spawn(applySuperJump) end
   end,
})
MoveTab:CreateSlider({
   Name = "Jump Power",
   Range = {50, 500},
   Increment = 5,
   Suffix = "Height",
   CurrentValue = 100,
   Callback = function(Value) jumpPower = Value end,
})

MoveTab:CreateSection("Flight & NoClip")
MoveTab:CreateToggle({
   Name = "Fly (W,A,S,D,Space,Shift)",
   CurrentValue = false,
   Callback = function(Value)
       flyChecked = Value
       if Value then startFly() else stopFly() end
   end,
})
MoveTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 500},
   Increment = 10,
   Suffix = "Studs",
   CurrentValue = 150,
   Callback = function(Value) flySpeed = Value end,
})
MoveTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Callback = function(Value)
       noclipChecked = Value
       if Value then startNoclip() else stopNoclip() end
   end,
})

-- Character respawn handlers (Movement)
LP.CharacterAdded:Connect(function()
    task.wait(1)
    if speedChecked then task.spawn(applyVelocity) end
    if jumpChecked then task.spawn(applySuperJump) end
    if flyChecked then startFly() end
    if noclipChecked then startNoclip() end
end)
LP.CharacterRemoving:Connect(function()
    stopFly()
    if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
end)

-- =====================================================
-- TAB 2: VISUALS: ESP+
-- =====================================================
local VisualsAdvTab = Window:CreateTab("Visuals: ESP+")

-- ESP Settings
local ESP_Settings = {
    SurvivorColor = Color3.fromRGB(0, 255, 0),
    KillerColor = Color3.fromRGB(255, 0, 0),
    GenColor = Color3.fromRGB(0, 255, 255),
    PalletColor = Color3.fromRGB(127, 0, 255),
    GenProgressColor = Color3.fromRGB(255, 255, 255),
    SurvivorsActive = false,
    KillerActive = false,
    GenActive = false,
    PalletsActive = false,
    TracersActive = false,
    GenProgressActive = false
}

local playerTrackers = {}
local generatorProgressBillboards = {}

-- ===== HIGHLIGHTS =====
local function refreshHighlights()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP or not player.Character then continue end
        local isSurvivor = player.Team and player.Team.Name == "Survivors"
        local isKiller = player.Team and player.Team.Name == "Killer"
        local hl = player.Character:FindFirstChild("CustomESP")
        if (isSurvivor and ESP_Settings.SurvivorsActive) or (isKiller and ESP_Settings.KillerActive) then
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "CustomESP"
                hl.FillTransparency = 1
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.Parent = player.Character
            end
            hl.OutlineColor = isSurvivor and ESP_Settings.SurvivorColor or ESP_Settings.KillerColor
        else
            if hl then hl:Destroy() end
        end
    end
end

local function updateGenESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("generator") and (obj:IsA("Model") or obj:IsA("BasePart")) then
            local hl = obj:FindFirstChild("GenHL")
            if ESP_Settings.GenActive then
                if not hl then
                    hl = Instance.new("Highlight", obj)
                    hl.Name = "GenHL"
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                hl.FillColor = ESP_Settings.GenColor
                hl.OutlineColor = Color3.new(1,1,1)
                hl.FillTransparency = 0.5
            else
                if hl then hl:Destroy() end
            end
        end
    end
end

local function updatePalletESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name == "Palletwrong" then
            local hl = obj:FindFirstChild("PalletHL")
            if ESP_Settings.PalletsActive then
                if not hl then
                    hl = Instance.new("Highlight", obj)
                    hl.Name = "PalletHL"
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                end
                hl.FillColor = ESP_Settings.PalletColor
                hl.OutlineColor = ESP_Settings.PalletColor
                hl.FillTransparency = 0.5
            else
                if hl then hl:Destroy() end
            end
        end
    end
end

-- ===== TRACERS =====
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local isSurvivor = player.Team and player.Team.Name == "Survivors"
        local isKiller = player.Team and player.Team.Name == "Killer"
        local canShowTracer = ESP_Settings.TracersActive and ((isSurvivor and ESP_Settings.SurvivorsActive) or (isKiller and ESP_Settings.KillerActive))
        if canShowTracer and hrp then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local line = playerTrackers[player] or Drawing.new("Line")
                line.Visible = true
                line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                line.To = Vector2.new(vector.X, vector.Y)
                line.Color = isSurvivor and ESP_Settings.SurvivorColor or ESP_Settings.KillerColor
                line.Thickness = 1.5
                line.Transparency = 1
                playerTrackers[player] = line
            elseif playerTrackers[player] then playerTrackers[player].Visible = false end
        elseif playerTrackers[player] then playerTrackers[player].Visible = false end
    end
end)

-- ===== GENERATOR PROGRESS =====
local function getRepairValue(model)
    local val = model:GetAttribute("RepairProgress") or model:GetAttribute("Progress")
    if val ~= nil then return val end
    for _, child in ipairs(model:GetDescendants()) do
        local cVal = child:GetAttribute("RepairProgress") or child:GetAttribute("Progress")
        if cVal ~= nil then return cVal end
    end
    return nil
end

local function createGenProgressUI(model)
    if generatorProgressBillboards[model] then return end
    local bbg = Instance.new("BillboardGui", model)
    bbg.Name = "GenProgressUI"
    bbg.Size = UDim2.new(0, 100, 0, 40)
    bbg.StudsOffset = Vector3.new(0, 8, 0)
    bbg.AlwaysOnTop = true
    local label = Instance.new("TextLabel", bbg)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = ESP_Settings.GenProgressColor
    generatorProgressBillboards[model] = bbg
    task.spawn(function()
        while ESP_Settings.GenProgressActive and bbg and bbg.Parent do
            local raw = getRepairValue(model) or 0
            local percent = math.floor(raw <= 1.1 and raw * 100 or raw)
            label.Text = math.clamp(percent, 0, 100) .. "%"
            label.TextColor3 = ESP_Settings.GenProgressColor
            task.wait(0.5)
        end
        bbg:Destroy()
        generatorProgressBillboards[model] = nil
    end)
end

local function updateGenProgress(state)
    ESP_Settings.GenProgressActive = state
    if not state then return end
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("generator") then
            if getRepairValue(obj) then createGenProgressUI(obj) end
        end
    end
end

-- ===== GUI ESP =====
VisualsAdvTab:CreateSection("Player ESP")
VisualsAdvTab:CreateToggle({
   Name = "ESP Survivors",
   CurrentValue = false,
   Callback = function(v) ESP_Settings.SurvivorsActive = v refreshHighlights() end
})
VisualsAdvTab:CreateColorPicker({
    Name = "Survivors Color",
    Color = ESP_Settings.SurvivorColor,
    Callback = function(v) ESP_Settings.SurvivorColor = v refreshHighlights() end
})
VisualsAdvTab:CreateToggle({
   Name = "ESP Killer",
   CurrentValue = false,
   Callback = function(v) ESP_Settings.KillerActive = v refreshHighlights() end
})
VisualsAdvTab:CreateColorPicker({
    Name = "Killer Color",
    Color = ESP_Settings.KillerColor,
    Callback = function(v) ESP_Settings.KillerColor = v refreshHighlights() end
})
VisualsAdvTab:CreateToggle({
   Name = "Enable Tracers (Top Center)",
   CurrentValue = false,
   Callback = function(v) ESP_Settings.TracersActive = v end
})

VisualsAdvTab:CreateSection("Environment ESP")
VisualsAdvTab:CreateToggle({
   Name = "Generator Outlines",
   CurrentValue = false,
   Callback = function(v) ESP_Settings.GenActive = v updateGenESP() end
})
VisualsAdvTab:CreateColorPicker({
    Name = "Generator Color",
    Color = ESP_Settings.GenColor,
    Callback = function(v) ESP_Settings.GenColor = v updateGenESP() end
})
VisualsAdvTab:CreateToggle({
   Name = "Pallets ESP",
   CurrentValue = false,
   Callback = function(v) ESP_Settings.PalletsActive = v updatePalletESP() end
})
VisualsAdvTab:CreateColorPicker({
    Name = "Pallet Color",
    Color = ESP_Settings.PalletColor,
    Callback = function(v) ESP_Settings.PalletColor = v updatePalletESP() end
})

VisualsAdvTab:CreateSection("Generator Progress")
VisualsAdvTab:CreateToggle({
   Name = "Show Repair %",
   CurrentValue = false,
   Callback = function(v) updateGenProgress(v) end
})
VisualsAdvTab:CreateColorPicker({
    Name = "Percentage Color",
    Color = ESP_Settings.GenProgressColor,
    Callback = function(v) ESP_Settings.GenProgressColor = v end
})

-- ESP events
Players.PlayerRemoving:Connect(function(p)
    if playerTrackers[p] then
        playerTrackers[p]:Remove()
        playerTrackers[p] = nil
    end
end)
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(0.5)
        refreshHighlights()
    end)
end)

-- =====================================================
-- TAB 3: FUNCTIONS (GOD MODE - ANTI-FREEZE)
-- =====================================================
local FunctionsTab = Window:CreateTab("Functions")

-- GOD MODE VARIABLES
local godModeEnabled = false
local godModeLoop = nil
local oldNamecallHook = nil

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

        if hookmetamethod and not oldNamecallHook then
            oldNamecallHook = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if godModeEnabled and method == "FireServer" then
                    local name = string.lower(self.Name)
                    if name:find("damage") or name:find("twist") or name:find("fate") or name:find("hurt") or name:find("kill") then
                        return nil
                    end
                end
                return oldNamecallHook(self, ...)
            end)
        end

        Window:Notify({Title = "ZIP HUB – God Mode", Content = "✅ Aktif", Duration = 2})
    else
        if godModeLoop then godModeLoop:Disconnect() end
        godModeEnabled = false
        Window:Notify({Title = "ZIP HUB – God Mode", Content = "❌ Mati", Duration = 2})
    end
end

FunctionsTab:CreateSection("Protection")
FunctionsTab:CreateToggle({
    Name = "God Mode (Anti Twist / Damage)",
    CurrentValue = false,
    Callback = function(v) toggleGodMode(v) end
})

-- =====================================================
-- TAB 4: AUTO (Fitur Baru)
-- =====================================================
local AutoTab = Window:CreateTab("Auto")

-- ===== VARIABLES =====
local autoGenEnabled = false
local autoEscapeEnabled = false
local smartGenEnabled = false
local completedGenerators = {}
local isEscaping = false

-- ===== FIND GENERATORS =====
local function FindGenerators()
    local gens = {}
    for _, obj in pairs(workspace:GetDescendants()) do
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

-- ===== FIND ESCAPE GATES =====
local function FindEscapeGates()
    local gates = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("gate") or name:find("escape") or name:find("exit") or name:find("door") then
                table.insert(gates, obj)
            end
        end
    end
    return gates
end

-- ===== FIND KILLER =====
local function FindKiller()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        if player.Team and player.Team.Name == "Killer" then
            return player
        end
    end
    return nil
end

-- ===== AUTO GENERATOR =====
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

        local isCompleted = false
        if target:GetAttribute("Completed") == true then isCompleted = true
        elseif target:GetAttribute("Progress") and target:GetAttribute("Progress") >= 1 then isCompleted = true
        elseif target.Parent and target.Parent:GetAttribute("Completed") == true then isCompleted = true
        end

        if isCompleted then
            completedGenerators[target] = true
            continue
        end

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

-- ===== AUTO ESCAPE =====
local function TriggerAutoEscape()
    if isEscaping then return end
    isEscaping = true

    local char = LP.Character
    if not char then isEscaping = false return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then isEscaping = false return end

    for _, obj in pairs(workspace:GetDescendants()) do
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

-- ===== SMART GENERATOR TELEPORT =====
local function GetNearestIncompleteGenerator()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local gens = FindGenerators()
    local nearest = nil
    local nearestDist = math.huge

    for _, gen in pairs(gens) do
        local isCompleted = false
        if gen:GetAttribute("Completed") == true then isCompleted = true
        elseif gen:GetAttribute("Progress") and gen:GetAttribute("Progress") >= 1 then isCompleted = true
        elseif gen.Parent and gen.Parent:GetAttribute("Completed") == true then isCompleted = true
        elseif completedGenerators[gen] then isCompleted = true
        end

        if not isCompleted then
            local dist = (hrp.Position - gen.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = gen
            end
        end
    end
    return nearest
end

local function TeleportToNearestIncompleteGenerator()
    local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local target = GetNearestIncompleteGenerator()
    if target then
        hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
        print("📍 ZIP HUB: Teleport ke generator terdekat yang belum selesai!")
    else
        print("⚠️ ZIP HUB: Tidak ada generator yang belum selesai ditemukan!")
    end
end

local function SmartGenLoop()
    while smartGenEnabled and task.wait(1) do
        local char = LP.Character
        if not char then continue end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local killer = FindKiller()
        local killerNearby = false
        if killer and killer.Character then
            local killerHrp = killer.Character:FindFirstChild("HumanoidRootPart")
            if killerHrp then
                local dist = (hrp.Position - killerHrp.Position).Magnitude
                if dist < 40 then killerNearby = true end
            end
        end

        local currentGenCompleted = false
        local gens = FindGenerators()
        local currentGen = nil
        local minDist = 5
        for _, gen in pairs(gens) do
            local dist = (hrp.Position - gen.Position).Magnitude
            if dist < minDist then
                minDist = dist
                currentGen = gen
            end
        end

        if currentGen then
            if currentGen:GetAttribute("Completed") == true or 
               (currentGen:GetAttribute("Progress") and currentGen:GetAttribute("Progress") >= 1) or
               (currentGen.Parent and currentGen.Parent:GetAttribute("Completed") == true) or
               completedGenerators[currentGen] then
                currentGenCompleted = true
            end
        end

        if killerNearby then
            print("🔴 ZIP HUB: Killer terdeteksi! Mencari generator aman...")
            TeleportToNearestIncompleteGenerator()
            task.wait(0.5)
        elseif currentGenCompleted then
            print("⚡ ZIP HUB: Generator selesai! Mencari generator berikutnya...")
            if currentGen then completedGenerators[currentGen] = true end
            TeleportToNearestIncompleteGenerator()
            task.wait(0.5)
        end
    end
end

-- ===== GUI AUTO =====
AutoTab:CreateSection("Generator")
AutoTab:CreateToggle({
    Name = "Auto Generator",
    CurrentValue = false,
    Callback = function(v)
        autoGenEnabled = v
        if v then task.spawn(AutoGeneratorLoop) end
    end
})
AutoTab:CreateToggle({
    Name = "Smart Gen Teleport",
    CurrentValue = false,
    Callback = function(v)
        smartGenEnabled = v
        if v then task.spawn(SmartGenLoop) end
    end
})
AutoTab:CreateSection("Escape")
AutoTab:CreateToggle({
    Name = "Auto Escape (Auto Win)",
    CurrentValue = false,
    Callback = function(v)
        autoEscapeEnabled = v
        if v then task.spawn(AutoEscapeLoop) end
    end
})

-- Character respawn handler untuk fitur baru
LP.CharacterAdded:Connect(function()
    task.wait(1)
    if autoGenEnabled then task.spawn(AutoGeneratorLoop) end
    if autoEscapeEnabled then task.spawn(AutoEscapeLoop) end
    if smartGenEnabled then task.spawn(SmartGenLoop) end
end)

-- =====================================================
-- NOTIFICATION AWAL
-- =====================================================
Window:Notify({
   Title = "✅ ZIP HUB Loaded",
   Content = "All features ready!",
   Duration = 5,
})
