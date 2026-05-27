-- REDZ HUB VERSION FINAL – 100% WORK
-- KEY: DIKZPROJECT
-- JIKALAU MASIH ERROR, GANTI EXECUTOR ATAU RESTART GAME.

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Pilih GUI parent yang paling mungkin berhasil (CoreGui atau PlayerGui)
local guiParent = nil
local success, err = pcall(function()
    guiParent = game:GetService("CoreGui")
end)
if not success or not guiParent then
    pcall(function()
        guiParent = LocalPlayer:WaitForChild("PlayerGui")
    end)
end
if not guiParent then
    -- fallback terakhir: buat ScreenGui sendiri di nil (tidak disarankan)
    guiParent = game:GetService("CoreGui")
end

local correctKey = "DIKZPROJECT"

-- ==================== BYPASS ANTI-CHEAT (AMAN) ====================
local function BypassAntiCheat()
    local success = pcall(function()
        -- Nonaktifkan idle kick
        for _, v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end
        -- Hook teleport remote
        local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() == "FireServer" and self.Name == "Teleport" then return nil end
            return oldNamecall(self, ...)
        end)
        -- Hapus script antikick
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("LocalScript") and (v.Name == "AntiCheat" or string.find(v.Name, "Kick")) then
                v:Destroy()
            end
        end
    end)
    StarterGui:SetCore("SendNotification", {
        Title = "Anti-Cheat",
        Text = success and "Bypass aktif" or "Bypass gagal (aman)",
        Duration = 2
    })
end

-- ==================== FLOATING LOGO ====================
local function CreateFloatingLogo()
    local success, screenGui = pcall(function()
        local sg = Instance.new("ScreenGui")
        sg.Name = "RedzLogo"
        sg.Parent = guiParent
        sg.ResetOnSpawn = false
        
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0, 150, 0, 45)
        frame.Position = UDim2.new(1, -160, 0, 10)
        frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
        frame.BackgroundTransparency = 0.3
        frame.BorderSizePixel = 0
        frame.Parent = sg
        
        local t1 = Instance.new("TextLabel")
        t1.Size = UDim2.new(1,0,0,20)
        t1.Position = UDim2.new(0,0,0,5)
        t1.Text = "Min Amin"
        t1.TextColor3 = Color3.fromRGB(255,200,100)
        t1.Font = Enum.Font.GothamBold
        t1.TextSize = 14
        t1.BackgroundTransparency = 1
        t1.Parent = frame
        
        local t2 = Instance.new("TextLabel")
        t2.Size = UDim2.new(1,0,0,20)
        t2.Position = UDim2.new(0,0,0,25)
        t2.Text = "cina bukitzz"
        t2.TextColor3 = Color3.fromRGB(180,180,255)
        t2.Font = Enum.Font.Gotham
        t2.TextSize = 12
        t2.BackgroundTransparency = 1
        t2.Parent = frame
        
        -- Drag sederhana
        local dragging = false
        local dragStart, startPos
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        frame.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        return sg
    end)
    if not success then
        -- gagal buat logo, abaikan
    end
end

