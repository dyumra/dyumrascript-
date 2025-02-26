-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local EnemyInput = Instance.new("TextBox")
EnemyInput.Parent = MainFrame
EnemyInput.Size = UDim2.new(0, 200, 0, 30)
EnemyInput.Position = UDim2.new(0.1, 0, 0.1, 0)
EnemyInput.PlaceholderText = "Enter Enemy Name"

local ReloadButton = Instance.new("TextButton")
ReloadButton.Parent = MainFrame
ReloadButton.Size = UDim2.new(0, 80, 0, 30)
ReloadButton.Position = UDim2.new(0.75, 0, 0.1, 0)
ReloadButton.Text = "Reload"

local EnemyList = Instance.new("ScrollingFrame")
EnemyList.Parent = MainFrame
EnemyList.Size = UDim2.new(0, 280, 0, 200)
EnemyList.Position = UDim2.new(0.05, 0, 0.2, 0)
EnemyList.CanvasSize = UDim2.new(0, 0, 5, 0)
EnemyList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local function updateEnemyList()
    for _, v in pairs(EnemyList:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end
    local enemies = game.Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, enemy in pairs(enemies:GetChildren()) do
            local EnemyButton = Instance.new("TextButton")
            EnemyButton.Parent = EnemyList
            EnemyButton.Size = UDim2.new(1, 0, 0, 30)
            EnemyButton.Text = enemy.Name
            EnemyButton.MouseButton1Click:Connect(function()
                EnemyInput.Text = enemy.Name
            end)
        end
    end
end

EnemyInput.FocusLost:Connect(function()
    updateEnemyList()
end)

ReloadButton.MouseButton1Click:Connect(function()
    updateEnemyList()
end)

local StartButton = Instance.new("TextButton")
StartButton.Parent = MainFrame
StartButton.Size = UDim2.new(0, 280, 0, 50)
StartButton.Position = UDim2.new(0.05, 0, 0.8, 0)
StartButton.Text = "Start"

local farming = false

local function startFarming()
    farming = true
    while farming do
        local enemies = game.Workspace:FindFirstChild("Enemies")
        if enemies then
            local target = enemies:FindFirstChild(EnemyInput.Text)
            if target and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 2 then
                local player = game.Players.LocalPlayer.Character
                if player then
                    player:SetPrimaryPartCFrame(target.HumanoidRootPart.CFrame + Vector3.new(0, 0, 5))
                end
            end
        end
        wait(2)
    end
end

local function stopFarming()
    farming = false
end

StartButton.MouseButton1Click:Connect(function()
    if farming then
        stopFarming()
        StartButton.Text = "Start"
    else
        startFarming()
        StartButton.Text = "Stop"
    end
end)

updateEnemyList()
