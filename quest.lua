local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:FindFirstChildOfClass("PlayerGui")

-- สร้าง ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui

-- สร้าง Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

-- สร้าง ScrollingFrame
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(0.9, 0, 0.7, 0)
scrollingFrame.Position = UDim2.new(0.05, 0, 0.05, 0)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0) -- ให้เลื่อนดูได้
scrollingFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
scrollingFrame.Parent = frame

-- รายชื่อมอนสเตอร์ที่ใช้รับเควส
local monsters = {"Thug [Level 5]", "HumanUser [Level 15]", "Gryphon [Level 30]", "Vampire [Level 40]",
    "Snow Thug [Level 50]", "Snow Man [Level 65]", "Wammu", "Desert Bandit [Level 120]",
    "Dio Guard [Level 165]", "Dio Royal Guard [Level 180]", "City Criminal [Level 280]",
    "Criminal Master [Level 300]", "School Bully [Level 270]"}
local selectedQuest = ""

-- เพิ่มปุ่มสำหรับแต่ละมอนสเตอร์
for i, monster in ipairs(monsters) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.9, 0, 0, 30)
    button.Position = UDim2.new(0.05, 0, 0, (i - 1) * 35)
    button.Text = monster
    button.TextScaled = true
    button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = scrollingFrame
    
    button.MouseButton1Click:Connect(function()
        selectedQuest = monster
    end)
end

-- สร้างปุ่ม Start/Stop
local button = Instance.new("TextButton")
button.Size = UDim2.new(0.8, 0, 0.2, 0)
button.Position = UDim2.new(0.1, 0, 0.8, 0)
button.Text = "Start"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- สีเขียว (Start)
button.Parent = frame

local remoteEvent = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("GameEvent")
local running = false

-- ฟังก์ชันเริ่ม/หยุดการทำงาน
local function toggleQuest()
    running = not running
    if running then
        button.Text = "Stop"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- สีแดง (Stop)
        while running do
            if selectedQuest and selectedQuest ~= "" then
                local args = {
                    [1] = "Quest",
                    [2] = selectedQuest
                }
                remoteEvent:FireServer(unpack(args))
            end
            wait(2) -- ส่งทุก 2 วินาที
        end
    else
        button.Text = "Start"
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- สีเขียว (Start)
    end
end

-- เมื่อกดปุ่ม Start/Stop
button.MouseButton1Click:Connect(toggleQuest)
