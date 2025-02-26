-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

local FarmLabel = Instance.new("TextLabel")
FarmLabel.Parent = ScreenGui
FarmLabel.Text = "Farm Mob"
FarmLabel.Size = UDim2.new(0, 200, 0, 50)
FarmLabel.Position = UDim2.new(0.5, -100, 0.2, 0)

local StartButton = Instance.new("TextButton")
StartButton.Parent = ScreenGui
StartButton.Text = "Start"
StartButton.Size = UDim2.new(0, 200, 0, 50)
StartButton.Position = UDim2.new(0.5, -100, 0.3, 0)

local ReloadButton = Instance.new("TextButton")
ReloadButton.Parent = ScreenGui
ReloadButton.Text = "Reload"
ReloadButton.Size = UDim2.new(0, 100, 0, 30)
ReloadButton.Position = UDim2.new(0.5, 50, 0.3, 0)

local EspButton = Instance.new("TextButton")
EspButton.Parent = ScreenGui
EspButton.Text = "ESP"
EspButton.Size = UDim2.new(0, 100, 0, 30)
EspButton.Position = UDim2.new(0.5, -150, 0.3, 0)

local farming = false
local espEnabled = false

local function startFarming()
    farming = true
    while farming do
        local nearestEnemy = nil
        local shortestDistance = 40
        for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 2 then
                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestEnemy = enemy
                end
            end
        end
        if nearestEnemy then
            local vampirePosition = nearestEnemy.HumanoidRootPart.Position
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(vampirePosition.X, vampirePosition.Y, vampirePosition.Z))
        end
        wait(2)
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = Color3.new(1, 1, 1)
                highlight.OutlineColor = Color3.new(1, 0, 0)
                
                local billboard = Instance.new("BillboardGui")
                billboard.Parent = player.Character.Head
                billboard.Size = UDim2.new(5, 0, 1, 0)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true
                
                local nameLabel = Instance.new("TextLabel")
                nameLabel.Parent = billboard
                nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                nameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
                nameLabel.TextColor3 = Color3.new(1, 1, 1)
                nameLabel.BackgroundColor3 = Color3.new(0, 0, 0)
                nameLabel.BorderColor3 = Color3.new(1, 0, 0)
                nameLabel.TextStrokeTransparency = 0
                
                local levelLabel = Instance.new("TextLabel")
                levelLabel.Parent = billboard
                levelLabel.Position = UDim2.new(0, 0, -0.5, 0)
                levelLabel.Size = UDim2.new(1, 0, 0.5, 0)
                levelLabel.Text = "Level " .. (player:FindFirstChild("Level") and player.Level.Value or "000") .. " | $" .. (player:FindFirstChild("Money") and player.Money.Value or "000")
                levelLabel.TextColor3 = Color3.new(1, 1, 1)
                levelLabel.BackgroundColor3 = Color3.new(0, 0, 0)
                levelLabel.BorderColor3 = Color3.new(1, 1, 0)
                levelLabel.TextStrokeTransparency = 0
            end
        end
    else
        for _, player in pairs(game.Players:GetPlayers()) do
            if player.Character then
                for _, obj in pairs(player.Character:GetChildren()) do
                    if obj:IsA("Highlight") or obj:IsA("BillboardGui") then
                        obj:Destroy()
                    end
                end
            end
        end
    end
end

EspButton.MouseButton1Click:Connect(toggleESP)
StartButton.MouseButton1Click:Connect(function()
    if farming then
        farming = false
        StartButton.Text = "Start"
    else
        startFarming()
        StartButton.Text = "Stop"
    end
end)

ReloadButton.MouseButton1Click:Connect(function()
    print("Reloading Enemies...")
end)
