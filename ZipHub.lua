-- =====================================================
-- ZIP HUB v55.0 – 6LOCC LIGHTWEIGHT EDITION
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

-- =====================================================
-- LIGHTWEIGHT: FUNGSI DASAR (OPTIMIZED)
-- =====================================================
local function GetCharacter() return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait() end
local function GetHumanoid() local c = GetCharacter() return c and c:FindFirstChild("Humanoid") end
local function GetHRP() local c = GetCharacter() return c and (c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Torso") or c:FindFirstChild("UpperTorso")) end

local function IsKiller(p)
    if not p then return false end
    if p:GetAttribute("Role") == "Killer" or p:GetAttribute("Team") == "Killer" or p:GetAttribute("IsKiller") == true then return true end
    local c = p.Character
    if c then
        if c:GetAttribute("Role") == "Killer" or c:GetAttribute("Team") == "Killer" or c:GetAttribute("IsKiller") == true then return true end
        for _, t in pairs(c:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("knife") or n:find("weapon") or n:find("scythe") or n:find("blade") or n:find("sword") or n:find("axe") or n:find("hammer") or n:find("gun") or n:find("claw") then return true end
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
            if n:find("generator") or n:find("gen") or n:find("power") or n:find("repair") then table.insert(g, o) end
        end
    end
    return g
end

local function FindGates()
    local g = {}
    for _, o in pairs(Workspace:GetDescendants()) do
        if o:IsA("BasePart") then
            local n = o.Name:lower()
            if n:find("gate") or n:find("escape") or n:find("exit") or n:find("door") then table.insert(g, o) end
        end
    end
    return g
end

local function FindHooks()
    local h = {}
    for _, o in pairs(Workspace:GetDescendants()) do
        if o:IsA("BasePart") and o.Name:lower():find("hook") then table.insert(h, o) end
    end
    return h
end

local function FindPallets()
    local p = {}
    for _, o in pairs(Workspace:GetDescendants()) do
        if o:IsA("BasePart") and (o.Name:lower():find("pallet") or o.Name:lower():find("plank")) then table.insert(p, o) end
    end
    return p
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
                if d < s then s = d; c = p end
            end
        end
    end
    return c
end

local function GetHealthState(p)
    local h = p.Character and p.Character:FindFirstChild("Humanoid")
    if not h then return "💀" end
    local r = h.Health / h.MaxHealth
    if r <= 0 then return "💀"
    elseif r <= 0.25 then return "🪝"
    elseif r <= 0.5 then return "🩸"
    elseif r <= 0.75 then return "🟡"
    else return "🟢" end
end

local function GetChased(d)
    if d < 30 then return "🔴!!"
    elseif d < 50 then return "🟡!"
    else return "🟢" end
end

-- =====================================================
-- LIGHTWEIGHT TOGGLES
-- =====================================================
local t = {}
local conn = {}
local espObj = {}
local flyActive, invActive, genActive, clipActive, godActive, espActive = false, false, false, false, false, false

-- =====================================================
-- LIGHTWEIGHT: FLY (OPTIMIZED)
-- =====================================================
local function StartFly()
    if flyActive then return end
    flyActive = true
    local hrp = GetHRP()
    if not hrp then flyActive = false; return end
    local h = GetHumanoid()
    if h then h.PlatformStand = true end
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bv.Velocity = Vector3.new(0, 0, 0)
    bv.Parent = hrp
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(1e9, 1e9, 1e9)
    bp.Position = hrp.Position
    bp.Parent = hrp
    local c = RunService.RenderStepped:Connect(function()
        if not flyActive or not t.fly then StopFly(); return end
        local hrp = GetHRP()
        if not hrp then return end
        if bp then bp.Position = hrp.Position end
        local cam = Camera.CFrame
        local f = cam.LookVector
        local r = cam.RightVector
        local ff = Vector3.new(f.X, 0, f.Z).Unit
        local fr = Vector3.new(r.X, 0, r.Z).Unit
        local md = Vector3.new()
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then md = md + ff end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then md = md - ff end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then md = md - fr end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then md = md + fr end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then md = md + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then md = md + Vector3.new(0, -1, 0) end
        bv.Velocity = md.Magnitude > 0 and md.Unit * 50 or Vector3.new(0, 0.5, 0)
    end)
    conn.fly = {bv = bv, bp = bp, c = c}
end

local function StopFly()
    flyActive = false
    if conn.fly then
        if conn.fly.c then conn.fly.c:Disconnect() end
        if conn.fly.bv then conn.fly.bv:Destroy() end
        if conn.fly.bp then conn.fly.bp:Destroy() end
        conn.fly = nil
    end
    local h = GetHumanoid()
    if h then h.PlatformStand = false end
end

-- =====================================================
-- LIGHTWEIGHT: INVISIBLE
-- =====================================================
local function StartInvisible()
    if invActive then return end
    invActive = true
    conn.inv = RunService.RenderStepped:Connect(function()
        if not invActive or not t.invisible then StopInvisible(); return end
        local c = GetCharacter()
        if not c then return end
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.Transparency = 1; p.CanCollide = false; p.CastShadow = false end
        end
        local h = GetHumanoid()
        if h then h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None; h.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff end
    end)
end

local function StopInvisible()
    invActive = false
    if conn.inv then conn.inv:Disconnect(); conn.inv = nil end
    local c = GetCharacter()
    if c then
        for _, p in pairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.Transparency = 0; p.CanCollide = true; p.CastShadow = true end
        end
        local h = GetHumanoid()
        if h then h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer; h.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOn end
    end
end

-- =====================================================
-- LIGHTWEIGHT: AUTO GENERATOR
-- =====================================================
local function AutoGenAction()
    local hrp = GetHRP()
    if not hrp then return end
    local gens = FindGens()
    if #gens == 0 then return end
    table.sort(gens, function(a,b) return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude end)
    local target = gens[1]
    if not target then return end
    hrp.CFrame = CFrame.new(target.Position + Vector3.new(0, 2, 0))
    task.wait(0.15)
    for i = 1, 10 do
        pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
        task.wait(0.03)
    end
    for _, o in pairs(ReplicatedStorage:GetDescendants()) do
        if o:IsA("RemoteEvent") then
            local n = o.Name:lower()
            if n:find("generator") or n:find("gen") or n:find("repair") or n:find("complete") then
                pcall(function() o:FireServer(target) end)
            end
        end
    end
end

local function StartAutoGen()
    if genActive then return end
    genActive = true
    conn.gen = RunService.RenderStepped:Connect(function()
        if not genActive or not t.autoGenerator then StopAutoGen(); return end
        AutoGenAction()
        task.wait(0.8)
    end)
end

local function StopAutoGen()
    genActive = false
    if conn.gen then conn.gen:Disconnect(); conn.gen = nil end
end

-- =====================================================
-- LIGHTWEIGHT: NO CLIP
-- =====================================================
local function StartNoClip()
    if clipActive then return end
    clipActive = true
    conn.clip = RunService.RenderStepped:Connect(function()
        if not clipActive or not t.noClip then StopNoClip(); return end
        local c = GetCharacter()
        if c then for _, p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end
    end)
end

local function StopNoClip()
    clipActive = false
    if conn.clip then conn.clip:Disconnect(); conn.clip = nil end
    local c = GetCharacter()
    if c then for _, p in pairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = true end end end
end

-- =====================================================
-- LIGHTWEIGHT: GOD MODE
-- =====================================================
local function StartGodMode()
    if godActive then return end
    godActive = true
    conn.god = RunService.RenderStepped:Connect(function()
        if not godActive or not t.godMode then StopGodMode(); return end
        local h = GetHumanoid()
        if h then h.Health = h.MaxHealth; h.PlatformStand = false end
    end)
end

local function StopGodMode()
    godActive = false
    if conn.god then conn.god:Disconnect(); conn.god = nil end
end

-- =====================================================
-- LIGHTWEIGHT: ESP (7 IN 1 – OPTIMIZED)
-- =====================================================
local function ClearESP()
    for _, o in pairs(espObj) do pcall(function() o:Destroy() end) end
    espObj = {}
end

local function AddESP(target, color, label, lc)
    if not target then return end
    local h = Instance.new("Highlight")
    h.Parent = target
    h.FillColor = color
    h.FillTransparency = 0.25
    h.OutlineColor = Color3.fromRGB(255,255,255)
    h.OutlineTransparency = 0.1
    table.insert(espObj, h)
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
        l.Size = UDim2.new(1,0,1,0)
        l.BackgroundTransparency = 1
        l.Text = label or ""
        l.TextColor3 = lc or color
        l.TextSize = 10
        l.Font = Enum.Font.GothamBold
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.3
        table.insert(espObj, b)
        table.insert(espObj, l)
    end
end

local function UpdateESP()
    ClearESP()
    if not espActive then return end
    local hrp = GetHRP()
    
    if t.espKiller then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and IsKiller(p) and p.Character then
                local th = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                local d = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                AddESP(p.Character, Color3.fromRGB(255,0,0), GetChased(d).." "..p.Name.." ["..math.floor(d).."m]", Color3.fromRGB(255,0,0))
            end
        end
    end
    
    if t.espSurvivor then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and not IsKiller(p) and p.Character then
                local th = p.Character:FindFirstChild("HumanoidRootPart") or p.Character:FindFirstChild("Torso")
                local d = hrp and th and (hrp.Position - th.Position).Magnitude or 0
                AddESP(p.Character, Color3.fromRGB(0,255,0), "🟢 "..p.Name.." ["..math.floor(d).."m] "..GetHealthState(p), Color3.fromRGB(0,255,0))
            end
        end
    end
    
    if t.espGenerator then
        for _, g in pairs(FindGens()) do
            AddESP(g.Parent or g, Color3.fromRGB(0,255,255), "⚡ Gen", Color3.fromRGB(0,255,255))
        end
    end
    
    if t.espHook then
        for _, h in pairs(FindHooks()) do
            AddESP(h.Parent or h, Color3.fromRGB(255,165,0), "🪝 Hook", Color3.fromRGB(255,165,0))
        end
    end
    
    if t.espPallet then
        for _, p in pairs(FindPallets()) do
            AddESP(p.Parent or p, Color3.fromRGB(139,69,19), "📦 Pallet", Color3.fromRGB(139,69,19))
        end
    end
end

local function StartESP()
    if espActive then return end
    espActive = true
    conn.esp = RunService.RenderStepped:Connect(function() if espActive then UpdateESP() end end)
end

local function StopESP()
    espActive = false
    if conn.esp then conn.esp:Disconnect(); conn.esp = nil end
    ClearESP()
end

-- =====================================================
-- LIGHTWEIGHT: AUTO SKILL CHECK
-- =====================================================
local function StartAutoSkill()
    if conn.skill then return end
    conn.skill = RunService.RenderStepped:Connect(function()
        if t.autoSkill then
            local pg = LocalPlayer.PlayerGui
            if pg then
                for _, g in pairs(pg:GetDescendants()) do
                    if g:IsA("Frame") or g:IsA("ImageLabel") then
                        if g.Name:lower():find("skill") or g.Name:lower():find("check") then
                            for _, b in pairs(g:GetDescendants()) do
                                if b:IsA("TextButton") or b:IsA("ImageButton") then
                                    pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end)
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
-- LIGHTWEIGHT: INSTANT ESCAPE
-- =====================================================
local function StartInstantEscape()
    if conn.escape then return end
    conn.escape = RunService.RenderStepped:Connect(function()
        if t.instantEscape then
            local hrp = GetHRP()
            if not hrp then return end
            local gates = FindGates()
            if #gates > 0 then
                table.sort(gates, function(a,b) return (hrp.Position - a.Position).Magnitude < (hrp.Position - b.Position).Magnitude end)
                local target = gates[1]
                if target then
                    hrp.CFrame = CFrame.new(target.Position + Vector3.new(0,3,0))
                    task.wait(0.15)
                    for _, o in pairs(ReplicatedStorage:GetDescendants()) do
                        if o:IsA("RemoteEvent") and o.Name:lower():find("escape") then
                            pcall(function() o:FireServer() end)
                        end
                    end
                end
            end
        end
    end)
end

-- =====================================================
-- LIGHTWEIGHT: FORCE END GAME
-- =====================================================
local function StartForceEnd()
    if conn.force then return end
    conn.force = RunService.RenderStepped:Connect(function()
        if t.forceEnd then
            for _, o in pairs(Workspace:GetDescendants()) do
                if o:IsA("BasePart") and o.Name:lower():find("gate") then
                    pcall(function() o:SetAttribute("Open", true); local c = o:FindFirstChild("ClickDetector"); if c then c:Click() end end)
                end
            end
            for _, o in pairs(ReplicatedStorage:GetDescendants()) do
                if o:IsA("RemoteEvent") and o.Name:lower():find("gate") then pcall(function() o:FireServer() end) end
            end
        end
    end)
end

-- =====================================================
-- LIGHTWEIGHT: TOGGLE HANDLER
-- =====================================================
local function Toggle(key, state)
    t[key] = state
    if key == "fly" and not state then StopFly() end
    if key == "invisible" and not state then StopInvisible() end
    if key == "autoGenerator" and not state then StopAutoGen() end
    if key == "noClip" and not state then StopNoClip() end
    if key == "godMode" and not state then StopGodMode() end
    if key == "espKiller" or key == "espSurvivor" or key == "espGenerator" or key == "espHook" or key == "espPallet" then
        local any = t.espKiller or t.espSurvivor or t.espGenerator or t.espHook or t.espPallet
        if not any then StopESP() else if not espActive then StartESP() end end
    end
    
    if state then
        if key == "fly" then StartFly()
        elseif key == "invisible" then StartInvisible()
        elseif key == "autoGenerator" then StartAutoGen()
        elseif key == "noClip" then StartNoClip()
        elseif key == "godMode" then StartGodMode()
        elseif key == "speedHack" then local h = GetHumanoid(); if h then h.WalkSpeed = 60 end
        elseif key == "superJump" then local h = GetHumanoid(); if h then h.JumpPower = 150 end
        elseif key == "autoParry" then
            task.spawn(function() while t.autoParry do pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) task.wait(0.1) end end)
        elseif key == "antiAFK" then
            task.spawn(function() while t.antiAFK do pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) task.wait(30) end end)
        elseif key == "autoSkill" then StartAutoSkill()
        elseif key == "instantEscape" then StartInstantEscape()
        elseif key == "forceEnd" then StartForceEnd()
        elseif key == "antiBlind" then
            task.spawn(function()
                while t.antiBlind do
                    for _, g in pairs(LocalPlayer.PlayerGui and LocalPlayer.PlayerGui:GetDescendants() or {}) do
                        if g:IsA("Frame") or g:IsA("ImageLabel") then
                            local n = g.Name:lower()
                            if n:find("blind") or n:find("flash") or n:find("overlay") then pcall(function() g.Visible = false end) end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
end

-- =====================================================
-- =====================================================
-- ⚡ GUI 6LOCC STYLE + LOGO + LIGHTWEIGHT
-- =====================================================
-- =====================================================

local GUI = Instance.new("ScreenGui")
GUI.Parent = CoreGui
GUI.Name = "ZipHubLite"
GUI.ResetOnSpawn = false

-- MAIN FRAME (SIZE KECIL – 6LOCC STYLE)
local Main = Instance.new("Frame")
Main.Parent = GUI
Main.Size = UDim2.new(0, 280, 0, 340)
Main.Position = UDim2.new(0.5, -140, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Draggable = true

local MC = Instance.new("UICorner")
MC.Parent = Main
MC.CornerRadius = UDim.new(0, 8)

local MB = Instance.new("UIStroke")
MB.Parent = Main
MB.Color = Color3.fromRGB(0, 200, 255)
MB.Thickness = 1
MB.Transparency = 0.3

-- HEADER (KECIL)
local Header = Instance.new("Frame")
Header.Parent = Main
Header.Size = UDim2.new(1, 0, 0, 38)
Header.BackgroundColor3 = Color3.fromRGB(0, 80, 180)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0

local HC = Instance.new("UICorner")
HC.Parent = Header
HC.CornerRadius = UDim.new(0, 8)

-- LOGO + NAMA ZIP
local LogoFrame = Instance.new("Frame")
LogoFrame.Parent = Header
LogoFrame.Size = UDim2.new(0, 28, 0, 28)
LogoFrame.Position = UDim2.new(0, 6, 0.5, -14)
LogoFrame.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
LogoFrame.BackgroundTransparency = 0
LogoFrame.BorderSizePixel = 0

local LFC = Instance.new("UICorner")
LFC.Parent = LogoFrame
LFC.CornerRadius = UDim.new(1, 0)

-- Icon "Z" di logo
local LogoText = Instance.new("TextLabel")
LogoText.Parent = LogoFrame
LogoText.Size = UDim2.new(1, 0, 1, 0)
LogoText.BackgroundTransparency = 1
LogoText.Text = "Z"
LogoText.TextColor3 = Color3.fromRGB(10, 10, 25)
LogoText.TextSize = 18
LogoText.Font = Enum.Font.GothamBold

-- Title "ZIP HUB"
local Title = Instance.new("TextLabel")
Title.Parent = Header
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.Position = UDim2.new(0, 38, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZIP HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Sub "v55.0"
local Sub = Instance.new("TextLabel")
Sub.Parent = Header
Sub.Size = UDim2.new(0.3, 0, 1, 0)
Sub.Position = UDim2.new(0.65, 0, 0, 0)
Sub.BackgroundTransparency = 1
Sub.Text = "v55.0"
Sub.TextColor3 = Color3.fromRGB(100, 200, 255)
Sub.TextSize = 10
Sub.Font = Enum.Font.GothamMedium
Sub.TextXAlignment = Enum.TextXAlignment.Right

-- Close
local Close = Instance.new("TextButton")
Close.Parent = Header
Close.Size = UDim2.new(0, 20, 0, 20)
Close.Position = UDim2.new(1, -26, 0.5, -10)
Close.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
Close.Text = "✕"
Close.TextColor3 = Color3.fromRGB(255,255,255)
Close.TextSize = 11
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0

local CC = Instance.new("UICorner")
CC.Parent = Close
CC.CornerRadius = UDim.new(1,0)

Close.MouseButton1Click:Connect(function() GUI:Destroy() end)

-- SCROLL
local Scroll = Instance.new("ScrollingFrame")
Scroll.Parent = Main
Scroll.Size = UDim2.new(1, -8, 1, -46)
Scroll.Position = UDim2.new(0, 4, 0, 42)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
Scroll.BorderSizePixel = 0

-- =====================================================
-- CREATE TOGGLE (6LOCC STYLE – KECIL)
-- =====================================================
local function CreateToggle(text, key, y)
    local f = Instance.new("Frame")
    f.Parent = Scroll
    f.Size = UDim2.new(1, -4, 0, 32)
    f.Position = UDim2.new(0, 0, 0, y)
    f.BackgroundColor3 = Color3.fromRGB(20, 20, 45)
    f.BackgroundTransparency = 0.15
    f.BorderSizePixel = 1
    f.BorderColor3 = Color3.fromRGB(0, 150, 255)

    local fc = Instance.new("UICorner")
    fc.Parent = f
    fc.CornerRadius = UDim.new(0, 4)

    local l = Instance.new("TextLabel")
    l.Parent = f
    l.Size = UDim2.new(0.6, 0, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(255,255,255)
    l.TextSize = 11
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left

    local btn = Instance.new("TextButton")
    btn.Parent = f
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -46, 0.5, -10)
    btn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    btn.Text = "OFF"
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0

    local bc = Instance.new("UICorner")
    bc.Parent = btn
    bc.CornerRadius = UDim.new(0, 3)

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and "ON" or "OFF"
        btn.BackgroundColor3 = state and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(180, 40, 40)
        Toggle(key, state)
    end)
    return y + 36
end

-- =====================================================
-- DAFTAR TOGGLE (6LOCC STYLE – RINGKAS)
-- =====================================================
local y = 2
y = CreateToggle("✈️ Fly", "fly", y)
y = CreateToggle("👻 Invisible", "invisible", y)
y = CreateToggle("⚡ Auto Gen", "autoGenerator", y)
y = CreateToggle("🚪 No Clip", "noClip", y)
y = CreateToggle("🛡️ God Mode", "godMode", y)
y = CreateToggle("💨 Speed", "speedHack", y)
y = CreateToggle("🦘 Super Jump", "superJump", y)
y = CreateToggle("🛡️ Auto Parry", "autoParry", y)
y = CreateToggle("⏰ Anti AFK", "antiAFK", y)
y = CreateToggle("🔴 Killer ESP", "espKiller", y)
y = CreateToggle("🟢 Survivor ESP", "espSurvivor", y)
y = CreateToggle("⚡ Gen ESP", "espGenerator", y)
y = CreateToggle("🪝 Hook ESP", "espHook", y)
y = CreateToggle("📦 Pallet ESP", "espPallet", y)
y = CreateToggle("🎯 Auto Skill", "autoSkill", y)
y = CreateToggle("🏃 Inst Escape", "instantEscape", y)
y = CreateToggle("🚪 Force End", "forceEnd", y)
y = CreateToggle("👁️ Anti Blind", "antiBlind", y)

Scroll.CanvasSize = UDim2.new(0, 0, 0, y + 10)

-- =====================================================
-- WATERMARK
-- =====================================================
local WM = Instance.new("TextLabel")
WM.Parent = GUI
WM.Size = UDim2.new(0, 120, 0, 14)
WM.Position = UDim2.new(0, 6, 1, -20)
WM.BackgroundTransparency = 1
WM.Text = "⚡ ZIP HUB v55.0"
WM.TextColor3 = Color3.fromRGB(0, 200, 255)
WM.TextSize = 9
WM.Font = Enum.Font.GothamMedium
WM.TextTransparency = 0.5

-- =====================================================
-- AUTO START ESP
-- =====================================================
task.wait(0.3)
Toggle("espKiller", true)
Toggle("espSurvivor", true)
Toggle("espGenerator", true)
Toggle("espHook", true)
Toggle("espPallet", true)

print("✅ ZIP HUB v55.0 – 6LOCC LIGHTWEIGHT EDITION LOADED!")
print("✅ 18 FITUR – GUI KECIL + LOGO ZIP – NO LAG!")
