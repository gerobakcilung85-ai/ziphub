-- ========================================
-- ZIP HUB - FULL (AUTO FARM KILLER + INSTANT KILL ALL!)
-- VERSION 48.0
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
-- 🔥 WARNA ESP
-- ========================================
local ESP_COLORS = {
    KILLER = Color3.fromRGB(255, 0, 0),      -- MERAH
    SURVIVOR = Color3.fromRGB(0, 255, 0),    -- HIJAU
    GENERATOR = Color3.fromRGB(0, 255, 255), -- CYAN
    GATE = Color3.fromRGB(255, 255, 0),      -- KUNING
    PALLET = Color3.fromRGB(255, 165, 0)     -- ORANGE
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
    autoKillAll = false  -- 🔥 BARU!
}

local connections = {}
local espObjects = {}

-- ========================================
-- 🔥 FUNGSI DETEKSI KILLER (PASTI MERAH!)
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

-- ========================================
-- 🔥 FUNGSI DETEKSI ROLE KILLER (UNTUK AUTO KILL ALL)
-- ========================================
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

-- ========================================
-- 🔥 GET ALL SURVIVOR (UNTUK AUTO KILL ALL)
-- ========================================
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

-- ========================================
-- 🔥 KILL ALL SURVIVOR (INSTANT!)
-- ========================================
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

-- ========================================
-- 🔥 AUTO KILL ALL (LOOP!)
-- ========================================
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
-- 🔥 ESP (PISAH PER JENIS!)
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
-- 🔥 FLY (INFINITE YIELD STYLE!)
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
-- 🔥 GOD MODE (BISA GEN SAAT DI-HIT!)
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
-- 🔥 AUTO GENERATOR (INSTANT - TANPA KLIK!)
-- ========================================
function AutoGenerator()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
    if not hrp then return end

    local targetGen = nil
    local targetPos = nil
    local nearestDist = math.huge

    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen") or obj.Name:lower():find("power")) then
            local dist = (hrp.Position - obj.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                targetGen = obj
                targetPos = obj.Position
            end
        end
    end

    if targetGen and targetPos then
        if nearestDist > 5 then
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
    else
        print("❌ Generator tidak ditemukan!")
    end
end

-- ========================================
-- 🔥 AUTO ESCAPE (15 METODE!)
-- ========================================
function AutoEscape()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local gates = {}
    local keywords = {"gate", "escape", "exit", "door", "win", "finish", "portal", "teleport", "out", "leave", "safe", "goal", "complete", "done", "victory"}

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            for _, kw in pairs(keywords) do
                if name:find(kw) then
                    table.insert(gates, obj)
                    break
                end
            end
        end
    end

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BasePart") then
            local color = obj.BrickColor
            if color == BrickColor.new("Bright green") or color == BrickColor.new("Bright yellow") or color == BrickColor.new("Lime green") then
                table.insert(gates, obj)
            end
        end
    end

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Size.Magnitude > 15 then
            table.insert(gates, obj)
        end
    end

    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("Model") then
            local name = obj.Name:lower()
            for _, kw in pairs(keywords) do
                if name:find(kw) then
                    for _, part in pairs(obj:GetDescendants()) do
                        if part:IsA("BasePart") then
                            table.insert(gates, part)
                            break
                        end
                    end
                    break
                end
            end
        end
    end

    if #gates > 0 then
        local nearest = nil
        local nearDist = math.huge
        for _, gate in pairs(gates) do
            local dist = (hrp.Position - gate.Position).Magnitude
            if dist < nearDist then
                nearDist = dist
                nearest = gate
            end
        end

        if nearest then
            hrp.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3, 0))
            wait(0.3)

            for i = 1, 30 do
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
        end
    else
        print("❌ Gate tidak ditemukan!")
        hrp.CFrame = CFrame.new(99999, 99999, 99999)
    end
end

-- ========================================
-- 🔥 AUTO FARM SURVIVOR (AUTO REPAIR GEN!)
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
    end
end

-- ========================================
-- 🎨 GUI
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHub"
ScreenGui.ResetOnSpawn = false

local Logo = Instance.new("TextButton")
Logo.Parent = ScreenGui
Logo.Size = UDim2.new(0, 55, 0, 55)
Logo.Position = UDim2.new(0, 10, 0, 10)
Logo.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Logo.BackgroundTransparency = 0
Logo.BorderSizePixel = 2
Logo.BorderColor3 = Color3.fromRGB(255, 255, 255)
Logo.Text = "ZH"
Logo.TextColor3 = Color3.fromRGB(255, 255, 255)
Logo.TextSize = 22
Logo.Font = Enum.Font.GothamBlack
Logo.TextScaled = true
Logo.Draggable = true
Logo.ZIndex = 999

