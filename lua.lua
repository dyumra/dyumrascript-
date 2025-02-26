local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local playerGui = player:FindFirstChildOfClass("PlayerGui")

-- สร้าง GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

-- สร้าง ScrollingFrame
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(0.9, 0, 0.6, 0)
scrollingFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
scrollingFrame.Parent = frame

-- สร้างปุ่ม Start/Stop
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0.15, 0)
button.Position = UDim2.new(0.1, 0, 0.75, 0)
button.Text = "Start"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
button.Parent = frame

local remoteEvent = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("GameEvent")
local running = false
local selectedEnemy = nil

-- สร้างปุ่มเลือกมอนสเตอร์ใน ScrollingFrame
local enemies = {"Thug [Level 5]", "HumanUser [Level 15]", "Gryphon [Level 30]", "Vampire [Level 40]",
    "Snow Thug [Level 50]", "Snow Man [Level 65]", "Wammu", "Desert Bandit [Level 120]",
    "Dio Guard [Level 165]", "Dio Royal Guard [Level 180]", "City Criminal [Level 280]",
    "Criminal Master [Level 300]", "School Bully [Level 270]"} -- เพิ่มมอนสเตอร์ที่ต้องการ
for _, enemyName in ipairs(enemies) do
    local enemyButton = Instance.new("TextButton")
    enemyButton.Size = UDim2.new(1, 0, 0.2, 0)
    enemyButton.Text = enemyName
    enemyButton.Parent = scrollingFrame
    
    enemyButton.MouseButton1Click:Connect(function()
        selectedEnemy = enemyName
        print("Selected Enemy:", selectedEnemy)
    end)
end

-- ฟังก์ชันเริ่ม/หยุดการทำงาน
local function toggleQuest()
    if not selectedEnemy then return end
    running = not running
    if running then
        button.Text = "Stop"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        while running do
            local args = {
                [1] = "Quest",
                [2] = selectedEnemy
            }
            remoteEvent:FireServer(unpack(args))
            wait(2) -- ส่งทุก 2 วินาที
        end
    else
        button.Text = "Start"
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    end
end

button.MouseButton1Click:Connect(toggleQuest)

-- ฟังก์ชันเทเลพอร์ตไปหามอนสเตอร์ที่เลือก
local function teleportToEnemy()
    if not selectedEnemy then return end
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local enemiesFolder = game.Workspace:FindFirstChild(selectedEnemy)
        if enemiesFolder then
            for _, enemy in pairs(enemiesFolder:GetChildren()) do
                if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 2 then
                    character.HumanoidRootPart.CFrame = enemy.HumanoidRootPart.CFrame + Vector3.new(0, 3, 3)
                    return
                end
            end
        end
    end
end

button.MouseButton1Click:Connect(teleportToEnemy)
