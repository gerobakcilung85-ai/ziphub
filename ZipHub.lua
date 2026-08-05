-- =====================================================
-- ZIP HUB v55.0 – Professional Edition
-- Framework: Violence District
-- Author: ZIP
-- Features: 25+ Premium Features
-- Optimized: Anti-Lag, Clean Code, Config System
-- =====================================================

-- ////////////////////////////////////////////////////
-- KONFIGURASI AWAL
-- ////////////////////////////////////////////////////
local Config = {
    GUI = {
        Theme = "Dark",         -- Dark / Light
        Accent = Color3.fromRGB(0, 180, 255),
        Transparency = 0.85,
        Font = "Gotham"
    },
    Fly = {
        Speed = 50,
        Control = "WASD + Space/Shift"
    },
    SpeedHack = {
        WalkSpeed = 60
    },
    SuperJump = {
        JumpPower = 150
    },
    AutoGenerator = {
        Cooldown = 1.5,
        MaxClicks = 8
    },
    ESP = {
        UpdateRate = 0.3,
        MaxDistance = 150
    }
}

-- ////////////////////////////////////////////////////
-- CORE SERVICES
-- ////////////////////////////////////////////////////
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Camera = Workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

-- ////////////////////////////////////////////////////
-- HELPER FUNCTIONS (Modular)
-- ////////////////////////////////////////////////////
local function GetCharacter() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
local function GetHumanoid() local c = GetCharacter() return c and c:FindFirstChild("Humanoid") end
local function GetHRP() local c = GetCharacter() return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")) end

local function IsKiller(player)
    if not player then return false end
    if player:GetAttribute("Role") == "Killer" then return true end
    if player:GetAttribute("Team") == "Killer" then return true end
    if player:GetAttribute("IsKiller") == true then return true end
    local char = player.Character
    if char then
        if char:GetAttribute("Role") == "Killer" then return true end
        if char:GetAttribute("Team") == "Killer" then return true end
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("knife") or name:find("weapon") or name:find("scythe") or name:find("blade") or name:find("sword") or name:find("axe") or name:find("hammer") or name:find("gun") or name:find("claw") then
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
        if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen") or obj.Name:lower():find("power") or obj.Name:lower():find("repair")) then
            table.insert(gens, obj)
        end
    end
    return gens
end

local function FindGates()
    local gates = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("gate") or obj.Name:lower():find("escape") or obj.Name:lower():find("exit") or obj.Name:lower():find("door")) then
            table.insert(gates, obj)
        end
    end
    return gates
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
            local target = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
            if target then
                local dist = (hrp.Position - target.Position).Magnitude
                if dist < shortest then
                    shortest = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

-- ////////////////////////////////////////////////////
-- TOAST NOTIFICATION SYSTEM
-- ////////////////////////////////////////////////////
local function ShowToast(message, duration, color)
    duration = duration or 3
    color = color or Config.GUI.Accent
    local toast = Instance.new("Frame")
    toast.Parent = CoreGui
    toast.Size = UDim2.new(0, 300, 0, 40)
    toast.Position = UDim2.new(0.5, -150, 0.9, 0)
    toast.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    toast.BackgroundTransparency = 0.2
    toast.BorderSizePixel = 0
    local corner = Instance.new("UICorner")
    corner.Parent = toast
    corner.CornerRadius = UDim.new(0, 8)
    local border = Instance.new("UIStroke")
    border.Parent = toast
    border.Color = color
    border.Thickness = 1.5
    border.Transparency = 0.3
    local label = Instance.new("TextLabel")
    label.Parent = toast
    label.Size = UDim2.new(1, -20, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = message
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    TweenService:Create(toast, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0.85, 0)}):Play()
    task.wait(duration)
    TweenService:Create(toast, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -150, 0.9, 0)}):Play()
    task.wait(0.5)
    toast:Destroy()
end

-- ////////////////////////////////////////////////////
-- CONFIG SYSTEM (Save/Load)
-- ////////////////////////////////////////////////////
local configFilePath = "ZIP_HUB_Config.json"
local function SaveConfig(toggles)
    if not writefile then return end
    local data = HttpService:JSONEncode(toggles)
    writefile(configFilePath, data)
    ShowToast("✅ Config saved!", 2)