local LogoCorner = Instance.new("UICorner")
LogoCorner.Parent = Logo
LogoCorner.CornerRadius = UDim.new(1, 0)

local LogoLabel = Instance.new("TextLabel")
LogoLabel.Parent = ScreenGui
LogoLabel.Size = UDim2.new(0, 60, 0, 14)
LogoLabel.Position = UDim2.new(0, 10, 0, 67)
LogoLabel.BackgroundTransparency = 1
LogoLabel.Text = "ZIP HUB"
LogoLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
LogoLabel.TextSize = 9
LogoLabel.Font = Enum.Font.GothamBold
LogoLabel.ZIndex = 999

local Menu = Instance.new("Frame")
Menu.Parent = ScreenGui
Menu.Size = UDim2.new(0, 400, 0, 650)
Menu.Position = UDim2.new(0.5, -200, 0.5, -325)
Menu.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
Menu.BackgroundTransparency = 0
Menu.BorderSizePixel = 2
Menu.BorderColor3 = Color3.fromRGB(255, 50, 50)
Menu.ClipsDescendants = true
Menu.Active = true
Menu.Draggable = true
Menu.Visible = false
Menu.ZIndex = 999

local MenuCorner = Instance.new("UICorner")
MenuCorner.Parent = Menu
MenuCorner.CornerRadius = UDim.new(0, 12)

local Header = Instance.new("Frame")
Header.Parent = Menu
Header.Size = UDim2.new(1, 0, 0, 35)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
Header.BackgroundTransparency = 0
Header.BorderSizePixel = 0
Header.ZIndex = 1000

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.Parent = Header
HeaderCorner.CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ZIP HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 1001

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.BackgroundTransparency = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.ZIndex = 1002

local CloseCorner = Instance.new("UICorner")
CloseCorner.Parent = CloseBtn
CloseCorner.CornerRadius = UDim.new(1, 0)

CloseBtn.MouseButton1Click:Connect(function()
    Menu.Visible = false
end)

local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Menu
Scroll.Size = UDim2.new(1, -12, 1, -45)
Scroll.Position = UDim2.new(0, 6, 0, 40)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
Scroll.BorderSizePixel = 0
Scroll.ZIndex = 999

local function Cat(text, y)
    local c = Instance.new("TextLabel")
    c.Parent = Scroll
    c.Size = UDim2.new(1, -10, 0, 22)
    c.Position = UDim2.new(0, 0, 0, y)
    c.BackgroundTransparency = 1
    c.Text = "▸ " .. text
    c.TextColor3 = Color3.fromRGB(255, 100, 100)
    c.TextSize = 12
    c.Font = Enum.Font.GothamBold
    c.TextXAlignment = Enum.TextXAlignment.Left
    c.ZIndex = 999
end

local function Div(y)
    local d = Instance.new("Frame")
    d.Parent = Scroll
    d.Size = UDim2.new(0.9, 0, 0, 1)
    d.Position = UDim2.new(0.05, 0, 0, y)
    d.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    d.BackgroundTransparency = 0.3
    d.BorderSizePixel = 0
    d.ZIndex = 999
end

local function Btn(text, y, cb, color)
    local b = Instance.new("TextButton")
    b.Parent = Scroll
    b.Size = UDim2.new(1, -10, 0, 26)
    b.Position = UDim2.new(0, 0, 0, y)
    b.BackgroundColor3 = color or Color3.fromRGB(60, 60, 90)
    b.BackgroundTransparency = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 11
    b.Font = Enum.Font.GothamMedium
    b.BorderSizePixel = 1
    b.BorderColor3 = Color3.fromRGB(255, 50, 50)
    b.ZIndex = 999
    local c = Instance.new("UICorner")
    c.Parent = b
    c.CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
end

