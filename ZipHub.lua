-- =====================================================
-- ZIP HUB v6.0 – 6LOCC STYLE FULL REPLICA
-- ALL FEATURES IDENTIK DENGAN 6LOCC
-- UI: 6LOCC STYLE + LOGO "ZIP"
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
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

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

local function GetChasedIndicator(distance)
    if distance < 30 then return "🔴!!"
    elseif distance < 50 then return "🟡!"
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

local function FindVaults()
    local vaults = {}
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("vault") or obj.Name:lower():find("window") or obj.Name:lower():find("ledge")) then
            table.insert(vaults, obj)
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
-- TOGGLES – SEMUA FITUR 6LOCC
-- =====================================================
local toggles = {
    -- ESP
    espKiller = false,
    espSurvivor = false,
    espGenerator = false,
    espHook = false,
    espPallet = false,
    espVault = false,
    espBlood = false,
    espBackground = false,
    espRangeLimit = false,
    
    -- Combat
    autoParry = false,
    aimbotRevolver = false,
    infiniteLunge = false,
    noStun = false,
    autoArm = false,
    
    -- Movement
    speedBoost = false,
    vaultSpeed = false,
    noClip = false,
    moonwalk = false,
    disableMoonwalkNearVault = false,
    
    -- Auto Farm
    autoGenerator = false,
    autoSkillCheck = false,
    killAura = false,
    hookSpam = false,
    destroyPallets = false,
    autoFarmKiller = false,
    autoFarmSurvivor = false,
    
    -- Utility
    teleportMenu = false,
    flowstatePerk = false,
    antiWiggle = false,
    instantHeal = false,
    cancelGenerator = false,
    antiCamp = false,
    serverHop = false,
    
    -- Misc
    godMode = false,
    antiAFK = false,
    fullBright = false,
    antiBlind = false
}

local connections = {}
local espObjects = {}
local flyActive = false
local flyBodyVelocity = nil
local flyBodyPosition = nil
local flyConnection = nil
local flySpeed = 50

local invisibleActive = false
local invisibleConnection = nil

local autoGenActive = false
local autoGenConnection = nil

local noClipActive = false
local noClipConnection = nil

local godModeActive = false
local godModeConnection = nil

local espActive = false
local espConnection = nil

local moonwalkGyro = nil
local moonwalkActive = false

local speedBoostActive = false
local vaultSpeedActive = false

-- =====================================================
-- ESP SYSTEM (7 FITUR)
-- =====================================================
local function ClearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
end

