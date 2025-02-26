local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Draggable = true
Frame.Active = true
Frame.Selectable = true

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Frame
TitleLabel.Text = "BizBlox by Kawin"
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18

local EnemyInput = Instance.new("TextBox")
EnemyInput.Parent = Frame
EnemyInput.PlaceholderText = "Enter Name"
EnemyInput.Size = UDim2.new(1, -70, 0, 40)
EnemyInput.Position = UDim2.new(0, 10, 0, 60)
EnemyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
EnemyInput.TextColor3 = Color3.fromRGB(255, 255, 255)

local ReloadButton = Instance.new("TextButton")
ReloadButton.Parent = Frame
ReloadButton.Text = "Reload"
ReloadButton.Size = UDim2.new(0, 48, 0, 40)
ReloadButton.Position = UDim2.new(1, -58, 0, 60)
ReloadButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
ReloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local EnemyList = Instance.new("ScrollingFrame")
EnemyList.Parent = Frame
EnemyList.Size = UDim2.new(1, -20, 0, 50)
EnemyList.Position = UDim2.new(0, 10, 0, 110)
EnemyList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
EnemyList.CanvasSize = UDim2.new(0, 0, 1, 0)
EnemyList.ScrollBarThickness = 5

local StartButton = Instance.new("TextButton")
StartButton.Parent = Frame
StartButton.Text = "Start"
StartButton.Size = UDim2.new(1, -20, 0, 50)
StartButton.Position = UDim2.new(0, 10, 0, 170)
StartButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 20

-- Create a ScreenGui and Button
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local virtualUser = game:GetService("VirtualUser")

local autoClicking = false

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:FindFirstChildOfClass("PlayerGui")

-- สร้างปุ่ม
local autom1 = Instance.new("TextButton")
autom1.Parent = Frame
autom1.Text = "Start / Auto M1"
autom1.Size = UDim2.new(1, -20, 0, 50)
autom1.Position = UDim2.new(0, 10, 0, 380)
autom1.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
autom1.TextColor3 = Color3.fromRGB(255, 255, 255)
autom1.Font = Enum.Font.GothamBold
autom1.TextSize = 20

-- ฟังก์ชัน Auto Click
local function autoClick()
    while autoClicking do
        if userInputService.TouchEnabled then
            -- รองรับ Mobile (แตะหน้าจอ)
            virtualUser:Button1Down(Vector2.new(0, 0)) 
            task.wait(0.05)
            virtualUser:Button1Up(Vector2.new(0, 0))
        else
            -- รองรับ PC (คลิกเมาส์)
            userInputService.InputBegan:Fire(Enum.UserInputType.MouseButton1, false)
        end
        task.wait(0.1) -- ปรับความเร็วคลิก (ค่าต่ำลง = เร็วขึ้น)
    end
end

-- เมื่อกดปุ่มให้สลับสถานะ Auto Click
autom1.MouseButton1Click:Connect(function()
    autoClicking = not autoClicking

    if autoClicking then
        button.Text = "Stop / Auto M1"
        autoClick()
    else
        button.Text = "Start / Auto M1"
    end
end)


local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer


-- สร้าง TextBox สำหรับใส่ชื่อเควส
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 0, 50)
textBox.Position = UDim2.new(0, 10, 0, 240)
textBox.PlaceholderText = "Enter Quest"
textBox.Text = ""
textBox.TextScaled = true
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.Parent = Frame

-- สร้างปุ่ม Start/Stop
local button = Instance.new("TextButton")
button.Parent = Frame
button.Text = "Start"
button.Size = UDim2.new(1, -20, 0, 50)
button.Position = UDim2.new(0, 10, 0, 310)
button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 20

local remoteEvent = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("GameEvent")
local running = false

-- ฟังก์ชันเริ่ม/หยุดการทำงาน
local function toggleQuest()
    running = not running
    if running then
        button.Text = "Stop"
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- สีแดง (Stop)
        while running do
            local questName = textBox.Text
            if questName and questName ~= "" then
                local args = {
                    [1] = "Quest",
                    [2] = questName
                }
                remoteEvent:FireServer(unpack(args))
            end
            wait(2) -- ส่งทุก 2 วินาที
        end
    else
        button.Text = "Start"
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0) -- สีเขียว (Start)
    end
end

