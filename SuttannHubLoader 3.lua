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
local pastebin_user_key = "" -- kalau nggak pakai login user, biarkan kosong
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

-- Intro GUI
local introGui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", introGui)
frame.Size = UDim2.new(0,400,0,200)
frame.Position = UDim2.new(0.5,-200,0.5,-100)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,50)
title.Text = "🔑 SuttannHub Loader"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local KeyBox = Instance.new("TextBox", frame)
KeyBox.Size = UDim2.new(1,-20,0,40)
KeyBox.Position = UDim2.new(0,10,0,70)
KeyBox.PlaceholderText = "Enter your key"
KeyBox.Text = ""
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 18
KeyBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
KeyBox.TextColor3 = Color3.fromRGB(255,255,255)

local Submit = Instance.new("TextButton", frame)
Submit.Size = UDim2.new(0.5,-15,0,40)
Submit.Position = UDim2.new(0,10,1,-50)
Submit.Text = "Submit"
Submit.BackgroundColor3 = Color3.fromRGB(0,120,255)
Submit.TextColor3 = Color3.fromRGB(255,255,255)
Submit.Font = Enum.Font.GothamBold
Submit.TextSize = 18

-- Fungsi cek key
local function CheckKey(key)
    for line in string.gmatch(ValidKeyData, "[^
]+") do
        local savedKey, usedHWID = string.match(line,"(%S+)|?(%S*)")
        if savedKey == key then
            if usedHWID == "" or usedHWID == HWID then
                return true
            else
                return false,"Key sudah digunakan di device lain!"
            end
        end
    end
    return false,"Key tidak valid atau sudah direset, hubungi admin!"
end

-- Main GUI
local function OpenMainGUI()
    introGui:Destroy()

    local mainGui = Instance.new("ScreenGui", game.CoreGui)
    local bg = Instance.new("Frame", mainGui)
    bg.Size = UDim2.new(0,220,0,400)
    bg.Position = UDim2.new(0,20,0.5,-200)
    bg.BackgroundColor3 = Color3.fromRGB(25,25,25)

    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(1,0,0,40)
    title.Text = "🔥 SuttannHub"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255,255,255)

    -- Dragging GUI
    local dragging, dragInput, mousePos, framePos = false, nil, nil, nil
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = bg.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - mousePos
            bg.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)

    -- Toggle system
    local y = 50
    local function AddToggle(name, callback)
        local btn = Instance.new("TextButton", bg)
        btn.Size = UDim2.new(1,-20,0,30)
        btn.Position = UDim2.new(0,10,0,y)
        btn.Text = "[OFF] "..name
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16

        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = (state and "[ON] " or "[OFF] ") .. name
            pcall(callback,state)
            StarterGui:SetCore("SendNotification",{Title=name, Text=(state and "ON" or "OFF"), Duration=3})
        end)
        y = y + 35
    end

    -- ✅ FPS Boost aman
    AddToggle("FPS Boost", function(state)
        if state then
            for _,v in pairs(workspace:GetDescendants()) do
                if v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then
                    v.Enabled = false
                elseif v:IsA("SpotLight") or v:IsA("SurfaceLight") or v:IsA("PointLight") then
                    v.Enabled = false
                end
            end
            game.Lighting.GlobalShadows = false
            game.Lighting.FogEnd = 9e9
        else
            game.Lighting.GlobalShadows = true
        end
    end)

    -- Mod Detection
    AddToggle("Mod Detection", function(state)
        local modAdminOwnerList = {
            ["GroupHolderCosmic"]=true,
            ["Halax"]=true,
            ["zCxsmic"]=true,
            ["555wick"]=true,
            ["Skythrill9"]=true
        }
        if state then
            for _,plr in pairs(Players:GetPlayers()) do
                if modAdminOwnerList[plr.Name] then
                    StarterGui:SetCore("SendNotification",{Title="⚠️ Mod/Admin Detected",Text=plr.Name.." ada di server!",Duration=5})
                end
            end
            Players.PlayerAdded:Connect(function(plr)
                if modAdminOwnerList[plr.Name] then
                    StarterGui:SetCore("SendNotification",{Title="⚠️ Mod/Admin Detected",Text=plr.Name.." join server!",Duration=5})
                end
            end)
        end
    end)

    -- External features
    AddToggle("Name", function(state) if state then loadstring(game:HttpGet('https://pastebin.com/raw/SDSsfiVN'))() end end)
    AddToggle("Show Guns", function(state) if state then loadstring(game:HttpGet("https://raw.githubusercontent.com/hellmid122/script-0x391/main/guns"))() end end)
    AddToggle("Health", function(state) if state then loadstring(game:HttpGet('https://pastebin.com/raw/mxLC8P1L'))() end end)
    AddToggle("Distance", function(state) if state then loadstring(game:HttpGet('https://pastebin.com/raw/nDnBxSyZ'))() end end)
    AddToggle("Skeleton", function(state) if state then loadstring(game:HttpGet("https://raw.githubusercontent.com/melvin123gp/shit/refs/heads/main/skeleto"))() end end)
    AddToggle("Cham", function(state) if state then loadstring(game:HttpGet("https://raw.githubusercontent.com/melvin123gp/e21/refs/heads/main/111"))() end end)

    -- Hide/Show GUI Button
    local hideBtn = Instance.new("TextButton", mainGui)
    hideBtn.Size = UDim2.new(0,60,0,25)
    hideBtn.Position = UDim2.new(1,-65,0,5)
    hideBtn.Text = "Hide"
    hideBtn.Font = Enum.Font.GothamBold
    hideBtn.TextSize = 14
    hideBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
    hideBtn.TextColor3 = Color3.fromRGB(255,255,255)

    local hidden = false
    hideBtn.MouseButton1Click:Connect(function()
        hidden = not hidden
        bg.Visible = not hidden
        hideBtn.Text = hidden and "Show" or "Hide"
    end)

    -- Jalankan script utama SuttannHubV3
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Mereeeecuf/Scriptbro/refs/heads/main/SuttannHubV3"))()
    end)
end

-- Cek apakah sudah ada file key
local savedKey = nil
if isfile and readfile and isfile(keyFile) then
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(keyFile)) end)
    if ok and data and data.Key and data.HWID == HWID then
        savedKey = data.Key
    end
end

-- Auto login atau input key
if savedKey then
    local valid,msg = CheckKey(savedKey)
    if valid then
        StarterGui:SetCore("SendNotification",{Title="✅ Auto Login",Text="Welcome back to SuttannHub",Duration=3})
        OpenMainGUI()
    else
        StarterGui:SetCore("SendNotification",{Title="❌ Key Error",Text=msg,Duration=5})
    end
else
    Submit.MouseButton1Click:Connect(function()
        local key = KeyBox.Text
        local valid,msg = CheckKey(key)
        if valid then
            StarterGui:SetCore("SendNotification",{Title="✅ Key Valid",Text="Welcome to SuttannHub",Duration=3})
            -- Simpan key + HWID
            if writefile then
                local data = HttpService:JSONEncode({Key=key,HWID=HWID})
                writefile(keyFile, data)
            end
            OpenMainGUI()
        else
            StarterGui:SetCore("SendNotification",{Title="❌ Key Error",Text=msg,Duration=5})
        end
    end)
end
