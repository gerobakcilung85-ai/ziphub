-- ========================================
-- ZIP HUB - FULL SCRIPT
-- VERSION 52.0 (DENGAN SURVIVOR MENU)
-- ========================================

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

-- ========================================
-- 🔥 KONFIGURASI HUB
-- ========================================
local HUB_NAME = "ZIP HUB"
local VERSION = "52.0"

-- ========================================
-- 🔥 WARNA ESP
-- ========================================
local ESP_COLORS = {
    KILLER = Color3.fromRGB(255, 0, 0),
    SURVIVOR = Color3.fromRGB(0, 255, 0),
    GENERATOR = Color3.fromRGB(0, 255, 255),
    GATE = Color3.fromRGB(255, 255, 0),
    PALLET = Color3.fromRGB(255, 165, 0)
}

-- ========================================
-- 🔥 VARIABEL
-- ========================================
local flyActive = false
local flyBody = nil
local flyPos = nil
local flyConn = nil
local flySpeed = 300
local silentAimActive = false
local silentAimConn = nil
local antiAFKConn = nil
local skillCheckConn = nil
local invisibleActive = false
local invisibleConn = nil
local fastVaultActive = false
local fastVaultConn = nil
local autoAttackActive = false
local autoAttackConn = nil
local autoFarmSurvivorActive = false
local autoFarmSurvivorConn = nil
local autoWinKillerActive = false
local autoWinKillerConn = nil
local espActive = false
local espConn = nil
local espTimer = 0
local espUpdateRate = 0.5
local autoKillAllActive = false
local autoKillAllConn = nil
local isKiller = false
local noParryCooldownActive = false
local noFallActive = false
local noTurnSpeedActive = false

local toggles = {
    autoParry = false,
    godMode = false,
    autoHeal = false,
    autoShoot = false,
    silentAim = false,
    autoStun = false,
    autoBlock = false,
    speedHack = false,
    fly = false,
    noClip = false,
    moonWalk = false,
    invisible = false,
    espPlayer = false,
    espKiller = false,
    espGenerator = false,
    espGate = false,
    espPallet = false,
    autoGenerator = false,
    teleportGen = false,
    autoEscape = false,
    antiAFK = false,
    autoSkillCheck = false,
    killerAlert = false,
    antiBlind = false,
    fullBright = false,
    aimbotWall = false,
    autoAttack = false,
    fastVault = false,
    autoFarmSurvivor = false,
    autoWinKiller = false,
    autoKillAll = false,
    noParryCooldown = false,
    noFall = false,
    noTurnSpeed = false
}

local connections = {}
local espObjects = {}

-- ========================================
-- 🔥 FUNGSI DETEKSI KILLER
-- ========================================
function IsPlayerKiller(player)
    if not player then return false end
    if player:GetAttribute("Role") == "Killer" then return true end
    if player:GetAttribute("Team") == "Killer" then return true end
    if player:GetAttribute("IsKiller") == true then return true end
    if player:GetAttribute("Killer") == true then return true end

    local character = player.Character
    if character then
        if character:GetAttribute("Role") == "Killer" then return true end
        if character:GetAttribute("Team") == "Killer" then return true end
        if character:GetAttribute("IsKiller") == true then return true end
        if character:GetAttribute("Killer") == true then return true end
    end

    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid and humanoid.MaxHealth > 100 then
            if humanoid.DisplayName:lower():find("killer") then return true end
            return true
        end
    end

    if character then
        for _, child in pairs(character:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("knife") or name:find("weapon") or name:find("scythe") or 
                   name:find("blade") or name:find("sword") or name:find("axe") or
                   name:find("hammer") or name:find("gun") or name:find("claw") then
                    return true
                end
            end
        end
    end

    if player.Parent then
        local parentName = player.Parent.Name:lower()
        if parentName:find("killer") or parentName:find("hunter") or parentName:find("bad") then
            return true
        end
    end

    return false
end

function DetectKillerRole()
    if LocalPlayer:GetAttribute("Role") == "Killer" then return true end
    if LocalPlayer:GetAttribute("Team") == "Killer" then return true end
    if LocalPlayer:GetAttribute("IsKiller") == true then return true end

    local char = LocalPlayer.Character
    if char then
        if char:GetAttribute("Role") == "Killer" then return true end
        if char:GetAttribute("Team") == "Killer" then return true end
        if char:GetAttribute("IsKiller") == true then return true end

        for _, child in pairs(char:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("knife") or name:find("weapon") or name:find("scythe") or 
                   name:find("blade") or name:find("sword") or name:find("axe") or
                   name:find("hammer") or name:find("gun") or name:find("claw") then
                    return true
                end
            end
        end

        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid and humanoid.MaxHealth > 100 then
            return true
        end
    end

    if LocalPlayer.Parent then
        local parentName = LocalPlayer.Parent.Name:lower()
        if parentName:find("killer") or parentName:find("hunter") or parentName:find("bad") then
            return true
        end
    end

    return false
end

function GetSurvivors()
    local survivors = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local isSurvivor = true
            
            if player:GetAttribute("Role") == "Killer" then isSurvivor = false end
            if player:GetAttribute("Team") == "Killer" then isSurvivor = false end
            if player:GetAttribute("IsKiller") == true then isSurvivor = false end
            
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.MaxHealth > 100 then
                isSurvivor = false
            end
            
            if isSurvivor then
                table.insert(survivors, player)
            end
        end
    end
    return survivors
end

function KillAllSurvivor()
    local survivors = GetSurvivors()
    local killed = 0
    
    for _, survivor in pairs(survivors) do
        pcall(function()
            local char = survivor.Character
            if not char then return end
            
            local humanoid = char:FindFirstChild("Humanoid")
            if not humanoid or humanoid.Health <= 0 then return end
            
            local killerHrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
            local survivorHrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
            
            if killerHrp and survivorHrp then
                local direction = (killerHrp.Position - survivorHrp.Position).Unit
                killerHrp.CFrame = CFrame.new(survivorHrp.Position + direction * 2)
                wait(0.05)
            end
            
            for i = 1, 5 do
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.05)
                end)
            end
            
            pcall(function()
                for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then
                        local name = obj.Name:lower()
                        if name:find("attack") or name:find("hit") or name:find("damage") or name:find("kill") then
                            pcall(function()
                                obj:FireServer(survivor)
                            end)
                        end
                    end
                end
            end)
            
            pcall(function()
                humanoid.Health = 0
            end)
            
            pcall(function()
                char:BreakJoints()
            end)
            
            killed = killed + 1
            print("🔪 " .. survivor.Name .. " telah dibunuh!")
            wait(0.1)
        end)
    end
    
    print("💀 " .. killed .. " survivor telah dibunuh!")
    return killed
