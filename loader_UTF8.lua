
--// Loader Final Versi 4 - SuttannHub (Update FPS Boost Aman + Pastebin API)

-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- HWID unik
local HWID = tostring(game:GetService("RbxAnalyticsService"):GetClientId())

-- Pastebin API Setup
local pastebin_api_dev_key = "sWadCtMzLezIsOrFCcQsBhGQGMOIlmi2"
local pastebin_user_key = "" -- kosong jika tidak pakai login
local paste_id = "c7DnMX7z" -- ID paste yang berisi daftar key

-- Fungsi ambil key dari Pastebin
local function GetPastebinRaw(paste_id)
    local success, result = pcall(function()
        return game:HttpGet("https://pastebin.com/raw/"..paste_id)
    end)
    if success then
        return result
    else
        warn("Gagal ambil key dari Pastebin")
        return ""
    end
end

local ValidKeyData = GetPastebinRaw(paste_id)

-- File untuk simpan key
local keyFile = "SuttannHubKey.json"