local function AddESP(target, color, label, labelColor, bgColor)
    if not target then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Parent = target
    highlight.FillColor = color
    highlight.FillTransparency = 0.3
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.1
    table.insert(espObjects, highlight)
    
    if toggles.espBackground then
        local bg = Instance.new("BillboardGui")
        bg.Parent = target
        bg.Size = UDim2.new(0, 180, 0, 30)
        bg.Adornee = target
        bg.AlwaysOnTop = true
        bg.StudsOffset = Vector3.new(0, 2.5, 0)
        local bgFrame = Instance.new("Frame")
        bgFrame.Parent = bg
        bgFrame.Size = UDim2.new(1, 0, 1, 0)
        bgFrame.BackgroundColor3 = bgColor or Color3.fromRGB(0, 0, 0)
        bgFrame.BackgroundTransparency = 0.5
        bgFrame.BorderSizePixel = 0
        table.insert(espObjects, bg)
        table.insert(espObjects, bgFrame)
    end
    
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
    if not espActive then return end
    
    local hrp = GetHRP()
    
    -- ESP KILLER
    if toggles.espKiller then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and IsPlayerKiller(player) and player.Character then
                local th = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                local dist = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                if toggles.espRangeLimit and dist > 100 then break end
                local chased = GetChasedIndicator(dist)
                AddESP(player.Character, Color3.fromRGB(255, 0, 0), chased .. " " .. player.Name .. " [" .. math.floor(dist) .. "m] [Killer]", Color3.fromRGB(255, 0, 0), Color3.fromRGB(50, 0, 0))
            end
        end
    end
    
    -- ESP SURVIVOR
    if toggles.espSurvivor then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not IsPlayerKiller(player) and player.Character then
                local th = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                local dist = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                if toggles.espRangeLimit and dist > 100 then break end
                local state = GetHealthState(player)
                AddESP(player.Character, Color3.fromRGB(0, 255, 0), "🟢 " .. player.Name .. " [" .. math.floor(dist) .. "m] " .. state, Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 50, 0))
            end
        end
    end
    
    -- ESP GENERATOR
    if toggles.espGenerator then
        for _, gen in pairs(FindGenerators()) do
            AddESP(gen.Parent or gen, Color3.fromRGB(0, 255, 255), "⚡ Generator", Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 50, 50))
        end
    end
    
    -- ESP HOOK
    if toggles.espHook then
        for _, hook in pairs(FindHooks()) do
            AddESP(hook.Parent or hook, Color3.fromRGB(255, 165, 0), "🪝 Hook", Color3.fromRGB(255, 165, 0), Color3.fromRGB(50, 30, 0))
        end
    end
    
    -- ESP PALLET
    if toggles.espPallet then
        for _, pallet in pairs(FindPallets()) do
            AddESP(pallet.Parent or pallet, Color3.fromRGB(139, 69, 19), "📦 Pallet", Color3.fromRGB(139, 69, 19), Color3.fromRGB(30, 15, 0))
        end
    end
    
    -- ESP VAULT
    if toggles.espVault then
        for _, vault in pairs(FindVaults()) do
            AddESP(vault.Parent or vault, Color3.fromRGB(255, 255, 0), "🪟 Vault", Color3.fromRGB(255, 255, 0), Color3.fromRGB(50, 50, 0))
        end
    end
    
    -- ESP BLOOD
    if toggles.espBlood then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not IsPlayerKiller(player) and player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid and humanoid.Health < humanoid.MaxHealth then
                    local th = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                    local dist = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                    local state = GetHealthState(player)
                    AddESP(player.Character, Color3.fromRGB(255, 0, 0), "🩸 " .. player.Name .. " " .. state, Color3.fromRGB(255, 0, 0), Color3.fromRGB(50, 0, 0))
                end
            end
        end
    end
end

local function StartESP()
    if espActive then return end
    espActive = true
    espConnection = RunService.RenderStepped:Connect(function()
        if espActive then
            UpdateESP()
        end
    end)
end

local function StopESP()
    espActive = false
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
    ClearESP()
end

-- =====================================================
-- COMBAT SYSTEM
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

-- NO STUN
local function StartNoStun()
    if connections.noStun then return end
    connections.noStun = RunService.RenderStepped:Connect(function()
        if toggles.noStun then
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

-- AUTO ARM
local function StartAutoArm()
    if connections.autoArm then return end
    connections.autoArm = RunService.RenderStepped:Connect(function()
        if toggles.autoArm then
            local char = GetCharacter()
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") and not tool:GetAttribute("Equipped") then
                        pcall(function()
                            LocalPlayer.Character.Humanoid:EquipTool(tool)
                        end)
                    end
                end
            end
        end
    end)
end

-- =====================================================
-- MOVEMENT SYSTEM
-- =====================================================

-- SPEED BOOST
local function StartSpeedBoost()
    if connections.speedBoost then return end
    connections.speedBoost = RunService.RenderStepped:Connect(function()
        if toggles.speedBoost then
            local humanoid = GetHumanoid()
            if humanoid then humanoid.WalkSpeed = 60 end
        end
    end)
end

-- VAULT SPEED
local function StartVaultSpeed()
    if connections.vaultSpeed then return end
    connections.vaultSpeed = RunService.RenderStepped:Connect(function()
        if toggles.vaultSpeed then
            local hrp = GetHRP()
            if not hrp then return end
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("vault") or obj.Name:lower():find("pallet") or obj.Name:lower():find("window") or obj.Name:lower():find("ledge")) then
                    if (hrp.Position - obj.Position).Magnitude < 5 then
                        local humanoid = GetHumanoid()
                        if humanoid then
                            humanoid.Jump = true
                            task.wait(0.03)
                            hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 15
                        end
                        break
                    end
                end
            end
        end
    end)
end

