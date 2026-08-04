-- =====================================================
-- H4xScript Loader – Violence District Edition
-- GitHub: https://github.com/H4xScripts/Loader
-- Fitur: ESP, Auto Farm, Kill Aura, Teleports, dll.
-- =====================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- =====================================================
-- KEY SYSTEM (SESUAI H4xScript)
-- =====================================================
local function GetKey()
    local key = "H4X-FREE-2024" -- Key default (temporary)
    return key
end

local function ValidateKey(input)
    local validKeys = {
        "H4X-FREE-2024",
        "H4X-PREMIUM-2024",
        "H4X-VIP-2024"
    }
    for _, v in pairs(validKeys) do
        if input == v then return true end
    end
    return false
end

-- =====================================================
-- FUNGSI DASAR
-- =====================================================
local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoid()
    local c = GetCharacter()
    return c and c:FindFirstChild("Humanoid")
end

local function GetHRP()
    local c = GetCharacter()
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso"))
end

local function IsKiller(p)
    if not p then return false end
    if p:GetAttribute("Role") == "Killer" then return true end
    if p:GetAttribute("Team") == "Killer" then return true end
    if p:GetAttribute("IsKiller") == true then return true end
    local c = p.Character
    if c then
        for _, t in pairs(c:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("knife") or n:find("weapon") or n:find("scythe") or n:find("blade") or n:find("sword") or n:find("axe") or n:find("hammer") or n:find("gun") or n:find("claw") then
                    return true
                end
            end
        end
    end
    return false
end

local function FindGenerators()
    local gens = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("generator") or name:find("gen") or name:find("power") or name:find("repair") then
                table.insert(gens, obj)
            end
        end
    end
    return gens
end

local function FindHooks()
    local hooks = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find("hook") then
            table.insert(hooks, obj)
        end
    end
    return hooks
end

local function FindPallets()
    local pallets = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("pallet") or obj.Name:lower():find("plank") or obj.Name:lower():find("board")) then
            table.insert(pallets, obj)
        end
    end
    return pallets
end

