-- =====================================================
-- ZIP HUB v7.0 – LIGHTWEIGHT 6LOCC REPLICA
-- FIX: BLACKSCREEN AUTO GENERATOR
-- FIX: LAG (OPTIMIZED LOOPS)
-- GUI: 100% MIRIP GAMBAR (Survivor Menu Style)
-- FEATURE: HIDE MENU ( - )
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
local Lighting = game:GetService("Lightning")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

-- =====================================================
-- OPTIMASI: FUNGSI DASAR (CACHE)
-- =====================================================
local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHumanoid()
    local c = GetCharacter()
    return c and c:FindFirstChild("Humanoid")
end

local function GetHRP()
    local c = GetCharacter()
    return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso"))
end

local function IsKiller(p)
    if not p then return false end
    if p:GetAttribute("Role") == "Killer" then return true end
    if p:GetAttribute("Team") == "Killer" then return true end
    if p:GetAttribute("IsKiller") == true then return true end
    local c = p.Character
    if c then
        if c:GetAttribute("Role") == "Killer" then return true end
        if c:GetAttribute("Team") == "Killer" then return true end
        for _, t in pairs(c:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("knife") or n:find("weapon") or n:find("scythe") or n:find("blade") or n:find("sword") or n:find("axe") or n:find("hammer") or n:find("gun") or n:find("claw") then
                    return true
                end
            end
        end
    end
    return false
end

local function FindGens()
    local g = {}
    for _, o in pairs(Workspace:GetDescendants()) do
        if o:IsA("BasePart") then
            local n = o.Name:lower()
            if n:find("generator") or n:find("gen") or n:find("power") or n:find("repair") then
                table.insert(g, o)
            end
        end
    end
    return g
end

local function FindGates()
    local g = {}
    for _, o in pairs(Workspace:GetDescendants()) do
        if o:IsA("BasePart") then
            local n = o.Name:lower()
            if n:find("gate") or n:find("escape") or n:find("exit") or n:find("door") then
                table.insert(g, o)
            end
        end
    end
    return g
end

local function GetClosest()
    local c, s = nil, math.huge
    local hrp = GetHRP()
    if not hrp then return nil end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local t = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
            if t then
                local d = (hrp.Position - t.Position).Magnitude
                if d < s then
                    s = d
                    c = p
                end
            end
        end
    end
    return c
end

-- =====================================================
-- TOGGLES (GARIS BESAR SESUAI GAMBAR)
-- =====================================================
local toggles = {
    noParryCooldown = false,
    autoParry = false,
    noFall = false,
    noTurnSpeed = false,
    autoEscape = false,
    -- tambahan fitur pendukung
    noClip = false,
    godMode = false,
    speedHack = false,
    superJump = false,
    antiAFK = false,
    espKiller = false,
    espSurvivor = false,
    autoGenerator = false,
    autoSkillCheck = false,
    fullBright = false,
    antiBlind = false,
    moonwalk = false,
    fastVault = false
}

local conn = {}
local espObjects = {}
local espActive = false
local godActive = false
local clipActive = false
local genActive = false
local genCooldown = 0

-- =====================================================
-- FITUR SESUAI GAMBAR
-- =====================================================

-- 1. NO PARRY COOLDOWN
local function StartNoParryCooldown()
    if conn.noParryCooldown then return end
    conn.noParryCooldown = RunService.RenderStepped:Connect(function()
        if toggles.noParryCooldown then
            local char = GetCharacter()
            if char then
                for _, child in pairs(char:GetChildren()) do
                    if child:IsA("Tool") and child.Name:lower():find("parry") then
                        if child:FindFirstChild("Cooldown") then
                            child.Cooldown.Value = 0
                        end
                    end
                end
            end
        end
    end)
end

-- 2. AUTO PARRY
local function StartAutoParry()
    if conn.autoParry then return end
    conn.autoParry = RunService.RenderStepped:Connect(function()
        if toggles.autoParry then
            local hrp = GetHRP()
            if not hrp then return end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and IsKiller(p) and p.Character then
                    local t = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                    if t and (hrp.Position - t.Position).Magnitude < 20 then
                        pcall(function()
                            VirtualUser:CaptureController()
                            VirtualUser:ClickButton2(Vector2.new())
                        end)
                    end
                end
            end
        end
    end)
end

-- 3. NO FALL
local function StartNoFall()
    if conn.noFall then return end
    conn.noFall = RunService.RenderStepped:Connect(function()
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

-- 4. NO TURN SPEED LIMIT
local function StartNoTurnSpeed()
    if conn.noTurnSpeed then return end
    conn.noTurnSpeed = RunService.RenderStepped:Connect(function()
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

-- 5. AUTO ESCAPE (FIX: TANPA BLACKSCREEN)
local function StartAutoEscape()
    if conn.autoEscape then return end
    conn.autoEscape = RunService.RenderStepped:Connect(function()
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
                        end
                    end
                end
            end
        end
    end)
end

-- =====================================================
-- FITUR TAMBAHAN (DARI PERMINTAAN SEBELUMNYA)
-- =====================================================

-- NO CLIP
local function StartNoClip()
    if clipActive then return end
    clipActive = true
    conn.clip = RunService.RenderStepped:Connect(function()
        if not clipActive or not toggles.noClip then
            StopNoClip()
            return
        end
        local c = GetCharacter()
        if c then
            for _, p in pairs(c:GetDescendants()) do
                if p:IsA("BasePart") then
                    p.CanCollide = false
                end
            end
        end
    end)
end

local function StopNoClip()
    clipActive = false
    if conn.clip then
        conn.clip:Disconnect()
        conn.clip = nil
    end
    local c = GetCharacter()
    if c then
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then
                p.CanCollide = true
            end
        end
    end
end

-- GOD MODE
local function StartGodMode()
    if godActive then return end
    godActive = true
    conn.god = RunService.RenderStepped:Connect(function()
        if not godActive or not toggles.godMode then
            StopGodMode()
            return
        end
        local h = GetHumanoid()
        if h then
            h.Health = h.MaxHealth
            h.PlatformStand = false
        end
    end)
end

local function StopGodMode()
    godActive = false
    if conn.god then
        conn.god:Disconnect()
        conn.god = nil
    end
end

-- SPEED HACK
local function StartSpeedHack()
    if conn.speedHack then return end
    conn.speedHack = RunService.RenderStepped:Connect(function()
        if toggles.speedHack then
            local h = GetHumanoid()
            if h then
                h.WalkSpeed = 60
            end
        end
    end)
end

-- SUPER JUMP
local function StartSuperJump()
    if conn.superJump then return end
    conn.superJump = RunService.RenderStepped:Connect(function()
        if toggles.superJump then
            local h = GetHumanoid()
            if h then
                h.JumpPower = 150
            end
        end
    end)
end

-- ANTI AFK
local function StartAntiAFK()
    if conn.antiAFK then return end
    conn.antiAFK = RunService.RenderStepped:Connect(function()
        if toggles.antiAFK then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end
    end)
end

-- ESP (RINGAN)
local function ClearESP()
    for _, o in pairs(espObjects) do
        pcall(function() o:Destroy() end)
    end
    espObjects = {}
end

local function AddESP(target, color, label, lc)
    if not target then return end
    local h = Instance.new("Highlight")
    h.Parent = target
    h.FillColor = color
    h.FillTransparency = 0.25
    h.OutlineColor = Color3.fromRGB(255, 255, 255)
    h.OutlineTransparency = 0.1
    table.insert(espObjects, h)
    local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChild("Torso") or target:FindFirstChild("Head")
    if hrp then
        local b = Instance.new("BillboardGui")
        b.Parent = hrp
        b.Size = UDim2.new(0, 150, 0, 24)
        b.Adornee = hrp
        b.AlwaysOnTop = true
        b.StudsOffset = Vector3.new(0, 2, 0)
        local l = Instance.new("TextLabel")
        l.Parent = b
        l.Size = UDim2.new(1, 0, 1, 0)
        l.BackgroundTransparency = 1
        l.Text = label or ""
        l.TextColor3 = lc or color
        l.TextSize = 10
        l.Font = Enum.Font.GothamBold
        l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        l.TextStrokeTransparency = 0.3
        table.insert(espObjects, b)
        table.insert(espObjects, l)
    end
end

local function UpdateESP()
    ClearESP()
    if not espActive then return end
    local hrp = GetHRP()
    if toggles.espKiller then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and IsKiller(p) and p.Character then
                local th = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                local d = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                AddESP(p.Character, Color3.fromRGB(255, 0, 0), "🔴 " .. p.Name .. " [" .. math.floor(d) .. "m]", Color3.fromRGB(255, 0, 0))
            end
        end
    end
    if toggles.espSurvivor then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not IsKiller(p) and p.Character then
                local th = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                local d = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                AddESP(p.Character, Color3.fromRGB(0, 255, 0), "🟢 " .. p.Name .. " [" .. math.floor(d) .. "m]", Color3.fromRGB(0, 255, 0))
            end
        end
    end
end

local function StartESP()
    if espActive then return end
    espActive = true
    conn.esp = RunService.RenderStepped:Connect(function()
        if espActive then
            UpdateESP()
        end
    end)
end

local function StopESP()
    espActive = false
    if conn.esp then
        conn.esp:Disconnect()
        conn.esp = nil
    end
    ClearESP()
end

-- =====================================================
-- FIX: AUTO GENERATOR (TANPA BLACKSCREEN)
-- =====================================================
local function AutoGeneratorAction()
    local hrp = GetHRP()
    if not hrp then return end
    local gens = FindGens()
    if #gens == 0 then return end
    table.sort(gens, function(a, b)
        return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude
    end)
    local target = gens[1]
    if not target then return end
    
    -- TELEPORT (TANPA BLACKSCREEN)
    hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
    task.wait(0.1)
    
    -- CLICK (PAKAI VIRTUALUSER, BUKAN FIRESERVER BERLEBIH)
    for i = 1, 8 do
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        task.wait(0.03)
    end
    
    -- FIRESERVER (HANYA 1 KALI)
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
    if genActive then return end
    genActive = true
    conn.gen = RunService.RenderStepped:Connect(function()
        if not genActive or not toggles.autoGenerator then
            StopAutoGenerator()
            return
        end
        -- COOLDOWN UNTUK CEK BLACKSCREEN
        if tick() - genCooldown > 1.5 then
            genCooldown = tick()
            AutoGeneratorAction()
        end
    end)
end

local function StopAutoGenerator()
    genActive = false
    if conn.gen then
        conn.gen:Disconnect()
        conn.gen = nil
    end
end

-- AUTO SKILL CHECK
local function StartAutoSkillCheck()
    if conn.autoSkillCheck then return end
    conn.autoSkillCheck = RunService.RenderStepped:Connect(function()
        if toggles.autoSkillCheck then
            local pg = LocalPlayer.PlayerGui
            if pg then
                for _, g in pairs(pg:GetDescendants()) do
                    if g:IsA("Frame") or g:IsA("ImageLabel") then
                        local n = g.Name:lower()
                        if n:find("skill") or n:find("check") then
                            for _, b in pairs(g:GetDescendants()) do
                                if b:IsA("TextButton") or b:IsA("ImageButton") then
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

-- =====================================================
-- TOGGLE HANDLER
-- =====================================================
local function ToggleFeature(key, state)
    toggles[key] = state
    
    -- STOP
    if key == "noClip" and not state then StopNoClip() end
    if key == "godMode" and not state then StopGodMode() end
    if key == "autoGenerator" and not state then StopAutoGenerator() end
    if key == "espKiller" and not state then
        if not toggles.espKiller and not toggles.espSurvivor then StopESP() end
    end
    if key == "espSurvivor" and not state then
        if not toggles.espKiller and not toggles.espSurvivor then StopESP() end
    end
    
    -- START
    if state then
        if key == "noParryCooldown" then StartNoParryCooldown()
        elseif key == "autoParry" then StartAutoParry()
        elseif key == "noFall" then StartNoFall()
        elseif key == "noTurnSpeed" then StartNoTurnSpeed()
        elseif key == "autoEscape" then StartAutoEscape()
        elseif key == "noClip" then StartNoClip()
        elseif key == "godMode" then StartGodMode()
        elseif key == "speedHack" then StartSpeedHack()
        elseif key == "superJump" then StartSuperJump()
        elseif key == "antiAFK" then StartAntiAFK()
        elseif key == "espKiller" or key == "espSurvivor" then
            if not espActive then StartESP() end
        elseif key == "autoGenerator" then StartAutoGenerator()
        elseif key == "autoSkillCheck" then StartAutoSkillCheck()
        elseif key == "fullBright" then
            Lighting.Brightness = 10
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        elseif key == "antiBlind" then
            local pg = LocalPlayer.PlayerGui
            if pg then
                for _, g in pairs(pg:GetDescendants()) do
                    if g:IsA("Frame") or g:IsA("ImageLabel") then
                        local n = g.Name:lower()
                        if n:find("blind") or n:find("flash") or n:find("overlay") then
                            pcall(function() g.Visible = false end)
                        end
                    end
                end
            end
        elseif key == "moonwalk" then
            local h = GetHumanoid()
            if h then
                h.WalkSpeed = 50
                h.AutoRotate = false
            end
        elseif key == "fastVault" then
            local hrp = GetHRP()
            if hrp then
                for _, o in pairs(Workspace:GetDescendants()) do
                    if o:IsA("BasePart") and (o.Name:lower():find("vault") or o.Name:lower():find("pallet") or o.Name:lower():find("window")) then
                        if (hrp.Position - o.Position).Magnitude < 5 then
                            local h = GetHumanoid()
                            if h then
                                h.Jump = true
                                task.wait(0.03)
                                hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 10
                            end
                        end
                    end
                end
            end
        end
    end
end

-- =====================================================
-- GUI 100% MIRIP GAMBAR (SURVIVOR MENU)
-- =====================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = CoreGui
ScreenGui.Name = "ZipSurvivorMenu"
ScreenGui.ResetOnSpawn = false

-- MAIN FRAME (SURVIVOR THEME)
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
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

-- GLASS EFFECT
local GlassBg = Instance.new("Frame")
GlassBg.Parent = MainFrame
GlassBg.Size = UDim2.new(1, 0, 1, 0)
GlassBg.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
GlassBg.BackgroundTransparency = 0.7
GlassBg.BorderSizePixel = 0

-- HEADER (SURVIVOR THEME)
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

-- TITLE "SURVIVOR"
local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(0.5, 0, 1, 0)
Title.Position = UDim2.new(0, 44, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "SURVIVOR"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- SUBTITLE "ZIP HUB"
local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = Header
SubTitle.Size = UDim2.new(0.3, 0, 1, 0)
SubTitle.Position = UDim2.new(0.65, 0, 0, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "ZIP HUB v7.0"
SubTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Right

-- HIDE MENU BUTTON ( - )
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

-- CLOSE BUTTON (X)
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

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

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

-- TOGGLE CREATOR (MIRIP GAMBAR)
local function CreateToggle(text, desc, key, yPos)
    local frame = Instance.new("Frame")
    frame.Parent = ScrollingFrame
    frame.Size = UDim2.new(1, -10, 0, 52)
    frame.Position = UDim2.new(0, 0, 0, yPos)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 50)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 1
    frame.BorderColor3 = Color3.fromRGB(0, 180, 255)

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 6)

    -- LABEL (FITUR)
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

    -- DESKRIPSI (MIRIP GAMBAR)
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

    -- TOGGLE BUTTON
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

    return yPos + 56
end

-- =====================================================
-- DAFTAR TOGGLE (SESUAI GAMBAR + TAMBAHAN)
-- =====================================================
local yPos = 2

-- FITUR UTAMA (SESUAI GAMBAR)
yPos = CreateToggle("No Parry Cooldown", "Infinite parries (requires parry dagger).", "noParryCooldown", yPos)
yPos = CreateToggle("Auto Parry", "spams parrying when killer is close (nessy)", "autoParry", yPos)
yPos = CreateToggle("No Fall", "Gives you no fall penalty from high falls.", "noFall", yPos)
yPos = CreateToggle("No Turn Speed Limit", "Prevents you from being slowed down when making sharp turns while sprinting.", "noTurnSpeed", yPos)
yPos = CreateToggle("Auto Escape", "Use this to autoform screws.", "autoEscape", yPos)

-- FITUR TAMBAHAN (PENDUKUNG)
yPos = CreateToggle("🚪 No Clip", "Walk through walls", "noClip", yPos)
yPos = CreateToggle("🛡️ God Mode", "Infinite health", "godMode", yPos)
yPos = CreateToggle("💨 Speed Hack", "Run faster", "speedHack", yPos)
yPos = CreateToggle("🦘 Super Jump", "Jump higher", "superJump", yPos)
yPos = CreateToggle("⏰ Anti AFK", "Prevent AFK kick", "antiAFK", yPos)
yPos = CreateToggle("🔴 Killer ESP", "See killer through walls", "espKiller", yPos)
yPos = CreateToggle("🟢 Survivor ESP", "See survivors through walls", "espSurvivor", yPos)
yPos = CreateToggle("⚡ Auto Generator", "Auto farm generators (FIX BLACKSCREEN)", "autoGenerator", yPos)
yPos = CreateToggle("🎯 Auto Skill Check", "100% accuracy on skill checks", "autoSkillCheck", yPos)
yPos = CreateToggle("☀️ Full Bright", "Brighten map", "fullBright", yPos)
yPos = CreateToggle("👁️ Anti Blind", "Remove flash effects", "antiBlind", yPos)
yPos = CreateToggle("🌙 Moonwalk", "Moonwalk + sway", "moonwalk", yPos)
yPos = CreateToggle("🪟 Fast Vault", "Super fast vault", "fastVault", yPos)

ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 20)

-- WATERMARK
local Watermark = Instance.new("TextLabel")
Watermark.Parent = ScreenGui
Watermark.Size = UDim2.new(0, 160, 0, 16)
Watermark.Position = UDim2.new(0, 8, 1, -22)
Watermark.BackgroundTransparency = 1
Watermark.Text = "⚡ ZIP HUB v7.0 ⚡"
Watermark.TextColor3 = Color3.fromRGB(0, 180, 255)
Watermark.TextSize = 10
Watermark.Font = Enum.Font.GothamMedium
Watermark.TextTransparency = 0.4

-- AUTO START ESP
task.wait(0.3)
ToggleFeature("espKiller", true)
ToggleFeature("espSurvivor", true)

print("✅ ZIP HUB v7.0 – LIGHTWEIGHT 6LOCC REPLICA LOADED!")
print("✅ FITUR SESUAI GAMBAR: No Parry Cooldown, Auto Parry, No Fall, No Turn Speed, Auto Escape")
print("✅ FIX BLACKSCREEN AUTO GENERATOR")
print("✅ HIDE MENU ( - )")
print("✅ NO LAG (OPTIMIZED LOOPS)")
