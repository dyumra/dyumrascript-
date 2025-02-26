-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- สร้าง Frame สำหรับเมนู
local MenuFrame = Instance.new("Frame")
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 250, 0, 400)
MenuFrame.Position = UDim2.new(0, 10, 0.2, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- สร้างช่องกรอกชื่อมอนสเตอร์
local MobNameBox = Instance.new("TextBox")
MobNameBox.Parent = MenuFrame
MobNameBox.Size = UDim2.new(0, 200, 0, 30)
MobNameBox.Position = UDim2.new(0, 25, 0, 10)
MobNameBox.PlaceholderText = "Enter Mob Name"

-- ปุ่มเลือกทิศทาง
local directions = {"Front", "Back", "Left", "Right"}
local selectedDirection = "Back"
for i, dir in ipairs(directions) do
    local Button = Instance.new("TextButton")
    Button.Parent = MenuFrame
    Button.Size = UDim2.new(0, 200, 0, 30)
    Button.Position = UDim2.new(0, 25, 0, 50 + (i - 1) * 40)
    Button.Text = dir
    Button.MouseButton1Click:Connect(function()
        selectedDirection = dir
    end)
end

-- ปุ่มเริ่ม / หยุด
local StartButton = Instance.new("TextButton")
StartButton.Parent = MenuFrame
StartButton.Size = UDim2.new(0, 200, 0, 50)
StartButton.Position = UDim2.new(0, 25, 0, 250)
StartButton.Text = "Start"

local farming = false
local function startFarming()
    farming = true
    StartButton.Text = "Stop"
    
    while farming do
        local mobName = MobNameBox.Text
        local mob = game.Workspace.Enemies:FindFirstChild(mobName)
        
        if mob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 2 then
            local pos = mob.HumanoidRootPart.Position
            local player = game.Players.LocalPlayer.Character
            local offset = {Front = 5, Back = -5, Left = -5, Right = 5}
            
            if selectedDirection == "Front" or selectedDirection == "Back" then
                player:SetPrimaryPartCFrame(CFrame.new(pos.X, pos.Y, pos.Z + offset[selectedDirection]))
            else
                player:SetPrimaryPartCFrame(CFrame.new(pos.X + offset[selectedDirection], pos.Y, pos.Z))
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