-- NO CLIP
local function StartNoClip()
    if noClipActive then return end
    noClipActive = true
    noClipConnection = RunService.RenderStepped:Connect(function()
        if not noClipActive or not toggles.noClip then
            StopNoClip()
            return
        end
        local char = GetCharacter()
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function StopNoClip()
    noClipActive = false
    if noClipConnection then
        noClipConnection:Disconnect()
        noClipConnection = nil
    end
    local char = GetCharacter()
    if char then
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

-- MOONWALK (with sway speed, size, shaking)
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
            if moonwalkGyro then
                moonwalkGyro:Destroy()
                moonwalkGyro = nil
            end
            local humanoid = GetHumanoid()
            if humanoid then
                humanoid.AutoRotate = true
            end
        end
    end)
end

-- =====================================================
-- AUTO FARM SYSTEM
-- =====================================================

-- AUTO GENERATOR
local function AutoGeneratorAction()
    local hrp = GetHRP()
    if not hrp then return end
    local gens = FindGenerators()
    if #gens == 0 then return end
    table.sort(gens, function(a, b)
        return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
    end)
    local target = gens[1]
    if not target then return end
    hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
    task.wait(0.2)
    for i = 1, 15 do
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        task.wait(0.05)
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
    autoGenConnection = RunService.RenderStepped:Connect(function()
        if not autoGenActive or not toggles.autoGenerator then
            StopAutoGenerator()
            return
        end
        AutoGeneratorAction()
        task.wait(0.8)
    end)
end

local function StopAutoGenerator()
    autoGenActive = false
    if autoGenConnection then
        autoGenConnection:Disconnect()
        autoGenConnection = nil
    end
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

-- KILL AURA
local function StartKillAura()
    if connections.killAura then return end
    connections.killAura = RunService.RenderStepped:Connect(function()
        if toggles.killAura then
            local hrp = GetHRP()
            if not hrp then return end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and not IsPlayerKiller(player) and player.Character then
                    local targetHrp = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                    if targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 20 then
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton2(Vector2.new())
                            task.wait(0.1)
                        end)
                    end
                end
            end
        end
    end)
end

-- HOOK SPAM
local function StartHookSpam()
    if connections.hookSpam then return end
    connections.hookSpam = RunService.RenderStepped:Connect(function()
        if toggles.hookSpam then
            for _, hook in pairs(FindHooks()) do
                pcall(function()
                    local click = hook:FindFirstChild("ClickDetector")
                    if click then click:Click() end
                end)
            end
        end
    end)
end

-- DESTROY PALLETS
local function StartDestroyPallets()
    if connections.destroyPallets then return end
    connections.destroyPallets = RunService.RenderStepped:Connect(function()
        if toggles.destroyPallets then
            for _, pallet in pairs(FindPallets()) do
                pcall(function()
                    pallet:Destroy()
                end)
            end
        end
    end)
end

-- AUTO FARM KILLER
local function StartAutoFarmKiller()
    if connections.autoFarmKiller then return end
    connections.autoFarmKiller = RunService.RenderStepped:Connect(function()
        if toggles.autoFarmKiller then
            local hrp = GetHRP()
            if not hrp then return end
            local target = GetClosestPlayer()
            if target and target.Character then
                local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
                if targetHrp then
                    hrp.CFrame = CFrame.new(targetHrp.Position + Vector3.new(0, 2, 0))
                    task.wait(0.1)
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end)
                end
            end
        end
    end)
end