end

function StartAutoKillAll()
    if autoKillAllConn then return end
    autoKillAllActive = true
    
    isKiller = DetectKillerRole()
    if not isKiller then
        print("❌ Kamu bukan Killer! Auto Kill All dinonaktifkan.")
        return
    end
    
    print("🔪 Auto Kill All AKTIF! (Killer terdeteksi)")
    
    autoKillAllConn = RunService.RenderStepped:Connect(function()
        if not autoKillAllActive then return end
        if not toggles.autoKillAll then return end
        if not LocalPlayer.Character then return end
        
        if not DetectKillerRole() then
            print("❌ Role berubah! Auto Kill All dinonaktifkan.")
            StopAutoKillAll()
            return
        end
        
        pcall(function()
            KillAllSurvivor()
        end)
        
        task.wait(0.5)
    end)
end

function StopAutoKillAll()
    autoKillAllActive = false
    if autoKillAllConn then
        autoKillAllConn:Disconnect()
        autoKillAllConn = nil
    end
    print("🔪 Auto Kill All DINONAKTIFKAN!")
end

-- ========================================
-- 🔥 FITUR SURVIVOR (DARI GAMBAR)
-- ========================================

-- No Parry Cooldown
function StartNoParryCooldown()
    if connections.noParryCooldown then return end
    connections.noParryCooldown = RunService.RenderStepped:Connect(function()
        if toggles.noParryCooldown and LocalPlayer.Character then
            -- Reset cooldown parry (jika ada sistem cooldown)
            pcall(function()
                local char = LocalPlayer.Character
                for _, child in pairs(char:GetChildren()) do
                    if child:IsA("Tool") and child.Name:lower():find("parry") then
                        if child:FindFirstChild("Cooldown") then
                            child.Cooldown.Value = 0
                        end
                    end
                end
            end)
        end
    end)
end

-- No Fall
function StartNoFall()
    if connections.noFall then return end
    connections.noFall = RunService.RenderStepped:Connect(function()
        if toggles.noFall and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                -- Reset fall velocity
                if humanoid:GetState() == Enum.HumanoidStateType.Falling then
                    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
                    end
                end
            end
        end
    end)
end

-- No Turn Speed Limit
function StartNoTurnSpeed()
    if connections.noTurnSpeed then return end
    connections.noTurnSpeed = RunService.RenderStepped:Connect(function()
        if toggles.noTurnSpeed and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.AutoRotate = true
                -- Prevent speed reduction from sharp turns
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local vel = hrp.AssemblyLinearVelocity
                    if vel.Magnitude > 10 then
                        hrp.AssemblyLinearVelocity = vel
                    end
                end
            end
        end
    end)
end