end

local function LoadConfig()
    if not isfile then return {} end
    if not isfile(configFilePath) then return {} end
    local data = readfile(configFilePath)
    local decoded = HttpService:JSONDecode(data)
    return decoded or {}
end

-- ////////////////////////////////////////////////////
-- TOGGLES & VARIABLES
-- ////////////////////////////////////////////////////
local toggles = {
    fly = false,
    invisible = false,
    autoGenerator = false,
    noClip = false,
    godMode = false,
    speedHack = false,
    superJump = false,
    autoParry = false,
    antiAFK = false,
    espKiller = false,
    espSurvivor = false,
    espGenerator = false,
    espHook = false,
    espPallet = false,
    autoEscape = false,
    autoHeal = false,
    noParryCooldown = false,
    noFall = false,
    noTurnSpeed = false,
    fastVault = false,
    moonwalk = false,
    fullBright = false,
    antiBlind = false,
    crosshair = false
}

-- Load saved config
local saved = LoadConfig()
for k, v in pairs(saved) do
    if toggles[k] ~= nil then
        toggles[k] = v
    end
end

local connections = {}
local espObjects = {}
local flyActive = false
local invisibleActive = false
local noClipActive = false
local godModeActive = false
local espActive = false
local autoGenActive = false
local genCooldown = 0
local crosshairObjects = {}

-- ////////////////////////////////////////////////////
-- FEATURE: FLY (Profesional)
-- ////////////////////////////////////////////////////
local function StartFly()
    if flyActive then return end
    flyActive = true
    local hrp = GetHRP()
    if not hrp then flyActive = false; return end
    local humanoid = GetHumanoid()
    if humanoid then humanoid.PlatformStand = true end

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = hrp

    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bodyPosition.Position = hrp.Position
    bodyPosition.Parent = hrp

    connections.fly = RunService.RenderStepped:Connect(function()
        if not flyActive or not toggles.fly then StopFly(); return end
        local hrp = GetHRP()
        if not hrp then return end
        if bodyPosition then bodyPosition.Position = hrp.Position end

        local cam = Camera.CFrame
        local forward = cam.LookVector
        local right = cam.RightVector
        local flatForward = Vector3.new(forward.X, 0, forward.Z).Unit
        local flatRight = Vector3.new(right.X, 0, right.Z).Unit
        local move = Vector3.new()

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + flatForward end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - flatForward end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - flatRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + flatRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end

        bodyVelocity.Velocity = move.Magnitude > 0 and move.Unit * Config.Fly.Speed or Vector3.new(0, 0.5, 0)
    end)
    ShowToast("✈️ Fly activated!", 2)
end

local function StopFly()
    flyActive = false
    if connections.fly then connections.fly:Disconnect(); connections.fly = nil end
    local humanoid = GetHumanoid()
    if humanoid then humanoid.PlatformStand = false end
    local hrp = GetHRP()
    if hrp then
        for _, child in pairs(hrp:GetChildren()) do
            if child:IsA("BodyVelocity") or child:IsA("BodyPosition") then
                child:Destroy()
            end
        end
    end
end

-- ////////////////////////////////////////////////////
-- FEATURE: INVISIBLE
-- ////////////////////////////////////////////////////
local function StartInvisible()
    if invisibleActive then return end
    invisibleActive = true
    connections.invisible = RunService.RenderStepped:Connect(function()
        if not invisibleActive or not toggles.invisible then StopInvisible(); return end
        local char = GetCharacter()
        if not char then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
                part.CastShadow = false
            end
        end
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
        end
    end)
    ShowToast("👻 Invisible activated!", 2)
end

local function StopInvisible()
    invisibleActive = false
    if connections.invisible then connections.invisible:Disconnect(); connections.invisible = nil end
    local char = GetCharacter()
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.CanCollide = true
                part.CastShadow = true
            end
        end
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
        end
    end
end

