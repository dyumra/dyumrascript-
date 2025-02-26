local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local enemiesFolder = workspace:WaitForChild("Enemies")

local function getEnemyByName(name)
    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy.Name == name then
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                return enemy, humanoid
            end
        end
    end
    return nil
end

local function teleportToEnemy(enemy)
    local root = enemy:FindFirstChild("HumanoidRootPart")
    if root then
        humanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 0, -3) -- Teleport ข้างหน้า
    end
end

local function findNewTarget(excludeName)
    for _, enemy in pairs(enemiesFolder:GetChildren()) do
        if enemy:IsA("Model") and enemy.Name == excludeName then
            local humanoid = enemy:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 2 then
                return enemy
            end
        end
    end
    return nil
end

local function onButtonClick(enemyName)
    local enemy, humanoid = getEnemyByName(enemyName)
    if enemy then
        teleportToEnemy(enemy)
        
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health == 2 then
                local newTarget = findNewTarget(enemyName)
                if newTarget then
                    teleportToEnemy(newTarget)
                    task.wait(2) -- รอสักพักก่อนกลับไปหาเป้าหมายแรก
                    teleportToEnemy(enemy)
                end
            end
        end)
    end
end

for _, button in pairs(script.Parent.ScrollingFrame:GetChildren()) do
    if button:IsA("TextButton") then
        button.MouseButton1Click:Connect(function()
            local enemyName = string.match(button.Text, "^(.-) %[") or button.Text -- ดึงชื่อจากปุ่ม
            onButtonClick(enemyName)
        end)
    end
end
