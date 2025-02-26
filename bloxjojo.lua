-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

local FarmLabel = Instance.new("TextLabel")
FarmLabel.Parent = ScreenGui
FarmLabel.Text = "Farm Mob [Level 40]"
FarmLabel.Size = UDim2.new(0, 200, 0, 50)
FarmLabel.Position = UDim2.new(0.5, -100, 0.2, 0)

local StartButton = Instance.new("TextButton")
StartButton.Parent = ScreenGui
StartButton.Text = "Start"
StartButton.Size = UDim2.new(0, 200, 0, 50)
StartButton.Position = UDim2.new(0.5, -100, 0.3, 0)

-- ตัวแปรควบคุมการ farm
local farming = false

-- ฟังก์ชันเริ่มการ farm
local function startFarming()
    farming = true
    while farming do
        -- Teleport ไปยัง Vampire [Level 40]
        local vampire = game.Workspace.Enemies:FindFirstChild("Vampire [Level 40]")
        if vampire then
            -- Teleport ไปข้างหลัง
            local vampirePosition = vampire.HumanoidRootPart.Position
            local player = game.Players.LocalPlayer.Character
            player:SetPrimaryPartCFrame(CFrame.new(vampirePosition.X, vampirePosition.Y, vampirePosition.Z + 5))
            
            -- ใช้ไอเทมที่ 2 ใน Inventory
            local backpack = game.Players.LocalPlayer.Backpack
            local item = backpack:FindFirstChildOfClass("Tool")  -- หาหรือระบุไอเทมที่ 2 ตามลำดับ
            if item then
                -- ใช้ไอเทมที่ 2 (สามารถปรับเปลี่ยนได้ตามไอเทมในเกม)
                item.Activated:Fire()
            end

            -- ตีจนกว่า Health ของ Vampire จะหมด
            while vampire.Humanoid.Health > 0 and farming do
                -- ตี (ฟังก์ชันการโจมตีอาจแตกต่างกันไป)
                player.Humanoid:MoveTo(vampire.HumanoidRootPart.Position) -- เดินไปหามอนสเตอร์
                -- ถ้ามีการโจมตีผ่านการคลิกหรือคำสั่งพิเศษสามารถทำในส่วนนี้
                wait(1)
            end
        end
        -- ถ้า Vampire [Level 40] ตายแล้วให้ไปที่ Vampire ใหม่
        wait(2)  -- หน่วงเวลาระหว่างการหา Vampire ตัวใหม่
    end
end

-- ฟังก์ชันหยุดการ farm
local function stopFarming()
    farming = false
end

-- ตั้งค่าปุ่ม Start
StartButton.MouseButton1Click:Connect(function()
    if farming then
        stopFarming()
        StartButton.Text = "Start"  -- เปลี่ยนข้อความเมื่อหยุด
    else
        startFarming()
        StartButton.Text = "Stop"  -- เปลี่ยนข้อความเมื่อเริ่ม
    end
end)
