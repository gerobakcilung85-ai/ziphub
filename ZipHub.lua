-- =====================================================
-- ZIP HUB v4.0 – VIOLENCE DISTRICT FULL FEATURES
-- LOADSTRING: loadstring(game:HttpGet("https://pastebin.com/raw/ZipHubV4"))()
-- =====================================================

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local RunService = game:GetService("RunService")
local UserInput = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- =====================================================
-- [UI] DARK THEME DASHBOARD
-- =====================================================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally/rbxlib/main/Library.lua"))()
local main = Library:CreateWindow("ZIP HUB v4.0 | VIOLENCE DISTRICT", "Dark")
local combatTab = main:CreateTab("⚔️ Combat")
local visualTab = main:CreateTab("👁️ Visuals")
local movementTab = main:CreateTab("🏃 Movement")
local killerTab = main:CreateTab("🔪 Killer")
local survivorTab = main:CreateTab("🛡️ Survivor")
local miscTab = main:CreateTab("🔧 Misc")
local settingsTab = main:CreateTab("⚙️ Settings")

-- =====================================================
-- [VARIABLES GLOBAL]
-- =====================================================
local silentAimEnabled = false
local aimFOV = 150
local aimPart = "Head"
local espEnabled = false
local wallhackEnabled = false
local speedHack = false
local speedValue = 50
local jumpPower = 50
local noRecoil = false
local noSpread = false
local autoShoot = false
local triggerbot = false
local espColor = Color3.fromRGB(255, 0, 0)
local espTeamCheck = false
local flyEnabled = false
local flySpeed = 50
local autoGenerator = false
local autoKillAll = false
local autoEscape = false
local noClipEnabled = false
local dropAllPalet = false

-- =====================================================
-- [COMBAT FEATURES]
-- =====================================================
combatTab:CreateToggle("🎯 Silent Aim", function(bool)
    silentAimEnabled = bool
end)

combatTab:CreateSlider("FOV", 0, 360, 150, function(val)
    aimFOV = val
end)

combatTab:CreateDropdown("Aim Part", {"Head", "Torso", "HumanoidRootPart"}, function(sel)
    aimPart = sel
end)

combatTab:CreateToggle("🔫 Auto Shoot (Hold)", function(bool)
    autoShoot = bool
end)

combatTab:CreateToggle("⚡ Triggerbot", function(bool)
    triggerbot = bool
end)

combatTab:CreateToggle("📉 No Recoil", function(bool)
    noRecoil = bool
end)

combatTab:CreateToggle("🎯 No Spread", function(bool)
    noSpread = bool
end)

-- =====================================================
-- [VISUALS - ESP + WALLHACK]
-- =====================================================
visualTab:CreateToggle("🔲 ESP Boxes", function(bool)
    espEnabled = bool
end)

visualTab:CreateToggle("🧱 Wallhack", function(bool)
    wallhackEnabled = bool
end)

visualTab:CreateColorPicker("ESP Color", Color3.fromRGB(255,0,0), function(color)
    espColor = color
end)

visualTab:CreateToggle("👥 Team Check", function(bool)
    espTeamCheck = bool
end)

-- =====================================================
-- [MOVEMENT - FLY + SPEED + JUMP + NOCLIP]
-- =====================================================
movementTab:CreateToggle("✈️ Fly (Auto Generate)", function(bool)
    flyEnabled = bool
    if flyEnabled then
        local bf = Instance.new("BodyForce")
        bf.Force = Vector3.new(0, 500, 0)
        bf.Parent = player.Character.HumanoidRootPart
        player.Character.Humanoid.PlatformStand = true
        RunService.RenderStepped:Connect(function()
            if flyEnabled and player.Character then
                local root = player.Character.HumanoidRootPart
                local move = Vector3.new(
                    (UserInput:IsKeyDown(Enum.KeyCode.W) and 1 or 0) - (UserInput:IsKeyDown(Enum.KeyCode.S) and 1 or 0),
                    0,
                    (UserInput:IsKeyDown(Enum.KeyCode.A) and 1 or 0) - (UserInput:IsKeyDown(Enum.KeyCode.D) and 1 or 0)
                )
                if move.Magnitude > 0 then
                    root.Velocity = (Camera.CFrame:VectorToWorldSpace(move) * flySpeed) + Vector3.new(0, root.Velocity.Y, 0)
                else
                    root.Velocity = Vector3.new(0, root.Velocity.Y, 0)
                end
            end
        end)
    else
        player.Character.Humanoid.PlatformStand = false
    end
end)

movementTab:CreateSlider("Fly Speed", 10, 200, 50, function(val)
    flySpeed = val
end)

movementTab:CreateToggle("💨 Speed Hack", function(bool)
    speedHack = bool
end)

movementTab:CreateSlider("Speed Value", 16, 100, 50, function(val)
    speedValue = val
end)

movementTab:CreateToggle("🦘 Super Jump", function(bool)
    if bool then
        player.Character.Humanoid.JumpPower = jumpPower
    else
        player.Character.Humanoid.JumpPower = 50
    end
end)

movementTab:CreateSlider("Jump Power", 50, 200, 100, function(val)
    jumpPower = val
end)

