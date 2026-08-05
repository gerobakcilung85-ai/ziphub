-- ========================================
-- ZIP HUB - UNIVERSAL LOADER
-- VERSION 4.0 (NEW GUI & MENU)
-- ========================================

local VERSION = "4.0"
local HUB_NAME = "ZIP HUB"

-- ========================================
-- 🔥 DATABASE GAME (ZIP EDITION)
-- ========================================
local games = {
    -- Violence District (VD) - ZIP HUB FULL
    [6739698191] = "https://raw.githubusercontent.com/gerobakcilung85-ai/ziphub/main/ZipHub_Full.lua",
    
    -- Game dari Lynx (tetap support)
    [6701277882] = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/Fish_It.lua",
    [9691752199] = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/Sawah_Indo.lua",
    [7326934954] = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/99_nitf.lua",
    [8316902627] = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/pvb.lua",
    [9721900284] = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/fishzar.lua",
    [9546331833] = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/SambungKata.lua",
    [9465913467] = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/is.lua",
    [994732206]  = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/BloxFruit.lua"
}

-- ========================================
-- 🔥 AUTO DETECTION & LOADER
-- ========================================
local universeId = game.GameId
local placeId    = game.PlaceId
local scriptURL  = games[universeId] or games[placeId]

-- Cetak informasi HUB
print(string.format("[%s v%s] PlaceId: %d | UniverseId: %d", HUB_NAME, VERSION, placeId, universeId))

if scriptURL then
    print(string.format("[%s] Game supported! UniverseId: %d", HUB_NAME, universeId))
    print(string.format("[%s] Loading script...", HUB_NAME))

    local ok, err = pcall(function()
        loadstring(game:HttpGet(scriptURL))()
    end)

    if not ok then
        warn(string.format("[%s] Gagal load script: %s", HUB_NAME, tostring(err)))
    end
else
    -- ========================================
    -- 🔥 FALLBACK: GAME TIDAK TERDAFTAR
    -- ========================================
    local msg = string.format(
        "\n[%s] Game belum didukung!\nPlaceId: %d\nUniverseId: %d!\nMemuat ZIP HUB standar...",
        HUB_NAME, placeId, universeId
    )
    warn(msg)
    print(msg)
    
    -- Fallback: Load ZIP HUB dari repository utama
    local fallbackURL = "https://raw.githubusercontent.com/gerobakcilung85-ai/ziphub/main/ZipHub_Full.lua"
    local ok, err = pcall(function()
        loadstring(game:HttpGet(fallbackURL))()
    end)
    
    if not ok then
        warn(string.format("[%s] Gagal load fallback script: %s", HUB_NAME, tostring(err)))
        print("[ZIP HUB] Tidak ada script yang bisa dimuat!")
    end
end

