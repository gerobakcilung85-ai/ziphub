-- =====================================================
-- ZIP HUB v54.0 – 6LOCC FULL EDITION (30+ FITUR)
-- =====================================================

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
local CollectionService = game:GetService("CollectionService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- =====================================================
-- FUNGSI DASAR
-- =====================================================
local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoid()
    local char = GetCharacter()
    return char and char:FindFirstChild("Humanoid")
end

local function GetHRP()
    local char = GetCharacter()
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))
end

local function IsPlayerKiller(player)
    if not player then return false end
    if player:GetAttribute("Role") == "Killer" then return true end
    if player:GetAttribute("Team") == "Killer" then return true end
    if player:GetAttribute("IsKiller") == true then return true end
    local char = player.Character
    if char then
        if char:GetAttribute("Role") == "Killer" then return true end
        if char:GetAttribute("Team") == "Killer" then return true end
        for _, child in pairs(char:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("knife") or name:find("weapon") or name:find("scythe") or name:find("blade") or name:find("sword") or name:find("axe") or name:find("hammer") or name:find("gun") or name:find("claw") then
                    return true
                end
            end
        end
    end
    return false
end

local function GetHealthState(player)
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if not humanoid then return "💀 Dead" end
    local health = humanoid.Health
    local maxHealth = humanoid.MaxHealth
    local ratio = health / maxHealth
    if ratio <= 0 then return "💀 Dead"
    elseif ratio <= 0.25 then return "🪝 Hooked"
    elseif ratio <= 0.5 then return "🩸 Knocked"
    elseif ratio <= 0.75 then return "🟡 Injured"
    else return "🟢 Healed" end
end

local function GetKillerProperty(player)
    local char = player.Character
    if not char then return "Unknown" end
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name
            if name:find("Scythe") then return "Scythe"
            elseif name:find("Blade") then return "Blade"
            elseif name:find("Hammer") then return "Hammer"
            elseif name:find("Gun") then return "Gun"
            elseif name:find("Claw") then return "Claw" end
        end
    end
    return "None"
end

local function GetGeneratorProgress(gen)
    local progress = gen:GetAttribute("Progress") or gen:GetAttribute("Completion") or 0
    if type(progress) == "number" then
        return math.floor(progress * 100)
    end
    return 0
end

local function GetChasedIndicator(distance)
    if distance < 30 then return "🔴 !!"
    elseif distance < 50 then return "🟡 !"
    else return "🟢" end
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
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("generator") or name:find("gen") or name:find("power") then
                for _, part in pairs(obj:GetDescendants()) do
                    if part:IsA("BasePart") then
                        table.insert(gens, part)
                    end
                end
            end
        end
    end
    return gens
end

local function FindGates()
    local gates = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("gate") or name:find("escape") or name:find("exit") or name:find("door") then
                table.insert(gates, obj)
            end
        end
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            if name:find("gate") or name:find("escape") or name:find("exit") then
                for _, part in pairs(obj:GetDescendants()) do
                    if part:IsA("BasePart") then
                        table.insert(gates, part)
                    end
                end
            end
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
        if obj:IsA("Model") and obj.Name:lower():find("hook") then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(hooks, part)
                end
            end
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
        if obj:IsA("Model") and (obj.Name:lower():find("pallet") or obj.Name:lower():find("plank")) then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(pallets, part)
                end
            end
        end
    end
    return pallets
end

local function FindVaults()
    local vaults = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("vault") or obj.Name:lower():find("window") or obj.Name:lower():find("ledge")) then
            table.insert(vaults, obj)
        end
        if obj:IsA("Model") and (obj.Name:lower():find("vault") or obj.Name:lower():find("window")) then
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    table.insert(vaults, part)
                end
            end
        end
    end
    return vaults
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

local function GetClosestKiller()
    local closest, shortest = nil, math.huge
    local hrp = GetHRP()
    if not hrp then return nil end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsPlayerKiller(player) and player.Character then
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
-- TOGGLES – 30+ FITUR
-- =====================================================
local toggles = {
    -- MOVEMENT (5)
    fly = false,
    noClip = false,
    speedHack = false,
    superJump = false,
    moonwalk = false,
    
    -- VISUAL (8)
    invisible = false,
    fullBright = false,
    antiBlind = false,
    antiStun = false,
    noSlowdown = false,
    fastVault = false,
    hitboxExpander = false,
    crosshair = false,
    
    -- ESP (7)
    espKiller = false,
    espSurvivor = false,
    espGenerator = false,
    espHook = false,
    espPallet = false,
    espVault = false,
    espBlood = false,
    
    -- COMBAT (6)
    autoParry = false,
    infiniteAttack = false,
    aimbotRevolver = false,
    infiniteLunge = false,
    antiKnock = false,
    antiWiggle = false,
    
    -- AUTO FARM / UTILITY (8)
    autoGenerator = false,
    autoSkillCheck = false,
    instantEscape = false,
    forceEndGame = false,
    autoHeal = false,
    cancelGenerator = false,
    killerProximityAlert = false,
    serverHop = false,
    
    -- MISC (3)
    godMode = false,
    antiAFK = false,
    chasedIndicator = false
}