-- เมื่อกดปุ่ม Start/Stop
button.MouseButton1Click:Connect(toggleQuest)


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HighlightFolder = Instance.new("Folder", game.Workspace)
HighlightFolder.Name = "ESP_Highlights"

-- สร้าง GUI ปุ่ม ESP
local EspButton = Instance.new("TextButton")
EspButton.Parent = Frame
EspButton.Size = UDim2.new(0, 80, 0, 40)
EspButton.Position = UDim2.new(0, -100, 0.315, 280)
EspButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.Font = Enum.Font.GothamBold
EspButton.TextSize = 20
EspButton.Text = "ESP"

local espEnabled = true -- เปิดใช้งาน ESP ตั้งแต่เริ่มต้น

local function createESP(player)
    if not espEnabled then return end
    if player == game.Players.LocalPlayer then return end
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = HighlightFolder
        highlight.Adornee = player.Character
        highlight.FillColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.7
        
        -- สร้าง BillboardGui แสดงชื่อ, Level, Money และเลือด
        local billboard = Instance.new("BillboardGui")
        billboard.Parent = player.Character:FindFirstChild("HumanoidRootPart")
        billboard.Size = UDim2.new(6, 0, 2, 0) -- ปรับขนาดให้ใหญ่ขึ้น
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.MaxDistance = math.huge -- ทำให้มองเห็นจากที่ไกล

        local nameLabel = Instance.new("TextLabel", billboard)
        nameLabel.Size = UDim2.new(1, 0, 0.2, 0)
        nameLabel.Position = UDim2.new(0, 0, 0.8, 0)
        nameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextStrokeColor3 = Color3.fromRGB(255, 0, 0)
        nameLabel.TextStrokeTransparency = 0
        nameLabel.TextScaled = true

        local levelLabel = Instance.new("TextLabel", billboard)
        levelLabel.Size = UDim2.new(1, 0, 0.2, 0)
        levelLabel.Position = UDim2.new(0, 0, 0.6, 0)
        levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        levelLabel.BackgroundTransparency = 1
        levelLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 0)
        levelLabel.TextStrokeTransparency = 0
        levelLabel.TextScaled = true

        local moneyLabel = Instance.new("TextLabel", billboard)
        moneyLabel.Size = UDim2.new(1, 0, 0.2, 0)
        moneyLabel.Position = UDim2.new(0, 0, 0.4, 0)
        moneyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        moneyLabel.BackgroundTransparency = 1
        moneyLabel.TextStrokeColor3 = Color3.fromRGB(0, 255, 0)
        moneyLabel.TextStrokeTransparency = 0
        moneyLabel.TextScaled = true
        
        local healthLabel = Instance.new("TextLabel", billboard)
        healthLabel.Size = UDim2.new(1, 0, 0.2, 0)
        healthLabel.Position = UDim2.new(0, 0, 0.2, 0)
        healthLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        healthLabel.BackgroundTransparency = 1
        healthLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
        healthLabel.TextStrokeTransparency = 0
        healthLabel.TextScaled = true
        
        local function updateStats()
            if player:FindFirstChild("Level") and player:FindFirstChild("Money") and player.Character:FindFirstChild("Humanoid") then
                levelLabel.Text = "Level (" .. tostring(player.Level.Value) .. ")"
                moneyLabel.Text = "$" .. tostring(player.Money.Value)
                healthLabel.Text = "HP: " .. tostring(math.floor(player.Character.Humanoid.Health)) .. "/" .. tostring(math.floor(player.Character.Humanoid.MaxHealth))
            end
        end

        updateStats()
        player.Level:GetPropertyChangedSignal("Value"):Connect(updateStats)
        player.Money:GetPropertyChangedSignal("Value"):Connect(updateStats)
        if player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(updateStats)
        end
    end
end

local function removeESP(player)
    for _, obj in ipairs(HighlightFolder:GetChildren()) do
        if obj:IsA("Highlight") and obj.Adornee == player.Character then
            obj:Destroy()
        end
    end
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        for _, gui in ipairs(player.Character.HumanoidRootPart:GetChildren()) do
            if gui:IsA("BillboardGui") then
                gui:Destroy()
            end
        end
    end
end

EspButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        for _, player in ipairs(Players:GetPlayers()) do
            createESP(player)
        end
    else
        for _, player in ipairs(Players:GetPlayers()) do
            removeESP(player)
        end
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        createESP(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)