-- ========================================
-- 🔥 GUI ZIPTEM (TAMPILAN BARU)
-- ========================================
local function CreateZIPGUI()
    -- Buat ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Parent = game:GetService("CoreGui")
    ScreenGui.Name = "ZipHubGUI"
    ScreenGui.ResetOnSpawn = false

    -- Main Frame (Dengan tema ZIP)
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 400, 0, 500)
    MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
    MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = true
    MainFrame.Draggable = true

    -- Corner
    local UICorner = Instance.new("UICorner")
    UICorner.Parent = MainFrame
    UICorner.CornerRadius = UDim.new(0, 16)

    -- Border (Neon ZIP)
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Color = Color3.fromRGB(0, 180, 255)
    UIStroke.Thickness = 2
    UIStroke.Transparency = 0.3

    -- Glass Effect
    local GlassBg = Instance.new("Frame")
    GlassBg.Parent = MainFrame
    GlassBg.Size = UDim2.new(1, 0, 1, 0)
    GlassBg.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
    GlassBg.BackgroundTransparency = 0.75
    GlassBg.BorderSizePixel = 0

    -- ========================================
    -- HEADER ZIP
    -- ========================================
    local HeaderFrame = Instance.new("Frame")
    HeaderFrame.Parent = MainFrame
    HeaderFrame.Size = UDim2.new(1, 0, 0, 70)
    HeaderFrame.Position = UDim2.new(0, 0, 0, 0)
    HeaderFrame.BackgroundColor3 = Color3.fromRGB(0, 50, 100)
    HeaderFrame.BackgroundTransparency = 0.3
    HeaderFrame.BorderSizePixel = 0

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.Parent = HeaderFrame
    HeaderCorner.CornerRadius = UDim.new(0, 16)

    -- Logo ZIP (Teks besar)
    local LogoText = Instance.new("TextLabel")
    LogoText.Parent = HeaderFrame
    LogoText.Size = UDim2.new(0.5, 0, 1, 0)
    LogoText.Position = UDim2.new(0.25, 0, 0, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "ZIP"
    LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoText.TextSize = 35
    LogoText.Font = Enum.Font.GothamBlack
    LogoText.TextScaled = true
    LogoText.TextStrokeColor3 = Color3.fromRGB(0, 180, 255)
    LogoText.TextStrokeTransparency = 0.3

    -- Subtitle
    local SubTitle = Instance.new("TextLabel")
    SubTitle.Parent = HeaderFrame
    SubTitle.Size = UDim2.new(1, 0, 0, 20)
    SubTitle.Position = UDim2.new(0, 0, 1, -22)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Text = "⚡ ZIP HUB - UNIVERSAL LOADER"
    SubTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
    SubTitle.TextSize = 12
    SubTitle.Font = Enum.Font.GothamMedium

    -- Garis dekorasi
    local Line = Instance.new("Frame")
    Line.Parent = HeaderFrame
    Line.Size = UDim2.new(0.85, 0, 0, 2)
    Line.Position = UDim2.new(0.075, 0, 1, -3)
    Line.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
    Line.BackgroundTransparency = 0.4
    Line.BorderSizePixel = 0

    -- ========================================
    -- CLOSE BUTTON (X)
    -- ========================================
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = HeaderFrame
    CloseBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseBtn.Position = UDim2.new(1, -40, 0, 18)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 18
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.BorderSizePixel = 0

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.Parent = CloseBtn
    CloseCorner.CornerRadius = UDim.new(1, 0)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- ========================================
    -- SCROLLING FRAME (UNTUK MENU)
    -- ========================================
    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Parent = MainFrame
    ScrollingFrame.Size = UDim2.new(1, -20, 1, -90)
    ScrollingFrame.Position = UDim2.new(0, 10, 0, 80)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ScrollingFrame.ScrollBarThickness = 4
    ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 255)
    ScrollingFrame.BorderSizePixel = 0

    -- ========================================
    -- UI FUNCTIONS (TEMA ZIP)
    -- ========================================

    -- Category
    local function CreateCategory(text, yPos)
        local cat = Instance.new("TextLabel")
        cat.Parent = ScrollingFrame
        cat.Size = UDim2.new(1, -10, 0, 28)
        cat.Position = UDim2.new(0, 0, 0, yPos)
        cat.BackgroundTransparency = 1
        cat.Text = "▸ " .. text
        cat.TextColor3 = Color3.fromRGB(0, 200, 255)
        cat.TextSize = 14
        cat.Font = Enum.Font.GothamBold
        cat.TextXAlignment = Enum.TextXAlignment.Left
        return cat
    end

    -- Divider
    local function CreateDivider(yPos)
        local div = Instance.new("Frame")
        div.Parent = ScrollingFrame
        div.Size = UDim2.new(0.9, 0, 0, 2)
        div.Position = UDim2.new(0.05, 0, 0, yPos)
        div.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
        div.BackgroundTransparency = 0.5
        div.BorderSizePixel = 0
        return div
    end

    -- Toggle Button (ON/OFF)
    local function CreateToggle(text, yPos, callback)
        local frame = Instance.new("Frame")
        frame.Parent = ScrollingFrame
        frame.Size = UDim2.new(1, -10, 0, 34)
        frame.Position = UDim2.new(0, 0, 0, yPos)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 55)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 1
        frame.BorderColor3 = Color3.fromRGB(0, 180, 255)

        local corner = Instance.new("UICorner")
        corner.Parent = frame
        corner.CornerRadius = UDim.new(0, 8)

        local label = Instance.new("TextLabel")
        label.Parent = frame
        label.Size = UDim2.new(0.6, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(220, 220, 255)
        label.TextSize = 12
        label.Font = Enum.Font.GothamMedium
        label.TextXAlignment = Enum.TextXAlignment.Left

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Parent = frame
        toggleBtn.Size = UDim2.new(0, 55, 0, 26)
        toggleBtn.Position = UDim2.new(1, -65, 0, 4)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
        toggleBtn.Text = "OFF"
        toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        toggleBtn.TextSize = 11
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.BorderSizePixel = 0

        local toggleCorner = Instance.new("UICorner")
        toggleCorner.Parent = toggleBtn
        toggleCorner.CornerRadius = UDim.new(0, 6)

        local state = false
        toggleBtn.MouseButton1Click:Connect(function()
            state = not state
            toggleBtn.Text = state and "ON" or "OFF"
            toggleBtn.BackgroundColor3 = state and Color3.fromRGB(40, 200, 40) or Color3.fromRGB(200, 40, 40)
            callback(state)
        end)

        return toggleBtn
    end

    -- Action Button
    local function CreateButton(text, yPos, callback, color)
        local btn = Instance.new("TextButton")
        btn.Parent = ScrollingFrame
        btn.Size = UDim2.new(1, -10, 0, 34)
        btn.Position = UDim2.new(0, 0, 0, yPos)
        btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 70)
        btn.BackgroundTransparency = 0.3
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamMedium
        btn.BorderSizePixel = 1
        btn.BorderColor3 = Color3.fromRGB(0, 180, 255)

        local corner = Instance.new("UICorner")
        corner.Parent = btn
        corner.CornerRadius = UDim.new(0, 8)

        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- ========================================
    -- 📋 MENU (TEMA ZIP)
    -- ========================================
    local yPos = 5

    -- GAME SUPPORT
    CreateCategory("🎮 SUPPORTED GAMES", yPos)
    yPos = yPos + 32

    CreateButton("🎯 Violence District (LOAD)", yPos, function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/gerobakcilung85-ai/ziphub/main/ZipHub_Full.lua"))()
    end, Color3.fromRGB(0, 100, 200))
    yPos = yPos + 38

    CreateButton("🎯 Fish It (LOAD)", yPos, function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/Fish_It.lua"))()
    end, Color3.fromRGB(0, 100, 200))
    yPos = yPos + 38

    CreateButton("🎯 Sawah Indo (LOAD)", yPos, function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/Sawah_Indo.lua"))()
    end, Color3.fromRGB(0, 100, 200))
    yPos = yPos + 38

    CreateButton("🎯 Blox Fruit (LOAD)", yPos, function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/BloxFruit.lua"))()
    end, Color3.fromRGB(0, 100, 200))
    yPos = yPos + 38

    -- DIVIDER
    CreateDivider(yPos)
    yPos = yPos + 14

    -- SETTINGS
    CreateCategory("⚙️ SETTINGS", yPos)
    yPos = yPos + 32

    CreateButton("📋 List Supported Games", yPos, function()
        ListSupportedGames()
    end, Color3.fromRGB(50, 50, 80))
    yPos = yPos + 38

    CreateButton("🔄 Reload Script", yPos, function()
        ReloadScript()
    end, Color3.fromRGB(50, 50, 80))
    yPos = yPos + 38

    -- DIVIDER
    CreateDivider(yPos)
    yPos = yPos + 14

    -- VERSION
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Parent = ScrollingFrame
    versionLabel.Size = UDim2.new(1, -10, 0, 25)
    versionLabel.Position = UDim2.new(0, 0, 0, yPos)
    versionLabel.BackgroundTransparency = 1
    versionLabel.Text = "ZIP HUB v" .. VERSION .. " - © 2026"
    versionLabel.TextColor3 = Color3.fromRGB(100, 100, 150)
    versionLabel.TextSize = 12
    versionLabel.Font = Enum.Font.GothamMedium
    versionLabel.TextXAlignment = Enum.TextXAlignment.Center
    yPos = yPos + 30

    -- Update Canvas
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)

    -- ========================================
    -- WATERMARK
    -- ========================================
    local Watermark = Instance.new("TextLabel")
    Watermark.Parent = ScreenGui
    Watermark.Size = UDim2.new(0, 160, 0, 18)
    Watermark.Position = UDim2.new(0, 8, 1, -25)
    Watermark.BackgroundTransparency = 1
    Watermark.Text = "⚡ ZIP HUB"
    Watermark.TextColor3 = Color3.fromRGB(0, 180, 255)
    Watermark.TextSize = 10
    Watermark.Font = Enum.Font.GothamMedium
    Watermark.TextTransparency = 0.4

    print("✅ ZIP HUB - NEW GUI LOADED!")
end

-- ========================================
-- 🔥 JALANKAN GUI
-- ========================================
CreateZIPGUI()

-- ========================================
-- 🔥 FUNGSI TAMBAHAN
-- ========================================
function AddGame(gameId, scriptUrl)
    games[gameId] = scriptUrl
    print(string.format("[%s] Game ID %d ditambahkan!", HUB_NAME, gameId))
end

function ListSupportedGames()
    print(string.format("[%s] Daftar game yang didukung:", HUB_NAME))
    for id, url in pairs(games) do
        print(string.format("  - ID: %d -> %s", id, url))
    end
end

function ReloadScript()
    local currentURL = games[universeId] or games[placeId]
    if currentURL then
        print(string.format("[%s] Reloading script...", HUB_NAME))
        loadstring(game:HttpGet(currentURL))()
    else
        print(string.format("[%s] Tidak ada script untuk reload!", HUB_NAME))
    end
end

print(string.format("[%s] Loader siap!", HUB_NAME))
print(string.format("[%s] Ketik ListSupportedGames() untuk melihat game yang didukung", HUB_NAME))