-- ========================================
-- 🔥 FIND GATE (UNIVERSAL)
-- ========================================
function FindGate()
    local gates = {}
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return gates end

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BasePart") then
            local hasClickDetector = obj:FindFirstChild("ClickDetector") ~= nil
            local size = obj.Size.Magnitude
            local pos = obj.Position
            local isLarge = size > 10
            local isAtEdge = math.abs(pos.X) > 40 or math.abs(pos.Z) > 40
            
            if hasClickDetector and isLarge and isAtEdge then
                table.insert(gates, obj)
            end
        end
    end

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Model") then
            local hasClickDetector = false
            local hasLargePart = false
            local isAtEdge = false
            
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part:FindFirstChild("ClickDetector") then
                        hasClickDetector = true
                    end
                    if part.Size.Magnitude > 10 then
                        hasLargePart = true
                    end
                    if math.abs(part.Position.X) > 40 or math.abs(part.Position.Z) > 40 then
                        isAtEdge = true
                    end
                end
            end
            
            if hasClickDetector and hasLargePart and isAtEdge then
                for _, part in pairs(obj:GetDescendants()) do
                    if part:IsA("BasePart") then
                        table.insert(gates, part)
                    end
                end
            end
        end
    end

    local unique = {}
    local seen = {}
    for _, gate in pairs(gates) do
        local key = tostring(gate.Position.X) .. tostring(gate.Position.Y) .. tostring(gate.Position.Z)
        if not seen[key] then
            seen[key] = true
            table.insert(unique, gate)
        end
    end

    print("🔍 Ditemukan " .. #unique .. " gate potensial!")
    return unique
end

-- ========================================
-- 🔥 FIND GENERATOR (UNIVERSAL)
-- ========================================
function FindGenerator()
    local gens = {}
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return gens end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local hasClickDetector = obj:FindFirstChild("ClickDetector") ~= nil
            local size = obj.Size.Magnitude
            local isMedium = size > 2 and size < 10
            
            if hasClickDetector and isMedium then
                table.insert(gens, obj)
            end
        end
    end

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") then
            local hasClickDetector = false
            local hasMediumPart = false
            
            for _, part in pairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part:FindFirstChild("ClickDetector") then
                        hasClickDetector = true
                    end
                    local size = part.Size.Magnitude
                    if size > 2 and size < 10 then
                        hasMediumPart = true
                    end
                end
            end
            
            if hasClickDetector and hasMediumPart then
                for _, part in pairs(obj:GetDescendants()) do
                    if part:IsA("BasePart") then
                        table.insert(gens, part)
                    end
                end
            end
        end
    end

    local unique = {}
    local seen = {}
    for _, gen in pairs(gens) do
        local key = tostring(gen.Position.X) .. tostring(gen.Position.Y) .. tostring(gen.Position.Z)
        if not seen[key] then
            seen[key] = true
            table.insert(unique, gen)
        end
    end

    print("🔍 Ditemukan " .. #unique .. " generator potensial!")
    return unique
end

-- ========================================
-- 🔥 FUNGSI DASAR
-- ========================================
function GetClosestPlayer()
    local closest, shortest = nil, math.huge
    local char = LocalPlayer.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
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

-- ========================================
-- 🔥 ESP
-- ========================================
function ClearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
end

function CreateESPWithName(target, color, outlineColor, labelText, labelColor)
    if not target then return end
    local highlight = Instance.new("Highlight")
    highlight.Parent = target
    highlight.FillColor = color
    highlight.FillTransparency = 0.4
    highlight.OutlineColor = outlineColor or Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.2
    table.insert(espObjects, highlight)

    local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target:FindFirstChild("Head")
    if hrp then
        local billboard = Instance.new("BillboardGui")
        billboard.Parent = hrp
        billboard.Size = UDim2.new(0, 200, 0, 40)
        billboard.Adornee = hrp
        billboard.AlwaysOnTop = true
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Parent = billboard
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = labelText or "Unknown"
        nameLabel.TextColor3 = labelColor or Color3.fromRGB(255, 255, 255)
        nameLabel.TextSize = 14
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        nameLabel.TextStrokeTransparency = 0.3

        table.insert(espObjects, billboard)
        table.insert(espObjects, nameLabel)
    end
end

function UpdateESPPlayer()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local isKiller = IsPlayerKiller(player)
            local color = isKiller and ESP_COLORS.KILLER or ESP_COLORS.SURVIVOR
            local outlineColor = isKiller and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(0, 255, 255)
            local labelColor = isKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
            local labelText = isKiller and ("🔪 " .. player.Name .. " [KILLER]") or ("🟢 " .. player.Name .. " [SURVIVOR]")
            CreateESPWithName(player.Character, color, outlineColor, labelText, labelColor)
        end
    end
end

function UpdateESPGenerator()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen") or obj.Name:lower():find("power")) then
            local parent = obj.Parent or obj
            local label = "⚡ Generator"
            if obj:GetAttribute("Completed") == true then label = "✅ Generator (Selesai)" end
            CreateESPWithName(parent, ESP_COLORS.GENERATOR, Color3.fromRGB(0, 255, 255), label, ESP_COLORS.GENERATOR)
        end
    end
end

function UpdateESPGate()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("gate") or obj.Name:lower():find("escape") or obj.Name:lower():find("exit") or obj.Name:lower():find("door")) then
            local parent = obj.Parent or obj
            local label = "🚪 Gate"
            if obj:GetAttribute("Open") == true then label = "🚪 Gate (Terbuka)" end
            CreateESPWithName(parent, ESP_COLORS.GATE, Color3.fromRGB(255, 255, 255), label, ESP_COLORS.GATE)
        end
    end
end

function UpdateESPPallet()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("pallet") or obj.Name:lower():find("box") or obj.Name:lower():find("plank") or obj.Name:lower():find("board")) then
            local parent = obj.Parent or obj
            local label = "📦 Pallet"
            if obj:GetAttribute("Broken") == true then label = "💔 Pallet (Rusak)" end
            CreateESPWithName(parent, ESP_COLORS.PALLET, Color3.fromRGB(255, 255, 255), label, ESP_COLORS.PALLET)
        end
    end
end

function UpdateESP()
    ClearESP()

    if toggles.espPlayer then
        UpdateESPPlayer()
    end

    if toggles.espGenerator then
        UpdateESPGenerator()
    end

    if toggles.espGate then
        UpdateESPGate()
    end

    if toggles.espPallet then
        UpdateESPPallet()
    end
end

function StartESP()
    if espConn then return end
    espActive = true
    espTimer = 0
    espConn = RunService.RenderStepped:Connect(function()
        if not espActive then return end
        espTimer = espTimer + 0.05
        if espTimer >= espUpdateRate then
            espTimer = 0
            UpdateESP()
        end
    end)
end

function StopESP()
    espActive = false
    if espConn then
        espConn:Disconnect()
        espConn = nil
    end
    ClearESP()
end

