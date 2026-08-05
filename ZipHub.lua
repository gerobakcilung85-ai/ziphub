-- ========================================
-- ZIP HUB - UNIVERSAL LOADER
-- VERSION 3.0 (FULL THEME ZIP)
-- ========================================

local VERSION = "3.0"
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
-- 🔥 FUNGSI TAMBAHAN (OPSIONAL)
-- ========================================

-- Fungsi untuk menambah game ke database (bisa dipanggil manual)
function AddGame(gameId, scriptUrl)
    games[gameId] = scriptUrl
    print(string.format("[%s] Game ID %d ditambahkan!", HUB_NAME, gameId))
end

-- Fungsi untuk melihat daftar game yang didukung
function ListSupportedGames()
    print(string.format("[%s] Daftar game yang didukung:", HUB_NAME))
    for id, url in pairs(games) do
        print(string.format("  - ID: %d -> %s", id, url))
    end
end

-- Fungsi untuk reload script (jika diperlukan)
function ReloadScript()
    local currentURL = games[universeId] or games[placeId]
    if currentURL then
        print(string.format("[%s] Reloading script...", HUB_NAME))
        loadstring(game:HttpGet(currentURL))()
    else
        print(string.format("[%s] Tidak ada script untuk reload!", HUB_NAME))
    end
end

-- ========================================
-- 🔥 STATUS
-- ========================================
print(string.format("[%s] Loader siap!", HUB_NAME))
print(string.format("[%s] Ketik ListSupportedGames() untuk melihat game yang didukung", HUB_NAME))
