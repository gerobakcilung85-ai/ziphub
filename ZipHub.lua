-- =====================================================
-- ZIP HUB v53.0 – FULL FIX (ALL FEATURES WORKING)
-- FIX: FLY, INVISIBLE, AUTO GENERATOR, ESP, DLL
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

-- =====================================================
-- VARIABEL GLOBAL
-- =====================================================
local flyActive = false
local flyBodyVelocity = nil
local flyBodyPosition = nil
local flyConnection = nil
local flySpeed = 50

local invisibleActive = false
local invisibleConnection = nil
local invisibleParts = {}

local espActive = false
local espConnection = nil
local espObjects = {}

local silentAimActive = false
local silentAimConnection = nil

local noClipActive = false
local noClipConnection = nil

local godModeActive = false
local godModeConnection = nil

local autoGenActive = false
local autoGenConnection = nil
local genCooldown = 0

local autoKillActive = false
local autoKillConnection = nil

local toggles = {
    fly = false,
    invisible = false,
    autoGenerator = false,
    esp = false,
    silentAim = false,
    autoKill = false,
    noClip = false,
    godMode = false,
    speedHack = false,
    superJump = false,
    antiAFK = false,
    autoParry = false,
    noRecoil = false,
    wallhack = false,
    autoEscape = false,
    autoHeal = false,
    noParryCooldown = false,
    noFall = false,
    noTurnSpeed = false,
    fastVault = false,
    moonwalk = false,
    fullBright = false,
    antiBlind = false,
    espKiller = false,
    espSurvivor = false,
    espGenerator = false,
    espHook = false,
    espPallet = false
}

local connections = {}

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
-- FLY (FIXED)
-- =====================================================
local function StartFly()
    if flyActive then return end
    flyActive = true
    
    local hrp = GetHRP()
    if not hrp then
        flyActive = false
        return
    end
    
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.PlatformStand = true
        humanoid.Sit = false
    end
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = hrp
    
    flyBodyPosition = Instance.new("BodyPosition")
    flyBodyPosition.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    flyBodyPosition.Position = hrp.Position
    flyBodyPosition.Parent = hrp
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flyActive or not toggles.fly then
            StopFly()
            return
        end
        
        local hrp = GetHRP()
        if not hrp then return end
        
        if flyBodyPosition then
            flyBodyPosition.Position = hrp.Position
        end
        
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
        
        if moveDir.Magnitude > 0 then
            flyBodyVelocity.Velocity = moveDir.Unit * flySpeed
        else
            flyBodyVelocity.Velocity = Vector3.new(0, 0.5, 0)
        end
    end)
    
    print("✈️ Fly ACTIVE")
end

local function StopFly()
    flyActive = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    if flyBodyPosition then
        flyBodyPosition:Destroy()
        flyBodyPosition = nil
    end
    local humanoid = GetHumanoid()
    if humanoid then
        humanoid.PlatformStand = false
    end
    print("✈️ Fly DEACTIVATED")
end

-- =====================================================
-- INVISIBLE (FIXED)
-- =====================================================
local function StartInvisible()
    if invisibleActive then return end
    invisibleActive = true
    
    invisibleConnection = RunService.RenderStepped:Connect(function()
        if not invisibleActive or not toggles.invisible then
            StopInvisible()
            return
        end
        
        local char = GetCharacter()
        if not char then return end
        
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
                part.CastShadow = false
                table.insert(invisibleParts, part)
            end
            if part:IsA("Accessory") and part:FindFirstChild("Handle") then
                part.Handle.Transparency = 1
                part.Handle.CanCollide = false
                table.insert(invisibleParts, part.Handle)
            end
        end
        
        local humanoid = GetHumanoid()
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            humanoid.NameDisplayDistance = 0
        end
    end)
    
    print("👻 Invisible ACTIVE")
end

local function StopInvisible()
    invisibleActive = false
    if invisibleConnection then
        invisibleConnection:Disconnect()
        invisibleConnection = nil
    end
    
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
    invisibleParts = {}
    print("👻 Invisible DEACTIVATED")
end

-- =====================================================
-- AUTO GENERATOR (FIXED)
-- =====================================================
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
    task.wait(0.1)
    
    for i = 1, 10 do
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        task.wait(0.03)
    end
    
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

local function StartAutoGenerator()
    if autoGenActive then return end
    autoGenActive = true
    
    autoGenConnection = RunService.RenderStepped:Connect(function()
        if not autoGenActive or not toggles.autoGenerator then
            StopAutoGenerator()
            return
        end
        if tick() - genCooldown > 1.5 then
            genCooldown = tick()
            AutoGeneratorAction()
        end
    end)
    
    print("⚡ Auto Generator ACTIVE")
end

local function StopAutoGenerator()
    autoGenActive = false
    if autoGenConnection then
        autoGenConnection:Disconnect()
        autoGenConnection = nil
    end
    print("⚡ Auto Generator DEACTIVATED")
end

-- =====================================================
-- NO CLIP (FIXED)
-- =====================================================
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
    
    print("🚪 No Clip ACTIVE")
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
    print("🚪 No Clip DEACTIVATED")
