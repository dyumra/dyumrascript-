local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local workspace = game:GetService("Workspace")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(0.3, 0, 0.5, 0)
scrollingFrame.Position = UDim2.new(0.35, 0, 0.25, 0)
scrollingFrame.Parent = screenGui

-- รายชื่อศัตรูใน List
local enemiesList = {
    "Thug", "HumanUser", "Gryphon", "Vampire", "Snow Thug", "Snow Man", 
    "Wammu", "Desert Bandit", "Dio Guard", "Dio Royal Guard", "City Criminal", 
    "Criminal Master", "School Bully"
}

-- ฟังก์ชันเช็คเลือดและ teleport
local function getDummyHealth(enemyName)
    local dummy = workspace.Enemies:FindFirstChild(enemyName)
    if dummy and dummy:FindFirstChild("Health") then
        return dummy.Health.Value
    end
    return nil
end

local function teleportToEnemy(enemyName)
    local dummy = workspace.Enemies:FindFirstChild(enemyName)
    if dummy then
        -- ตรวจสอบเลือด ถ้าลดเหลือ 2 ก็ไปจัดการตัวอื่นก่อน
        local health = getDummyHealth(enemyName)
        if health and health <= 2 then
            -- ค้นหาศัตรูอื่นที่เลือดมากกว่า 2
            for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                if enemy:IsA("Model") and enemy:FindFirstChild("Health") then
                    local otherHealth = getDummyHealth(enemy.Name)
                    if otherHealth and otherHealth > 2 then
                        -- Teleport ไปหาตัวอื่นก่อน
                        local humanoidRootPart = enemy:FindFirstChild("HumanoidRootPart")
                        if humanoidRootPart then
                            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(humanoidRootPart.CFrame)
                            return
                        end
                    end
                end
            end
        end

        -- Teleport ไปยังศัตรูที่เลือดเหลือ 2 ถ้าเจอ
        local humanoidRootPart = dummy:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            game.Players.LocalPlayer.Character:SetPrimaryPartCFrame(humanoidRootPart.CFrame)
        end
    end
end

-- สร้างปุ่ม GUI สำหรับแต่ละศัตรูใน List
for _, enemyName in ipairs(enemiesList) do
    local button = Instance.new("TextButton")
    button.Text = enemyName
    button.Size = UDim2.new(1, 0, 0, 50)
    button.Parent = scrollingFrame
    button.MouseButton1Click:Connect(function()
        teleportToEnemy(enemyName)
    end)
end
