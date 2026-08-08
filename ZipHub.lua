-- =====================================================
-- ZIP HUB – Violence District Edition
-- UI: ZIP UI Library (dengan Animasi Intro)
-- FITUR LENGKAP: Movement, ESP+, Protection, Auto
-- =====================================================

-- 1. LOAD LIBRARY & JALANKAN INTRO ANIMASI ZIP
local Zip = loadstring(game:HttpGet("https://raw.githubusercontent.com/gerobakcilung85-ai/ziphub/main/Zip.lua"))()

-- 2. BUAT WINDOW UTAMA
local Window = Zip:CreateWindow({
    Name = "ZIP HUB – Violence District",
    LoadingTitle = "Loading ZIP HUB Modules...",
    LoadingSubtitle = "by ZIP",
    ConfigurationSaving = { Enabled = false }
})

local LP = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Teams = game:GetService("Teams")
local Players = game:GetService("Players")
local Camera = workspace.CurrentCamera

-- =====================================================
-- TAB 1: MOVEMENT
-- =====================================================
local MoveTab = Window:CreateTab("Movement")

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
-- TAB 2: VISUALS (ESP+)
-- =====================================================
local VisualsAdvTab = Window:CreateTab("Visuals: ESP+")

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

VisualsAdvTab:CreateSection("Player ESP")
VisualsAdvTab:CreateToggle({
   Name = "ESP Survivors",
   CurrentValue = false,
   Callback = function(v) ESP_Settings.SurvivorsActive = v refreshHighlights() end
})
VisualsAdvTab:CreateToggle({
   Name = "ESP Killer",
   CurrentValue = false,
   Callback = function(v) ESP_Settings.KillerActive = v refreshHighlights() end
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
VisualsAdvTab:CreateToggle({
   Name = "Pallets ESP",
   CurrentValue = false,
   Callback = function(v) ESP_Settings.PalletsActive = v updatePalletESP() end
})

VisualsAdvTab:CreateSection("Generator Progress")
VisualsAdvTab:CreateToggle({
   Name = "Show Repair %",
   CurrentValue = false,
   Callback = function(v) updateGenProgress(v) end
})

Players.PlayerRemoving:Connect(function(p)
    if playerTrackers[p] then playerTrackers[p]:Remove() playerTrackers[p] = nil end
end)
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(0.5) refreshHighlights() end)
end)

-- =====================================================
-- TAB 3: FUNCTIONS (GOD MODE)
-- =====================================================
local FunctionsTab = Window:CreateTab("Functions")

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
        Window:Notify({Title = "ZIP HUB", Content = "God Mode Aktif", Duration = 2})
    else
        if godModeLoop then godModeLoop:Disconnect() end
        godModeEnabled = false
        Window:Notify({Title = "ZIP HUB", Content = "God Mode Nonaktif", Duration = 2})
    end
end

FunctionsTab:CreateSection("Protection")
FunctionsTab:CreateToggle({
    Name = "God Mode (Anti Twist / Damage)",
    CurrentValue = false,
    Callback = function(v) toggleGodMode(v) end
})

-- =====================================================
-- TAB 4: AUTO (AUTO GENERATOR, AUTO ESCAPE, SMART TELEPORT)
-- =====================================================
local AutoTab = Window:CreateTab("Auto")

local autoGenEnabled = false
local autoEscapeEnabled = false
local smartGenEnabled = false
local completedGenerators = {}
local isEscaping = false

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

local function FindKiller()
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LP then continue end
        if player.Team and player.Team.Name == "Killer" then return player end
    end
    return nil
end

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

        if isCompleted then completedGenerators[target] = true continue end

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
    while autoEscapeEnabled and task.wait(2) do TriggerAutoEscape() end
end

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
            TeleportToNearestIncompleteGenerator()
            task.wait(0.5)
        elseif currentGenCompleted then
            if currentGen then completedGenerators[currentGen] = true end
            TeleportToNearestIncompleteGenerator()
            task.wait(0.5)
        end
    end
end

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

LP.CharacterAdded:Connect(function()
    task.wait(1)
    if autoGenEnabled then task.spawn(AutoGeneratorLoop) end
    if autoEscapeEnabled then task.spawn(AutoEscapeLoop) end
    if smartGenEnabled then task.spawn(SmartGenLoop) end
end)

-- NOTIFIKASI AWAL
Window:Notify({
   Title = "✅ ZIP HUB Loaded",
   Content = "Semua fitur & animasi siap!",
   Duration = 5,
})

print("✅ ZIP HUB Full Features Loaded Successfully!")