-- AUTO FARM SURVIVOR
local function StartAutoFarmSurvivor()
    if connections.autoFarmSurvivor then return end
    connections.autoFarmSurvivor = RunService.RenderStepped:Connect(function()
        if toggles.autoFarmSurvivor then
            AutoGeneratorAction()
            task.wait(0.5)
            local gates = FindGates()
            if #gates > 0 then
                local hrp = GetHRP()
                if hrp then
                    table.sort(gates, function(a, b)
                        return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
                    end)
                    hrp.CFrame = CFrame.new(gates[1].Position + Vector3.new(0, 3, 0))
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

-- =====================================================
-- UTILITY SYSTEM
-- =====================================================

-- TELEPORT MENU
local function TeleportToObject(type)
    local hrp = GetHRP()
    if not hrp then return end
    local targets = {}
    local searchName = type
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(searchName) then
            table.insert(targets, obj)
        end
    end
    if #targets > 0 then
        table.sort(targets, function(a, b)
            return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
        end)
        hrp.CFrame = CFrame.new(targets[1].Position + Vector3.new(0, 2, 0))
    end
end

-- FORCE FLOWSTATE PERK
local function StartFlowstatePerk()
    if connections.flowstatePerk then return end
    connections.flowstatePerk = RunService.RenderStepped:Connect(function()
        if toggles.flowstatePerk then
            for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                if obj:IsA("RemoteEvent") and obj.Name:lower():find("flowstate") then
                    pcall(function() obj:FireServer() end)
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

-- INSTANT HEAL
local function StartInstantHeal()
    if connections.instantHeal then return end
    connections.instantHeal = RunService.RenderStepped:Connect(function()
        if toggles.instantHeal then
            local humanoid = GetHumanoid()
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
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

-- ANTI CAMP
local function StartAntiCamp()
    if connections.antiCamp then return end
    connections.antiCamp = RunService.RenderStepped:Connect(function()
        if toggles.antiCamp then
            local hrp = GetHRP()
            if not hrp then return end
            local killer = GetClosestKiller()
            if killer and killer.Character then
                local targetHrp = killer.Character:FindFirstChild("HumanoidRootPart") or killer.Character:FindFirstChild("Torso")
                if targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 15 then
                    hrp.CFrame = hrp.CFrame + Vector3.new(0, 10, 0)
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
-- MISC SYSTEM
-- =====================================================

-- GOD MODE
local function StartGodMode()
    if godModeActive then return end
    godModeActive = true
    godModeConnection = RunService.RenderStepped:Connect(function()
        if not godModeActive or not toggles.godMode then
            StopGodMode()
            return
        end
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.Health = humanoid.MaxHealth
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end
    end)
end

local function StopGodMode()
    godModeActive = false
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
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

-- =====================================================
-- TOGGLE HANDLER
-- =====================================================
local function ToggleFeature(key, state)
    toggles[key] = state
    
    -- STOP FEATURES
    if key == "noClip" and not state then StopNoClip() end
    if key == "godMode" and not state then StopGodMode() end
    if key == "autoGenerator" and not state then StopAutoGenerator() end
    
    if key == "espKiller" or key == "espSurvivor" or key == "espGenerator" or key == "espHook" or key == "espPallet" or key == "espVault" or key == "espBlood" or key == "espBackground" or key == "espRangeLimit" then
        local anyESP = toggles.espKiller or toggles.espSurvivor or toggles.espGenerator or toggles.espHook or toggles.espPallet or toggles.espVault or toggles.espBlood
        if not anyESP then StopESP() end
    end
    
    -- START FEATURES
    if state then
        if key == "espKiller" or key == "espSurvivor" or key == "espGenerator" or key == "espHook" or key == "espPallet" or key == "espVault" or key == "espBlood" or key == "espBackground" or key == "espRangeLimit" then
            if not espActive then StartESP() end
        elseif key == "autoParry" then StartAutoParry()
        elseif key == "aimbotRevolver" then StartAimbotRevolver()
        elseif key == "infiniteLunge" then StartInfiniteLunge()
        elseif key == "noStun" then StartNoStun()
        elseif key == "autoArm" then StartAutoArm()
        elseif key == "speedBoost" then StartSpeedBoost()
        elseif key == "vaultSpeed" then StartVaultSpeed()
        elseif key == "noClip" then StartNoClip()
        elseif key == "moonwalk" then StartMoonwalk()
        elseif key == "autoGenerator" then StartAutoGenerator()
        elseif key == "autoSkillCheck" then StartAutoSkillCheck()
        elseif key == "killAura" then StartKillAura()
        elseif key == "hookSpam" then StartHookSpam()
        elseif key == "destroyPallets" then StartDestroyPallets()
        elseif key == "autoFarmKiller" then StartAutoFarmKiller()
        elseif key == "autoFarmSurvivor" then StartAutoFarmSurvivor()
        elseif key == "teleportMenu" then
            -- Teleport menu handler (dipanggil via tombol)
        elseif key == "flowstatePerk" then StartFlowstatePerk()
        elseif key == "antiWiggle" then StartAntiWiggle()
        elseif key == "instantHeal" then StartInstantHeal()
        elseif key == "cancelGenerator" then StartCancelGenerator()
        elseif key == "antiCamp" then StartAntiCamp()
        elseif key == "serverHop" then StartServerHop()
        elseif key == "godMode" then StartGodMode()
        elseif key == "antiAFK" then StartAntiAFK()
        elseif key == "fullBright" then StartFullBright()
        elseif key == "antiBlind" then StartAntiBlind()
        end
    end
end

-- =====================================================
-- TELEPORT MENU CALLBACK
-- =====================================================
local function TeleportToGen()
    TeleportToObject("generator")
end

local function TeleportToHook()
    TeleportToObject("hook")
end

local function TeleportToPallet()
    TeleportToObject("pallet")
end

local function TeleportToVault()
    TeleportToObject("vault")
end

-- =====================================================
-- GUI – 6LOCC STYLE + LOGO ZIP
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHub6locc"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
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
MainBorder.Color = Color3.fromRGB(0, 200, 255)
MainBorder.Thickness = 1.5
MainBorder.Transparency = 0.2

-- HEADER WITH LOGO
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 12)

-- LOGO ZIP
local LogoFrame = Instance.new("Frame")
LogoFrame.Parent = Header
LogoFrame.Size = UDim2.new(0, 30, 0, 30)
LogoFrame.Position = UDim2.new(0, 8, 0.5, -15)
LogoFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
LogoFrame.BackgroundTransparency = 0
LogoFrame.BorderSizePixel = 0

local LogoCorner = Instance.new("UICorner")
LogoCorner.Parent = LogoFrame
LogoCorner.CornerRadius = UDim.new(1, 0)

local LogoText = Instance.new("TextLabel")
LogoText.Parent = LogoFrame
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "Z"
LogoText.TextColor3 = Color3.fromRGB(10, 10, 25)
LogoText.TextSize = 20
LogoText.Font = Enum.Font.GothamBold

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(0.5, 0, 1, 0)
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
SubTitle.Text = "v6.0"
SubTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Right

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 13
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseBtn
CloseCorner.CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- SCROLLING FRAME
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Size = UDim2.new(1, -12, 1, -55)
ScrollingFrame.Position = UDim2.new(0, 6, 0, 50)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
ScrollingFrame.BorderSizePixel = 0

-- TOGGLE CREATOR (6LOCC STYLE)
local function CreateToggle(text, desc, key, yPos)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 42)
    frame.Position = UDim2.new(0, 0, 0, yPos)
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
        ToggleFeature(key, state)
    end)
    return yPos + 46
end

-- TELEPORT BUTTON CREATOR
local function CreateTeleportButton(text, desc, callback, yPos)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 42)
    frame.Position = UDim2.new(0, 0, 0, yPos)
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
    actionBtn.Size = UDim2.new(0, 52, 0, 22)
    actionBtn.Position = UDim2.new(1, -60, 0.5, -11)
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
    return yPos + 46