-- ========================================
-- 🔥 FLY (INFINITE YIELD STYLE)
-- ========================================
function StartFly()
    if flyActive then return end
    flyActive = true

    local char = LocalPlayer.Character
    if not char then flyActive = false; return end

    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not hrp then flyActive = false; return end

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.PlatformStand = true
        humanoid.Sit = false
    end

    flyBody = Instance.new("BodyVelocity")
    flyBody.MaxForce = Vector3.new(999999999, 999999999, 999999999)
    flyBody.Velocity = Vector3.new(0, 0, 0)
    flyBody.Parent = hrp

    flyPos = Instance.new("BodyPosition")
    flyPos.MaxForce = Vector3.new(999999999, 999999999, 999999999)
    flyPos.Position = hrp.Position
    flyPos.Parent = hrp

    local lastTime = tick()

    flyConn = RunService.RenderStepped:Connect(function()
        if not flyActive then
            if flyPos then flyPos:Destroy() end
            return
        end
        if not toggles.fly then
            if flyPos then flyPos:Destroy() end
            return
        end
        if not LocalPlayer.Character then return end

        local char = LocalPlayer.Character
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        if not hrp then return end

        if flyPos then
            flyPos.Position = hrp.Position
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

        if UserInputService:GetTouchEnabled() then
            local touches = UserInputService:GetTouches()
            for _, t in pairs(touches) do
                local pos = t.Position
                local screenSize = Camera.ViewportSize
                local centerX = screenSize.X / 2
                local centerY = screenSize.Y / 2

                if pos.X < centerX and pos.Y > centerY then
                    local dx = (pos.X - centerX) / centerX
                    local dy = (pos.Y - centerY) / centerY
                    dx = math.clamp(dx, -1, 1)
                    dy = math.clamp(dy, -1, 1)
                    if math.abs(dx) > 0.2 or math.abs(dy) > 0.2 then
                        moveDir = moveDir + flatForward * -dy + flatRight * dx
                    end
                end

                if pos.X > centerX and pos.Y > centerY then
                    local dy = (pos.Y - centerY) / centerY
                    dy = math.clamp(dy, -1, 1)
                    if dy < -0.3 then
                        moveDir = moveDir + Vector3.new(0, 1, 0)
                    elseif dy > 0.3 then
                        moveDir = moveDir + Vector3.new(0, -1, 0)
                    end
                end
            end
        end

        local currentTime = tick()
        local deltaTime = currentTime - lastTime
        lastTime = currentTime

        if moveDir.Magnitude > 0 then
            flyBody.Velocity = moveDir.Unit * flySpeed
        else
            flyBody.Velocity = Vector3.new(0, 0.5, 0)
        end
    end)
end

function StopFly()
    flyActive = false
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBody then flyBody:Destroy(); flyBody = nil end
    if flyPos then flyPos:Destroy(); flyPos = nil end
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
end

-- ========================================
-- 🔥 GOD MODE
-- ========================================
function StartGodMode()
    if connections.godMode then return end
    connections.godMode = RunService.RenderStepped:Connect(function()
        if toggles.godMode and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.Health = humanoid.MaxHealth
                humanoid.PlatformStand = false
                humanoid.Sit = false
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
                end
            end
        end
    end)
end

-- ========================================
-- 🔥 AUTO PARRY
-- ========================================
function StartAutoParry()
    if connections.autoParry then return end
    connections.autoParry = RunService.RenderStepped:Connect(function()
        if toggles.autoParry and LocalPlayer.Character then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end

-- ========================================
-- 🔥 AUTO GENERATOR (INSTANT)
-- ========================================
function AutoGenerator()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
    if not hrp then return end

    local gens = FindGenerator()
    
    if #gens > 0 then
        table.sort(gens, function(a, b)
            local distA = (hrp.Position - a.Position).Magnitude
            local distB = (hrp.Position - b.Position).Magnitude
            return distA < distB
        end)
        
        local targetGen = gens[1]
        if targetGen then
            local targetPos = targetGen.Position
            local dist = (hrp.Position - targetPos).Magnitude
            
            if dist > 5 then
                if toggles.teleportGen then
                    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
                    wait(0.3)
                end
            end
            
            for i = 1, 20 do
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.05)
                end)
            end
            
            pcall(function()
                for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                    if obj:IsA("RemoteEvent") then
                        local name = obj.Name:lower()
                        if name:find("generator") or name:find("gen") or name:find("power") or name:find("complete") or name:find("finish") or name:find("repair") then
                            pcall(function() obj:FireServer(targetGen) end)
                        end
                    end
                end
            end)
            
            pcall(function()
                targetGen:SetAttribute("Completed", true)
            end)
            
            pcall(function()
                local clickDetector = targetGen:FindFirstChild("ClickDetector")
                if clickDetector then clickDetector:Click() end
            end)
            
            print("⚡ Generator LANGSUNG SELESAI!")
        end
    else
        print("❌ Generator tidak ditemukan!")
    end
end

-- ========================================
-- 🔥 AUTO ESCAPE
-- ========================================
function AutoEscape()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        print("❌ Karakter tidak ditemukan!")
        return 
    end

    local gates = FindGate()
    
    if #gates > 0 then
        table.sort(gates, function(a, b)
            local distA = (hrp.Position - a.Position).Magnitude
            local distB = (hrp.Position - b.Position).Magnitude
            return distA < distB
        end)
        
        local maxTry = math.min(3, #gates)
        for i = 1, maxTry do
            local gate = gates[i]
            if gate then
                hrp.CFrame = CFrame.new(gate.Position + Vector3.new(0, 3, 0))
                wait(0.3)
                
                for j = 1, 30 do
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                        wait(0.05)
                    end)
                end
                
                pcall(function()
                    for _, obj in pairs(ReplicatedStorage:GetDescendants()) do
                        if obj:IsA("RemoteEvent") then
                            local name = obj.Name:lower()
                            if name:find("escape") or name:find("gate") or name:find("win") or name:find("finish") or name:find("complete") then
                                pcall(function() obj:FireServer() end)
                            end
                        end
                    end
                end)
                
                print("🚪 Auto Escape Berhasil!")
                return
            end
        end
        
        print("❌ Semua gate gagal diakses!")
    else
        print("❌ Gate tidak ditemukan! Mencoba teleport ke lokasi aman...")
        hrp.CFrame = CFrame.new(0, 50, 0)
    end
