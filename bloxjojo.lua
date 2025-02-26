local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- สร้าง Frame สำหรับเมนู
local MenuFrame = Instance.new("Frame")
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 250, 0, 200)
MenuFrame.Position = UDim2.new(0, 10, 0.2, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- สร้างช่องกรอกชื่อมอนสเตอร์
local MobNameBox = Instance.new("TextBox")
MobNameBox.Parent = MenuFrame
MobNameBox.Size = UDim2.new(0, 200, 0, 30)
MobNameBox.Position = UDim2.new(0, 25, 0, 10)
MobNameBox.PlaceholderText = "Enter Mob Name"

-- ปุ่มเริ่ม / หยุด
local StartButton = Instance.new("TextButton")
StartButton.Parent = MenuFrame
StartButton.Size = UDim2.new(0, 200, 0, 50)
StartButton.Position = UDim2.new(0, 25, 0, 50)
StartButton.Text = "Start"

local farming = false
local function startFarming()
    farming = true
    StartButton.Text = "Stop"
    
    while farming do
        local mobName = MobNameBox.Text
        local mobs = game.Workspace.Enemies:GetChildren()
        local targetMob = nil
        
        for _, mob in ipairs(mobs) do
            if mob.Name == mobName and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 2 then
                targetMob = mob
                break
            end
        end
        
        if targetMob then
            local pos = targetMob.HumanoidRootPart.Position
            local player = game.Players.LocalPlayer.Character
            player:SetPrimaryPartCFrame(CFrame.new(pos.X, pos.Y, pos.Z + 5))
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