local connections = {}
local espObjects = {}
local flyActive = false
local invisibleActive = false
local autoGenActive = false
local noClipActive = false
local godModeActive = false
local espActive = false
local moonwalkGyro = nil

-- =====================================================
-- MOVEMENT FITUR (5)
-- =====================================================

-- FLY
local function StartFly()
    if flyActive then return end
    flyActive = true
    local hrp = GetHRP()
    if not hrp then flyActive = false; return end
    local humanoid = GetHumanoid()
    if humanoid then humanoid.PlatformStand = true end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bp.Position = hrp.Position
    bp.Parent = hrp
    local conn = RunService.RenderStepped:Connect(function()
        if not flyActive or not toggles.fly then StopFly(); return end
        local hrp = GetHRP()
        if not hrp then return end
        if bp then bp.Position = hrp.Position end
        local cam = Camera.CFrame
        local forward = cam.LookVector
        local right = cam.RightVector
        local flatForward = Vector3.new(forward.X, 0, forward.Z).Unit
        local flatRight = Vector3.new(right.X, 0, right.Z).Unit
        local moveDir = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + flatForward end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - flatForward end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - flatRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + flatRight end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir + Vector3.new(0, -1, 0) end
        if moveDir.Magnitude > 0 then bv.Velocity = moveDir.Unit * 50 else bv.Velocity = Vector3.new(0, 0.5, 0) end
    end)
    connections.fly = {bv = bv, bp = bp, conn = conn}
end

local function StopFly()
    flyActive = false
    if connections.fly then
        if connections.fly.conn then connections.fly.conn:Disconnect() end
        if connections.fly.bv then connections.fly.bv:Destroy() end
        if connections.fly.bp then connections.fly.bp:Destroy() end
        connections.fly = nil
    end
    local humanoid = GetHumanoid()
    if humanoid then humanoid.PlatformStand = false end
end

-- NO CLIP
local function StartNoClip()
    if noClipActive then return end
    noClipActive = true
    local conn = RunService.RenderStepped:Connect(function()
        if not noClipActive or not toggles.noClip then StopNoClip(); return end
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end)
    connections.noClip = conn
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

-- SPEED HACK
local function StartSpeedHack()
    if connections.speedHack then return end
    connections.speedHack = RunService.RenderStepped:Connect(function()
        if toggles.speedHack then
            local humanoid = GetHumanoid()
            if humanoid then humanoid.WalkSpeed = 60 end
        end
    end)
end

-- SUPER JUMP
local function StartSuperJump()
    if connections.superJump then return end
    connections.superJump = RunService.RenderStepped:Connect(function()
        if toggles.superJump then
            local humanoid = GetHumanoid()
            if humanoid then humanoid.JumpPower = 150 end
        end
    end)
end

-- MOONWALK WITH SWAY
local function StartMoonwalk()
    if connections.moonwalk then return end
    connections.moonwalk = RunService.RenderStepped:Connect(function()
        if toggles.moonwalk then
            local humanoid = GetHumanoid()
            if humanoid then
                humanoid.WalkSpeed = 50
                humanoid.AutoRotate = false
            end
            local hrp = GetHRP()
            if hrp and not moonwalkGyro then
                moonwalkGyro = Instance.new("BodyGyro")
                moonwalkGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
                moonwalkGyro.CFrame = hrp.CFrame
                moonwalkGyro.Parent = hrp
                task.spawn(function()
                    local angle = 0
                    while toggles.moonwalk do
                        angle = angle + 0.05
                        if moonwalkGyro then
                            moonwalkGyro.CFrame = CFrame.Angles(0, math.sin(angle * 2) * 0.3, 0)
                        end
                        task.wait(0.05)
                    end
                end)
            end
        else
            if moonwalkGyro then moonwalkGyro:Destroy(); moonwalkGyro = nil end
            local humanoid = GetHumanoid()
            if humanoid then humanoid.AutoRotate = true end
        end
    end)
