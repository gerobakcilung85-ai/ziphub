-- =====================================================
-- ZIP HUB – Violence District Edition
-- All features preserved – God Mode anti-freeze
-- UI: Rayfield (sirius.menu)
-- =====================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
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
-- TAB 1: MOVEMENT (Speed, Jump, Fly, NoClip)
-- =====================================================
local MoveTab = Window:CreateTab("Movement", 4483362458)

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
   Flag = "SpeedToggle",
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
   Flag = "SpeedVal",
   Callback = function(Value) speedValue = Value end,
})

MoveTab:CreateSection("Jump Settings")
MoveTab:CreateToggle({
   Name = "Super Jump",
   CurrentValue = false,
   Flag = "JumpToggle",
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
   Flag = "JumpVal",
   Callback = function(Value) jumpPower = Value end,
})

MoveTab:CreateSection("Flight & NoClip")
MoveTab:CreateToggle({
   Name = "Fly (W,A,S,D,Space,Shift)",
   CurrentValue = false,
   Flag = "FlyToggle",
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
   Flag = "FlySpeedVal",
   Callback = function(Value) flySpeed = Value end,
})
MoveTab:CreateToggle({
   Name = "NoClip",
   CurrentValue = false,
   Flag = "NoclipToggle",
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
local VisualsAdvTab = Window:CreateTab("Visuals: ESP+", 4483362458)

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
local FunctionsTab = Window:CreateTab("Functions", 4483362458)

-- GOD MODE VARIABLES
local godModeEnabled = false
local godModeLoop = nil
local oldNamecallHook = nil

local function toggleGodMode(state)
    godModeEnabled = state

    if state then
        -- 1. MATIKAN LOOP SEBELUMNYA (jika ada)
        if godModeLoop then
            godModeLoop:Disconnect()
            godModeLoop = nil
        end

        -- 2. LOOP PULIHKAN HEALTH (setiap frame, tapi ringan)
        godModeLoop = RunService.Heartbeat:Connect(function()
            if not godModeEnabled then return end
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            -- Jika health turun di bawah 100, langsung set ke 100
            if hum.Health < 100 and hum.Health > 0 then
                hum.Health = 100
            end
        end)

        -- 3. HOOKMETAMETHOD (blokir FireServer damage)
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

        Rayfield:Notify({Title = "ZIP HUB – God Mode", Content = "✅ Aktif", Duration = 2})
    else
        -- MATIKAN
        if godModeLoop then
            godModeLoop:Disconnect()
            godModeLoop = nil
        end
        -- Hook tetap terpasang, tapi kita set flag false agar tidak memblokir
        godModeEnabled = false
        Rayfield:Notify({Title = "ZIP HUB – God Mode", Content = "❌ Mati", Duration = 2})
    end
end

FunctionsTab:CreateSection("Protection")
FunctionsTab:CreateToggle({
    Name = "God Mode (Anti Twist / Damage)",
    CurrentValue = false,
    Callback = function(v) toggleGodMode(v) end
})

-- =====================================================
-- NOTIFICATION AWAL
-- =====================================================
Rayfield:Notify({
   Title = "✅ ZIP HUB Loaded",
   Content = "All features ready!",
   Duration = 5,
   Image = 4483362458,
})
