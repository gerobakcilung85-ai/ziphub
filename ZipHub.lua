-- ========================================
-- ZIP HUB + LYNX (35+ FITUR!)
-- VERSION 35.0 (FINAL - GABUNGAN ALL FIX)
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

-- ========================================
-- 🔥 VARIABEL
-- ========================================
local flyActive = false
local flyBody = nil
local flyConn = nil
local flySpeed = 300
local silentAimActive = false
local silentAimConn = nil
local antiAFKConn = nil
local autoSaveConn = nil
local autoSaveActive = false
local savedFriends = {}

local toggles = {
    autoParry = false,
    godMode = false,
    autoHeal = false,
    autoShoot = false,
    silentAim = false,
    autoStun = false,
    autoBlock = false,
    autoDodge = false,
    autoVault = false,
    autoFlashlight = false,
    autoPerk = false,
    autoRepair = false,
    autoSabotage = false,
    autoHide = false,
    autoRun = false,
    autoCrouchWalk = false,
    autoSlowWalk = false,
    autoSpin = false,
    autoKillAura = false,
    autoGrabLoot = false,
    autoRespawn = false,
    autoUseItem = false,
    autoSave = false,
    speedHack = false,
    fly = false,
    noClip = false,
    moonWalk = false,
    invisible = false,
    autoGrab = false,
    autoDrop = false,
    autoPickup = false,
    autoUse = false,
    autoSprint = false,
    autoCrouch = false,
    autoJump = false,
    espPlayer = false,
    espKiller = false,
    espGenerator = false,
    espGate = false,
    espPallet = false,
    autoGenerator = false,
    teleportGen = false,
    autoEscape = false,
    antiAFK = false
}

local connections = {}
local espObjects = {}

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

function KillAll()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local h = p.Character:FindFirstChild("Humanoid")
            if h then
                h.Health = 0
                pcall(function() p.Character:BreakJoints() end)
            end
        end
    end
end

-- ========================================
-- 🔥 FLY (MOBILE + PC SUPPORT!)
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
    
    flyConn = RunService.RenderStepped:Connect(function()
        if not flyActive or not flyBody then return end
        if not LocalPlayer.Character then return end
        
        local char = LocalPlayer.Character
        local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
        if not hrp then return end
        
        local cam = Camera.CFrame
        local forward = cam.LookVector
        local right = cam.RightVector
        
        local flatForward = Vector3.new(forward.X, 0, forward.Z).Unit
        local flatRight = Vector3.new(right.X, 0, right.Z).Unit
        
        local moveDir = Vector3.new()
        
        -- PC CONTROL
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + flatForward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - flatForward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - flatRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + flatRight
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir + Vector3.new(0, -1, 0)
        end
        
        -- MOBILE CONTROL
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
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then humanoid.PlatformStand = false end
    end
end

-- ========================================
-- 🔥 SILENT AIM
-- ========================================
function StartSilentAim()
    if silentAimConn then return end
    silentAimActive = true
    silentAimConn = RunService.RenderStepped:Connect(function()
        if not silentAimActive then return end
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

-- ========================================
-- 🔥 ANTI AFK
-- ========================================
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

-- ========================================
-- 🔥 ESP
-- ========================================
function CreateESP(target, color, outlineColor)
    if not target then return end
    local highlight = Instance.new("Highlight")
    highlight.Parent = target
    highlight.FillColor = color
    highlight.FillTransparency = 0.5
    highlight.OutlineColor = outlineColor or Color3.fromRGB(255, 255, 255)
    highlight.OutlineTransparency = 0.2
    table.insert(espObjects, highlight)
end

function ClearESP()
    for _, obj in pairs(espObjects) do
        pcall(function() obj:Destroy() end)
    end
    espObjects = {}
end

function ESPPlayer(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreateESP(player.Character, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255))
            end
        end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                wait(0.5)
                if toggles.espPlayer and player ~= LocalPlayer then
                    CreateESP(player.Character, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255))
                end
            end)
        end)
    else
        ClearESP()
    end
end

function ESPKiller(state)
    if state then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                CreateESP(player.Character, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 0))
            end
        end
    else
        ClearESP()
    end
end