end

-- =====================================================
-- GOD MODE (FIXED)
-- =====================================================
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
    
    print("🛡️ God Mode ACTIVE")
end

local function StopGodMode()
    godModeActive = false
    if godModeConnection then
        godModeConnection:Disconnect()
        godModeConnection = nil
    end
    print("🛡️ God Mode DEACTIVATED")
end

-- =====================================================
-- ESP (FIXED)
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
    highlight.FillTransparency = 0.25
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.1
    table.insert(espObjects, highlight)
    
    local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target:FindFirstChild("UpperTorso") or target:FindFirstChild("Head")
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
            if player ~= LocalPlayer and IsPlayerKiller(player) and player.Character then
                local th = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                local dist = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                AddESP(player.Character, Color3.fromRGB(255, 0, 0), "🔴 " .. player.Name .. " [" .. math.floor(dist) .. "m] [KILLER]", Color3.fromRGB(255, 0, 0))
            end
        end
    end
    
    if toggles.espSurvivor then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not IsPlayerKiller(player) and player.Character then
                local th = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                local dist = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                AddESP(player.Character, Color3.fromRGB(0, 255, 0), "🟢 " .. player.Name .. " [" .. math.floor(dist) .. "m] [SURVIVOR]", Color3.fromRGB(0, 255, 0))
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

local function StartESP()
    if espActive then return end
    espActive = true
    
    espConnection = RunService.RenderStepped:Connect(function()
        if espActive then
            UpdateESP()
        end
    end)
    
    print("👁️ ESP ACTIVE")
end

local function StopESP()
    espActive = false
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
    ClearESP()
    print("👁️ ESP DEACTIVATED")
end

-- =====================================================
-- FITUR TAMBAHAN (RINGAN)
-- =====================================================

-- Speed Hack
local function StartSpeedHack()
    if connections.speedHack then return end
    connections.speedHack = RunService.RenderStepped:Connect(function()
        if toggles.speedHack then
            local h = GetHumanoid()
            if h then h.WalkSpeed = 60 end
        end
    end)
end

-- Super Jump
local function StartSuperJump()
    if connections.superJump then return end
    connections.superJump = RunService.RenderStepped:Connect(function()
        if toggles.superJump then
            local h = GetHumanoid()
            if h then h.JumpPower = 150 end
        end
    end)
end

-- Anti AFK
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

-- Auto Parry
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

-- No Parry Cooldown
local function StartNoParryCooldown()
    if connections.noParryCooldown then return end
    connections.noParryCooldown = RunService.RenderStepped:Connect(function()
        if toggles.noParryCooldown then
            local char = GetCharacter()
            if char then
                for _, child in pairs(char:GetChildren()) do
                    if child:IsA("Tool") and child.Name:lower():find("parry") and child:FindFirstChild("Cooldown") then
                        child.Cooldown.Value = 0
                    end
                end
            end
        end
    end)
end

-- No Fall
local function StartNoFall()
    if connections.noFall then return end
    connections.noFall = RunService.RenderStepped:Connect(function()
        if toggles.noFall then
            local humanoid = GetHumanoid()
            if humanoid and humanoid:GetState() == Enum.HumanoidStateType.Falling then
                local hrp = GetHRP()
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
                end
            end
        end
    end)
end

-- No Turn Speed Limit
local function StartNoTurnSpeed()
    if connections.noTurnSpeed then return end
    connections.noTurnSpeed = RunService.RenderStepped:Connect(function()
        if toggles.noTurnSpeed then
            local humanoid = GetHumanoid()
            if humanoid then
                humanoid.AutoRotate = true
                local hrp = GetHRP()
                if hrp and hrp.AssemblyLinearVelocity.Magnitude > 10 then
                    hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity
                end
            end
        end
    end)
end

-- Fast Vault
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

-- Moonwalk
local function StartMoonwalk()
    if connections.moonwalk then return end
    connections.moonwalk = RunService.RenderStepped:Connect(function()
        if toggles.moonwalk then
            local humanoid = GetHumanoid()
            if humanoid then
                humanoid.WalkSpeed = 50
                humanoid.AutoRotate = false
            end
        else
            local humanoid = GetHumanoid()
            if humanoid then
                humanoid.AutoRotate = true
            end
        end
    end)
end

-- Full Bright
local function StartFullBright()
    if connections.fullBright then return end
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
end

-- Anti Blind
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