-- ==================== MENU UTAMA (SEDERHANA TAPI PASTI MUNCUL) ====================
local function ShowMainMenu()
    -- Hapus GUI key jika masih ada
    for _, child in pairs(guiParent:GetChildren()) do
        if child.Name == "KeySystemGUI" then
            pcall(function() child:Destroy() end)
        end
    end
    
    local mainGui = Instance.new("ScreenGui")
    mainGui.Name = "RedzHubMain"
    mainGui.Parent = guiParent
    mainGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 320, 0, 240)
    frame.Position = UDim2.new(0.5, -160, 0.5, -120)
    frame.BackgroundColor3 = Color3.fromRGB(35,35,45)
    frame.BorderSizePixel = 0
    frame.Parent = mainGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,35)
    title.BackgroundColor3 = Color3.fromRGB(55,55,65)
    title.Text = "REDZ HUB | BLOX FRUITS"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.Parent = frame
    
    -- Tombol Close
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -35, 0, 2.5)
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.BackgroundColor3 = Color3.fromRGB(200,70,70)
    close.Font = Enum.Font.GothamBold
    close.Parent = frame
    close.MouseButton1Click:Connect(function() mainGui:Destroy() end)
    
    -- Auto Farm toggle
    local autoBtn = Instance.new("TextButton")
    autoBtn.Size = UDim2.new(0, 140, 0, 40)
    autoBtn.Position = UDim2.new(0.5, -70, 0, 55)
    autoBtn.Text = "Auto Farm (OFF)"
    autoBtn.BackgroundColor3 = Color3.fromRGB(70,130,200)
    autoBtn.TextColor3 = Color3.fromRGB(255,255,255)
    autoBtn.Font = Enum.Font.GothamBold
    autoBtn.Parent = frame
    
    local autoActive = false
    autoBtn.MouseButton1Click:Connect(function()
        autoActive = not autoActive
        autoBtn.Text = autoActive and "Auto Farm (ON)" or "Auto Farm (OFF)"
        autoBtn.BackgroundColor3 = autoActive and Color3.fromRGB(100,200,100) or Color3.fromRGB(70,130,200)
        if autoActive then
            task.spawn(function()
                while autoActive do
                    task.wait(0.5)
                    pcall(function()
                        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                        if remote and remote:FindFirstChild("Main") then
                            remote.Main:FireServer("Farm", "Mastery")
                        end
                    end)
                end
            end)
        end
    end)
    
    -- Bypass manual
    local bypassBtn = Instance.new("TextButton")
    bypassBtn.Size = UDim2.new(0, 140, 0, 40)
    bypassBtn.Position = UDim2.new(0.5, -70, 0, 110)
    bypassBtn.Text = "Bypass Anti-Cheat"
    bypassBtn.BackgroundColor3 = Color3.fromRGB(200,130,70)
    bypassBtn.TextColor3 = Color3.fromRGB(255,255,255)
    bypassBtn.Font = Enum.Font.GothamBold
    bypassBtn.Parent = frame
    bypassBtn.MouseButton1Click:Connect(function()
        BypassAntiCheat()
        StarterGui:SetCore("SendNotification", {Title = "Bypass", Text = "Manual bypass", Duration = 2})
    end)
    
    -- Teleport
    local teleBtn = Instance.new("TextButton")
    teleBtn.Size = UDim2.new(0, 140, 0, 40)
    teleBtn.Position = UDim2.new(0.5, -70, 0, 165)
    teleBtn.Text = "Teleport ke Island"
    teleBtn.BackgroundColor3 = Color3.fromRGB(70,130,200)
    teleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    teleBtn.Font = Enum.Font.GothamBold
    teleBtn.Parent = frame
    teleBtn.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(1000, 50, 2000)
        end
    end)
    
    -- Status teks
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1,0,0,25)
    status.Position = UDim2.new(0,0,0,215)
    status.Text = "Ready | Key: DIKZPROJECT"
    status.TextColor3 = Color3.fromRGB(200,200,200)
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.BackgroundTransparency = 1
    status.Parent = frame
    
    -- Notifikasi sukses
    StarterGui:SetCore("SendNotification", {
        Title = "REDZ HUB",
        Text = "Menu utama berhasil dimuat!",
        Duration = 2
    })
end

-- ==================== KEY SYSTEM ====================
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeySystemGUI"
keyGui.Parent = guiParent

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 280, 0, 160)
keyFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
keyFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = keyGui

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1,0,0,35)
keyTitle.BackgroundColor3 = Color3.fromRGB(45,45,55)
keyTitle.Text = "REDZ HUB - KEY SYSTEM"
keyTitle.TextColor3 = Color3.fromRGB(255,255,255)
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 16
keyTitle.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0, 200, 0, 35)
keyBox.Position = UDim2.new(0.5, -100, 0, 55)
keyBox.PlaceholderText = "Masukkan Key"
keyBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.Parent = keyFrame

local submit = Instance.new("TextButton")
submit.Size = UDim2.new(0, 100, 0, 35)
submit.Position = UDim2.new(0.5, -50, 0, 105)
submit.Text = "MASUKAN"
submit.BackgroundColor3 = Color3.fromRGB(70,130,200)
submit.TextColor3 = Color3.fromRGB(255,255,255)
submit.Font = Enum.Font.GothamBold
submit.Parent = keyFrame

local keyStatus = Instance.new("TextLabel")
keyStatus.Size = UDim2.new(1,0,0,25)
keyStatus.Position = UDim2.new(0,0,0,140)
keyStatus.Text = ""
keyStatus.TextColor3 = Color3.fromRGB(255,100,100)
keyStatus.Font = Enum.Font.Gotham
keyStatus.TextSize = 11
keyStatus.Parent = keyFrame

submit.MouseButton1Click:Connect(function()
    if keyBox.Text == correctKey then
        keyStatus.Text = "✅ KEY BENAR, MEMUAT MENU..."
        keyStatus.TextColor3 = Color3.fromRGB(100,255,100)
        -- Eksekusi semuanya
        pcall(function()
            BypassAntiCheat()
            CreateFloatingLogo()
            ShowMainMenu()
            keyGui:Destroy()
        end)
        -- Verifikasi menu muncul
        task.wait(1)
        if not guiParent:FindFirstChild("RedzHubMain") then
            StarterGui:SetCore("SendNotification", {
                Title = "ERROR",
                Text = "Menu gagal dimuat, coba jalankan ulang script",
                Duration = 5
            })
        end
    else
        keyStatus.Text = "⚠️ KEY ANDA SALAH, COBA LAGI..."
        keyStatus.TextColor3 = Color3.fromRGB(255,100,100)
        for i = 1, 3 do
            keyFrame.Position = UDim2.new(0.5, -140 + (i%2==0 and -5 or 5), 0.5, -80)
            task.wait(0.03)
        end
        keyFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
    end
end)

-- Notifikasi awal
StarterGui:SetCore("SendNotification", {
    Title = "REDZ HUB",
    Text = "Masukkan key: DIKZPROJECT",
    Duration = 3
})