-- ////////////////////////////////////////////////////
-- FEATURE: AUTO GENERATOR (Fix Blackscreen)
-- ////////////////////////////////////////////////////
local function AutoGeneratorAction()
    local hrp = GetHRP()
    if not hrp then return end
    local gens = FindGenerators()
    if #gens == 0 then return end
    table.sort(gens, function(a, b) return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude end)
    local target = gens[1]
    if not target then return end

    hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
    task.wait(0.1)
    for i = 1, Config.AutoGenerator.MaxClicks do
        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
        task.wait(0.03)
    end
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") and obj.Name:lower():find("generator") then
            pcall(function() obj:FireServer(target) end)
            break
        end
    end
end

local function StartAutoGenerator()
    if autoGenActive then return end
    autoGenActive = true
    connections.autoGenerator = RunService.RenderStepped:Connect(function()
        if not autoGenActive or not toggles.autoGenerator then StopAutoGenerator(); return end
        if tick() - genCooldown > Config.AutoGenerator.Cooldown then
            genCooldown = tick()
            AutoGeneratorAction()
        end
    end)
    ShowToast("⚡ Auto Generator activated!", 2)
end

local function StopAutoGenerator()
    autoGenActive = false
    if connections.autoGenerator then connections.autoGenerator:Disconnect(); connections.autoGenerator = nil end
end