function ESPGenerator(state)
    if state then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("generator") or obj.Name:lower():find("gen")) then
                CreateESP(obj.Parent or obj, Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 255, 255))
            end
        end
    else
        ClearESP()
    end
end

function ESPGate(state)
    if state then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("gate") or obj.Name:lower():find("escape") or obj.Name:lower():find("door")) then
                CreateESP(obj.Parent or obj, Color3.fromRGB(255, 255, 0), Color3.fromRGB(255, 255, 255))
            end
        end
    else
        ClearESP()
    end
end

function ESPPallet(state)
    if state then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("pallet") or obj.Name:lower():find("box") or obj.Name:lower():find("crate")) then
                CreateESP(obj.Parent or obj, Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 255, 255))
            end
        end
    else
        ClearESP()
    end
end

-- ========================================
-- 🔥 AUTO GENERATOR (FIX - LANGSUNG JADI!)
-- ========================================
function AutoGenerator()
    if not LocalPlayer.Character then return end
    local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
    if not hrp then return end
    
    local targetGen = nil
    local targetPos = nil
    local nearestDist = math.huge
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (
            obj.Name:lower():find("generator") or 
            obj.Name:lower():find("gen") or
            obj.Name:lower():find("power") or
            obj.Name:lower():find("engine")
        ) then
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
        
        for i = 1, 10 do
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
                    if name:find("generator") or name:find("gen") or name:find("power") or name:find("complete") or name:find("finish") then
                        pcall(function() obj:FireServer(targetGen) end)
                    end
                end
            end
        end)
        
        pcall(function()
            local clickDetector = targetGen:FindFirstChild("ClickDetector")
            if clickDetector then clickDetector:Click() end
        end)
    end
end

-- ========================================
-- 🔥 AUTO ESCAPE
-- ========================================
function AutoEscape()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name:lower():find("gate") or obj.Name:lower():find("escape") or obj.Name:lower():find("door")) then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2, 0))
                wait(0.5)
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end)
                return
            end
        end
    end
end

-- ========================================
-- 🔥 10 FITUR VD NEW
-- ========================================
function StartAutoVault()
    connections.autoVault = RunService.RenderStepped:Connect(function()
        if not toggles.autoVault then return end
        local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
        if hrp then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("vault") or obj.Name:lower():find("pallet") or obj.Name:lower():find("barrier")) then
                    if (hrp.Position - obj.Position).Magnitude < 8 then
                        local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                        if h then
                            h.Jump = true
                            wait(0.1)
                            hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 5
                        end
                        break
                    end
                end
            end
        end
    end)
end

function StartAutoFlashlight()
    connections.autoFlashlight = RunService.RenderStepped:Connect(function()
        if not toggles.autoFlashlight then return end
        local light = Lighting:FindFirstChild("Flashlight") or LocalPlayer.Character:FindFirstChild("Flashlight")
        if light then
            if Lighting.Brightness < 1 then
                light.Enabled = true
            else
                light.Enabled = false
            end
        end
    end)
end

function StartAutoPerk()
    connections.autoPerk = RunService.RenderStepped:Connect(function()
        if not toggles.autoPerk then return end
        local perks = LocalPlayer:FindFirstChild("Perks")
        if perks then
            for _, perk in pairs(perks:GetChildren()) do
                if perk:IsA("Tool") and perk:FindFirstChild("Activate") then
                    pcall(function()
                        perk.Activate:FireServer()
                        wait(0.5)
                    end)
                    break
                end
            end
        end
    end)
end

function StartAutoRepair()
    connections.autoRepair = RunService.RenderStepped:Connect(function()
        if not toggles.autoRepair then return end
        local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
        if hrp then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("repair") or obj.Name:lower():find("fix") or obj.Name:lower():find("broken")) then
                    if (hrp.Position - obj.Position).Magnitude < 10 then
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton2(Vector2.new())
                            wait(0.3)
                        end)
                        break
                    end
                end
            end
        end
    end)
end

function StartAutoSabotage()
    connections.autoSabotage = RunService.RenderStepped:Connect(function()
        if not toggles.autoSabotage then return end
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

function StartAutoHide()
    connections.autoHide = RunService.RenderStepped:Connect(function()
        if not toggles.autoHide then return end
        local target = GetClosestPlayer()
        if target and target.Character then
            local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
            local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
            if hrp and targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 20 then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("locker") or obj.Name:lower():find("closet") or obj.Name:lower():find("cabinet")) then
                        if (hrp.Position - obj.Position).Magnitude < 10 then
                            pcall(function()
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton2(Vector2.new())
                                wait(0.5)
                            end)
                            break
                        end
                    end
                end
            end
        end
    end)