local function GetClosestPlayer()
    local closest, shortest = nil, math.huge
    local hrp = GetHRP()
    if not hrp then return nil end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local targetHrp = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
            if targetHrp then
                local dist = (hrp.Position - targetHrp.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

-- =====================================================
-- TOGGLES
-- =====================================================
local toggles = {
    espPlayer = false,
    espKiller = false,
    espGenerator = false,
    espHook = false,
    espPallet = false,
    autoFarm = false,
    killAura = false,
    autoParry = false,
    noClip = false,
    speedHack = false,
    superJump = false,
    teleportGen = false,
    teleportHook = false,
    teleportPallet = false,
    godMode = false,
    antiAFK = false,
    fullBright = false,
    antiBlind = false,
    autoEscape = false
}

local connections = {}
local espObjects = {}
local espActive = false

-- =====================================================
-- ESP SYSTEM
-- =====================================================
local function ClearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
end

local function AddESP(target, color, label, labelColor)
    if not target then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = target
    highlight.FillColor = color
    highlight.FillTransparency = 0.3
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.1
    table.insert(espObjects, highlight)
    
    local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target:FindFirstChild("Head")
    if hrp then
        local billboard = Instance.new("BillboardGui")
        billboard.Parent = hrp
        billboard.Size = UDim2.new(0, 150, 0, 24)
        billboard.Adornee = hrp
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        
        local labelText = Instance.new("TextLabel")
        labelText.Parent = billboard
        labelText.Size = UDim2.new(1, 0, 1, 0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label or ""
        labelText.TextColor3 = labelColor or color
        labelText.TextSize = 10
        labelText.Font = Enum.Font.GothamBold
        labelText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        labelText.TextStrokeTransparency = 0.2
        
        table.insert(espObjects, billboard)
        table.insert(espObjects, labelText)
    end
end

local function UpdateESP()
    ClearESP()
    if not espActive then return end
    
    local hrp = GetHRP()
    
    if toggles.espKiller then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsKiller(player) and player.Character then
                local th = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                local dist = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                AddESP(player.Character, Color3.fromRGB(255, 0, 0), "🔴 " .. player.Name .. " [" .. math.floor(dist) .. "m] [Killer]", Color3.fromRGB(255, 0, 0))
            end
        end
    end
    
    if toggles.espPlayer then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not IsKiller(player) and player.Character then
                local th = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                local dist = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                AddESP(player.Character, Color3.fromRGB(0, 255, 0), "🟢 " .. player.Name .. " [" .. math.floor(dist) .. "m] [Survivor]", Color3.fromRGB(0, 255, 0))
            end
        end
    end
    
    if toggles.espGenerator then
        for _, gen in pairs(FindGenerators()) do
            AddESP(gen.Parent or gen, Color3.fromRGB(0, 255, 255), "⚡ Generator", Color3.fromRGB(0, 255, 255))
        end
    end
    
    if toggles.espHook then
        for _, hook in pairs(FindHooks()) do
            AddESP(hook.Parent or hook, Color3.fromRGB(255, 165, 0), "🪝 Hook", Color3.fromRGB(255, 165, 0))
        end
    end
    
    if toggles.espPallet then
        for _, pallet in pairs(FindPallets()) do
            AddESP(pallet.Parent or pallet, Color3.fromRGB(139, 69, 19), "📦 Pallet", Color3.fromRGB(139, 69, 19))
        end
    end
end

local function StartESP()
    if espActive then return end
    espActive = true
    connections.esp = RunService.RenderStepped:Connect(function()
        if espActive then
            UpdateESP()
        end
    end)
end

local function StopESP()
    espActive = false
    if connections.esp then
        connections.esp:Disconnect()
        connections.esp = nil
    end
    ClearESP()
end

-- =====================================================
-- AUTO FARM (Generator + Escape)
-- =====================================================
local function AutoFarmAction()
    local hrp = GetHRP()
    if not hrp then return end
    
    -- Auto Generator
    local gens = FindGenerators()
    if #gens > 0 then
        table.sort(gens, function(a, b)
            return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
        end)
        local target = gens[1]
        if target then
            hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
            task.wait(0.2)
            for i = 1, 10 do
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
                task.wait(0.05)
            end
            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                if obj:IsA("RemoteEvent") and obj.Name:lower():find("generator") then
                    pcall(function() obj:FireServer(target) end)
                    break
                end
            end
        end
    end
    
    -- Auto Escape
    if toggles.autoEscape then
        local gates = {}
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("gate") or obj.Name:lower():find("escape") or obj.Name:lower():find("exit")) then
                table.insert(gates, obj)
            end
        end
        if #gates > 0 then
            table.sort(gates, function(a, b)
                return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
            end)
            local target = gates[1]
            if target then
                hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
                task.wait(0.2)
                for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and obj.Name:lower():find("escape") then
                        pcall(function() obj:FireServer() end)
                        break
                    end
                end
            end
        end
    end
end

connections.autoFarm = RunService.RenderStepped:Connect(function()
    if toggles.autoFarm then
        AutoFarmAction()
        task.wait(0.5)
    end
end)

-- =====================================================
-- KILL AURA
-- =====================================================
connections.killAura = RunService.RenderStepped:Connect(function()
    if toggles.killAura then
        local hrp = GetHRP()
        if not hrp then return end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not IsKiller(player) and player.Character then
                local targetHrp = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                if targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 15 then
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                    task.wait(0.1)
                end
            end
        end
    end
end)

-- =====================================================
-- AUTO PARRY
-- =====================================================
connections.autoParry = RunService.RenderStepped:Connect(function()
    if toggles.autoParry then
        local hrp = GetHRP()
        if not hrp then return end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsKiller(player) and player.Character then
                local targetHrp = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                if targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 20 then
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            end
        end
    end
end)

-- =====================================================
-- NO CLIP
-- =====================================================
connections.noClip = RunService.RenderStepped:Connect(function()
    if toggles.noClip then
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    else
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

-- =====================================================
-- SPEED HACK & SUPER JUMP
-- =====================================================
connections.speedHack = RunService.RenderStepped:Connect(function()
    if toggles.speedHack then
        local humanoid = GetHumanoid()
        if humanoid then humanoid.WalkSpeed = 60 end
    end
end)

connections.superJump = RunService.RenderStepped:Connect(function()
    if toggles.superJump then
        local humanoid = GetHumanoid()
        if humanoid then humanoid.JumpPower = 150 end
    end
end)

-- =====================================================
-- GOD MODE
-- =====================================================
connections.godMode = RunService.RenderStepped:Connect(function()
    if toggles.godMode then
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            humanoid.PlatformStand = false
        end
    end
end)

-- =====================================================
-- ANTI AFK
-- =====================================================
connections.antiAFK = RunService.RenderStepped:Connect(function()
    if toggles.antiAFK then
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end)

-- =====================================================
-- FULL BRIGHT
-- =====================================================
connections.fullBright = RunService.RenderStepped:Connect(function()
    if toggles.fullBright then
        Lighting.Brightness = 10
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 2
        Lighting.Ambient = Color3.fromRGB(127, 127, 127)
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.GlobalShadows = true
    end
end)

-- =====================================================
-- ANTI BLIND
-- =====================================================
connections.antiBlind = RunService.RenderStepped:Connect(function()
    if toggles.antiBlind then
        local playerGui = LocalPlayer.PlayerGui
        if playerGui then
            for _, gui in pairs(playerGui:GetDescendants()) do
                if gui:IsA("Frame") or gui:IsA("ImageLabel") then
                    local name = gui.Name:lower()
                    if name:find("blind") or name:find("flash") or name:find("overlay") then
                        pcall(function() gui.Visible = false end)
                    end
                end
            end
        end
        pcall(function()
            Lighting.Bloom.Enabled = false
            Lighting.Bloom.Intensity = 0
        end)
    end
end)

-- =====================================================
-- TELEPORT FUNCTIONS
-- =====================================================
local function TeleportToGenerator()
    local hrp = GetHRP()
    if not hrp then return end
    local gens = FindGenerators()
    if #gens > 0 then
        table.sort(gens, function(a, b)
            return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
        end)
        hrp.CFrame = CFrame.new(gens[1].Position + Vector3.new(0, 2, 0))
    end
end

local function TeleportToHook()
    local hrp = GetHRP()
    if not hrp then return end
    local hooks = FindHooks()
    if #hooks > 0 then
        table.sort(hooks, function(a, b)
            return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
        end)
        hrp.CFrame = CFrame.new(hooks[1].Position + Vector3.new(0, 2, 0))
    end
end

local function TeleportToPallet()
    local hrp = GetHRP()
    if not hrp then return end
    local pallets = FindPallets()
    if #pallets > 0 then
        table.sort(pallets, function(a, b)
            return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
        end)
        hrp.CFrame = CFrame.new(pallets[1].Position + Vector3.new(0, 2, 0))
    end
end

-- =====================================================
-- GUI H4xSCRIPT STYLE
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "H4xScriptGUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame
MainCorner.CornerRadius = UDim.new(0, 10)

local MainBorder = Instance.new("UIStroke")
MainBorder.Parent = MainFrame
MainBorder.Color = Color3.fromRGB(0, 200, 255)
MainBorder.Thickness = 1.5
MainBorder.Transparency = 0.3

-- HEADER
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 10)

-- LOGO H4x
local Logo = Instance.new("TextLabel")
Logo.Parent = Header
Logo.Size = UDim2.new(0.5, 0, 1, 0)
Logo.Position = UDim2.new(0, 10, 0, 0)
Logo.BackgroundTransparency = 1
Logo.Text = "H4xScript"
Logo.TextColor3 = Color3.fromRGB(0, 200, 255)
Logo.TextSize = 16
Logo.Font = Enum.Font.GothamBold
Logo.TextXAlignment = Enum.TextXAlignment.Left

local SubLogo = Instance.new("TextLabel")
SubLogo.Parent = Header
SubLogo.Size = UDim2.new(0.3, 0, 1, 0)
SubLogo.Position = UDim2.new(0.65, 0, 0, 0)
SubLogo.BackgroundTransparency = 1
SubLogo.Text = "v3.0"
SubLogo.TextColor3 = Color3.fromRGB(100, 200, 255)
SubLogo.TextSize = 10
SubLogo.Font = Enum.Font.GothamMedium
SubLogo.TextXAlignment = Enum.TextXAlignment.Right

-- CLOSE
local Close = Instance.new("TextButton")
Close.Parent = Header
Close.Size = UDim2.new(0, 24, 0, 24)
Close.Position = UDim2.new(1, -30, 0.5, -12)
Close.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 13
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = Close
CloseCorner.CornerRadius = UDim.new(1, 0)

Close.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- SCROLL
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = MainFrame
Scroll.Size = UDim2.new(1, -10, 1, -50)
Scroll.Position = UDim2.new(0, 5, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
Scroll.BorderSizePixel = 0

-- TOGGLE CREATOR
local function CreateToggle(text, desc, key, y)
    local frame = Instance.new("Frame")
    frame.Parent = Scroll
    frame.Size = UDim2.new(1, -4, 0, 44)
    frame.Position = UDim2.new(0, 0, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(0, 150, 255)

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 4)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left

    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = frame
    descLabel.Size = UDim2.new(0.6, 0, 0, 14)
    descLabel.Position = UDim2.new(0, 8, 0, 22)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc or ""
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    descLabel.TextSize = 9
    descLabel.Font = Enum.Font.GothamMedium
    descLabel.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 44, 0, 22)
    toggleBtn.Position = UDim2.new(1, -52, 0.5, -11)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 10
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleBtn
    toggleCorner.CornerRadius = UDim.new(0, 3)

    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(180, 40, 40)
        toggles[key] = state
        if key == "espPlayer" or key == "espKiller" or key == "espGenerator" or key == "espHook" or key == "espPallet" then
            local anyESP = toggles.espPlayer or toggles.espKiller or toggles.espGenerator or toggles.espHook or toggles.espPallet
            if anyESP then
                if not espActive then StartESP() end
            else
                if espActive then StopESP() end
            end
        end
    end)
    return y + 48