end

-- ========================================
-- 🔥 AUTO FARM SURVIVOR
-- ========================================
function StartAutoFarmSurvivor()
    if autoFarmSurvivorConn then return end
    autoFarmSurvivorActive = true
    autoFarmSurvivorConn = RunService.RenderStepped:Connect(function()
        if not toggles.autoFarmSurvivor then return end
        if not autoFarmSurvivorActive then return end
        if not LocalPlayer.Character then return end

        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
        if not hrp then return end

        local targetGen = nil
        local targetPos = nil
        local nearestDist = math.huge

        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen") or obj.Name:lower():find("power")) then
                if obj:GetAttribute("Completed") ~= true then
                    local dist = (hrp.Position - obj.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        targetGen = obj
                        targetPos = obj.Position
                    end
                end
            end
        end

        if targetGen and targetPos then
            if nearestDist > 10 then
                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
                wait(0.3)
            end

            for i = 1, 10 do
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.1)
                end)
            end

            if targetGen:GetAttribute("Completed") == true then
                wait(0.5)
            end
        else
            local randomDir = Vector3.new(math.random(-100, 100), 0, math.random(-100, 100))
            hrp.CFrame = CFrame.new(hrp.Position + randomDir)
        end
    end)
end

function StopAutoFarmSurvivor()
    autoFarmSurvivorActive = false
    if autoFarmSurvivorConn then autoFarmSurvivorConn:Disconnect(); autoFarmSurvivorConn = nil end
end

-- ========================================
-- 🔥 AUTO WIN KILLER
-- ========================================
function StartAutoWinKiller()
    if autoWinKillerConn then return end
    autoWinKillerActive = true
    autoWinKillerConn = RunService.RenderStepped:Connect(function()
        if not toggles.autoWinKiller then return end
        if not autoWinKillerActive then return end
        if not LocalPlayer.Character then return end

        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
        if not hrp then return end

        local target = nil
        local targetPos = nil
        local nearestDist = math.huge

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetHrp = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                if targetHrp then
                    local dist = (hrp.Position - targetHrp.Position).Magnitude
                    if dist < nearestDist then
                        nearestDist = dist
                        target = player
                        targetPos = targetHrp.Position
                    end
                end
            end
        end

        if target and targetPos then
            if nearestDist > 10 then
                hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
                wait(0.3)
            end
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                wait(0.2)
            end)
            local humanoid = target.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health <= 0 then
                for i = 1, 5 do
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                        wait(0.2)
                    end)
                end
                print("🔪 " .. target.Name .. " telah ditangkap!")
                wait(1)
            end
        else
            local randomDir = Vector3.new(math.random(-100, 100), 0, math.random(-100, 100))
            hrp.CFrame = CFrame.new(hrp.Position + randomDir)
        end
    end)
end

function StopAutoWinKiller()
    autoWinKillerActive = false
    if autoWinKillerConn then autoWinKillerConn:Disconnect(); autoWinKillerConn = nil end
end

-- ========================================
-- 🔥 FUNGSI LAINNYA
-- ========================================
function StartSilentAim()
    if silentAimConn then return end
    silentAimActive = true
    silentAimConn = RunService.RenderStepped:Connect(function()
        if not silentAimActive then return end
        if not toggles.silentAim then return end
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            local direction = (targetPos - Camera.CFrame.Position).Unit
            Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, Camera.CFrame.Position + direction * 100)
        end
    end)
end

function StopSilentAim()
    silentAimActive = false
    if silentAimConn then silentAimConn:Disconnect(); silentAimConn = nil end
end

function StartAntiAFK()
    if antiAFKConn then return end
    antiAFKConn = RunService.RenderStepped:Connect(function()
        if toggles.antiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            wait(60)
        end
    end)
end

function StopAntiAFK()
    if antiAFKConn then antiAFKConn:Disconnect(); antiAFKConn = nil end
end

function StartAutoSkillCheck()
    if skillCheckConn then return end
    skillCheckActive = true
    skillCheckConn = RunService.RenderStepped:Connect(function()
        if not toggles.autoSkillCheck then return end
        if not LocalPlayer.Character then return end
        local playerGui = LocalPlayer.PlayerGui
        if not playerGui then return end
        for _, guiObj in pairs(playerGui:GetDescendants()) do
            if guiObj:IsA("Frame") or guiObj:IsA("ImageLabel") then
                local name = guiObj.Name:lower()
                if name:find("skill") or name:find("check") or name:find("gen") or name:find("repair") then
                    for _, child in pairs(guiObj:GetDescendants()) do
                        if child:IsA("TextButton") or child:IsA("ImageButton") then
                            pcall(function()
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton2(Vector2.new())
                                wait(0.05)
                            end)
                        end
                    end
                end
            end
        end
    end)
end

function StopAutoSkillCheck()
    skillCheckActive = false
    if skillCheckConn then skillCheckConn:Disconnect(); skillCheckConn = nil end
end