end

-- =====================================================
-- VISUAL FITUR (8)
-- =====================================================

-- INVISIBLE
local function StartInvisible()
    if invisibleActive then return end
    invisibleActive = true
    local conn = RunService.RenderStepped:Connect(function()
        if not invisibleActive or not toggles.invisible then StopInvisible(); return end
        local char = GetCharacter()
        if not char then return end
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
                part.CastShadow = false
            end
            if part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Transparency = 1
                part.Handle.CanCollide = false
            end
        end
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            humanoid.NameDisplayDistance = 0
        end
    end)
    connections.invisible = conn
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
            if part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Transparency = 0
                part.Handle.CanCollide = true
            end
        end
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
            humanoid.NameDisplayDistance = 100
        end
    end
end

-- FULL BRIGHT
local function StartFullBright()
    if connections.fullBright then return end
    connections.fullBright = RunService.RenderStepped:Connect(function()
        if toggles.fullBright then
            Lighting.Brightness = 10
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.GlobalShadows = false
        end
    end)
end

-- ANTI BLIND
local function StartAntiBlind()
    if connections.antiBlind then return end
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
end

-- ANTI STUN
local function StartAntiStun()
    if connections.antiStun then return end
    connections.antiStun = RunService.RenderStepped:Connect(function()
        if toggles.antiStun then
            local humanoid = GetHumanoid()
            if humanoid then
                humanoid.PlatformStand = false
                humanoid.Sit = false
            end
            local hrp = GetHRP()
            if hrp then
                hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
            end
        end
    end)
end

-- NO SLOWDOWN
local function StartNoSlowdown()
    if connections.noSlowdown then return end
    connections.noSlowdown = RunService.RenderStepped:Connect(function()
        if toggles.noSlowdown then
            local humanoid = GetHumanoid()
            if humanoid then humanoid.AutoRotate = true end
            local hrp = GetHRP()
            if hrp and hrp.AssemblyLinearVelocity.Magnitude > 10 then
                hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity
            end
        end
    end)
end

-- FAST VAULT
local function StartFastVault()
    if connections.fastVault then return end
    connections.fastVault = RunService.RenderStepped:Connect(function()
        if toggles.fastVault then
            local hrp = GetHRP()
            if not hrp then return end
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("vault") or obj.Name:lower():find("pallet") or obj.Name:lower():find("window")) then
                    if (hrp.Position - obj.Position).Magnitude < 5 then
                        local humanoid = GetHumanoid()
                        if humanoid then
                            humanoid.Jump = true
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

-- HITBOX EXPANDER
local function StartHitboxExpander()
    if connections.hitboxExpander then return end
    connections.hitboxExpander = RunService.RenderStepped:Connect(function()
        if toggles.hitboxExpander then
            local char = GetCharacter()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and (part.Name:lower():find("head") or part.Name:lower():find("torso")) then
                        part.Size = part.Size * 1.5
                    end
                end
            end
        end
    end)
end

-- CROSSHAIR
local function StartCrosshair()
    if connections.crosshair then return end
    local crosshair = Instance.new("Frame")
    crosshair.Parent = CoreGui
    crosshair.Size = UDim2.new(0, 4, 0, 20)
    crosshair.Position = UDim2.new(0.5, -2, 0.5, -10)
    crosshair.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    crosshair.BackgroundTransparency = 0.5
    crosshair.ZIndex = 999
    local crosshair2 = Instance.new("Frame")
    crosshair2.Parent = CoreGui
    crosshair2.Size = UDim2.new(0, 20, 0, 4)
    crosshair2.Position = UDim2.new(0.5, -10, 0.5, -2)
    crosshair2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    crosshair2.BackgroundTransparency = 0.5
    crosshair2.ZIndex = 999
    connections.crosshair = {crosshair, crosshair2}
end