-- ////////////////////////////////////////////////////
-- FEATURE: NO CLIP
-- ////////////////////////////////////////////////////
local function StartNoClip()
    if noClipActive then return end
    noClipActive = true
    connections.noClip = RunService.RenderStepped:Connect(function()
        if not noClipActive or not toggles.noClip then StopNoClip(); return end
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
    ShowToast("🚪 No Clip activated!", 2)
end

local function StopNoClip()
    noClipActive = false
    if connections.noClip then connections.noClip:Disconnect(); connections.noClip = nil end
    local char = GetCharacter()
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end

-- ////////////////////////////////////////////////////
-- FEATURE: GOD MODE
-- ////////////////////////////////////////////////////
local function StartGodMode()
    if godModeActive then return end
    godModeActive = true
    connections.godMode = RunService.RenderStepped:Connect(function()
        if not godModeActive or not toggles.godMode then StopGodMode(); return end
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end
    end)
    ShowToast("🛡️ God Mode activated!", 2)
end

local function StopGodMode()
    godModeActive = false
    if connections.godMode then connections.godMode:Disconnect(); connections.godMode = nil end
end

-- ////////////////////////////////////////////////////
-- FEATURE: ESP (Professional with Health State)
-- ////////////////////////////////////////////////////
local function ClearESP()
    for _, obj in pairs(espObjects) do pcall(function() obj:Destroy() end) end
    espObjects = {}
end

local function GetHealthState(player)
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if not humanoid then return "💀 Dead" end
    local ratio = humanoid.Health / humanoid.MaxHealth
    if ratio <= 0 then return "💀 Dead"
    elseif ratio <= 0.25 then return "🪝 Hooked"
    elseif ratio <= 0.5 then return "🩸 Knocked"
    elseif ratio <= 0.75 then return "🟡 Injured"
    else return "🟢 Healed" end
end

local function AddESP(target, color, label, labelColor)
    if not target then return end
    local highlight = Instance.new("Highlight")
    highlight.Parent = target
    highlight.FillColor = color
    highlight.FillTransparency = 0.25
    highlight.OutlineColor = Color3.fromRGB(255,255,255)
    highlight.OutlineTransparency = 0.1
    table.insert(espObjects, highlight)

    local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target:FindFirstChild("Head")
    if hrp then
        local billboard = Instance.new("BillboardGui")
        billboard.Parent = hrp
        billboard.Size = UDim2.new(0, 150, 0, 24)
        billboard.Adornee = hrp
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2, 0)
        local labelText = Instance.new("TextLabel")
        labelText.Parent = billboard
        labelText.Size = UDim2.new(1, 0, 1, 0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label or ""
        labelText.TextColor3 = labelColor or color
        labelText.TextSize = 10
        labelText.Font = Enum.Font.GothamBold
        labelText.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        labelText.TextStrokeTransparency = 0.2
        table.insert(espObjects, billboard)
        table.insert(espObjects, labelText)
    end
end

local espTimer = 0
local function UpdateESP()
    ClearESP()
    if not espActive then return end
    local hrp = GetHRP()
    if toggles.espKiller then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsKiller(player) and player.Character then
                local th = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                local dist = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                if dist <= Config.ESP.MaxDistance then
                    local indicator = dist < 30 and "🔴!!" or dist < 50 and "🟡!" or "🟢"
                    AddESP(player.Character, Color3.fromRGB(255,0,0), indicator .. " " .. player.Name .. " [" .. math.floor(dist) .. "m] [KILLER]", Color3.fromRGB(255,0,0))
                end
            end
        end
    end
    if toggles.espSurvivor then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not IsKiller(player) and player.Character then
                local th = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                local dist = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                if dist <= Config.ESP.MaxDistance then
                    local state = GetHealthState(player)
                    AddESP(player.Character, Color3.fromRGB(0,255,0), "🟢 " .. player.Name .. " [" .. math.floor(dist) .. "m] " .. state, Color3.fromRGB(0,255,0))
                end
            end
        end
    end
    if toggles.espGenerator then
        for _, gen in pairs(FindGenerators()) do
            AddESP(gen.Parent or gen, Color3.fromRGB(0,255,255), "⚡ Generator", Color3.fromRGB(0,255,255))
        end
    end
    if toggles.espHook then
        for _, hook in pairs(FindHooks()) do
            AddESP(hook.Parent or hook, Color3.fromRGB(255,165,0), "🪝 Hook", Color3.fromRGB(255,165,0))
        end
    end
    if toggles.espPallet then
        for _, pallet in pairs(FindPallets()) do
            AddESP(pallet.Parent or pallet, Color3.fromRGB(139,69,19), "📦 Pallet", Color3.fromRGB(139,69,19))
        end
    end
end

local function StartESP()
    if espActive then return end
    espActive = true
    connections.esp = RunService.RenderStepped:Connect(function()
        if espActive then
            espTimer = espTimer + 0.05
            if espTimer >= Config.ESP.UpdateRate then
                espTimer = 0
                UpdateESP()
            end
        end
    end)
    ShowToast("👁️ ESP activated!", 2)
end

local function StopESP()
    espActive = false
    if connections.esp then connections.esp:Disconnect(); connections.esp = nil end
    ClearESP()
end

-- ////////////////////////////////////////////////////
-- FEATURE: CROSSHAIR (Professional)
-- ////////////////////////////////////////////////////
local function StartCrosshair()
    if #crosshairObjects > 0 then return end
    local function createLine(pos, size, color)
        local frame = Instance.new("Frame")
        frame.Parent = CoreGui
        frame.Size = size
        frame.Position = pos
        frame.BackgroundColor3 = color
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        table.insert(crosshairObjects, frame)
        return frame
    end
    local color = Config.GUI.Accent
    local size = UDim2.new(0, 2, 0, 16)
    local gap = 8
    -- Top
    createLine(UDim2.new(0.5, -1, 0.5, -gap-16), size, color)
    -- Bottom
    createLine(UDim2.new(0.5, -1, 0.5, gap), size, color)
    -- Left
    createLine(UDim2.new(0.5, -gap-16, 0.5, -1), UDim2.new(0, 16, 0, 2), color)
    -- Right
    createLine(UDim2.new(0.5, gap, 0.5, -1), UDim2.new(0, 16, 0, 2), color)
    -- Center dot
    local dot = Instance.new("Frame")
    dot.Parent = CoreGui
    dot.Size = UDim2.new(0, 2, 0, 2)
    dot.Position = UDim2.new(0.5, -1, 0.5, -1)
    dot.BackgroundColor3 = color
    dot.BackgroundTransparency = 0.2
    dot.BorderSizePixel = 0
    table.insert(crosshairObjects, dot)
    ShowToast("🎯 Crosshair activated!", 2)
end

local function StopCrosshair()
    for _, obj in pairs(crosshairObjects) do obj:Destroy() end
    crosshairObjects = {}
end

-- ////////////////////////////////////////////////////
-- FEATURE: OTHER UTILITIES (Modular)
-- ////////////////////////////////////////////////////
local function StartSpeedHack()
    if connections.speedHack then return end
    connections.speedHack = RunService.RenderStepped:Connect(function()
        if toggles.speedHack then
            local h = GetHumanoid()
            if h then h.WalkSpeed = Config.SpeedHack.WalkSpeed end
        end
    end)
end

local function StartSuperJump()
    if connections.superJump then return end
    connections.superJump = RunService.RenderStepped:Connect(function()
        if toggles.superJump then
            local h = GetHumanoid()
            if h then h.JumpPower = Config.SuperJump.JumpPower end
        end
    end)
end

local function StartAutoParry()
    if connections.autoParry then return end
    connections.autoParry = RunService.RenderStepped:Connect(function()
        if toggles.autoParry then
            pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
        end
    end)
end

local function StartAntiAFK()
    if connections.antiAFK then return end
    connections.antiAFK = RunService.RenderStepped:Connect(function()
        if toggles.antiAFK then
            pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
        end
    end)
end

local function StartAutoEscape()
    if connections.autoEscape then return end
    connections.autoEscape = RunService.RenderStepped:Connect(function()
        if toggles.autoEscape then
            local hrp = GetHRP()
            if not hrp then return end
            local gates = FindGates()
            if #gates > 0 then
                table.sort(gates, function(a,b) return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude end)
                local target = gates[1]
                if target then
                    hrp.CFrame = CFrame.new(target.Position + Vector3.new(0,3,0))
                    task.wait(0.15)
                    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                        if obj:IsA("RemoteEvent") and obj.Name:lower():find("escape") then
                            pcall(function() obj:FireServer() end)
                            break
                        end
                    end
                end
            end
        end
    end)
end

local function StartAutoHeal()
    if connections.autoHeal then return end
    connections.autoHeal = RunService.RenderStepped:Connect(function()
        if toggles.autoHeal then
            local h = GetHumanoid()
            if h and h.Health < h.MaxHealth then
                pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
            end
        end
    end)
end

local function StartNoParryCooldown()
    if connections.noParryCooldown then return end
    connections.noParryCooldown = RunService.RenderStepped:Connect(function()
        if toggles.noParryCooldown then
            local char = GetCharacter()
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") and tool.Name:lower():find("parry") and tool:FindFirstChild("Cooldown") then
                        tool.Cooldown.Value = 0
                    end
                end
            end
        end
    end)
end

local function StartNoFall()
    if connections.noFall then return end
    connections.noFall = RunService.RenderStepped:Connect(function()
        if toggles.noFall then
            local h = GetHumanoid()
            if h and h:GetState() == Enum.HumanoidStateType.Falling then
                local hrp = GetHRP()
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
                end
            end
        end
    end)
end

local function StartNoTurnSpeed()
    if connections.noTurnSpeed then return end
    connections.noTurnSpeed = RunService.RenderStepped:Connect(function()
        if toggles.noTurnSpeed then
            local h = GetHumanoid()
            if h then h.AutoRotate = true end
            local hrp = GetHRP()
            if hrp and hrp.AssemblyLinearVelocity.Magnitude > 10 then
                hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity
            end
        end
    end)
end

local function StartFastVault()
    if connections.fastVault then return end
    connections.fastVault = RunService.RenderStepped:Connect(function()
        if toggles.fastVault then
            local hrp = GetHRP()
            if not hrp then return end
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("vault") or obj.Name:lower():find("pallet") or obj.Name:lower():find("window")) then
                    if (hrp.Position - obj.Position).Magnitude < 5 then
                        local h = GetHumanoid()
                        if h then
                            h.Jump = true
                            task.wait(0.05)
                            hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 10
                        end
                        break
                    end
                end
            end
        end
    end)