end

-- =====================================================
-- DAFTAR FITUR DI GUI (SEMUA 6LOCC)
-- =====================================================
local yPos = 2

-- ESP
yPos = CreateToggle("🔴 Killer ESP", "Tampilkan killer + jarak", "espKiller", yPos)
yPos = CreateToggle("🟢 Survivor ESP", "Tampilkan survivor + status", "espSurvivor", yPos)
yPos = CreateToggle("⚡ Generator ESP", "Tampilkan posisi generator", "espGenerator", yPos)
yPos = CreateToggle("🪝 Hook ESP", "Tampilkan posisi hook", "espHook", yPos)
yPos = CreateToggle("📦 Pallet ESP", "Tampilkan posisi pallet", "espPallet", yPos)
yPos = CreateToggle("🪟 Vault ESP", "Tampilkan posisi vault", "espVault", yPos)
yPos = CreateToggle("🩸 Blood ESP", "Tampilkan survivor terluka", "espBlood", yPos)
yPos = CreateToggle("📋 ESP Background", "Background card di ESP", "espBackground", yPos)
yPos = CreateToggle("📏 ESP Range Limit", "Batas jarak ESP 100m", "espRangeLimit", yPos)

-- Combat
yPos = CreateToggle("🛡️ Auto Parry", "Parry otomatis saat diserang", "autoParry", yPos)
yPos = CreateToggle("🎯 Aimbot Revolver", "Aim otomatis ke target", "aimbotRevolver", yPos)
yPos = CreateToggle("📏 Infinite Lunge", "Jarak serangan unlimited", "infiniteLunge", yPos)
yPos = CreateToggle("⛔ No Stun", "Cegah stun/kunci", "noStun", yPos)
yPos = CreateToggle("🔫 Auto Arm", "Ambil senjata otomatis", "autoArm", yPos)