end

function StartAutoRun()
    connections.autoRun = RunService.RenderStepped:Connect(function()
        if not toggles.autoRun then return end
        local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
        if h then
            h.WalkSpeed = 50
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

function StartAutoCrouchWalk()
    connections.autoCrouchWalk = RunService.RenderStepped:Connect(function()
        if not toggles.autoCrouchWalk then return end
        local target = GetClosestPlayer()
        if target and target.Character then
            local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
            local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
            if hrp and targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 25 then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then
                    h.WalkSpeed = 10
                    h.Sit = true
                    wait(0.1)
                    h.Sit = false
                end
            end
        end
    end)
end

function StartAutoSlowWalk()
    connections.autoSlowWalk = RunService.RenderStepped:Connect(function()
        if not toggles.autoSlowWalk then return end
        local target = GetClosestPlayer()
        if target and target.Character then
            local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
            local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
            if hrp and targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 15 then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = 5 end
            else
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = 16 end
            end
        end
    end)
end

function StartAutoSpin()
    connections.autoSpin = RunService.RenderStepped:Connect(function()
        if not toggles.autoSpin then return end
        local target = GetClosestPlayer()
        if target and target.Character then
            local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
            local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
            if hrp and targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 10 then
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
            end
        end
    end)
end

-- ========================================
-- 🔥 5 FITUR ULTIMATE
-- ========================================
function StartAutoKillAura()
    connections.autoKillAura = RunService.RenderStepped:Connect(function()
        if not toggles.autoKillAura then return end
        local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
        if not hrp then return end
        
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetHrp = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                if targetHrp then
                    local dist = (hrp.Position - targetHrp.Position).Magnitude
                    if dist < 20 then
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton2(Vector2.new())
                            wait(0.1)
                        end)
                        pcall(function()
                            local humanoid = player.Character:FindFirstChild("Humanoid")
                            if humanoid and humanoid.Health > 0 then
                                humanoid.Health = 0
                            end
                        end)
                    end
                end
            end
        end
    end)
end

function StartAutoGrabLoot()
    connections.autoGrabLoot = RunService.RenderStepped:Connect(function()
        if not toggles.autoGrabLoot then return end
        local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
        if not hrp then return end
        
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (
                obj.Name:lower():find("loot") or 
                obj.Name:lower():find("item") or 
                obj.Name:lower():find("chest") or 
                obj.Name:lower():find("box") or
                obj.Name:lower():find("crate") or
                obj.Name:lower():find("drop")
            ) then
                local dist = (hrp.Position - obj.Position).Magnitude
                if dist < 15 then
                    pcall(function()
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                        wait(0.1)
                    end)
                end
            end
        end
    end)
end

function TeleportToPlayer()
    local target = GetClosestPlayer()
    if target and target.Character then
        local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
        local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
        if hrp and targetHrp then
            hrp.CFrame = targetHrp.CFrame + Vector3.new(0, 2, 0)
        end
    end
end

function StartAutoRespawn()
    connections.autoRespawn = RunService.RenderStepped:Connect(function()
        if not toggles.autoRespawn then return end
        if not LocalPlayer.Character or LocalPlayer.Character:FindFirstChild("Humanoid") == nil then
            pcall(function()
                local respawnBtn = CoreGui:FindFirstChild("RespawnButton") or CoreGui:FindFirstChild("DeathScreen")
                if respawnBtn then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.5)
                else
                    local remote = ReplicatedStorage:FindFirstChild("Respawn") or ReplicatedStorage:FindFirstChild("RespawnPlayer")
                    if remote then
                        pcall(function() remote:FireServer() end)
                    end
                end
            end)
        end
    end)
end