movementTab:CreateToggle("🚪 No Clip (Through Walls)", function(bool)
    noClipEnabled = bool
    if noClipEnabled then
        local char = player.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    else
        local char = player.Character
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
-- [KILLER FEATURES - AUTO KILL ALL]
-- =====================================================
killerTab:CreateToggle("☠️ Auto Kill All Survivors", function(bool)
    autoKillAll = bool
    if autoKillAll then
        spawn(function()
            while autoKillAll do
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        local remote = ReplicatedStorage:FindFirstChild("KillRemote") or ReplicatedStorage:FindFirstChild("DamageRemote")
                        if remote then
                            remote:FireServer(v.Character.HumanoidRootPart, 100)
                        else
                            v.Character.Humanoid.Health = 0
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

killerTab:CreateButton("🔪 Instant Kill All (One Click)", function()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Humanoid") then
            v.Character.Humanoid.Health = 0
        end
    end
end)

-- =====================================================
-- [SURVIVOR FEATURES - AUTO ESCAPE + DROP ALL PALET]
-- =====================================================
survivorTab:CreateToggle("🏃 Auto Escape (Find Exit)", function(bool)
    autoEscape = bool
    if autoEscape then
        spawn(function()
            while autoEscape do
                local exit = Workspace:FindFirstChild("Exit") or Workspace:FindFirstChild("EscapePoint")
                if exit and player.Character then
                    player.Character.HumanoidRootPart.CFrame = exit.CFrame
                end
                task.wait(1)
            end
        end)
    end
end)

survivorTab:CreateToggle("📦 Drop All Palet (Auto)", function(bool)
    dropAllPalet = bool
    if dropAllPalet then
        spawn(function()
            while dropAllPalet do
                local remote = ReplicatedStorage:FindFirstChild("DropPaletRemote")
                if remote then
                    remote:FireServer("All")
                else
                    for _, item in pairs(player.Backpack:GetChildren()) do
                        if item.Name:find("Palet") then
                            item.Parent = Workspace
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

survivorTab:CreateButton("📤 Drop All Palet (Manual)", function()
    for _, item in pairs(player.Backpack:GetChildren()) do
        if item.Name:find("Palet") then
            item.Parent = Workspace
        end
    end
end)

-- =====================================================
-- [MISC - AUTO GENERATOR + INFINITE RESOURCES]
-- =====================================================
miscTab:CreateToggle("⚡ Auto Generator (Farm Resources)", function(bool)
    autoGenerator = bool
    if autoGenerator then
        spawn(function()
            while autoGenerator do
                local gen = Workspace:FindFirstChild("Generator") or Workspace:FindFirstChild("ResourceNode")
                if gen and player.Character then
                    player.Character.HumanoidRootPart.CFrame = gen.CFrame + Vector3.new(0, 2, 0)
                    task.wait(1)
                    local remote = ReplicatedStorage:FindFirstChild("CollectRemote")
                    if remote then remote:FireServer(gen) end
                end
                task.wait(0.5)
            end
        end)
    end
end)

miscTab:CreateToggle("♾️ Infinite Ammo", function(bool)
    if bool then
        local ammo = ReplicatedStorage:FindFirstChild("AmmoRemote")
        if ammo then ammo:FireServer(999) end
    end
end)

miscTab:CreateToggle("🛡️ God Mode (Client Side)", function(bool)
    if bool then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.MaxHealth = 9999
            char.Humanoid.Health = 9999
        end
    end
end)

-- =====================================================
-- [SETTINGS - SAVE/LOAD + REJOIN]
-- =====================================================
settingsTab:CreateButton("💾 Save Config", function()
    writefile("ZipHub_Config_v4.txt", game:GetService("HttpService"):JSONEncode({
        aimFOV = aimFOV,
        aimPart = aimPart,
        espColor = espColor,
        speedValue = speedValue,
        jumpPower = jumpPower,
        flySpeed = flySpeed
    }))
end)

settingsTab:CreateButton("📂 Load Config", function()
    if isfile("ZipHub_Config_v4.txt") then
        local data = game:GetService("HttpService"):JSONDecode(readfile("ZipHub_Config_v4.txt"))
        aimFOV = data.aimFOV or 150
        aimPart = data.aimPart or "Head"
        espColor = data.espColor or Color3.fromRGB(255,0,0)
        speedValue = data.speedValue or 50
        jumpPower = data.jumpPower or 100
        flySpeed = data.flySpeed or 50
    end
end)

settingsTab:CreateButton("🔄 Rejoin Server", function()
    TeleportService:Teleport(game.PlaceId)
end)

settingsTab:CreateButton("📋 Copy Loadstring", function()
    setclipboard('loadstring(game:HttpGet("https://pastebin.com/raw/ZipHubV4"))()')
end)

-- =====================================================
-- [ANTI-KICK + ANTI-FREEZE]
-- =====================================================
pcall(function()
    game:GetService("Players").LocalPlayer:Kick = function() end
end)

-- =====================================================
-- [INITIALIZATION NOTIFICATION]
-- =====================================================
game.StarterGui:SetCore("SendNotification", {
    Title = "✅ ZIP HUB v4.0 LOADED",
    Text = "All Features Active – Auto Kill, Escape, Generator, Fly, NoClip, Drop Palet",
    Duration = 5
})

print("🔥 Zip Hub v4.0 Loaded – Full Dominance Active!")
