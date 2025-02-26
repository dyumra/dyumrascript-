local player = game.Players.LocalPlayer
local scrollingFrame = script.Parent.ScrollingFrame
local enemiesFolder = workspace.Enemies -- Folder that contains the enemies

-- รายชื่อศัตรูใน ScrollingFrame
local enemies = {
    "Thug", "HumanUser", "Gryphon", "Vampire", "Snow Thug", "Snow Man",
    "Wammu", "Desert Bandit", "Dio Guard", "Dio Royal Guard", "City Criminal",
    "Criminal Master", "School Bully"
}

-- ฟังก์ชันตรวจสอบเลือดของ dummy
local function getDummyHealth(dummyName)
    local dummy = enemiesFolder:FindFirstChild(dummyName)
    if dummy and dummy:FindFirstChild("Health") then
        return dummy.Health.Value
    end
    return nil
end

-- ฟังก์ชันเทเลพอร์ตไปยัง dummy
local function teleportToDummy(dummyName)
    local dummy = enemiesFolder:FindFirstChild(dummyName)
    if dummy then
        player.Character:SetPrimaryPartCFrame(dummy.HumanoidRootPart.CFrame)
    end
end

-- สร้างปุ่มใน ScrollingFrame
for _, enemyName in ipairs(enemies) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 200, 0, 50)
    button.Position = UDim2.new(0, 0, 0, (#scrollingFrame:GetChildren() - 1) * 55) -- ตั้งตำแหน่งของปุ่ม
    button.Text = enemyName
    button.Parent = scrollingFrame

    button.MouseButton1Click:Connect(function()
        local dummyHealth = getDummyHealth(enemyName)

        if dummyHealth then
            -- ถ้าเลือดเหลือ 2 ให้หาตัวอื่นที่เลือดเต็ม
            if dummyHealth <= 2 then
                for _, otherEnemyName in ipairs(enemies) do
                    if otherEnemyName ~= enemyName then
                        local otherDummyHealth = getDummyHealth(otherEnemyName)
                        if otherDummyHealth and otherDummyHealth > 2 then
                            teleportToDummy(otherEnemyName) -- เทเลพอร์ตไปที่ศัตรูตัวอื่น
                            wait(1) -- รอ 1 วินาที
                            teleportToDummy(enemyName) -- กลับไปที่ศัตรูตัวเดิม
                            break
                        end
                    end
                end
            else
                teleportToDummy(enemyName) -- ถ้าเลือดมากกว่า 2, เทเลพอร์ตไปยังตัวที่เลือก
            end
        end
    end)
end