end

-- TELEPORT BUTTON
local function CreateTeleportButton(text, desc, callback, y)
    local frame = Instance.new("Frame")
    frame.Parent = Scroll
    frame.Size = UDim2.new(1, -4, 0, 44)
    frame.Position = UDim2.new(0, 0, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    frame.BackgroundTransparency = 0.15
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(0, 150, 255)

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 4)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 2)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left

    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = frame
    descLabel.Size = UDim2.new(0.6, 0, 0, 14)
    descLabel.Position = UDim2.new(0, 8, 0, 22)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc or ""
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    descLabel.TextSize = 9
    descLabel.Font = Enum.Font.GothamMedium
    descLabel.TextXAlignment = Enum.TextXAlignment.Left

    local actionBtn = Instance.new("TextButton")
    actionBtn.Parent = frame
    actionBtn.Size = UDim2.new(0, 48, 0, 22)
    actionBtn.Position = UDim2.new(1, -56, 0.5, -11)
    actionBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    actionBtn.Text = "TP"
    actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionBtn.TextSize = 10
    actionBtn.Font = Enum.Font.GothamBold
    actionBtn.BorderSizePixel = 0

    local actionCorner = Instance.new("UICorner")
    actionCorner.Parent = actionBtn
    actionCorner.CornerRadius = UDim.new(0, 3)

    actionBtn.MouseButton1Click:Connect(callback)
    return y + 48
