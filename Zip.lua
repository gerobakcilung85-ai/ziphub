-- =====================================================
-- ZIP UI LIBRARY v2.0 (FULL FEATURES)
-- Mobile-friendly, animasi smooth, pakai asset ID Anda
-- =====================================================

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local ZIPUI = {}
local ASSET_ID = 128536767801427  -- GANTI DENGAN ID ASSET ANDA

-- =====================================================
-- THEME
-- =====================================================
local Theme = {
    Background = Color3.fromRGB(15, 15, 35),
    Section = Color3.fromRGB(25, 25, 50),
    Accent = Color3.fromRGB(0, 180, 255),
    Text = Color3.fromRGB(255, 255, 255),
    TextDark = Color3.fromRGB(150, 150, 200),
    ButtonOff = Color3.fromRGB(200, 40, 40),
    ButtonOn = Color3.fromRGB(40, 200, 40),
    Border = Color3.fromRGB(0, 180, 255),
    SliderBg = Color3.fromRGB(60, 60, 80),
    SliderFill = Color3.fromRGB(0, 180, 255),
    DropdownBg = Color3.fromRGB(30, 30, 55),
    DropdownHover = Color3.fromRGB(45, 45, 75),
    InputBg = Color3.fromRGB(30, 30, 50),
    InputStroke = Color3.fromRGB(60, 60, 80),
    Placeholder = Color3.fromRGB(150, 150, 200),
}

