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
button1.Parent = frame
button1.Size = UDim2.new(0, 48, 0, 20)
button1.Position = UDim2.new(0, 10, 0, 240)
button1.Text = "Bring Rebirth Arrow"
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
button2.Parent = frame
button2.Size = UDim2.new(0, 48, 0, 20)
button2.Position = UDim2.new(0, 10, 0, 310)
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
button3.Parent = frame
button3.Size = UDim2.new(0, 48, 0, 20)
button3.Position = UDim2.new(0, 10, 0, 380)
button3.Text = "Bring Stone"
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