function StartAutoUseItem()
    connections.autoUseItem = RunService.RenderStepped:Connect(function()
        if not toggles.autoUseItem then return end
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        local health = humanoid.Health
        local maxHealth = humanoid.MaxHealth
        local stamina = humanoid:GetAttribute("Stamina") or 100
        
        if health / maxHealth < 0.5 then
            local inv = LocalPlayer:FindFirstChild("Inventory")
            if inv then
                for _, item in pairs(inv:GetChildren()) do
                    if item:IsA("Tool") and (
                        item.Name:lower():find("health") or 
                        item.Name:lower():find("med") or 
                        item.Name:lower():find("heal") or
                        item.Name:lower():find("bandage")
                    ) then
                        pcall(function()
                            if item:FindFirstChild("Use") then
                                item.Use:FireServer()
                            else
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton2(Vector2.new())
                            end
                            wait(0.5)
                        end)
                        break
                    end
                end
            end
        end
        
        if stamina < 30 then
            local inv = LocalPlayer:FindFirstChild("Inventory")
            if inv then
                for _, item in pairs(inv:GetChildren()) do
                    if item:IsA("Tool") and (
                        item.Name:lower():find("stamina") or 
                        item.Name:lower():find("energy") or 
                        item.Name:lower():find("drink")
                    ) then
                        pcall(function()
                            if item:FindFirstChild("Use") then
                                item.Use:FireServer()
                            else
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton2(Vector2.new())
                            end
                            wait(0.5)
                        end)
                        break
                    end
                end
            end
        end
    end)
end

-- ========================================
-- 🔥 AUTO SAVE TEMEN
-- ========================================
function GetKnockedFriends()
    local knockedList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                if humanoid.Health <= 0 or humanoid:GetAttribute("Knocked") == true then
                    local hrp = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
                    if hrp then
                        table.insert(knockedList, {
                            player = player,
                            position = hrp.Position,
                            distance = (LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")) and 
                                (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")).Position - hrp.Position).Magnitude or math.huge
                        })
                    end
                end
            end
        end
    end
    table.sort(knockedList, function(a, b) return a.distance < b.distance end)
    return knockedList
end

function StartAutoSave()
    if autoSaveConn then return end
    autoSaveActive = true
    autoSaveConn = RunService.RenderStepped:Connect(function()
        if not autoSaveActive or not LocalPlayer.Character then return end
        local knockedFriends = GetKnockedFriends()
        if #knockedFriends > 0 then
            local target = knockedFriends[1]
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
            if hrp and target.position then
                if target.distance > 15 then
                    hrp.CFrame = CFrame.new(target.position + Vector3.new(0, 2, 2))
                    wait(0.2)
                end
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.2)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.2)
                    local remote = ReplicatedStorage:FindFirstChild("SavePlayer") or 
                                   ReplicatedStorage:FindFirstChild("RescuePlayer") or
                                   ReplicatedStorage:FindFirstChild("HelpPlayer")
                    if remote then
                        pcall(function() remote:FireServer(target.player) end)
                    end
                end)
                savedFriends[target.player.Name] = true
            end
        end
    end)
end

function StopAutoSave()
    autoSaveActive = false
    if autoSaveConn then autoSaveConn:Disconnect(); autoSaveConn = nil end
    savedFriends = {}
end