-- Movement
yPos = CreateToggle("💨 Speed Boost", "Kecepatan lebih tinggi", "speedBoost", yPos)
yPos = CreateToggle("🪟 Vault Speed", "Vault super cepat", "vaultSpeed", yPos)
yPos = CreateToggle("🚪 No Clip", "Tembus dinding", "noClip", yPos)
yPos = CreateToggle("🌙 Moonwalk", "Moonwalk + sway", "moonwalk", yPos)

-- Auto Farm
yPos = CreateToggle("⚡ Auto Generator", "Auto farm generator", "autoGenerator", yPos)
yPos = CreateToggle("🎯 Auto Skill Check", "Auto skill check 100%", "autoSkillCheck", yPos)
yPos = CreateToggle("☠️ Kill Aura", "Serang survivor di sekitar", "killAura", yPos)
yPos = CreateToggle("🪝 Hook Spam", "Spam interaksi hook", "hookSpam", yPos)
yPos = CreateToggle("💥 Destroy Pallets", "Hancurkan semua pallet", "destroyPallets", yPos)
yPos = CreateToggle("🔪 Auto Farm Killer", "Farm sebagai killer", "autoFarmKiller", yPos)
yPos = CreateToggle("🟢 Auto Farm Survivor", "Farm sebagai survivor", "autoFarmSurvivor", yPos)

-- Teleport Menu
yPos = CreateTeleportButton("🔘 TP Generator", "Teleport ke generator", TeleportToGen, yPos)
yPos = CreateTeleportButton("🔘 TP Hook", "Teleport ke hook", TeleportToHook, yPos)
yPos = CreateTeleportButton("🔘 TP Pallet", "Teleport ke pallet", TeleportToPallet, yPos)
yPos = CreateTeleportButton("🔘 TP Vault", "Teleport ke vault", TeleportToVault, yPos)

-- Utility
yPos = CreateToggle("⚡ Flowstate Perk", "Force enable no CD", "flowstatePerk", yPos)
yPos = CreateToggle("🔄 Anti Wiggle", "Cegah wiggle di hook", "antiWiggle", yPos)
yPos = CreateToggle("💚 Instant Heal", "Heal instan", "instantHeal", yPos)
yPos = CreateToggle("❌ Cancel Generator", "Reset progress generator", "cancelGenerator", yPos)
yPos = CreateToggle("🚫 Anti Camp", "Cegah killer camping", "antiCamp", yPos)
yPos = CreateToggle("🔄 Server Hop", "Pindah server", "serverHop", yPos)

-- Misc
yPos = CreateToggle("🛡️ God Mode", "Health tidak bisa mati", "godMode", yPos)
yPos = CreateToggle("⏰ Anti AFK", "Cegah kick AFK", "antiAFK", yPos)
yPos = CreateToggle("☀️ Full Bright", "Peta terang benderang", "fullBright", yPos)
yPos = CreateToggle("👁️ Anti Blind", "Hilangkan efek flash", "antiBlind", yPos)

ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- WATERMARK
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 160, 0, 16)
Watermark.Position = UDim2.new(0, 8, 1, -22)
Watermark.BackgroundTransparency = 1
Watermark.Text = "⚡ ZIP HUB v6.0 ⚡"
Watermark.TextColor3 = Color3.fromRGB(0, 200, 255)
Watermark.TextSize = 10
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextTransparency = 0.4

-- AUTO START ESP
task.wait(0.5)
ToggleFeature("espKiller", true)
ToggleFeature("espSurvivor", true)
ToggleFeature("espGenerator", true)
ToggleFeature("espHook", true)
ToggleFeature("espPallet", true)

print("✅ ZIP HUB v6.0 – 6LOCC REPLICA LOADED!")
print("✅ 35+ FITUR – FULL 6LOCC FUNCTIONALITY")
print("✅ LOGO ZIP – UI 6LOCC STYLE")
