--[[
    REDZ HUB – FIX VERSION
    Tanpa library eksternal, menu langsung muncul setelah key benar.
    Key: DIKZPROJECT
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local correctKey = "DIKZPROJECT"
local keyValid = false

-- ========== BYPASS ANTI-CHEAT ==========
local function BypassAntiCheat()
    pcall(function()
        for _, v in pairs(getconnections(LocalPlayer.Idled)) do v:Disable() end
    end)
    pcall(function()
        local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() == "FireServer" and self.Name == "Teleport" then return nil end
            return oldNamecall(self, ...)
        end)
    end)
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("LocalScript") and (v.Name == "AntiCheat" or string.find(v.Name, "Kick")) then
            pcall(function() v:Destroy() end)
        end
    end
    StarterGui:SetCore("SendNotification", {Title = "Anti-Cheat", Text = "Bypass aktif", Duration = 2})
end

-- ========== FLOATING LOGO ==========
local function CreateFloatingLogo()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FloatingLogo"
    screenGui.Parent = CoreGui
    screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 160, 0, 50)
    frame.Position = UDim2.new(1, -170, 0, 10)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local text1 = Instance.new("TextLabel")
    text1.Size = UDim2.new(1,0,0,22)
    text1.Position = UDim2.new(0,0,0,5)
    text1.Text = "Min Amin"
    text1.TextColor3 = Color3.fromRGB(255,200,100)
    text1.Font = Enum.Font.GothamBold
    text1.TextSize = 14
    text1.BackgroundTransparency = 1
    text1.Parent = frame
    
    local text2 = Instance.new("TextLabel")
    text2.Size = UDim2.new(1,0,0,22)
    text2.Position = UDim2.new(0,0,0,27)
    text2.Text = "cina bukitzz"
    text2.TextColor3 = Color3.fromRGB(180,180,255)
    text2.Font = Enum.Font.Gotham
    text2.TextSize = 12
    text2.BackgroundTransparency = 1
    text2.Parent = frame
    
    -- Draggable
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
end

-- ========== MENU UTAMA (Native GUI) ==========
local function ShowMainMenu()
    keyValid = true
    BypassAntiCheat()
    CreateFloatingLogo()
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RedzHubMenu"
    screenGui.Parent = CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 400, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35,35,45)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,40)
    title.BackgroundColor3 = Color3.fromRGB(55,55,65)
    title.Text = "REDZ HUB | BLOX FRUITS"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.Parent = mainFrame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,70,70)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = mainFrame
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Tombol Auto Farm
    local autoFarmBtn = Instance.new("TextButton")
    autoFarmBtn.Size = UDim2.new(0, 180, 0, 40)
    autoFarmBtn.Position = UDim2.new(0.5, -90, 0, 60)
    autoFarmBtn.Text = "Auto Farm (OFF)"
    autoFarmBtn.BackgroundColor3 = Color3.fromRGB(70,130,200)
    autoFarmBtn.TextColor3 = Color3.fromRGB(255,255,255)
    autoFarmBtn.Font = Enum.Font.GothamBold
    autoFarmBtn.Parent = mainFrame
    
    local autoFarmActive = false
    autoFarmBtn.MouseButton1Click:Connect(function()
        autoFarmActive = not autoFarmActive
        autoFarmBtn.Text = autoFarmActive and "Auto Farm (ON)" or "Auto Farm (OFF)"
        autoFarmBtn.BackgroundColor3 = autoFarmActive and Color3.fromRGB(100,200,100) or Color3.fromRGB(70,130,200)
        
        if autoFarmActive then
            task.spawn(function()
                while autoFarmActive and keyValid do
                    task.wait(0.5)
                    pcall(function()
                        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                        if remote then
                            local mainRemote = remote:FindFirstChild("Main")
                            if mainRemote then
                                mainRemote:FireServer("Farm", "Mastery")
                            end
                        end
                    end)
                end
            end)
        end
    end)
    
    -- Tombol Bypass Manual
    local bypassBtn = Instance.new("TextButton")
    bypassBtn.Size = UDim2.new(0, 180, 0, 40)
    bypassBtn.Position = UDim2.new(0.5, -90, 0, 120)
    bypassBtn.Text = "Bypass Anti-Cheat"
    bypassBtn.BackgroundColor3 = Color3.fromRGB(200,130,70)
    bypassBtn.TextColor3 = Color3.fromRGB(255,255,255)
    bypassBtn.Font = Enum.Font.GothamBold
    bypassBtn.Parent = mainFrame
    bypassBtn.MouseButton1Click:Connect(function()
        BypassAntiCheat()
        StarterGui:SetCore("SendNotification", {Title = "Bypass", Text = "Anti-cheat di-bypass", Duration = 2})
    end)
    
    -- Tombol Teleport
    local teleportBtn = Instance.new("TextButton")
    teleportBtn.Size = UDim2.new(0, 180, 0, 40)
    teleportBtn.Position = UDim2.new(0.5, -90, 0, 180)
    teleportBtn.Text = "Teleport ke Island"
    teleportBtn.BackgroundColor3 = Color3.fromRGB(70,130,200)
    teleportBtn.TextColor3 = Color3.fromRGB(255,255,255)
    teleportBtn.Font = Enum.Font.GothamBold
    teleportBtn.Parent = mainFrame
    teleportBtn.MouseButton1Click:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(1000, 50, 2000)
        end
    end)
    
    StarterGui:SetCore("SendNotification", {Title = "REDZ HUB", Text = "Menu utama siap!", Duration = 2})
end

-- ========== KEY SYSTEM (SEDERHANA) ==========
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "KeySystem"
keyGui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0.5, -150, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
frame.BorderSizePixel = 0
frame.Parent = keyGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,40)
title.BackgroundColor3 = Color3.fromRGB(45,45,55)
title.Text = "REDZ HUB - KEY SYSTEM"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0, 200, 0, 35)
keyBox.Position = UDim2.new(0.5, -100, 0, 60)
keyBox.PlaceholderText = "Masukkan Key"
keyBox.BackgroundColor3 = Color3.fromRGB(50,50,60)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 14
keyBox.Parent = frame

local submitBtn = Instance.new("TextButton")
submitBtn.Size = UDim2.new(0, 100, 0, 35)
submitBtn.Position = UDim2.new(0.5, -50, 0, 110)
submitBtn.Text = "MASUKAN"
submitBtn.BackgroundColor3 = Color3.fromRGB(70,130,200)
submitBtn.TextColor3 = Color3.fromRGB(255,255,255)
submitBtn.Font = Enum.Font.GothamBold
submitBtn.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1,0,0,25)
statusLabel.Position = UDim2.new(0,0,0,150)
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 11
statusLabel.Parent = frame

submitBtn.MouseButton1Click:Connect(function()
    if keyBox.Text == correctKey then
        statusLabel.Text = "✅ KEY BENAR, MEMUAT MENU..."
        statusLabel.TextColor3 = Color3.fromRGB(100,255,100)
        ShowMainMenu()
        keyGui:Destroy()
    else
        statusLabel.Text = "⚠️ KEY ANDA SALAH, COBA LAGI..."
        statusLabel.TextColor3 = Color3.fromRGB(255,100,100)
        for i = 1, 3 do
            frame.Position = UDim2.new(0.5, -150 + (i%2==0 and -5 or 5), 0.5, -90)
            task.wait(0.03)
        end
        frame.Position = UDim2.new(0.5, -150, 0.5, -90)
    end
end)

StarterGui:SetCore("SendNotification", {Title = "REDZ HUB", Text = "Masukkan key: DIKZPROJECT", Duration = 3})