end

local function StartMoonwalk()
    if connections.moonwalk then return end
    connections.moonwalk = RunService.RenderStepped:Connect(function()
        if toggles.moonwalk then
            local h = GetHumanoid()
            if h then
                h.WalkSpeed = 50
                h.AutoRotate = false
            end
        else
            local h = GetHumanoid()
            if h then h.AutoRotate = true end
        end
    end)
end

local function StartFullBright()
    if connections.fullBright then return end
    connections.fullBright = RunService.RenderStepped:Connect(function()
        if toggles.fullBright then
            Lighting.Brightness = 10
            Lighting.Ambient = Color3.fromRGB(255,255,255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
            Lighting.GlobalShadows = false
        else
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(127,127,127)
            Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
            Lighting.GlobalShadows = true
        end
    end)
end

local function StartAntiBlind()
    if connections.antiBlind then return end
    connections.antiBlind = RunService.RenderStepped:Connect(function()
        if toggles.antiBlind then
            local pg = LocalPlayer.PlayerGui
            if pg then
                for _, obj in pairs(pg:GetDescendants()) do
                    if obj:IsA("Frame") or obj:IsA("ImageLabel") then
                        local name = obj.Name:lower()
                        if name:find("blind") or name:find("flash") or name:find("overlay") then
                            pcall(function() obj.Visible = false end)
                        end
                    end
                end
            end
            pcall(function() Lighting.Bloom.Enabled = false; Lighting.Bloom.Intensity = 0 end)
        end
    end)
end

-- ////////////////////////////////////////////////////
-- TOGGLE HANDLER (Professional)
-- ////////////////////////////////////////////////////
local function ToggleFeature(key, state)
    toggles[key] = state
    if key == "fly" and not state then StopFly() end
    if key == "invisible" and not state then StopInvisible() end
    if key == "autoGenerator" and not state then StopAutoGenerator() end
    if key == "noClip" and not state then StopNoClip() end
    if key == "godMode" and not state then StopGodMode() end
    if key == "esp" and not state then StopESP() end
    if key == "crosshair" and not state then StopCrosshair() end

    if state then
        if key == "fly" then StartFly()
        elseif key == "invisible" then StartInvisible()
        elseif key == "autoGenerator" then StartAutoGenerator()
        elseif key == "noClip" then StartNoClip()
        elseif key == "godMode" then StartGodMode()
        elseif key == "espKiller" or key == "espSurvivor" or key == "espGenerator" or key == "espHook" or key == "espPallet" then
            if not espActive then StartESP() end
        elseif key == "crosshair" then StartCrosshair()
        elseif key == "speedHack" then StartSpeedHack()
        elseif key == "superJump" then StartSuperJump()
        elseif key == "autoParry" then StartAutoParry()
        elseif key == "antiAFK" then StartAntiAFK()
        elseif key == "autoEscape" then StartAutoEscape()
        elseif key == "autoHeal" then StartAutoHeal()
        elseif key == "noParryCooldown" then StartNoParryCooldown()
        elseif key == "noFall" then StartNoFall()
        elseif key == "noTurnSpeed" then StartNoTurnSpeed()
        elseif key == "fastVault" then StartFastVault()
        elseif key == "moonwalk" then StartMoonwalk()
        elseif key == "fullBright" then StartFullBright()
        elseif key == "antiBlind" then StartAntiBlind()
        end
    end
    -- Auto-save config
    SaveConfig(toggles)
end

-- ////////////////////////////////////////////////////
-- PROFESSIONAL GUI (Modern + Animations)
-- ////////////////////////////////////////////////////
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHubProfessional"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 320, 0, 440)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame
MainCorner.CornerRadius = UDim.new(0, 14)

local MainBorder = Instance.new("UIStroke")
MainBorder.Parent = MainFrame
MainBorder.Color = Config.GUI.Accent
MainBorder.Thickness = 1.5
MainBorder.Transparency = 0.25

-- Background gradient (professional)
local Gradient = Instance.new("Frame")
Gradient.Parent = MainFrame
Gradient.Size = UDim2.new(1, 0, 1, 0)
Gradient.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
Gradient.BackgroundTransparency = 0.8
Gradient.BorderSizePixel = 0
local GradCorner = Instance.new("UICorner")
GradCorner.Parent = Gradient
GradCorner.CornerRadius = UDim.new(0, 14)

-- HEADER (Gradient + Logo)
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 52)
Header.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Header.BackgroundTransparency = 0.15
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 14)

