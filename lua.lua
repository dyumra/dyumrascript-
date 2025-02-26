local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 300, 0, 500)
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
EnemyList.Size = UDim2.new(1, -20, 0, 250)
EnemyList.Position = UDim2.new(0, 10, 0, 60)
EnemyList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
EnemyList.CanvasSize = UDim2.new(0, 0, 0, 0)
EnemyList.ScrollBarThickness = 5

local StartButton = Instance.new("TextButton")
StartButton.Parent = Frame
StartButton.Text = "Start"
StartButton.Size = UDim2.new(1, -20, 0, 50)
StartButton.Position = UDim2.new(0, 10, 0, 320)
StartButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 20

local QuestButton = Instance.new("TextButton")
QuestButton.Parent = Frame
QuestButton.Text = "Accept Quest"
QuestButton.Size = UDim2.new(1, -20, 0, 50)
QuestButton.Position = UDim2.new(0, 10, 0, 380)
QuestButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
QuestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
QuestButton.Font = Enum.Font.GothamBold
QuestButton.TextSize = 20

local farming = false
local selectedEnemy = nil

local enemyNames = {
    "Thug [Level 5]", "HumanUser [Level 15]", "Gryphon [Level 30]", "Vampire [Level 40]",
    "Snow Thug [Level 50]", "Snow Man [Level 65]", "Wammu", "Desert Bandit [Level 120]",
    "Dio Guard [Level 165]", "Dio Royal Guard [Level 180]", "City Criminal [Level 280]",
    "Criminal Master [Level 300]", "School Bully [Level 270]"
}

local function loadEnemies()
    for _, v in pairs(EnemyList:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end
    
    local count = 0
    for _, enemyName in pairs(enemyNames) do
        count = count + 1
        local EnemyButton = Instance.new("TextButton")
        EnemyButton.Parent = EnemyList
        EnemyButton.Text = enemyName
        EnemyButton.Size = UDim2.new(1, 0, 0, 30)
        EnemyButton.Position = UDim2.new(0, 0, 0, (count - 1) * 35)
        EnemyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        EnemyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        EnemyButton.MouseButton1Click:Connect(function()
            selectedEnemy = string.match(enemyName, "(.-) %[") or enemyName
        end)
    end
    EnemyList.CanvasSize = UDim2.new(0, 0, 0, count * 35)
end

local function startFarming()
    if not selectedEnemy then return end
    farming = true
    StartButton.Text = "Stop"
    while farming do
        local enemiesFolder = game.Workspace:FindFirstChild("Enemies")
        if enemiesFolder then
            local closestEnemy = nil
            local closestDist = 50 
            local player = game.Players.LocalPlayer.Character
            if player and player.PrimaryPart then
                for _, enemy in pairs(enemiesFolder:GetChildren()) do
                    if enemy:IsA("Model") and enemy.Name == selectedEnemy and enemy:FindFirstChild("Humanoid") then
                        local dist = (player.PrimaryPart.Position - enemy.PrimaryPart.Position).Magnitude
                        if dist < closestDist and enemy.Humanoid.Health > 2 then
                            closestEnemy = enemy
                            closestDist = dist
                        end
                    end
                end
                
                if closestEnemy then
                    -- ใช้ CFrame เพื่อเทเลพอร์ตไปที่ตำแหน่งของศัตรู
                    local enemyPos = closestEnemy.HumanoidRootPart.Position
                    player:SetPrimaryPartCFrame(CFrame.new(enemyPos.X, enemyPos.Y, enemyPos.Z + 3))
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

QuestButton.MouseButton1Click:Connect(function()
    if selectedEnemy then
        print("Quest Accepted: Defeat " .. selectedEnemy)
    end
end)

loadEnemies()