function ManualSaveNearest()
    local knockedFriends = GetKnockedFriends()
    if #knockedFriends > 0 then
        local target = knockedFriends[1]
        local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
        if hrp and target.position then
            hrp.CFrame = CFrame.new(target.position + Vector3.new(0, 2, 2))
            wait(0.3)
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
                wait(0.2)
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end
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
    
    if not state then
        if key == "fly" then StopFly() end
        if key == "silentAim" then StopSilentAim() end
        if key == "antiAFK" then StopAntiAFK() end
        if key == "autoSave" then StopAutoSave() end
        return
    end
    
    -- COMBAT
    if key == "autoParry" then
        connections.autoParry = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
            end
        end)
    elseif key == "godMode" then
        connections.godMode = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.Health = h.MaxHealth end
            end
        end)
    elseif key == "autoHeal" then
        connections.autoHeal = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h and h.Health < h.MaxHealth then
                    pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
                end
            end
        end)
    elseif key == "autoShoot" then
        connections.autoShoot = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
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
            if not toggles.autoStun then return end
            local target = GetClosestPlayer()
            if target and target.Character then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    wait(0.1)
                end)
            end
        end)
    elseif key == "autoBlock" then
        connections.autoBlock = RunService.RenderStepped:Connect(function()
            if not toggles.autoBlock then return end
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
        end)
    elseif key == "autoDodge" then
        connections.autoDodge = RunService.RenderStepped:Connect(function()
            if not toggles.autoDodge then return end
            local target = GetClosestPlayer()
            if target and target.Character then
                local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
                local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
                if hrp and targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 10 then
                    local dir = (hrp.Position - targetHrp.Position).Unit
                    hrp.CFrame = hrp.CFrame + Vector3.new(-dir.Z, 0, dir.X) * 10
                    wait(0.1)
                end
            end
        end)
    -- VD NEW
    elseif key == "autoVault" then
        StartAutoVault()
    elseif key == "autoFlashlight" then
        StartAutoFlashlight()
    elseif key == "autoPerk" then
        StartAutoPerk()
    elseif key == "autoRepair" then
        StartAutoRepair()
    elseif key == "autoSabotage" then
        StartAutoSabotage()
    elseif key == "autoHide" then
        StartAutoHide()
    elseif key == "autoRun" then
        StartAutoRun()
    elseif key == "autoCrouchWalk" then
        StartAutoCrouchWalk()
    elseif key == "autoSlowWalk" then
        StartAutoSlowWalk()
    elseif key == "autoSpin" then
        StartAutoSpin()
    -- ULTIMATE
    elseif key == "autoKillAura" then
        StartAutoKillAura()
    elseif key == "autoGrabLoot" then
        StartAutoGrabLoot()
    elseif key == "autoRespawn" then
        StartAutoRespawn()
    elseif key == "autoUseItem" then
        StartAutoUseItem()
    -- SAVE
    elseif key == "autoSave" then
        StartAutoSave()
    -- MOVEMENT
    elseif key == "speedHack" then
        connections.speedHack = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = 50 end
            end
        end)
    elseif key == "fly" then
        StartFly()
    elseif key == "noClip" then
        connections.noClip = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end)
    elseif key == "moonWalk" then
        connections.moonWalk = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then h.WalkSpeed = 50; h.JumpPower = 0; h.AutoRotate = false end
            end
        end)
    -- STEALTH
    elseif key == "invisible" then
        connections.invisible = RunService.RenderStepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                        part.CanCollide = false
                        part.CastShadow = false
                    end
                end
                local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                if h then
                    h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    h.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                end
            end
        end)
    -- ESP
    elseif key == "espPlayer" then
        ESPPlayer(state)
    elseif key == "espKiller" then
        ESPKiller(state)
    elseif key == "espGenerator" then
        ESPGenerator(state)
    elseif key == "espGate" then
        ESPGate(state)
    elseif key == "espPallet" then
        ESPPallet(state)
    -- GENERATOR
    elseif key == "autoGenerator" then
        connections.autoGenerator = RunService.RenderStepped:Connect(function()
            if toggles.autoGenerator then AutoGenerator() end
        end)
    elseif key == "autoEscape" then
        connections.autoEscape = RunService.RenderStepped:Connect(function()
            if toggles.autoEscape then AutoEscape() end
        end)
    -- LYNX
    elseif key == "autoGrab" then
        connections.autoGrab = RunService.RenderStepped:Connect(function()
            if not toggles.autoGrab then return end
            local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
            if hrp then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("item") or obj.Name:lower():find("loot") or obj.Name:lower():find("body")) then
                        if (hrp.Position - obj.Position).Magnitude < 10 then
                            pcall(function()
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton2(Vector2.new())
                                wait(0.2)
                            end)
                            break
                        end
                    end
                end
            end
        end)
    elseif key == "autoDrop" then
        connections.autoDrop = RunService.RenderStepped:Connect(function()
            if not toggles.autoDrop then return end
            local inv = LocalPlayer:FindFirstChild("Inventory")
            if inv then
                for _, item in pairs(inv:GetChildren()) do
                    if item:IsA("Tool") or item:IsA("Palette") then
                        pcall(function()
                            item.Parent = Workspace
                            wait(0.1)
                        end)
                        break
                    end
                end
            end
        end)
    elseif key == "autoPickup" then
        connections.autoPickup = RunService.RenderStepped:Connect(function()
            if not toggles.autoPickup then return end
            local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
            if hrp then
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():find("item") or obj.Name:lower():find("loot") or obj.Name:lower():find("drop")) then
                        if (hrp.Position - obj.Position).Magnitude < 10 then
                            pcall(function()
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton2(Vector2.new())
                                wait(0.2)
                            end)
                            break
                        end
                    end
                end
            end
        end)
    elseif key == "autoUse" then
        connections.autoUse = RunService.RenderStepped:Connect(function()
            if not toggles.autoUse then return end
            local inv = LocalPlayer:FindFirstChild("Inventory")
            if inv then
                for _, item in pairs(inv:GetChildren()) do
                    if item:IsA("Tool") and item:FindFirstChild("Use") then
                        pcall(function()
                            item.Use:FireServer()
                            wait(0.5)
                        end)
                        break
                    end
                end
            end
        end)
    elseif key == "autoSprint" then
        connections.autoSprint = RunService.RenderStepped:Connect(function()
            if not toggles.autoSprint then return end
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if h then
                h.WalkSpeed = 50
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    elseif key == "autoCrouch" then
        connections.autoCrouch = RunService.RenderStepped:Connect(function()
            if not toggles.autoCrouch then return end
            local target = GetClosestPlayer()
            if target and target.Character then
                local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
                local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
                if hrp and targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 20 then
                    local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if h then
                        h.Sit = true
                        wait(0.2)
                        h.Sit = false
                    end
                end
            end
        end)
    elseif key == "autoJump" then
        connections.autoJump = RunService.RenderStepped:Connect(function()
            if not toggles.autoJump then return end
            local target = GetClosestPlayer()
            if target and target.Character then
                local hrp = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso"))
                local targetHrp = target.Character:FindFirstChild("HumanoidRootPart") or target.Character:FindFirstChild("Torso")
                if hrp and targetHrp and (hrp.Position - targetHrp.Position).Magnitude < 10 then
                    local h = LocalPlayer.Character:FindFirstChild("Humanoid")
                    if h then h.Jump = true; wait(0.1) end
                end
            end
        end)
    -- UTILITY
    elseif key == "antiAFK" then
        StartAntiAFK()
    end
end

-- ========================================
-- 🎨 GUI FIX (TERANG & BISA DI KLIK!)
-- ========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipHub"
ScreenGui.ResetOnSpawn = false

-- LOGO
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

-- ========================================
-- MENU (TERANG & BISA DIKLIK!)
-- ========================================
local Menu = Instance.new("Frame")
Menu.Parent = ScreenGui
Menu.Size = UDim2.new(0, 370, 0, 520)
Menu.Position = UDim2.new(0.5, -185, 0.5, -260)
Menu.BackgroundColor3 = Color3.fromRGB(20, 20, 40)  -- TERANG!
Menu.BackgroundTransparency = 0  -- GA KEREDUP!
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

-- HEADER
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

-- CLOSE
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

-- SCROLL
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

-- ========================================
-- UI FUNGSI (TERANG!)
-- ========================================
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
    label.Size = UDim2.new(0.6, 0, 1, 0)
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
Tog("💀 God", y, "godMode"); y = y + 28
Tog("💚 Heal", y, "autoHeal"); y = y + 28
Tog("🔫 Shoot", y, "autoShoot"); y = y + 28
Tog("🤫 Silent", y, "silentAim"); y = y + 28
Tog("⚡ Stun", y, "autoStun"); y = y + 28
Tog("🛡️ Block", y, "autoBlock"); y = y + 28
Tog("💨 Dodge", y, "autoDodge"); y = y + 28
Btn("💥 OHK", y, function() KillAll() end, Color3.fromRGB(100, 0, 0))
y = y + 28
Div(y); y = y + 8

Cat("👁️ ESP", y); y = y + 24
Tog("🔴 Player", y, "espPlayer"); y = y + 28
Tog("🔴 Killer", y, "espKiller"); y = y + 28
Tog("🟢 Gen", y, "espGenerator"); y = y + 28
Tog("🟡 Gate", y, "espGate"); y = y + 28
Tog("🟠 Pallet", y, "espPallet"); y = y + 28
Div(y); y = y + 8

Cat("⚡ GENERATOR", y); y = y + 24
Tog("🔄 Auto Gen", y, "autoGenerator"); y = y + 28
Tog("🚀 Tele Gen", y, "teleportGen"); y = y + 28
Btn("📦 Drop Pallet", y, function()
    local inv = LocalPlayer:FindFirstChild("Inventory")
    if inv then
        for _, item in pairs(inv:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Palette") then
                pcall(function() item.Parent = Workspace end)
            end
        end
    end
end, Color3.fromRGB(120, 60, 0))
y = y + 28
Div(y); y = y + 8

Cat("🚪 ESCAPE", y); y = y + 24
Tog("🚪 Auto Escape", y, "autoEscape"); y = y + 28
Div(y); y = y + 8

Cat("🔥 VD", y); y = y + 24
Tog("🧱 Vault", y, "autoVault"); y = y + 28
Tog("🔦 Flash", y, "autoFlashlight"); y = y + 28
Tog("⚡ Perk", y, "autoPerk"); y = y + 28
Tog("🔧 Repair", y, "autoRepair"); y = y + 28
Tog("💣 Sabotage", y, "autoSabotage"); y = y + 28
Tog("👻 Hide", y, "autoHide"); y = y + 28
Tog("🏃 Run", y, "autoRun"); y = y + 28
Tog("🪑 Crouch W", y, "autoCrouchWalk"); y = y + 28
Tog("🐢 Slow", y, "autoSlowWalk"); y = y + 28
Tog("🔄 Spin", y, "autoSpin"); y = y + 28
Div(y); y = y + 8

Cat("💎 ULTIMATE", y); y = y + 24
Tog("💀 Kill Aura", y, "autoKillAura"); y = y + 28
Tog("📦 Loot", y, "autoGrabLoot"); y = y + 28
Btn("📦 Teleport", y, function() TeleportToPlayer() end, Color3.fromRGB(0, 100, 150))
y = y + 28
Tog("🔄 Respawn", y, "autoRespawn"); y = y + 28
Tog("💊 Use Item", y, "autoUseItem"); y = y + 28
Div(y); y = y + 8

Cat("🆘 SAVE", y); y = y + 24
Tog("🆘 Auto Save", y, "autoSave"); y = y + 28
Btn("🆘 Save Now", y, function() ManualSaveNearest() end, Color3.fromRGB(0, 150, 100))
y = y + 28
Div(y); y = y + 8

Cat("🏃 MOVEMENT", y); y = y + 24
Tog("⚡ Speed", y, "speedHack"); y = y + 28
Tog("🕊️ Fly", y, "fly"); y = y + 28
Tog("🧱 NoClip", y, "noClip"); y = y + 28
Tog("🌙 Moon", y, "moonWalk"); y = y + 28
Div(y); y = y + 8

Cat("👻 STEALTH", y); y = y + 24
Tog("👻 Invisible", y, "invisible"); y = y + 28
Div(y); y = y + 8

Cat("🔥 LYNX", y); y = y + 24
Tog("🤲 Grab", y, "autoGrab"); y = y + 28
Tog("📤 Drop", y, "autoDrop"); y = y + 28
Tog("📥 Pickup", y, "autoPickup"); y = y + 28
Tog("🔧 Use", y, "autoUse"); y = y + 28
Tog("🏃 Sprint", y, "autoSprint"); y = y + 28
Tog("🪑 Crouch", y, "autoCrouch"); y = y + 28
Tog("🦘 Jump", y, "autoJump"); y = y + 28
Div(y); y = y + 8

Cat("🔧 UTILITY", y); y = y + 24
Tog("🚫 Anti AFK", y, "antiAFK"); y = y + 28
Btn("🔄 Reset", y, function()
    for k, _ in pairs(toggles) do
        toggles[k] = false
        if connections[k] then connections[k]:Disconnect(); connections[k] = nil end
    end
    StopFly(); StopSilentAim(); StopAntiAFK(); StopAutoSave()
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

print("✅ ZIP HUB (FINAL - GABUNGAN ALL FIX) Loaded!")
print("✅ 35+ Fitur siap pakai!")
print("✅ Menu TERANG & BISA DIKLIK!")
print("✅ Fly Speed 300 + Support Mobile/PC!")
print("✅ Auto Generator langsung jadi!")
print("✅ Klik LOGO ZH untuk buka menu!")
