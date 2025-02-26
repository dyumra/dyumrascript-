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

local EnemyList = Instance.new("ScrollingFrame")
EnemyList.Parent = Frame
EnemyList.Size = UDim2.new(1, -20, 0, 280)
EnemyList.Position = UDim2.new(0, 10, 0, 60)
EnemyList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
EnemyList.CanvasSize = UDim2.new(0, 0, 1, 0)
EnemyList.ScrollBarThickness = 5

local StartButton = Instance.new("TextButton")
StartButton.Parent = Frame
StartButton.Text = "Start"
StartButton.Size = UDim2.new(1, -20, 0, 50)
StartButton.Position = UDim2.new(0, 10, 0, 350)
StartButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 20

local enemyNames = {
    "Thug [Level 5]", "HumanUser [Level 15]", "Gryphon [Level 30]", "Vampire [Level 40]",
    "Snow Thug [Level 50]", "Snow Man [Level 65]", "Wammu", "Desert Bandit [Level 120]",
    "Dio Guard [Level 165]", "Dio Royal Guard [Level 180]", "City Criminal [Level 280]",
    "Criminal Master [Level 300]", "School Bully [Level 270]"
}

local range = 50
local selectedEnemy = nil
local farming = false

-- โหลดรายชื่อศัตรูใน GUI
for _, name in pairs(enemyNames) do
    local EnemyButton = Instance.new("TextButton")
    EnemyButton.Parent = EnemyList
    EnemyButton.Text = name
    EnemyButton.Size = UDim2.new(1, 0, 0, 30)
    EnemyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    EnemyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    EnemyButton.MouseButton1Click:Connect(function()
        selectedEnemy = name
    end)
end

local function getNearestEnemy()
    local player = game.Players.LocalPlayer.Character
    if not player or not player.PrimaryPart then return nil end
    
    local enemiesFolder = game.Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end

    local nearestEnemy = nil
    local nearestDistance = range  -- ค่าระยะที่กำหนด
    
    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
            if enemy.Name == selectedEnemy then
                local distance = (enemy.HumanoidRootPart.Position - player.PrimaryPart.Position).Magnitude
                if distance <= nearestDistance and enemy.Humanoid.Health > 2 then
                    nearestEnemy = enemy
                    nearestDistance = distance
                end
            end
        end
    end
    return nearestEnemy
end

local function findAnotherEnemy(excludedEnemy)
    local player = game.Players.LocalPlayer.Character
    if not player or not player.PrimaryPart then return nil end
    
    local enemiesFolder = game.Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return nil end

    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
            if enemy.Name == selectedEnemy and enemy ~= excludedEnemy and enemy.Humanoid.Health > 2 then
                return enemy
            end
        end
    end
    return nil
end

local function startFarming()
    if not selectedEnemy then return end
    farming = true
    StartButton.Text = "Stop"
    
    while farming do
        local targetEnemy = getNearestEnemy()

        if targetEnemy then
            local player = game.Players.LocalPlayer.Character
            if player and player.PrimaryPart then
                player:SetPrimaryPartCFrame(targetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
            end
        else
            -- หา target อื่นถ้า HP <= 2
            local alternativeEnemy = findAnotherEnemy(targetEnemy)
            if alternativeEnemy then
                local player = game.Players.LocalPlayer.Character
                if player and player.PrimaryPart then
                    player:SetPrimaryPartCFrame(alternativeEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                end
            end
        end

        wait(0.5)
    end
end

local function stopFarming()
    farming = false
    StartButton.Text = "Start"
end

StartButton.MouseButton1Click:Connect(function()
    if farming then
        stopFarming()
    else
        startFarming()
    end
end)