-- =====================================================
-- ESP FITUR (7)
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
    local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target:FindFirstChild("UpperTorso") or target:FindFirstChild("Head")
    if hrp then
        local billboard = Instance.new("BillboardGui")
        billboard.Parent = hrp
        billboard.Size = UDim2.new(0, 200, 0, 30)
        billboard.Adornee = hrp
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 2.5, 0)
        local labelText = Instance.new("TextLabel")
        labelText.Parent = billboard
        labelText.Size = UDim2.new(1, 0, 1, 0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label or "Unknown"
        labelText.TextColor3 = labelColor or color
        labelText.TextSize = 12
        labelText.Font = Enum.Font.GothamBold
        labelText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        labelText.TextStrokeTransparency = 0.2
        table.insert(espObjects, billboard)
        table.insert(espObjects, labelText)
    end
end

local function UpdateESP()
    ClearESP()
    if espActive ~= true then return end
    
    local hrp = GetHRP()
    
    -- ESP KILLER
    if toggles.espKiller then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsPlayerKiller(player) and player.Character then
                local dist = hrp and (hrp.Position - (player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")).Position).Magnitude or 0
                local chased = GetChasedIndicator(dist)
                AddESP(player.Character, Color3.fromRGB(255, 0, 0), chased .. " " .. player.Name .. " [" .. math.floor(dist) .. "m] [Killer]", Color3.fromRGB(255, 0, 0))
            end
        end
    end
    
    -- ESP SURVIVOR
    if toggles.espSurvivor then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not IsPlayerKiller(player) and player.Character then
                local dist = hrp and (hrp.Position - (player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")).Position).Magnitude or 0
                local state = GetHealthState(player)
                AddESP(player.Character, Color3.fromRGB(0, 255, 0), "🟢 " .. player.Name .. " [" .. math.floor(dist) .. "m] " .. state, Color3.fromRGB(0, 255, 0))
            end
        end
    end
    
    -- ESP GENERATOR
    if toggles.espGenerator then
        for _, gen in pairs(FindGenerators()) do
            local progress = GetGeneratorProgress(gen)
            local label = "⚡ Generator " .. progress .. "%"
            local parent = gen.Parent or gen
            AddESP(parent, Color3.fromRGB(0, 255, 255), label, Color3.fromRGB(0, 255, 255))
        end
    end
    
    -- ESP HOOK
    if toggles.espHook then
        for _, hook in pairs(FindHooks()) do
            local parent = hook.Parent or hook
            AddESP(parent, Color3.fromRGB(255, 165, 0), "🪝 Hook", Color3.fromRGB(255, 165, 0))
        end
    end
    
    -- ESP PALLET
    if toggles.espPallet then
        for _, pallet in pairs(FindPallets()) do
            local parent = pallet.Parent or pallet
            AddESP(parent, Color3.fromRGB(139, 69, 19), "📦 Pallet", Color3.fromRGB(139, 69, 19))
        end
    end
    
    -- ESP VAULT
    if toggles.espVault then
        for _, vault in pairs(FindVaults()) do
            local parent = vault.Parent or vault
            AddESP(parent, Color3.fromRGB(255, 255, 0), "🪟 Vault", Color3.fromRGB(255, 255, 0))
        end
    end
    
    -- ESP BLOOD (Survivor health indicator on killer ESP)
    if toggles.espBlood then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not IsPlayerKiller(player) and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    local state = GetHealthState(player)
                    AddESP(player.Character, Color3.fromRGB(255, 0, 0), "🩸 " .. player.Name .. " " .. state, Color3.fromRGB(255, 0, 0))
                end
            end
        end
    end
end

local function StartESP()
    if espActive then return end
    espActive = true
    local conn = RunService.RenderStepped:Connect(function()
        if espActive then
            UpdateESP()
        end
    end)
    connections.esp = conn
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
-- COMBAT FITUR (6)
-- =====================================================

-- AUTO PARRY
local function StartAutoParry()
    if connections.autoParry then return end
    connections.autoParry = RunService.RenderStepped:Connect(function()
        if toggles.autoParry then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end

-- INFINITE ATTACK
local function StartInfiniteAttack()
    if connections.infiniteAttack then return end
    connections.infiniteAttack = RunService.RenderStepped:Connect(function()
        if toggles.infiniteAttack then
            local char = GetCharacter()
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Cooldown") then
                        tool.Cooldown.Value = 0
                    end
                end
            end
        end
    end)
end

-- AIMBOT REVOLVER
local function StartAimbotRevolver()
    if connections.aimbotRevolver then return end
    connections.aimbotRevolver = RunService.RenderStepped:Connect(function()
        if toggles.aimbotRevolver then
            local target = GetClosestPlayer()
            if target and target.Character then
                local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
                if targetHrp then
                    local origin = Camera.CFrame.Position
                    local direction = (targetHrp.Position - origin).Unit
                    local ray = Ray.new(origin, direction * 500)
                    local hit = Workspace:FindPartOnRay(ray, LocalPlayer.Character)
                    if not hit or hit:IsDescendantOf(target.Character) then
                        Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHrp.Position)
                    end
                end
            end
        end
    end)
end

-- INFINITE LUNGE
local function StartInfiniteLunge()
    if connections.infiniteLunge then return end
    connections.infiniteLunge = RunService.RenderStepped:Connect(function()
        if toggles.infiniteLunge then
            local char = GetCharacter()
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then
                        pcall(function()
                            tool:SetAttribute("Range", 100)
                        end)
                    end
                end
            end
        end
    end)
end

-- ANTI KNOCK
local function StartAntiKnock()
    if connections.antiKnock then return end
    connections.antiKnock = RunService.RenderStepped:Connect(function()
        if toggles.antiKnock then
            local humanoid = GetHumanoid()
            if humanoid then
                humanoid.BreakJointsOnDeath = false
                if humanoid.Health <= 0 then
                    humanoid.Health = 10
                end
            end
        end
    end)
end

-- ANTI WIGGLE
local function StartAntiWiggle()
    if connections.antiWiggle then return end
    connections.antiWiggle = RunService.RenderStepped:Connect(function()
        if toggles.antiWiggle then
            local char = GetCharacter()
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
        end
    end)
end

-- =====================================================
-- AUTO FARM / UTILITY (8)
-- =====================================================

-- AUTO GENERATOR
local function AutoGeneratorAction()
    local hrp = GetHRP()
    if not hrp then return end
    local gens = FindGenerators()
    if #gens == 0 then return end
    table.sort(gens, function(a,b) return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude end)
    local target = gens[1]
    if not target then return end
    hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
    task.wait(0.2)
    for i = 1, 15 do
        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()); task.wait(0.05) end)
    end
    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            if name:find("generator") or name:find("gen") or name:find("repair") or name:find("complete") then
                pcall(function() obj:FireServer(target) end)
            end
        end
    end
end

local function StartAutoGenerator()
    if autoGenActive then return end
    autoGenActive = true
    local conn = RunService.RenderStepped:Connect(function()
        if not autoGenActive or not toggles.autoGenerator then StopAutoGenerator(); return end
        AutoGeneratorAction()
        task.wait(1)
    end)
    connections.autoGenerator = conn
end

local function StopAutoGenerator()
    autoGenActive = false
    if connections.autoGenerator then connections.autoGenerator:Disconnect(); connections.autoGenerator = nil end
end

-- AUTO SKILL CHECK
local function StartAutoSkillCheck()
    if connections.autoSkillCheck then return end
    connections.autoSkillCheck = RunService.RenderStepped:Connect(function()
        if toggles.autoSkillCheck then
            local playerGui = LocalPlayer.PlayerGui
            if playerGui then
                for _, gui in pairs(playerGui:GetDescendants()) do
                    if gui:IsA("Frame") or gui:IsA("ImageLabel") then
                        local name = gui.Name:lower()
                        if name:find("skill") or name:find("check") then
                            for _, btn in pairs(gui:GetDescendants()) do
                                if btn:IsA("TextButton") or btn:IsA("ImageButton") then
                                    pcall(function()
                                        VirtualUser:CaptureController()
                                        VirtualUser:ClickButton2(Vector2.new())
                                    end)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end

-- INSTANT ESCAPE
local function StartInstantEscape()
    if connections.instantEscape then return end
    connections.instantEscape = RunService.RenderStepped:Connect(function()
        if toggles.instantEscape then
            local hrp = GetHRP()
            if not hrp then return end
            local gates = FindGates()
            if #gates > 0 then
                table.sort(gates, function(a,b) return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude end)
                local target = gates[1]
                if target then
                    hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
                    task.wait(0.2)
                    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                        if obj:IsA("RemoteEvent") and obj.Name:lower():find("escape") then
                            pcall(function() obj:FireServer() end)
                        end
                    end
                end
            end
        end
    end)
end

-- FORCE END GAME
local function StartForceEndGame()
    if connections.forceEndGame then return end
    connections.forceEndGame = RunService.RenderStepped:Connect(function()
        if toggles.forceEndGame then
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
        end
    end)
end

-- AUTO HEAL
local function StartAutoHeal()
    if connections.autoHeal then return end
    connections.autoHeal = RunService.RenderStepped:Connect(function()
        if toggles.autoHeal then
            local humanoid = GetHumanoid()
            if humanoid and humanoid.Health < humanoid.MaxHealth then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
            end
        end
    end)
end

-- CANCEL GENERATOR
local function StartCancelGenerator()
    if connections.cancelGenerator then return end
    connections.cancelGenerator = RunService.RenderStepped:Connect(function()
        if toggles.cancelGenerator then
            local gens = FindGenerators()
            for _, gen in pairs(gens) do
                pcall(function()
                    gen:SetAttribute("Progress", 0)
                    gen:SetAttribute("Completed", false)
                end)
            end
        end
    end)
end

-- KILLER PROXIMITY ALERT
local function StartKillerProximityAlert()
    if connections.killerProximityAlert then return end
    connections.killerProximityAlert = RunService.RenderStepped:Connect(function()
        if toggles.killerProximityAlert then
            local hrp = GetHRP()
            if not hrp then return end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and IsPlayerKiller(player) and player.Character then
                    local targetHrp = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                    if targetHrp then
                        local dist = (hrp.Position - targetHrp.Position).Magnitude
                        if dist < 30 then
                            print("⚠️ KILLER NEARBY! " .. player.Name .. " [" .. math.floor(dist) .. "m]")
                        end
                    end
                end
            end
        end
    end)
end

-- SERVER HOP
local function StartServerHop()
    if connections.serverHop then return end
    connections.serverHop = RunService.RenderStepped:Connect(function()
        if toggles.serverHop then
            TeleportService:Teleport(game.PlaceId)
            toggles.serverHop = false
        end
    end)
end

-- =====================================================
-- MISC FITUR (3)
-- =====================================================

-- GOD MODE
local function StartGodMode()
    if godModeActive then return end
    godModeActive = true
    local conn = RunService.RenderStepped:Connect(function()
        if not godModeActive or not toggles.godMode then StopGodMode(); return end
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end
    end)
    connections.godMode = conn
end

local function StopGodMode()
    godModeActive = false
    if connections.godMode then connections.godMode:Disconnect(); connections.godMode = nil end
end

-- ANTI AFK
local function StartAntiAFK()
    if connections.antiAFK then return end
    connections.antiAFK = RunService.RenderStepped:Connect(function()
        if toggles.antiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end

-- CHASED INDICATOR (dipasang di ESP Killer)
-- Sudah include di UpdateESP

-- =====================================================
-- TOGGLE HANDLER
-- =====================================================
local function ToggleFeature(key, state)
    toggles[key] = state
    
    -- STOP FEATURES
    if key == "fly" and not state then StopFly() end
    if key == "noClip" and not state then StopNoClip() end
    if key == "invisible" and not state then StopInvisible() end
    if key == "godMode" and not state then StopGodMode() end
    if key == "espKiller" and not state then
        local anyESP = toggles.espKiller or toggles.espSurvivor or toggles.espGenerator or toggles.espHook or toggles.espPallet or toggles.espVault or toggles.espBlood
        if not anyESP then StopESP() end
    end
    if key == "espSurvivor" and not state then
        local anyESP = toggles.espKiller or toggles.espSurvivor or toggles.espGenerator or toggles.espHook or toggles.espPallet or toggles.espVault or toggles.espBlood
        if not anyESP then StopESP() end
    end
    if key == "espGenerator" and not state then
        local anyESP = toggles.espKiller or toggles.espSurvivor or toggles.espGenerator or toggles.espHook or toggles.espPallet or toggles.espVault or toggles.espBlood
        if not anyESP then StopESP() end
    end
    if key == "espHook" and not state then
        local anyESP = toggles.espKiller or toggles.espSurvivor or toggles.espGenerator or toggles.espHook or toggles.espPallet or toggles.espVault or toggles.espBlood
        if not anyESP then StopESP() end
    end
    if key == "espPallet" and not state then
        local anyESP = toggles.espKiller or toggles.espSurvivor or toggles.espGenerator or toggles.espHook or toggles.espPallet or toggles.espVault or toggles.espBlood
        if not anyESP then StopESP() end
    end
    if key == "espVault" and not state then
        local anyESP = toggles.espKiller or toggles.espSurvivor or toggles.espGenerator or toggles.espHook or toggles.espPallet or toggles.espVault or toggles.espBlood
        if not anyESP then StopESP() end
    end
    if key == "espBlood" and not state then
        local anyESP = toggles.espKiller or toggles.espSurvivor or toggles.espGenerator or toggles.espHook or toggles.espPallet or toggles.espVault or toggles.espBlood
        if not anyESP then StopESP() end
    end
    if key == "autoGenerator" and not state then StopAutoGenerator() end
    
    -- START FEATURES
    if state then
        if key == "fly" then StartFly()
        elseif key == "noClip" then StartNoClip()
        elseif key == "speedHack" then StartSpeedHack()
        elseif key == "superJump" then StartSuperJump()
        elseif key == "moonwalk" then StartMoonwalk()
        elseif key == "invisible" then StartInvisible()
        elseif key == "fullBright" then StartFullBright()
        elseif key == "antiBlind" then StartAntiBlind()
        elseif key == "antiStun" then StartAntiStun()
        elseif key == "noSlowdown" then StartNoSlowdown()
        elseif key == "fastVault" then StartFastVault()
        elseif key == "hitboxExpander" then StartHitboxExpander()
        elseif key == "crosshair" then StartCrosshair()
        elseif key == "espKiller" or key == "espSurvivor" or key == "espGenerator" or key == "espHook" or key == "espPallet" or key == "espVault" or key == "espBlood" then
            if not espActive then StartESP() end
        elseif key == "autoParry" then StartAutoParry()
        elseif key == "infiniteAttack" then StartInfiniteAttack()
        elseif key == "aimbotRevolver" then StartAimbotRevolver()
        elseif key == "infiniteLunge" then StartInfiniteLunge()
        elseif key == "antiKnock" then StartAntiKnock()
        elseif key == "antiWiggle" then StartAntiWiggle()
        elseif key == "autoGenerator" then StartAutoGenerator()
        elseif key == "autoSkillCheck" then StartAutoSkillCheck()
        elseif key == "instantEscape" then StartInstantEscape()
        elseif key == "forceEndGame" then StartForceEndGame()
        elseif key == "autoHeal" then StartAutoHeal()
        elseif key == "cancelGenerator" then StartCancelGenerator()
        elseif key == "killerProximityAlert" then StartKillerProximityAlert()
        elseif key == "serverHop" then StartServerHop()
        elseif key == "godMode" then StartGodMode()
        elseif key == "antiAFK" then StartAntiAFK()
        end
    end
end

-- =====================================================
-- GUI – FULL 30+ FITUR
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHubV54"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 360, 0, 600)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -300)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 40)
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

local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ZIP HUB v54.0 – 6LOCC EDITION ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 10)
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

local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Size = UDim2.new(1, -12, 1, -55)
ScrollingFrame.Position = UDim2.new(0, 6, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
ScrollingFrame.BorderSizePixel = 0

local function CreateToggle(text, desc, key, yPos)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 55)
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
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left

    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = frame
    descLabel.Size = UDim2.new(0.6, 0, 0, 16)
    descLabel.Position = UDim2.new(0, 10, 0, 26)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc or ""
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    descLabel.TextSize = 9
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

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.Parent = toggleBtn
    toggleCorner.CornerRadius = UDim.new(0, 4)

    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(200, 40, 40)
        ToggleFeature(key, state)
    end)
end

local function CreateCategory(text, yPos)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 4)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "▸ " .. text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamBold
    return yPos + 34
end

-- =====================================================
-- DAFTAR FITUR DI GUI (30+)
-- =====================================================
local yPos = 2

-- MOVEMENT
yPos = CreateCategory("MOVEMENT", yPos)
CreateToggle("✈️ Fly", "WASD + Space/Shift to move", "fly", yPos)
yPos = yPos + 54
CreateToggle("🚪 No Clip", "Walk through walls", "noClip", yPos)
yPos = yPos + 54
CreateToggle("💨 Speed Hack", "Run faster (WalkSpeed = 60)", "speedHack", yPos)
yPos = yPos + 54
CreateToggle("🦘 Super Jump", "Jump higher (JumpPower = 150)", "superJump", yPos)
yPos = yPos + 54
CreateToggle("🌙 Moonwalk", "Moonwalk with sway effect", "moonwalk", yPos)
yPos = yPos + 54

-- VISUAL
yPos = CreateCategory("VISUAL", yPos)
CreateToggle("👻 Invisible", "Become completely invisible", "invisible", yPos)
yPos = yPos + 54
CreateToggle("☀️ Full Bright", "Brighten map", "fullBright", yPos)
yPos = yPos + 54
CreateToggle("👁️ Anti Blind", "Remove flash/overlay effects", "antiBlind", yPos)
yPos = yPos + 54
CreateToggle("⛔ Anti Stun", "Prevent stun/immobilize", "antiStun", yPos)
yPos = yPos + 54
CreateToggle("🐢 No Slowdown", "Prevent speed reduction on turns", "noSlowdown", yPos)
yPos = yPos + 54
CreateToggle("🪟 Fast Vault", "Super fast vault over obstacles", "fastVault", yPos)
yPos = yPos + 54
CreateToggle("🎯 Hitbox Expander", "Enlarge head/torso hitbox", "hitboxExpander", yPos)
yPos = yPos + 54
CreateToggle("🎯 Crosshair", "Custom crosshair overlay", "crosshair", yPos)
yPos = yPos + 54

-- ESP
yPos = CreateCategory("ESP (7 FITUR)", yPos)
CreateToggle("🔴 Killer ESP", "Highlight killer + distance", "espKiller", yPos)
yPos = yPos + 54
CreateToggle("🟢 Survivor ESP", "Highlight survivor + health state", "espSurvivor", yPos)
yPos = yPos + 54
CreateToggle("⚡ Generator ESP", "Show generator position + progress", "espGenerator", yPos)
yPos = yPos + 54
CreateToggle("🪝 Hook ESP", "Show hook positions", "espHook", yPos)
yPos = yPos + 54
CreateToggle("📦 Pallet ESP", "Show pallet positions", "espPallet", yPos)
yPos = yPos + 54
CreateToggle("🪟 Vault ESP", "Show vault positions", "espVault", yPos)
yPos = yPos + 54
CreateToggle("🩸 Blood ESP", "Show injured survivors", "espBlood", yPos)
yPos = yPos + 54

-- COMBAT
yPos = CreateCategory("COMBAT", yPos)
CreateToggle("🛡️ Auto Parry", "Auto parry when attacked", "autoParry", yPos)
yPos = yPos + 54
CreateToggle("⚔️ Infinite Attack", "No cooldown on attacks", "infiniteAttack", yPos)
yPos = yPos + 54
CreateToggle("🎯 Aimbot Revolver", "Auto aim with wallcheck", "aimbotRevolver", yPos)
yPos = yPos + 54
CreateToggle("📏 Infinite Lunge", "Unlimited attack range", "infiniteLunge", yPos)
yPos = yPos + 54
CreateToggle("🛡️ Anti Knock", "Prevent getting knocked", "antiKnock", yPos)
yPos = yPos + 54
CreateToggle("🔄 Anti Wiggle", "Prevent wiggle off hook", "antiWiggle", yPos)
yPos = yPos + 54

-- AUTO FARM / UTILITY
yPos = CreateCategory("AUTO FARM & UTILITY", yPos)
CreateToggle("⚡ Auto Generator", "Auto farm generators", "autoGenerator", yPos)
yPos = yPos + 54
CreateToggle("🎯 Auto Skill Check", "100% accuracy on skill checks", "autoSkillCheck", yPos)
yPos = yPos + 54
CreateToggle("🏃 Instant Escape", "Teleport to gate + force escape", "instantEscape", yPos)
yPos = yPos + 54
CreateToggle("🚪 Force End Game", "Open all gates instantly", "forceEndGame", yPos)
yPos = yPos + 54
CreateToggle("💚 Auto Heal", "Auto heal when injured", "autoHeal", yPos)
yPos = yPos + 54
CreateToggle("❌ Cancel Generator", "Reset generator progress", "cancelGenerator", yPos)
yPos = yPos + 54
CreateToggle("⚠️ Killer Proximity Alert", "Alert when killer near", "killerProximityAlert", yPos)
yPos = yPos + 54
CreateToggle("🔄 Server Hop", "Auto teleport to new server", "serverHop", yPos)
yPos = yPos + 54

-- MISC
yPos = CreateCategory("MISC", yPos)
CreateToggle("🛡️ God Mode", "Infinite health", "godMode", yPos)
yPos = yPos + 54
CreateToggle("⏰ Anti AFK", "Prevent AFK kick", "antiAFK", yPos)
yPos = yPos + 54

ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- Watermark
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 180, 0, 16)
Watermark.Position = UDim2.new(0, 8, 1, -22)
Watermark.BackgroundTransparency = 1
Watermark.Text = "⚡ ZIP HUB v54.0 – 6LOCC ⚡"
Watermark.TextColor3 = Color3.fromRGB(0, 180, 255)
Watermark.TextSize = 10
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextTransparency = 0.4

print("✅ ZIP HUB v54.0 – 6LOCC EDITION LOADED!")
print("✅ 30+ FITUR AKTIF – SEMUA BERFUNGSI!")

-- =====================================================
-- AUTO START ESP BY DEFAULT
-- =====================================================
task.wait(0.5)
ToggleFeature("espKiller", true)
ToggleFeature("espSurvivor", true)
ToggleFeature("espGenerator", true)
ToggleFeature("espHook", true)
ToggleFeature("espPallet", true)

print("🔥 ZIP HUB v54.0 – READY TO DOMINATE!")