function StartInvisible()
    if invisibleConn then return end
    invisibleActive = true
    invisibleConn = RunService.RenderStepped:Connect(function()
        if not toggles.invisible then return end
        if not LocalPlayer.Character then return end
        local char = LocalPlayer.Character
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
                part.CastShadow = false
            end
            if part:IsA("Accessory") then
                pcall(function()
                    part.Handle.Transparency = 1
                    part.Handle.CanCollide = false
                end)
            end
        end
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
            humanoid.NameDisplayDistance = 0
        end
    end)
end

function StopInvisible()
    invisibleActive = false
    if invisibleConn then invisibleConn:Disconnect(); invisibleConn = nil end
    if LocalPlayer.Character then
        local char = LocalPlayer.Character
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.CanCollide = true
                part.CastShadow = true
            end
            if part:IsA("Accessory") then
                pcall(function()
                    part.Handle.Transparency = 0
                    part.Handle.CanCollide = true
                end)
            end
        end
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
            humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn
            humanoid.NameDisplayDistance = 100
        end
    end
end

function DropAllPalette()
    local inventory = LocalPlayer:FindFirstChild("Inventory")
    if not inventory then
        local char = LocalPlayer.Character
        if char then
            for _, child in pairs(char:GetChildren()) do
                if child:IsA("Tool") and (child.Name:lower():find("palette") or child.Name:lower():find("plank") or child.Name:lower():find("board")) then
                    pcall(function()
                        child.Parent = Workspace
                    end)
                end
            end
        end
        return
    end
    for _, item in pairs(inventory:GetChildren()) do
        if item:IsA("Tool") then
            local name = item.Name:lower()
            if name:find("palette") or name:find("plank") or name:find("board") or name:find("wood") then
                pcall(function()
                    item.Parent = Workspace
                    wait(0.05)
                end)
            end
        end
    end
    print("📦 Semua Palette di-drop!")
end

function StartFullBright()
    connections.fullBright = RunService.RenderStepped:Connect(function()
        if toggles.fullBright then
            Lighting.Brightness = 10
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
            Lighting.GlobalShadows = false
        end
    end)
end

function StopFullBright()
    if connections.fullBright then
        connections.fullBright:Disconnect()
        connections.fullBright = nil
    end
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(127, 127, 127)
    Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
    Lighting.GlobalShadows = true
end

function StartAutoAttack()
    if autoAttackConn then return end
    autoAttackActive = true
    autoAttackConn = RunService.RenderStepped:Connect(function()
        if not toggles.autoAttack then return end
        if not autoAttackActive then return end
        local target = GetClosestPlayer()
        if target and target.Character then
            local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
            local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
            if hrp and targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 15 then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.2)
                end)
            end
        end
    end)
end

function StopAutoAttack()
    autoAttackActive = false
    if autoAttackConn then autoAttackConn:Disconnect(); autoAttackConn = nil end
end

function StartFastVault()
    if fastVaultConn then return end
    fastVaultActive = true
    fastVaultConn = RunService.RenderStepped:Connect(function()
        if not toggles.fastVault then return end
        if not fastVaultActive then return end
        local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
        if hrp then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("vault") or obj.Name:lower():find("pallet") or obj.Name:lower():find("barrier") or obj.Name:lower():find("window")) then
                    if (hrp.Position - obj.Position).Magnitude < 5 then
                        local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                        if h then
                            h.Jump = true
                            wait(0.05)
                            hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 8
                        end
                        break
                    end
                end
            end
        end
    end)
end

function StopFastVault()
    fastVaultActive = false
    if fastVaultConn then fastVaultConn:Disconnect(); fastVaultConn = nil end
end

function StartKillerAlert()
    connections.killerAlert = RunService.RenderStepped:Connect(function()
        if not toggles.killerAlert then return end
        if not LocalPlayer.Character then return end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
                local targetHrp = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                if hrp and targetHrp then
                    local dist = (hrp.Position - targetHrp.Position).Magnitude
                    if dist < 20 then
                        local alert = Instance.new("TextLabel")
                        alert.Parent = CoreGui
                        alert.Size = UDim2.new(0, 300, 0, 30)
                        alert.Position = UDim2.new(0.5, -150, 0.8, 0)
                        alert.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                        alert.BackgroundTransparency = 0.5
                        alert.Text = "⚠️ KILLER DEKAT! (" .. player.Name .. ")"
                        alert.TextColor3 = Color3.fromRGB(255, 255, 255)
                        alert.TextSize = 14
                        alert.Font = Enum.Font.GothamBold
                        alert.ZIndex = 999
                        TweenService:Create(alert, TweenInfo.new(2), {BackgroundTransparency = 1}):Play()
                        task.wait(2)
                        alert:Destroy()
                        break
                    end
                end
            end
        end
    end)
end

function StartAntiBlind()
    connections.antiBlind = RunService.RenderStepped:Connect(function()
        if not toggles.antiBlind then return end
        if not LocalPlayer.Character then return end
        local playerGui = LocalPlayer.PlayerGui
        if playerGui then
            for _, guiObj in pairs(playerGui:GetDescendants()) do
                if guiObj:IsA("Frame") or guiObj:IsA("ImageLabel") then
                    local name = guiObj.Name:lower()
                    if name:find("blind") or name:find("flash") or name:find("overlay") then
                        pcall(function()
                            guiObj.Visible = false
                        end)
                    end
                end
            end
        end
        pcall(function()
            Lighting.Bloom.Enabled = false
            Lighting.Bloom.Intensity = 0
        end)
    end)
end

function StartAimbotWall()
    connections.aimbotWall = RunService.RenderStepped:Connect(function()
        if not toggles.aimbotWall then return end
        local target = GetClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = target.Character.HumanoidRootPart.Position
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
        end
    end)
end