local function Tog(text, y, key)
    local frame = Instance.new("Frame")
    frame.Parent = Scroll
    frame.Size = UDim2.new(1, -10, 0, 26)
    frame.Position = UDim2.new(0, 0, 0, y)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(255, 50, 50)
    frame.ZIndex = 999
    local c = Instance.new("UICorner")
    c.Parent = frame
    c.CornerRadius = UDim.new(0, 6)

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.55, 0, 1, 0)
    label.Position = UDim2.new(0, 6, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 10
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 999

    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.Size = UDim2.new(0, 42, 0, 20)
    btn.Position = UDim2.new(1, -48, 0, 3)
    btn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    btn.BackgroundTransparency = 0
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.ZIndex = 1000
    local tc = Instance.new("UICorner")
    tc.Parent = btn
    tc.CornerRadius = UDim.new(0, 4)

    btn.MouseButton1Click:Connect(function()
        local state = not toggles[key]
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        ToggleFeature(key, state)
    end)
end

-- ========================================
-- 📋 MENU
-- ========================================
local y = 2

Cat("⚔️ COMBAT", y); y = y + 24
Tog("🛡️ Parry", y, "autoParry"); y = y + 28
Tog("💀 God Mode", y, "godMode"); y = y + 28
Tog("💚 Heal", y, "autoHeal"); y = y + 28
Tog("🔫 Shoot", y, "autoShoot"); y = y + 28
Tog("🤫 Silent", y, "silentAim"); y = y + 28
Tog("⚡ Stun", y, "autoStun"); y = y + 28
Tog("🛡️ Block", y, "autoBlock"); y = y + 28
Tog("🔥 Auto Attack", y, "autoAttack"); y = y + 28
Btn("💀 Kill All (Manual)", y, function()
    if DetectKillerRole() then
        KillAllSurvivor()
    else
        print("❌ Kamu bukan Killer!")
    end
end, Color3.fromRGB(150, 0, 0))
y = y + 28
Div(y); y = y + 8

Cat("🔪 KILLER", y); y = y + 24
Tog("🔪 Auto Kill All (Killer Only)", y, "autoKillAll"); y = y + 28
Div(y); y = y + 8

Cat("⚡ SKILL CHECK", y); y = y + 24
Tog("✅ Auto Skill Check", y, "autoSkillCheck"); y = y + 28
Div(y); y = y + 8

Cat("👁️ ESP", y); y = y + 24
Tog("🔴 Player (KILLER MERAH!)", y, "espPlayer"); y = y + 28
Tog("🟢 Generator", y, "espGenerator"); y = y + 28
Tog("🟡 Gate", y, "espGate"); y = y + 28
Tog("🟠 Pallet", y, "espPallet"); y = y + 28
Div(y); y = y + 8

Cat("⚡ GENERATOR", y); y = y + 24
Tog("🔄 Auto Gen (Instant)", y, "autoGenerator"); y = y + 28
Tog("🚀 Tele Gen", y, "teleportGen"); y = y + 28
Btn("📦 Drop Pallet", y, function() DropAllPalette() end, Color3.fromRGB(120, 60, 0))
y = y + 28
Div(y); y = y + 8

Cat("🚪 ESCAPE", y); y = y + 24
Tog("🚪 Auto Escape", y, "autoEscape"); y = y + 28
Div(y); y = y + 8

Cat("🌾 AUTO FARM", y); y = y + 24
Tog("🌾 Auto Farm Survivor", y, "autoFarmSurvivor"); y = y + 28
Tog("🔪 Auto Win Killer", y, "autoWinKiller"); y = y + 28
Div(y); y = y + 8

Cat("🏃 MOVEMENT", y); y = y + 24
Tog("⚡ Speed", y, "speedHack"); y = y + 28
Tog("🕊️ Terbang Bebas", y, "fly"); y = y + 28
Tog("🧱 NoClip", y, "noClip"); y = y + 28
Tog("🌙 Moon", y, "moonWalk"); y = y + 28
Tog("⚡ Fast Vault", y, "fastVault"); y = y + 28
Div(y); y = y + 8

Cat("👻 STEALTH", y); y = y + 24
Tog("👻 Invisible", y, "invisible"); y = y + 28
Div(y); y = y + 8

Cat("🔧 UTILITY", y); y = y + 24
Tog("🚫 Anti AFK", y, "antiAFK"); y = y + 28
Tog("⚠️ Killer Alert", y, "killerAlert"); y = y + 28
Tog("🛡️ Anti Blind", y, "antiBlind"); y = y + 28
Tog("💡 FullBright", y, "fullBright"); y = y + 28
Tog("🎯 Aimbot Wall", y, "aimbotWall"); y = y + 28
Btn("🔄 Reset", y, function()
    for k, _ in pairs(toggles) do
        toggles[k] = false
        if connections[k] then connections[k]:Disconnect(); connections[k] = nil end
    end
    StopFly(); StopSilentAim(); StopAntiAFK(); StopAutoSkillCheck(); StopInvisible(); StopFullBright(); StopAutoAttack(); StopFastVault(); StopAutoFarmSurvivor(); StopAutoWinKiller(); StopESP(); StopAutoKillAll()
    if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end
end, Color3.fromRGB(100, 0, 0))
y = y + 28

Scroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)

-- ========================================
-- LOGO KLIK
-- ========================================
Logo.MouseButton1Click:Connect(function()
    Menu.Visible = not Menu.Visible
end)

print("✅ ZIP HUB - FULL (AUTO FARM KILLER + INSTANT KILL ALL!) Loaded!")
print("✅ ESP KILLER PASTI MERAH!")
print("✅ Auto Kill All (Killer Only)!")
print("✅ Kill All Survivor (Manual)!")
print("✅ Fly INFINITE YIELD STYLE!")
print("✅ Klik LOGO ZH untuk buka menu!")