end

-- DAFTAR TOGGLE
local y = 2
y = CreateToggle("ESP Player", "Highlight survivor", "espPlayer", y)
y = CreateToggle("ESP Killer", "Highlight killer + distance", "espKiller", y)
y = CreateToggle("ESP Generator", "Show generator position", "espGenerator", y)
y = CreateToggle("ESP Hook", "Show hook position", "espHook", y)
y = CreateToggle("ESP Pallet", "Show pallet position", "espPallet", y)
y = CreateToggle("Auto Farm", "Auto generator + escape", "autoFarm", y)
y = CreateToggle("Kill Aura", "Auto attack nearby survivor", "killAura", y)
y = CreateToggle("Auto Parry", "Auto parry when killer near", "autoParry", y)
y = CreateToggle("No Clip", "Walk through walls", "noClip", y)
y = CreateToggle("Speed Hack", "Run faster (WalkSpeed 60)", "speedHack", y)
y = CreateToggle("Super Jump", "Jump higher (JumpPower 150)", "superJump", y)
y = CreateToggle("God Mode", "Infinite health", "godMode", y)
y = CreateToggle("Anti AFK", "Prevent AFK kick", "antiAFK", y)
y = CreateToggle("Full Bright", "Brighten map", "fullBright", y)
y = CreateToggle("Anti Blind", "Remove flash effects", "antiBlind", y)
y = CreateTeleportButton("Teleport Generator", "TP to nearest generator", TeleportToGenerator, y)
y = CreateTeleportButton("Teleport Hook", "TP to nearest hook", TeleportToHook, y)
y = CreateTeleportButton("Teleport Pallet", "TP to nearest pallet", TeleportToPallet, y)

Scroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)

-- WATERMARK
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 120, 0, 14)
Watermark.Position = UDim2.new(0, 6, 1, -20)
Watermark.BackgroundTransparency = 1
Watermark.Text = "⚡ H4xScript"
Watermark.TextColor3 = Color3.fromRGB(0, 200, 255)
Watermark.TextSize = 9
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextTransparency = 0.5

print("✅ H4xScript Violence District Loaded!")
print("✅ Key: " .. GetKey())
print("✅ 18 Fitur Aktif")