-- Logo animasi (pulsing)
local Logo = Instance.new("Frame")
Logo.Parent = Header
Logo.Size = UDim2.new(0, 34, 0, 34)
Logo.Position = UDim2.new(0, 8, 0.5, -17)
Logo.BackgroundColor3 = Config.GUI.Accent
Logo.BackgroundTransparency = 0
Logo.BorderSizePixel = 0
local LogoCorner = Instance.new("UICorner")
LogoCorner.Parent = Logo
LogoCorner.CornerRadius = UDim.new(1, 0)
local LogoText = Instance.new("TextLabel")
LogoText.Parent = Logo
LogoText.Size = UDim2.new(1,0,1,0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "Z"
LogoText.TextColor3 = Color3.fromRGB(10,10,25)
LogoText.TextSize = 22
LogoText.Font = Enum.Font.GothamBold

-- Pulse animation
task.spawn(function()
    while true do
        TweenService:Create(Logo, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0}):Play()
        task.wait(0.5)
        TweenService:Create(Logo, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {BackgroundTransparency = 0.2}):Play()
        task.wait(0.5)
    end
end)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(0.55, 0, 1, 0)
Title.Position = UDim2.new(0, 48, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZIP HUB"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = Header
SubTitle.Size = UDim2.new(0.3, 0, 1, 0)
SubTitle.Position = UDim2.new(0.65, 0, 0, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "v55.0 Pro"
SubTitle.TextColor3 = Color3.fromRGB(100,200,255)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Right

-- Hide Button ( - )
local HideBtn = Instance.new("TextButton")
HideBtn.Parent = Header
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Position = UDim2.new(1, -72, 0.5, -15)
HideBtn.BackgroundColor3 = Color3.fromRGB(60,60,80)
HideBtn.Text = "−"
HideBtn.TextColor3 = Color3.fromRGB(255,255,255)
HideBtn.TextSize = 18
HideBtn.Font = Enum.Font.GothamBold
HideBtn.BorderSizePixel = 0
local HideCorner = Instance.new("UICorner")
HideCorner.Parent = HideBtn
HideCorner.CornerRadius = UDim.new(1,0)
local menuVisible = true
HideBtn.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    MainFrame.Visible = menuVisible
    HideBtn.Text = menuVisible and "−" or "+"
end)

-- Close Button (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200,30,30)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255,255,255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseBtn
CloseCorner.CornerRadius = UDim.new(1,0)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- SCROLLING FRAME
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = MainFrame
Scroll.Size = UDim2.new(1, -16, 1, -68)
Scroll.Position = UDim2.new(0, 8, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Config.GUI.Accent
Scroll.BorderSizePixel = 0

-- TOGGLE CREATOR (Profesional)
local function CreateToggle(text, desc, key, y)
    local frame = Instance.new("Frame")
    frame.Parent = Scroll
    frame.Size = UDim2.new(1, -8, 0, 50)
    frame.Position = UDim2.new(0, 0, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(25,25,50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Config.GUI.Accent
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 8)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.65, 0, 0, 18)
    label.Position = UDim2.new(0, 12, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextSize = 13
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left

    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = frame
    descLabel.Size = UDim2.new(0.65, 0, 0, 16)
    descLabel.Position = UDim2.new(0, 12, 0, 26)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc or ""
    descLabel.TextColor3 = Color3.fromRGB(150,150,200)
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.GothamMedium
    descLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Toggle Switch (Modern)
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 48, 0, 24)
    toggleBtn.Position = UDim2.new(1, -56, 0.5, -12)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(200,40,40)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    toggleBtn.TextSize = 10
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    local btnCorner = Instance.new("UICorner")
    btnCorner.Parent = toggleBtn
    btnCorner.CornerRadius = UDim.new(0, 4)

    -- Set initial state from saved config
    local state = toggles[key] or false
    if state then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40,200,40)
        toggleBtn.Text = "ON"
    end

    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
        ToggleFeature(key, state)
        -- Animate toggle
        TweenService:Create(toggleBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
        task.wait(0.1)
        TweenService:Create(toggleBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0}):Play()
    end)
    return y + 54