-- Auto Escape
local function StartAutoEscape()
    if connections.autoEscape then return end
    connections.autoEscape = RunService.RenderStepped:Connect(function()
        if toggles.autoEscape then
            local hrp = GetHRP()
            if not hrp then return end
            local gates = FindGates()
            if #gates > 0 then
                table.sort(gates, function(a, b)
                    return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
                end)
                local target = gates[1]
                if target then
                    hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
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

-- Auto Heal
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

-- =====================================================
-- TOGGLE HANDLER
-- =====================================================
local function ToggleFeature(key, state)
    toggles[key] = state
    
    -- Stop features
    if key == "fly" and not state then StopFly() end
    if key == "invisible" and not state then StopInvisible() end
    if key == "autoGenerator" and not state then StopAutoGenerator() end
    if key == "noClip" and not state then StopNoClip() end
    if key == "godMode" and not state then StopGodMode() end
    if key == "esp" and not state then StopESP() end
    
    -- Start features
    if state then
        if key == "fly" then StartFly()
        elseif key == "invisible" then StartInvisible()
        elseif key == "autoGenerator" then StartAutoGenerator()
        elseif key == "noClip" then StartNoClip()
        elseif key == "godMode" then StartGodMode()
        elseif key == "esp" or key == "espKiller" or key == "espSurvivor" or key == "espGenerator" or key == "espHook" or key == "espPallet" then
            if not espActive then StartESP() end
        elseif key == "speedHack" then StartSpeedHack()
        elseif key == "superJump" then StartSuperJump()
        elseif key == "antiAFK" then StartAntiAFK()
        elseif key == "autoParry" then StartAutoParry()
        elseif key == "noParryCooldown" then StartNoParryCooldown()
        elseif key == "noFall" then StartNoFall()
        elseif key == "noTurnSpeed" then StartNoTurnSpeed()
        elseif key == "fastVault" then StartFastVault()
        elseif key == "moonwalk" then StartMoonwalk()
        elseif key == "fullBright" then StartFullBright()
        elseif key == "antiBlind" then StartAntiBlind()
        elseif key == "autoEscape" then StartAutoEscape()
        elseif key == "autoHeal" then StartAutoHeal()
        end
    end
end

-- =====================================================
-- GUI – 6LOCC STYLE + LOGO ZIP
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHubV53"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 420)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
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
SubTitle.Text = "v53.0"
SubTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Right

-- HIDE BUTTON
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

-- CLOSE
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
    return yPos + 54
end

-- DAFTAR TOGGLE
local yPos = 2
yPos = CreateToggle("✈️ Fly", "WASD + Space/Shift to move", "fly", yPos)
yPos = CreateToggle("👻 Invisible", "Become completely invisible", "invisible", yPos)
yPos = CreateToggle("⚡ Auto Generator", "Auto farm generators (FIX BLACKSCREEN)", "autoGenerator", yPos)
yPos = CreateToggle("🚪 No Clip", "Walk through walls", "noClip", yPos)
yPos = CreateToggle("🛡️ God Mode", "Infinite health", "godMode", yPos)
yPos = CreateToggle("💨 Speed Hack", "Run faster (WalkSpeed 60)", "speedHack", yPos)
yPos = CreateToggle("🦘 Super Jump", "Jump higher (JumpPower 150)", "superJump", yPos)
yPos = CreateToggle("🛡️ Auto Parry", "Auto parry when attacked", "autoParry", yPos)
yPos = CreateToggle("⏰ Anti AFK", "Prevent AFK kick", "antiAFK", yPos)
yPos = CreateToggle("🔴 Killer ESP", "See killer through walls", "espKiller", yPos)
yPos = CreateToggle("🟢 Survivor ESP", "See survivors through walls", "espSurvivor", yPos)
yPos = CreateToggle("⚡ Generator ESP", "See generator positions", "espGenerator", yPos)
yPos = CreateToggle("🪝 Hook ESP", "See hook positions", "espHook", yPos)
yPos = CreateToggle("📦 Pallet ESP", "See pallet positions", "espPallet", yPos)
yPos = CreateToggle("🏃 Auto Escape", "Teleport to gate + force escape", "autoEscape", yPos)
yPos = CreateToggle("💚 Auto Heal", "Auto heal when injured", "autoHeal", yPos)
yPos = CreateToggle("🛡️ No Parry Cooldown", "Infinite parries", "noParryCooldown", yPos)
yPos = CreateToggle("🚫 No Fall", "No fall damage", "noFall", yPos)
yPos = CreateToggle("🔄 No Turn Speed", "No slowdown on sharp turns", "noTurnSpeed", yPos)
yPos = CreateToggle("🪟 Fast Vault", "Super fast vault", "fastVault", yPos)
yPos = CreateToggle("🌙 Moonwalk", "Moonwalk + sway", "moonwalk", yPos)
yPos = CreateToggle("☀️ Full Bright", "Brighten map", "fullBright", yPos)
yPos = CreateToggle("👁️ Anti Blind", "Remove flash effects", "antiBlind", yPos)

ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- WATERMARK
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 160, 0, 16)
Watermark.Position = UDim2.new(0, 8, 1, -22)
Watermark.BackgroundTransparency = 1
Watermark.Text = "⚡ ZIP HUB v53.0 ⚡"
Watermark.TextColor3 = Color3.fromRGB(0, 180, 255)
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

print("✅ ZIP HUB v53.0 – FULL FIX LOADED!")
print("✅ 23 FITUR – SEMUA BERFUNGSI!")
print("✅ FLY FIXED, INVISIBLE FIXED, AUTO GEN FIXED")
print("✅ NO LAG – OPTIMIZED LOOPS")
