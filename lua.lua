local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

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
TitleLabel.Text = "Enemy Teleport & Quest"
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
EnemyList.CanvasSize = UDim2.new(0, 0, 0, 500)
EnemyList.ScrollBarThickness = 5

local StartButton = Instance.new("TextButton")
StartButton.Parent = Frame
StartButton.Text = "Start"
StartButton.Size = UDim2.new(1, -20, 0, 40)
StartButton.Position = UDim2.new(0, 10, 0, 320)
StartButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.GothamBold
StartButton.TextSize = 20

local enemies = {
    "Thug [Level 5]", "HumanUser [Level 15]", "Gryphon [Level 30]", "Vampire [Level 40]",
    "Snow Thug [Level 50]", "Snow Man [Level 65]", "Wammu", "Desert Bandit [Level 120]",
    "Dio Guard [Level 165]", "Dio Royal Guard [Level 180]", "City Criminal [Level 280]",
    "Criminal Master [Level 300]", "School Bully [Level 270]"
}

local selectedEnemy = nil

for i, enemy in ipairs(enemies) do
    local EnemyButton = Instance.new("TextButton")
    EnemyButton.Parent = EnemyList
    EnemyButton.Text = enemy
    EnemyButton.Size = UDim2.new(1, 0, 0, 30)
    EnemyButton.Position = UDim2.new(0, 0, 0, (i - 1) * 30)
    EnemyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    EnemyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    EnemyButton.MouseButton1Click:Connect(function()
        selectedEnemy = enemy:match("^(.-) %[") or enemy
    end)
end

local function teleportToEnemy()
    if not selectedEnemy then return end
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    
    local enemiesFolder = game.Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        local foundEnemy = nil
        local minDistance = 50  -- Set range limit
        
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") and enemy.Name == selectedEnemy and enemy:FindFirstChild("HumanoidRootPart") then
                local distance = (character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if distance < minDistance then
                    foundEnemy = enemy
                    minDistance = distance
                end
            end
        end
        
        if foundEnemy then
            character:SetPrimaryPartCFrame(foundEnemy.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0))
        end
    end
end

StartButton.MouseButton1Click:Connect(teleportToEnemy)