-- ========================================
-- 🔥 TOGGLE FEATURE (ALL)
-- ========================================
function ToggleFeature(key, state)
    toggles[key] = state

    if connections[key] then
        connections[key]:Disconnect()
        connections[key] = nil
    end

    if key == "fly" and not state then StopFly() end
    if key == "silentAim" and not state then StopSilentAim() end
    if key == "antiAFK" and not state then StopAntiAFK() end
    if key == "autoSkillCheck" and not state then StopAutoSkillCheck() end
    if key == "invisible" and not state then StopInvisible() end
    if key == "fullBright" and not state then StopFullBright() end
    if key == "autoAttack" and not state then StopAutoAttack() end
    if key == "fastVault" and not state then StopFastVault() end
    if key == "autoFarmSurvivor" and not state then StopAutoFarmSurvivor() end
    if key == "autoWinKiller" and not state then StopAutoWinKiller() end
    if key == "autoKillAll" and not state then StopAutoKillAll() end
    if key == "noParryCooldown" and not state then 
        if connections.noParryCooldown then
            connections.noParryCooldown:Disconnect()
            connections.noParryCooldown = nil
        end
    end
    if key == "noFall" and not state then
        if connections.noFall then
            connections.noFall:Disconnect()
            connections.noFall = nil
        end
    end
    if key == "noTurnSpeed" and not state then
        if connections.noTurnSpeed then
            connections.noTurnSpeed:Disconnect()
            connections.noTurnSpeed = nil
        end
    end

    if key == "espPlayer" or key == "espKiller" or key == "espGenerator" or key == "espGate" or key == "espPallet" then
        if not state then
            local anyESP = toggles.espPlayer or toggles.espKiller or toggles.espGenerator or toggles.espGate or toggles.espPallet
            if not anyESP then
                StopESP()
            else
                UpdateESP()
            end
        else
            if not espConn then
                StartESP()
            else
                UpdateESP()
            end
        end
    end

    if not state then return end

    if key == "autoParry" then
        StartAutoParry()
    elseif key == "godMode" then
        StartGodMode()
    elseif key == "autoHeal" then
        connections.autoHeal = RunService.RenderStepped:Connect(function()
            if toggles.autoHeal and LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h and h.Health < h.MaxHealth then
                    pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
                end
            end
        end)
    elseif key == "autoShoot" then
        connections.autoShoot = RunService.RenderStepped:Connect(function()
            if toggles.autoShoot and LocalPlayer.Character then
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local hrp = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                        if hrp then
                            local myHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
                            if myHrp then
                                local dist = (myHrp.Position - hrp.Position).Magnitude
                                if dist < 30 then
                                    pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
                                end
                            end
                        end
                    end
                end
            end
        end)
    elseif key == "silentAim" then
        StartSilentAim()
    elseif key == "autoStun" then
        connections.autoStun = RunService.RenderStepped:Connect(function()
            if toggles.autoStun then
                local target = GetClosestPlayer()
                if target and target.Character then
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                        wait(0.1)
                    end)
                end
            end
        end)
    elseif key == "autoBlock" then
        connections.autoBlock = RunService.RenderStepped:Connect(function()
            if toggles.autoBlock then
                local target = GetClosestPlayer()
                if target and target.Character then
                    local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
                    local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
                    if hrp and targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 15 then
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton2(Vector2.new())
                        end)
                    end
                end
            end
        end)
    elseif key == "speedHack" then
        connections.speedHack = RunService.RenderStepped:Connect(function()
            if toggles.speedHack and LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = 50 end
            end
        end)
    elseif key == "fly" then
        StartFly()
    elseif key == "noClip" then
        connections.noClip = RunService.RenderStepped:Connect(function()
            if toggles.noClip and LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    elseif key == "moonWalk" then
        connections.moonWalk = RunService.RenderStepped:Connect(function()
            if toggles.moonWalk and LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = 50; h.JumpPower = 0; h.AutoRotate = false end
            end
        end)
    elseif key == "invisible" then
        StartInvisible()
    elseif key == "autoGenerator" then
        connections.autoGenerator = RunService.RenderStepped:Connect(function()
            if toggles.autoGenerator then AutoGenerator() end
        end)
    elseif key == "autoEscape" then
        connections.autoEscape = RunService.RenderStepped:Connect(function()
            if toggles.autoEscape then AutoEscape() end
        end)
    elseif key == "antiAFK" then
        StartAntiAFK()
    elseif key == "autoSkillCheck" then
        StartAutoSkillCheck()
    elseif key == "killerAlert" then
        StartKillerAlert()
    elseif key == "antiBlind" then
        StartAntiBlind()
    elseif key == "fullBright" then
        StartFullBright()
    elseif key == "aimbotWall" then
        StartAimbotWall()
    elseif key == "autoAttack" then
        StartAutoAttack()
    elseif key == "fastVault" then
        StartFastVault()
    elseif key == "autoFarmSurvivor" then
        StartAutoFarmSurvivor()
    elseif key == "autoWinKiller" then
        StartAutoWinKiller()
    elseif key == "autoKillAll" then
        StartAutoKillAll()
    elseif key == "noParryCooldown" then
        StartNoParryCooldown()
    elseif key == "noFall" then
        StartNoFall()
    elseif key == "noTurnSpeed" then
        StartNoTurnSpeed()
    end
end

-- ========================================
-- 🎨 GUI (SURVIVOR MENU)
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipSurvivorMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- ========================================
-- MAIN FRAME (SURVIVOR THEME)
-- ========================================
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
MainFrame.Visible = true
MainFrame.ZIndex = 999

-- Corner
local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame
MainCorner.CornerRadius = UDim.new(0, 12)

-- Border
local MainBorder = Instance.new("UIStroke")
MainBorder.Parent = MainFrame
MainBorder.Color = Color3.fromRGB(0, 180, 255)
MainBorder.Thickness = 1.5
MainBorder.Transparency = 0.2

-- Glass Effect
local GlassBg = Instance.new("Frame")
GlassBg.Parent = MainFrame
GlassBg.Size = UDim2.new(1, 0, 1, 0)
GlassBg.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
GlassBg.BackgroundTransparency = 0.7
GlassBg.BorderSizePixel = 0

-- ========================================
-- HEADER (SURVIVOR THEME)
-- ========================================
local Header = Instance.new("Frame")
Header.Parent = MainFrame
Header.Size = UDim2.new(1, 0, 0, 50)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 12)