-- =====================================================
-- UTILITY FUNCTIONS
-- =====================================================
local function Animate(obj, props, duration, style)
    style = style or Enum.EasingStyle.Quad
    local t = TweenService:Create(obj, TweenInfo.new(duration or 0.3, style, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local function MakeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

-- =====================================================
-- NOTIFICATION SYSTEM
-- =====================================================
local notifications = {}
local function Notify(title, content, duration)
    duration = duration or 3
    local gui = Instance.new("ScreenGui")
    gui.Parent = CoreGui
    gui.Name = "ZIPNotify"
    gui.ResetOnSpawn = false

    local frame = Instance.new("Frame")
    frame.Parent = gui
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(0.5, -150, 1, 20)
    frame.BackgroundColor3 = Theme.Background
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Theme.Accent
    frame.ClipsDescendants = true
    Instance.new("UICorner").Parent = frame

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

-- =====================================================
-- MAIN WINDOW
-- =====================================================
function ZIPUI:CreateWindow(config)
    local window = {}
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = CoreGui
    screenGui.Name = "ZIPUI"
    screenGui.ResetOnSpawn = false

    local main = Instance.new("Frame")
    main.Parent = screenGui
    main.Size = UDim2.new(0, 380, 0, 500)
    main.Position = UDim2.new(0.5, -190, 0.5, -250)
    main.BackgroundColor3 = Theme.Background
    main.BackgroundTransparency = 0.05
    main.BorderSizePixel = 1
    main.BorderColor3 = Theme.Border
    main.ClipsDescendants = true
    main.Active = true
    MakeDraggable(main)
    Instance.new("UICorner").Parent = main

    -- Header
    local header = Instance.new("Frame")
    header.Parent = main
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Theme.Accent
    header.BackgroundTransparency = 0.2
    header.BorderSizePixel = 0
    Instance.new("UICorner").Parent = header

    -- Logo
    local logo = Instance.new("ImageLabel")
    logo.Parent = header
    logo.Size = UDim2.new(0, 30, 0, 30)
    logo.Position = UDim2.new(0, 8, 0.5, -15)
    logo.Image = "rbxassetid://" .. ASSET_ID
    logo.BackgroundTransparency = 1
    Instance.new("UICorner").Parent = logo

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

    local hideBtn = Instance.new("TextButton")
    hideBtn.Parent = header
    hideBtn.Size = UDim2.new(0, 28, 0, 28)
    hideBtn.Position = UDim2.new(1, -66, 0.5, -14)
    hideBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    hideBtn.Text = "−"
    hideBtn.TextColor3 = Theme.Text
    hideBtn.TextSize = 18
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.BorderSizePixel = 0
    Instance.new("UICorner", hideBtn).CornerRadius = UDim.new(1, 0)
    local visible = true
    hideBtn.MouseButton1Click:Connect(function()
        visible = not visible
        main.Visible = visible
        hideBtn.Text = visible and "−" or "+"
    end)

    local closeBtn = Instance.new("TextButton")
    closeBtn.Parent = header
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -34, 0.5, -14)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextSize = 14
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
    closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

    -- Tab Container
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

    -- Content area
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

    window._gui = screenGui
    window._main = main
    window._scroll = scroll
    window._tabs = {}
    window._tabButtons = {}
    window._currentTab = nil

    -- ===== CREATE TAB =====
    function window:CreateTab(name, icon)
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

        if icon then
            local img = Instance.new("ImageLabel")
            img.Parent = btn
            img.Size = UDim2.new(0, 16, 0, 16)
            img.Position = UDim2.new(0, 8, 0.5, -8)
            img.Image = "rbxassetid://" .. icon
            img.BackgroundTransparency = 1
            btn.Text = ""
            local label = Instance.new("TextLabel")
            label.Parent = btn
            label.Size = UDim2.new(1, -30, 1, 0)
            label.Position = UDim2.new(0, 30, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Theme.TextDark
            label.TextSize = 13
            label.Font = Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Left
            btn._label = label
        end

        local contentFrame = Instance.new("Frame")
        contentFrame.Parent = scroll
        contentFrame.Size = UDim2.new(1, 0, 0, 0)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Visible = false
        contentFrame.ClipsDescendants = true

        local yPos = 0

        local function selectTab()
            for _, b in pairs(window._tabButtons) do
                if b._label then
                    b._label.TextColor3 = Theme.TextDark
                else
                    b.TextColor3 = Theme.TextDark
                end
            end
            if btn._label then
                btn._label.TextColor3 = Theme.Accent
            else
                btn.TextColor3 = Theme.Accent
            end
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

        -- ===== SECTION =====
        function tab:CreateSection(titleText)
            local sectionFrame = Instance.new("Frame")
            sectionFrame.Parent = contentFrame
            sectionFrame.Size = UDim2.new(1, 0, 0, 30)
            sectionFrame.Position = UDim2.new(0, 0, 0, yPos)
            sectionFrame.BackgroundTransparency = 1

            local label = Instance.new("TextLabel")
            label.Parent = sectionFrame
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = titleText
            label.TextColor3 = Theme.Accent
            label.TextSize = 14
            label.Font = Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Left

            yPos = yPos + 34
            return {
                _addToggle = function(self, text, desc, callback)
                    local frame = Instance.new("Frame")
                    frame.Parent = contentFrame
                    frame.Size = UDim2.new(1, -10, 0, 50)
                    frame.Position = UDim2.new(0, 0, 0, yPos)
                    frame.BackgroundColor3 = Theme.Section
                    frame.BackgroundTransparency = 0.2
                    frame.BorderSizePixel = 1
                    frame.BorderColor3 = Theme.Border
                    Instance.new("UICorner").Parent = frame

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
                    Instance.new("UICorner").Parent = toggleBtn

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
                    frame.Size = UDim2.new(1, -10, 0, 55)
                    frame.Position = UDim2.new(0, 0, 0, yPos)
                    frame.BackgroundColor3 = Theme.Section
                    frame.BackgroundTransparency = 0.2
                    frame.BorderSizePixel = 1
                    frame.BorderColor3 = Theme.Border
                    Instance.new("UICorner").Parent = frame

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
                    slider.BackgroundColor3 = Theme.SliderBg
                    slider.BorderSizePixel = 0
                    Instance.new("UICorner").Parent = slider

                    local fill = Instance.new("Frame")
                    fill.Parent = slider
                    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
                    fill.BackgroundColor3 = Theme.SliderFill
                    fill.BorderSizePixel = 0
                    Instance.new("UICorner").Parent = fill

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
                        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                            dragging = true
                            updateSlider(input.Position.X)
                        end
                    end)
                    slider.InputEnded:Connect(function()
                        dragging = false
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                            updateSlider(input.Position.X)
                        end
                    end)

                    yPos = yPos + 59
                    return {SetValue = function(v) val = v; callback(v); fill.Size = UDim2.new((v-min)/(max-min),0,1,0); valueLabel.Text=tostring(v); label.Text=text.." ("..v..")" end, GetValue = function() return val end}
                end,
                _addDropdown = function(self, text, options, default, callback)
                    local frame = Instance.new("Frame")
                    frame.Parent = contentFrame
                    frame.Size = UDim2.new(1, -10, 0, 50)
                    frame.Position = UDim2.new(0, 0, 0, yPos)
                    frame.BackgroundColor3 = Theme.Section
                    frame.BackgroundTransparency = 0.2
                    frame.BorderSizePixel = 1
                    frame.BorderColor3 = Theme.Border
                    frame.ClipsDescendants = true
                    Instance.new("UICorner").Parent = frame

                    local label = Instance.new("TextLabel")
                    label.Parent = frame
                    label.Size = UDim2.new(0.6, 0, 0, 18)
                    label.Position = UDim2.new(0, 10, 0, 4)
                    label.BackgroundTransparency = 1
                    label.Text = text
                    label.TextColor3 = Theme.Text
                    label.TextSize = 13
                    label.Font = Enum.Font.GothamBold
                    label.TextXAlignment = Enum.TextXAlignment.Left

                    local selectedLabel = Instance.new("TextLabel")
                    selectedLabel.Parent = frame
                    selectedLabel.Size = UDim2.new(0.25, 0, 0, 18)
                    selectedLabel.Position = UDim2.new(0.65, 0, 0, 4)
                    selectedLabel.BackgroundTransparency = 1
                    selectedLabel.Text = default or options[1] or "None"
                    selectedLabel.TextColor3 = Theme.Accent
                    selectedLabel.TextSize = 13
                    selectedLabel.Font = Enum.Font.GothamBold
                    selectedLabel.TextXAlignment = Enum.TextXAlignment.Right

                    local arrow = Instance.new("TextLabel")
                    arrow.Parent = frame
                    arrow.Size = UDim2.new(0, 20, 0, 20)
                    arrow.Position = UDim2.new(0.93, 0, 0.5, -10)
                    arrow.BackgroundTransparency = 1
                    arrow.Text = "▼"
                    arrow.TextColor3 = Theme.TextDark
                    arrow.TextSize = 14
                    arrow.Font = Enum.Font.GothamBold

                    local dropdownList = Instance.new("Frame")
                    dropdownList.Parent = frame
                    dropdownList.Size = UDim2.new(1, 0, 0, 0)
                    dropdownList.Position = UDim2.new(0, 0, 1, 0)
                    dropdownList.BackgroundColor3 = Theme.DropdownBg
                    dropdownList.BackgroundTransparency = 0.9
                    dropdownList.BorderSizePixel = 1
                    dropdownList.BorderColor3 = Theme.Border
                    dropdownList.ClipsDescendants = true
                    Instance.new("UICorner").Parent = dropdownList

                    local listLayout = Instance.new("UIListLayout")
                    listLayout.Parent = dropdownList
                    listLayout.Padding = UDim.new(0, 2)

                    local expanded = false
                    local currentOption = default or options[1] or "None"

                    for _, opt in ipairs(options) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Parent = dropdownList
                        optBtn.Size = UDim2.new(1, 0, 0, 28)
                        optBtn.BackgroundColor3 = Theme.DropdownBg
                        optBtn.BackgroundTransparency = 0.8
                        optBtn.Text = opt
                        optBtn.TextColor3 = Theme.Text
                        optBtn.TextSize = 13
                        optBtn.Font = Enum.Font.GothamMedium
                        optBtn.BorderSizePixel = 0
                        optBtn.MouseButton1Click:Connect(function()
                            currentOption = opt
                            selectedLabel.Text = opt
                            callback(opt)
                            expanded = false
                            Animate(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
                            Animate(frame, {Size = UDim2.new(1, -10, 0, 50)}, 0.3)
                            arrow.Text = "▼"
                        end)
                        optBtn.MouseEnter:Connect(function()
                            Animate(optBtn, {BackgroundTransparency = 0.5}, 0.2)
                        end)
                        optBtn.MouseLeave:Connect(function()
                            Animate(optBtn, {BackgroundTransparency = 0.8}, 0.2)
                        end)
                    end

                    frame.MouseButton1Click:Connect(function()
                        expanded = not expanded
                        if expanded then
                            local count = #options
                            local height = math.min(count * 30, 150)
                            Animate(dropdownList, {Size = UDim2.new(1, 0, 0, height)}, 0.3)
                            Animate(frame, {Size = UDim2.new(1, -10, 0, 50 + height)}, 0.3)
                            arrow.Text = "▲"
                        else
                            Animate(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
                            Animate(frame, {Size = UDim2.new(1, -10, 0, 50)}, 0.3)
                            arrow.Text = "▼"
                        end
                    end)

                    yPos = yPos + (expanded and 50 + 150 or 54)
                    return {SetValue = function(opt) currentOption = opt; selectedLabel.Text = opt; callback(opt) end, GetValue = function() return currentOption end}
                end,
                _addButton = function(self, text, callback)
                    local frame = Instance.new("Frame")
                    frame.Parent = contentFrame
                    frame.Size = UDim2.new(1, -10, 0, 40)
                    frame.Position = UDim2.new(0, 0, 0, yPos)
                    frame.BackgroundColor3 = Theme.Section
                    frame.BackgroundTransparency = 0.2
                    frame.BorderSizePixel = 1
                    frame.BorderColor3 = Theme.Border
                    Instance.new("UICorner").Parent = frame

                    local btn = Instance.new("TextButton")
                    btn.Parent = frame
                    btn.Size = UDim2.new(1, 0, 1, 0)
                    btn.BackgroundTransparency = 1
                    btn.Text = text
                    btn.TextColor3 = Theme.Text
                    btn.TextSize = 14
                    btn.Font = Enum.Font.GothamBold
                    btn.BorderSizePixel = 0

                    btn.MouseButton1Click:Connect(callback)
                    btn.MouseEnter:Connect(function()
                        Animate(frame, {BackgroundColor3 = Theme.Section}, 0.2)
                    end)
                    btn.MouseLeave:Connect(function()
                        Animate(frame, {BackgroundColor3 = Theme.Section}, 0.2)
                    end)

                    yPos = yPos + 44
                    return btn
                end,
                _addLabel = function(self, text, color)
                    local label = Instance.new("TextLabel")
                    label.Parent = contentFrame
                    label.Size = UDim2.new(1, -10, 0, 25)
                    label.Position = UDim2.new(0, 0, 0, yPos)
                    label.BackgroundTransparency = 1
                    label.Text = text
                    label.TextColor3 = color or Theme.Text
                    label.TextSize = 13
                    label.Font = Enum.Font.GothamMedium
                    label.TextXAlignment = Enum.TextXAlignment.Left

                    yPos = yPos + 29
                    return label
                end,
                _addParagraph = function(self, title, content)
                    local frame = Instance.new("Frame")
                    frame.Parent = contentFrame
                    frame.Size = UDim2.new(1, -10, 0, 50)
                    frame.Position = UDim2.new(0, 0, 0, yPos)
                    frame.BackgroundColor3 = Theme.Section
                    frame.BackgroundTransparency = 0.2
                    frame.BorderSizePixel = 1
                    frame.BorderColor3 = Theme.Border
                    Instance.new("UICorner").Parent = frame

                    local titleLabel = Instance.new("TextLabel")
                    titleLabel.Parent = frame
                    titleLabel.Size = UDim2.new(1, -20, 0, 18)
                    titleLabel.Position = UDim2.new(0, 10, 0, 4)
                    titleLabel.BackgroundTransparency = 1
                    titleLabel.Text = title
                    titleLabel.TextColor3 = Theme.Accent
                    titleLabel.TextSize = 14
                    titleLabel.Font = Enum.Font.GothamBold
                    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

                    local contentLabel = Instance.new("TextLabel")
                    contentLabel.Parent = frame
                    contentLabel.Size = UDim2.new(1, -20, 0, 20)
                    contentLabel.Position = UDim2.new(0, 10, 0, 24)
                    contentLabel.BackgroundTransparency = 1
                    contentLabel.Text = content
                    contentLabel.TextColor3 = Theme.TextDark
                    contentLabel.TextSize = 12
                    contentLabel.Font = Enum.Font.GothamMedium
                    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
                    contentLabel.TextWrapped = true
                    contentLabel.TextYAlignment = Enum.TextYAlignment.Top

                    local size = contentLabel.TextBounds.Y + 30
                    frame.Size = UDim2.new(1, -10, 0, size + 30)
                    yPos = yPos + size + 34
                    return frame
                end
            }
        end

        -- === PUBLIC METHODS ===
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

        function tab:CreateDropdown(config)
            local section = self:CreateSection("")
            local dropdown = section._addDropdown(config.Name, config.Options, config.CurrentOption or config.Options[1], function(v)
                if config.Callback then config.Callback(v) end
            end)
            return dropdown
        end

        function tab:CreateButton(config)
            local section = self:CreateSection("")
            return section._addButton(config.Name, config.Callback)
        end

        function tab:CreateLabel(config)
            local section = self:CreateSection("")
            return section._addLabel(config.Name, config.Color)
        end

        function tab:CreateParagraph(config)
            local section = self:CreateSection("")
            return section._addParagraph(config.Title, config.Content)
        end

        return tab
    end

    -- ===== NOTIFY =====
    function window:Notify(config)
        Notify(config.Title or "Notification", config.Content or "", config.Duration or 3)
    end

    -- ===== DESTROY =====
    function window:Destroy()
        screenGui:Destroy()
    end

    return window
end

-- =====================================================
-- EXPORT
-- =====================================================
return ZIPUI