end

-- DAFTAR TOGGLE (Professional)
local y = 2
y = CreateToggle("✈️ Fly", "WASD + Space/Shift (Speed: " .. Config.Fly.Speed .. ")", "fly", y)
y = CreateToggle("👻 Invisible", "Become completely invisible", "invisible", y)
y = CreateToggle("⚡ Auto Generator", "Auto farm gens (no blackscreen)", "autoGenerator", y)
y = CreateToggle("🚪 No Clip", "Walk through walls", "noClip", y)
y = CreateToggle("🛡️ God Mode", "Infinite health", "godMode", y)
y = CreateToggle("💨 Speed Hack", "WalkSpeed: " .. Config.SpeedHack.WalkSpeed, "speedHack", y)
y = CreateToggle("🦘 Super Jump", "JumpPower: " .. Config.SuperJump.JumpPower, "superJump", y)
y = CreateToggle("🛡️ Auto Parry", "Auto parry when attacked", "autoParry", y)
y = CreateToggle("⏰ Anti AFK", "Prevent AFK kick", "antiAFK", y)
y = CreateToggle("🔴 Killer ESP", "See killer with distance", "espKiller", y)
y = CreateToggle("🟢 Survivor ESP", "See survivors + health state", "espSurvivor", y)
y = CreateToggle("⚡ Generator ESP", "See generator positions", "espGenerator", y)
y = CreateToggle("🪝 Hook ESP", "See hook positions", "espHook", y)
y = CreateToggle("📦 Pallet ESP", "See pallet positions", "espPallet", y)
y = CreateToggle("🏃 Auto Escape", "Teleport to gate + force escape", "autoEscape", y)
y = CreateToggle("💚 Auto Heal", "Auto heal when injured", "autoHeal", y)
y = CreateToggle("🛡️ No Parry CD", "Infinite parries (no cooldown)", "noParryCooldown", y)
y = CreateToggle("🚫 No Fall", "No fall damage", "noFall", y)
y = CreateToggle("🔄 No Turn Speed", "No slowdown on sharp turns", "noTurnSpeed", y)
y = CreateToggle("🪟 Fast Vault", "Super fast vault over obstacles", "fastVault", y)
y = CreateToggle("🌙 Moonwalk", "Moonwalk + sway", "moonwalk", y)
y = CreateToggle("☀️ Full Bright", "Brighten map", "fullBright", y)
y = CreateToggle("👁️ Anti Blind", "Remove flash/overlay effects", "antiBlind", y)
y = CreateToggle("🎯 Crosshair", "Custom crosshair overlay", "crosshair", y)