-- เปิดใช้งาน ESP สำหรับผู้เล่นทุกคนที่อยู่ในเกมตอนเริ่มต้น
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end


local farming = false
local selectedEnemy = nil

local function loadEnemies(folderName)
    for _, v in pairs(EnemyList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    local folder = game.Workspace:FindFirstChild(folderName)
    if folder then
        for _, enemy in pairs(folder:GetChildren()) do
            if enemy:IsA("Model") then
                local EnemyButton = Instance.new("TextButton")
                EnemyButton.Parent = EnemyList
                EnemyButton.Text = enemy.Name
                EnemyButton.Size = UDim2.new(1, 0, 0, 30)
                EnemyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                EnemyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                EnemyButton.MouseButton1Click:Connect(function()
                    selectedEnemy = enemy.Name
                end)
            end
        end
    end
end

EnemyInput.FocusLost:Connect(function()
    loadEnemies(EnemyInput.Text)
end)

ReloadButton.MouseButton1Click:Connect(function()
    loadEnemies(EnemyInput.Text)
end)

local function startFarming()
    if not selectedEnemy then return end
    farming = true
    StartButton.Text = "Stop"  -- Set button text to "Stop" when farming starts
    while farming do
        local enemiesFolder = game.Workspace:FindFirstChild(EnemyInput.Text)
        if enemiesFolder then
            local foundEnemy = nil
            for _, enemy in pairs(enemiesFolder:GetChildren()) do
                if enemy:IsA("Model") and enemy.Name == selectedEnemy and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 2 then
                    foundEnemy = enemy
                    break
                end
            end
            
            if foundEnemy then
                local enemyPos = foundEnemy.HumanoidRootPart.Position
                local player = game.Players.LocalPlayer.Character
                player:SetPrimaryPartCFrame(CFrame.new(enemyPos.X, enemyPos.Y, enemyPos.Z + 5))
            end
        end
        wait(0.5)
    end
end

local button1 = Instance.new("TextButton")
button1.Parent = Frame
button1.Size = UDim2.new(0, 80, 0, 40)
button1.Position = UDim2.new(0, -100, 0.315, 70)
button1.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
button1.TextColor3 = Color3.fromRGB(255, 255, 255)
button1.Font = Enum.Font.GothamBold
button1.TextSize = 5
button1.Text = "Bring Rebirth"
button1.MouseButton1Click:Connect(function()
    -- Teleport ไปที่ Rebirth Arrow
    local item = game.Workspace:FindFirstChild("Rebirth Arrow")
    if item then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame
        wait(0.5)
        -- Teleport กลับมาที่เดิม
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
    end
end)

local button2 = Instance.new("TextButton")
button2.Parent = Frame
button2.Size = UDim2.new(0, 80, 0, 40)
button2.Position = UDim2.new(0, -100, 0.315, 140)
button2.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
button2.TextColor3 = Color3.fromRGB(255, 255, 255)
button2.Font = Enum.Font.GothamBold
button2.TextSize = 5
button2.Text = "Bring Arrow"
button2.MouseButton1Click:Connect(function()
    -- Teleport ไปที่ Arrow
    local item = game.Workspace:FindFirstChild("Arrow")
    if item then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame
        wait(0.5)
        -- Teleport กลับมาที่เดิม
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
    end
end)

local button3 = Instance.new("TextButton")
button3.Parent = Frame
button3.Size = UDim2.new(0, 80, 0, 40)
button3.Position = UDim2.new(0, -100, 0.315, 210)
button3.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
button3.TextColor3 = Color3.fromRGB(255, 255, 255)
button3.Font = Enum.Font.GothamBold
button3.TextSize = 5
button3.Text = "Bring Mask"
button3.MouseButton1Click:Connect(function()
    -- Teleport ไปที่ Stone
    local item = game.Workspace:FindFirstChild("Stone")
    if item then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item.CFrame
        wait(0.5)
        -- Teleport กลับมาที่เดิม
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
    end
end)


local function stopFarming()
    farming = false
    StartButton.Text = "Start"  -- Set button text back to "Start" when farming stops
end

StartButton.MouseButton1Click:Connect(function()
    if farming then
        stopFarming()
    else
        startFarming()
    end
end)
