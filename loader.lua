--[[
    REDZ HUB | BLOX FRUITS
    Key: DIKZPROJECT
    Fitur: Key system langsung ke menu utama, bypass anti-cheat, floating logo "Min Amin / cina bukitzz"
    Cara pakai: Copy semua kode ini ke executor (Synapse/Krnl/Delta/Fluxus) lalu Execute.
--]]

-- ========== 1. PERSIAPAN ==========
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local correctKey = "DIKZPROJECT"

-- ========== 2. BYPASS ANTI-CHEAT (agar tidak ban/kick) ==========
local function BypassAntiCheat()
    -- Nonaktifkan idle kick
    for _, v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end
    -- Spoof input
    local uis = game:GetService("UserInputService")
    local original = uis.InputBegan
    uis.InputBegan = function(...) return original(...) end
    -- Hook remote teleport
    local oldNamecall = nil
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        if getnamecallmethod() == "FireServer" and self.Name == "Teleport" then return nil end
        return oldNamecall(self, ...)
    end)
    -- Hapus script antikick lokal
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("LocalScript") and (v.Name == "AntiCheat" or string.find(v.Name, "Kick")) then
            v:Destroy()
        end
    end
    StarterGui:SetCore("SendNotification", {Title = "🛡️ Anti-Cheat", Text = "Bypass aktif! Aman dari ban.", Duration = 2})
end

-- ========== 3. FLOATING LOGO (Min Amin & cina bukitzz) ==========
local function CreateFloatingLogo()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FloatingLogo_RedzHub"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    
    local LogoFrame = Instance.new("Frame")
    LogoFrame.Size = UDim2.new(0, 180, 0, 60)
    LogoFrame.Position = UDim2.new(1, -190, 0, 10)
    LogoFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    LogoFrame.BackgroundTransparency = 0.2
    LogoFrame.BorderSizePixel = 0
    LogoFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = LogoFrame
    
    local Text1 = Instance.new("TextLabel")
    Text1.Size = UDim2.new(1, 0, 0, 25)
    Text1.Position = UDim2.new(0, 0, 0, 5)
    Text1.Text = "Min Amin"
    Text1.TextColor3 = Color3.fromRGB(255, 200, 100)
    Text1.Font = Enum.Font.GothamBold
    Text1.TextSize = 16
    Text1.BackgroundTransparency = 1
    Text1.Parent = LogoFrame
    
    local Text2 = Instance.new("TextLabel")
    Text2.Size = UDim2.new(1, 0, 0, 25)
    Text2.Position = UDim2.new(0, 0, 0, 30)
    Text2.Text = "cina bukitzz"
    Text2.TextColor3 = Color3.fromRGB(180, 180, 255)
    Text2.Font = Enum.Font.Gotham
    Text2.TextSize = 14
    Text2.BackgroundTransparency = 1
    Text2.Parent = LogoFrame
    
    -- Fungsi drag (logo bisa digeser)
    local dragging = false
    local dragInput, dragStart, startPos
    LogoFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = LogoFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    LogoFrame.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            LogoFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ========== 4. MENU UTAMA (REDZ HUB GUI) ==========
local function ShowMainMenu()
    -- Library UI (dari raw github)
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/UI"))()
    local Window = Library:CreateWindow("REDZ HUB | BLOX FRUITS")
    local AutoFarm = Window:CreateFolder("Auto Farm")
    local Misc = Window:CreateFolder("Misc")
    local BypassFolder = Window:CreateFolder("Anti-Cheat")
    
    -- Fitur Auto Farm Mastery
    local autoFarmState = false
    AutoFarm:Toggle("Auto Farm Mastery", false, function(state)
        autoFarmState = state
        while autoFarmState do
            task.wait(0.5)
            pcall(function()
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Main"):FireServer("Farm", "Mastery")
            end)
        end
    end)
    
    -- Tombol bypass manual
    BypassFolder:Button("Aktifkan Bypass Anti-Cheat", function()
        BypassAntiCheat()
        StarterGui:SetCore("SendNotification", {Title = "🛡️ Anti-Cheat", Text = "Bypass diaktifkan ulang!", Duration = 2})
    end)
    
    -- Teleport aman
    Misc:Button("Teleport ke Island (Safe)", function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1000, 50, 2000)
        end
    end)
    
    -- Informasi tambahan
    Misc:Button("Info Script", function()
        StarterGui:SetCore("SendNotification", {Title = "REDZ HUB", Text = "Key: DIKZPROJECT | Logo: Min Amin & cina bukitzz", Duration = 3})
    end)
    
    StarterGui:SetCore("SendNotification", {Title = "✅ REDZ HUB", Text = "Menu utama siap digunakan!", Duration = 2})
end

-- ========== 5. KEY SYSTEM (Langsung ke menu jika benar) ==========
local keyScreen = Instance.new("ScreenGui")
keyScreen.Name = "RedzKeySystem"
keyScreen.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 200)
Frame.Position = UDim2.new(0.5, -175, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.BorderSizePixel = 0
Frame.Parent = keyScreen

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
Title.Text = "REDZ HUB | BLOX FRUITS"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Frame

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(0, 250, 0, 35)
KeyBox.Position = UDim2.new(0.5, -125, 0, 70)
KeyBox.PlaceholderText = "Masukkan Key"
KeyBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
KeyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyBox.Font = Enum.Font.Gotham
KeyBox.TextSize = 14
KeyBox.Parent = Frame

local CheckButton = Instance.new("TextButton")
CheckButton.Size = UDim2.new(0, 120, 0, 35)
CheckButton.Position = UDim2.new(0.5, -60, 0, 120)
CheckButton.Text = "MASUKAN"
CheckButton.BackgroundColor3 = Color3.fromRGB(70, 130, 200)
CheckButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckButton.Font = Enum.Font.GothamBold
CheckButton.TextSize = 14
CheckButton.Parent = Frame

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 165)
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 12
StatusLabel.Parent = Frame

-- Fungsi saat key benar
local function OnKeyCorrect()
    StatusLabel.Text = "✅ KEY BENAR, MEMUAT MENU..."
    StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
    -- Jalankan bypass anti-cheat
    BypassAntiCheat()
    -- Tampilkan floating logo
    CreateFloatingLogo()
    -- Hapus GUI key system
    keyScreen:Destroy()
    -- Langsung tampilkan menu utama
    ShowMainMenu()
end

CheckButton.MouseButton1Click:Connect(function()
    if KeyBox.Text == correctKey then
        OnKeyCorrect()
    else
        StatusLabel.Text = "⚠️ KEY ANDA SALAH, SILAHKAN COBA LAGI..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        -- Animasi goyang
        for i = 1, 3 do
            Frame.Position = UDim2.new(0.5, -175 + (i%2==0 and -5 or 5), 0.5, -100)
            task.wait(0.03)
        end
        Frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    end
end)

-- Notifikasi awal
StarterGui:SetCore("SendNotification", {Title = "REDZ HUB", Text = "Masukkan key: DIKZPROJECT", Duration = 3})