Scroll.CanvasSize = UDim2.new(0, 0, 0, y + 20)

-- WATERMARK
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 180, 0, 16)
Watermark.Position = UDim2.new(0, 8, 1, -22)
Watermark.BackgroundTransparency = 1
Watermark.Text = "⚡ ZIP HUB Professional v55.0 ⚡"
Watermark.TextColor3 = Config.GUI.Accent
Watermark.TextSize = 10
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextTransparency = 0.4

-- ////////////////////////////////////////////////////
-- AUTO-START ESP & NOTIFICATION
-- ////////////////////////////////////////////////////
task.wait(0.5)
local anyESPMode = false
if toggles.espKiller or toggles.espSurvivor or toggles.espGenerator or toggles.espHook or toggles.espPallet then
    anyESPMode = true
end
if anyESPMode then
    ToggleFeature("espKiller", toggles.espKiller or false)
    ToggleFeature("espSurvivor", toggles.espSurvivor or false)
    ToggleFeature("espGenerator", toggles.espGenerator or false)
    ToggleFeature("espHook", toggles.espHook or false)
    ToggleFeature("espPallet", toggles.espPallet or false)
else
    -- Default ESP on for professional look
    ToggleFeature("espKiller", true)
    ToggleFeature("espSurvivor", true)
    ToggleFeature("espGenerator", true)
    ToggleFeature("espHook", true)
    ToggleFeature("espPallet", true)
end

-- ////////////////////////////////////////////////////
-- INITIALIZATION COMPLETE
-- ////////////////////////////////////////////////////
ShowToast("🚀 ZIP HUB Professional v55.0 loaded!", 3, Config.GUI.Accent)
print("✅ ZIP HUB Professional v55.0 – Ready to dominate!")
print("✅ 25+ Features – Modern GUI – Save/Load Config – Anti-Lag")
