-- GUI สุดหรูแบบแดง-ดำพร้อมลูกเล่น
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 400, 0, 300)
Frame.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
Frame.BorderSizePixel = 2
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)

local EnemiesBox = Instance.new("TextBox")
EnemiesBox.Parent = Frame
EnemiesBox.Size = UDim2.new(0, 200, 0, 30)
EnemiesBox.Position = UDim2.new(0, 10, 0, 10)
EnemiesBox.PlaceholderText = "Enter 'Enemies'"
EnemiesBox.BackgroundColor3 = Color3.fromRGB(50, 0, 0)
EnemiesBox.TextColor3 = Color3.fromRGB(255, 255, 255)

local ReloadButton = Instance.new("TextButton")
ReloadButton.Parent = Frame
ReloadButton.Size = UDim2.new(0, 100, 0, 30)
ReloadButton.Position = UDim2.new(0, 220, 0, 10)
ReloadButton.Text = "Reload"
ReloadButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
ReloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local EnemiesList = Instance.new("ScrollingFrame")
EnemiesList.Parent = Frame
EnemiesList.Size = UDim2.new(0, 380, 0, 200)
EnemiesList.Position = UDim2.new(0, 10, 0, 50)
EnemiesList.CanvasSize = UDim2.new(0, 0, 0, 0)
EnemiesList.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
EnemiesList.BorderSizePixel = 2
EnemiesList.BorderColor3 = Color3.fromRGB(255, 0, 0)

local farming = false
local selectedEnemy = nil

local function updateEnemiesList()
    for _, child in pairs(EnemiesList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local player = game.Players.LocalPlayer.Character
    if not player or not player:FindFirstChild("HumanoidRootPart") then return end
    
    local enemiesFolder = game.Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        local count = 0
        for _, enemy in pairs(enemiesFolder:GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
                local distance = (player.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                if distance <= 30 then
                    count = count + 1
                    local EnemyButton = Instance.new("TextButton")
                    EnemyButton.Parent = EnemiesList
                    EnemyButton.Size = UDim2.new(1, 0, 0, 30)
                    EnemyButton.Text = enemy.Name
                    EnemyButton.BackgroundColor3 = Color3.fromRGB(70, 0, 0)
                    EnemyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    
                    EnemyButton.MouseButton1Click:Connect(function()
                        selectedEnemy = enemy.Name
                    end)
                end
            end
        end
        EnemiesList.CanvasSize = UDim2.new(0, 0, 0, count * 30)
    end
end

ReloadButton.MouseButton1Click:Connect(updateEnemiesList)

local StartButton = Instance.new("TextButton")
StartButton.Parent = Frame
StartButton.Size = UDim2.new(0, 200, 0, 30)
StartButton.Position = UDim2.new(0, 100, 0, 260)
StartButton.Text = "Start"
StartButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local function startFarming()
    farming = true
    StartButton.Text = "Stop"
    
    while farming do
        local enemiesFolder = game.Workspace:FindFirstChild("Enemies")
        if enemiesFolder and selectedEnemy then
            for _, enemy in pairs(enemiesFolder:GetChildren()) do
                if enemy:IsA("Model") and enemy.Name == selectedEnemy and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
                    if enemy.Humanoid.Health > 2 then
                        local player = game.Players.LocalPlayer.Character
                        if player and player:FindFirstChild("HumanoidRootPart") then
                            player:SetPrimaryPartCFrame(enemy.HumanoidRootPart.CFrame + Vector3.new(0, 0, 5))
                            break
                        end
                    end
                end
            end
        end
        wait(1)
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