-- Title "SURVIVOR"
local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(1, 0, 1, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SURVIVOR"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 10

-- Subtitle "ZIP HUB"
local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = Header
SubTitle.Size = UDim2.new(1, 0, 0, 16)
SubTitle.Position = UDim2.new(0, 0, 1, -18)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "⚡ ZIP HUB ⚡"
SubTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextScaled = true
SubTitle.ZIndex = 10

-- ========================================
-- CLOSE BUTTON
-- ========================================
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0, 12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 11

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseBtn
CloseCorner.CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 0, 0)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(200, 30, 30)}):Play()
end)

-- ========================================
-- SCROLLING FRAME
-- ========================================
local ScrollingFrame = Instance.new("ScrollingFrame")
ScrollingFrame.Parent = MainFrame
ScrollingFrame.Size = UDim2.new(1, -12, 1, -65)
ScrollingFrame.Position = UDim2.new(0, 6, 0, 60)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ZIndex = 10

-- ========================================
-- UI FUNCTIONS (SURVIVOR STYLE)
-- ========================================

-- Toggle Button (Mirip gambar)
local function CreateSurvivorToggle(text, yPos, desc, key)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(0, 180, 255)
    frame.ZIndex = 10

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)

    -- Label (Fitur)
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
    label.ZIndex = 11

    -- Deskripsi (Mirip gambar)
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = frame
    descLabel.Size = UDim2.new(0.7, 0, 0, 16)
    descLabel.Position = UDim2.new(0, 10, 0, 24)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc or ""
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.GothamMedium
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 11

    -- Toggle Button
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
    toggleBtn.ZIndex = 12

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

    return toggleBtn
end

-- Action Button (Untuk Auto Escape)
local function CreateSurvivorButton(text, yPos, desc, callback)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(0, 180, 255)
    frame.ZIndex = 10

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)

    -- Label
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
    label.ZIndex = 11

    -- Deskripsi
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = frame
    descLabel.Size = UDim2.new(0.7, 0, 0, 16)
    descLabel.Position = UDim2.new(0, 10, 0, 24)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = desc or ""
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 200)
    descLabel.TextSize = 10
    descLabel.Font = Enum.Font.GothamMedium
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.ZIndex = 11

    -- Action Button
    local actionBtn = Instance.new("TextButton")
    actionBtn.Parent = frame
    actionBtn.Size = UDim2.new(0, 60, 0, 26)
    actionBtn.Position = UDim2.new(1, -70, 0, 12)
    actionBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    actionBtn.Text = "USE"
    actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    actionBtn.TextSize = 11
    actionBtn.Font = Enum.Font.GothamBold
    actionBtn.BorderSizePixel = 0
    actionBtn.ZIndex = 12

    local actionCorner = Instance.new("UICorner")
    actionCorner.Parent = actionBtn
    actionCorner.CornerRadius = UDim.new(0, 4)

    actionBtn.MouseButton1Click:Connect(callback)
    return actionBtn
}

-- ========================================
-- 📋 SURVIVOR MENU (MIRIP GAMBAR)
-- ========================================
local yPos = 2

-- No Parry Cooldown
CreateSurvivorToggle(
    "No Parry Cooldown",
    yPos,
    "Infinite parries (requires parry dagger).",
    "noParryCooldown"
)
yPos = yPos + 54

-- Auto Parry
CreateSurvivorToggle(
    "Auto Parry",
    yPos,
    "spams parrying when killer is close (nessy)",
    "autoParry"
)
yPos = yPos + 54

-- No Fall
CreateSurvivorToggle(
    "No Fall",
    yPos,
    "Gives you no fall penalty from high falls.",
    "noFall"
)
yPos = yPos + 54

-- No Turn Speed Limit
CreateSurvivorToggle(
    "No Turn Speed Limit",
    yPos,
    "Prevents you from being slowed down when making sharp turns while sprinting.",
    "noTurnSpeed"
)
yPos = yPos + 54

-- Auto Escape (Button)
CreateSurvivorButton(
    "Auto Escape",
    yPos,
    "Use this to autoform screws.",
    function()
        AutoEscape()
    end
)
yPos = yPos + 54

-- Update Canvas
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)

-- ========================================
-- 🔥 WATERMARK
-- ========================================
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 140, 0, 16)
Watermark.Position = UDim2.new(0, 8, 1, -22)
Watermark.BackgroundTransparency = 1
Watermark.Text = "⚡ ZIP HUB"
Watermark.TextColor3 = Color3.fromRGB(0, 180, 255)
Watermark.TextSize = 10
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextTransparency = 0.4
Watermark.ZIndex = 999

print("✅ ZIP HUB - FULL SCRIPT Loaded!")
print("✅ SURVIVOR MENU siap pakai!")
