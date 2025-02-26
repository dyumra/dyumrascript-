-- GUI หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- สร้าง Frame ที่สามารถลากได้
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
MainFrame.Draggable = true
MainFrame.Active = true

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainFrame
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.Padding = UDim.new(0, 5)

-- Input สำหรับพิมพ์ Enemies
local EnemyInput = Instance.new("TextBox")
EnemyInput.Parent = MainFrame
EnemyInput.PlaceholderText = "Enter Enemies Level"
EnemyInput.Size = UDim2.new(0, 280, 0, 30)
EnemyInput.Position = UDim2.new(0, 10, 0, 10)
EnemyInput.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
EnemyInput.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ปุ่ม Reload
local ReloadButton = Instance.new("TextButton")
ReloadButton.Parent = MainFrame
ReloadButton.Text = "Reload"
ReloadButton.Size = UDim2.new(0, 280, 0, 30)
ReloadButton.Position = UDim2.new(0, 10, 0, 50)
ReloadButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
ReloadButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- ListView สำหรับแสดง Enemies
local EnemyList = Instance.new("ScrollingFrame")
EnemyList.Parent = MainFrame
EnemyList.Size = UDim2.new(0, 280, 0, 250)
EnemyList.Position = UDim2.new(0, 10, 0, 90)
EnemyList.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
EnemyList.CanvasSize = UDim2.new(0, 0, 5, 0)

local UIListLayout2 = Instance.new("UIListLayout")
UIListLayout2.Parent = EnemyList
UIListLayout2.FillDirection = Enum.FillDirection.Vertical
UIListLayout2.Padding = UDim.new(0, 5)

-- ฟังก์ชันดึงเลข Level จากชื่อ
local function extractLevel(name)
    local level = string.match(name, "%[(%d+)%]") -- ค้นหาตัวเลขที่อยู่ใน []
    return level or "N/A" -- ถ้าไม่เจอให้ใช้ "N/A"
end

-- อัพเดทรายการ Enemies
local function updateEnemyList()
    for _, child in pairs(EnemyList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    for _, enemy in pairs(workspace:FindFirstChild("Enemies"):GetChildren()) do
        if enemy:FindFirstChild("HumanoidRootPart") and (enemy.HumanoidRootPart.Position - root.Position).magnitude <= 40 then
            local EnemyButton = Instance.new("TextButton")
            EnemyButton.Parent = EnemyList
            EnemyButton.Text = enemy.Name
            EnemyButton.Size = UDim2.new(1, 0, 0, 30)
            EnemyButton.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            EnemyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            EnemyButton.MouseButton1Click:Connect(function()
                EnemyInput.Text = extractLevel(enemy.Name) -- ใช้ฟังก์ชัน extractLevel
            end)
        end
    end
end

local EspButton = Instance.new("TextButton")
EspButton.Parent = MainFrame
EspButton.Text = "ESP Toggle"
EspButton.Size = UDim2.new(0, 280, 0, 30)
EspButton.Position = UDim2.new(0, 10, 0, 10)
EspButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Highlight Players Function
local espEnabled = false

local function createHighlight(player)
    if not player.Character then return end
    local highlight = player.Character:FindFirstChild("ESP_Highlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "ESP_Highlight"
        highlight.FillColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
        highlight.Parent = player.Character
    end
end

local function createNameTag(player)
    if not player.Character then return end

    -- ลบของเก่า
    if player.Character:FindFirstChild("ESP_NameTag") then
        player.Character:FindFirstChild("ESP_NameTag"):Destroy()
    end

    -- หัวของ Player
    local head = player.Character:FindFirstChild("Head")
    if not head then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_NameTag"
    billboard.Parent = player.Character
    billboard.Adornee = head
    billboard.Size = UDim2.new(4, 0, 1, 0)
    billboard.StudsOffset = Vector3.new(0, 2, 0)

    -- Level & Money
    local level = player:FindFirstChild("Level") and player.Level.Value or 0
    local money = player:FindFirstChild("Money") and player.Money.Value or 0

    -- สร้าง Label Level
    local levelLabel = Instance.new("TextLabel", billboard)
    levelLabel.Size = UDim2.new(1, 0, 0.3, 0)
    levelLabel.Position = UDim2.new(0, 0, 0, 0)
    levelLabel.BackgroundTransparency = 1
    levelLabel.Text = "Level (" .. level .. ")  $" .. money
    levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    levelLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 0) -- ขอบเหลือง
    levelLabel.TextStrokeTransparency = 0
    levelLabel.Font = Enum.Font.SourceSansBold
    levelLabel.TextScaled = true

    -- สร้าง Label ชื่อ
    local nameLabel = Instance.new("TextLabel", billboard)
    nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
    nameLabel.Position = UDim2.new(0, 0, 0.3, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeColor3 = Color3.fromRGB(255, 0, 0) -- ขอบแดง
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.SourceSansBold
    nameLabel.TextScaled = true
end

local function updateESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            if espEnabled then
                createHighlight(player)
                createNameTag(player)
            else
                if player.Character then
                    if player.Character:FindFirstChild("ESP_Highlight") then
                        player.Character.ESP_Highlight:Destroy()
                    end
                    if player.Character:FindFirstChild("ESP_NameTag") then
                        player.Character.ESP_NameTag:Destroy()
                    end
                end
            end
        end
    end
end

-- เปิด/ปิด ESP
EspButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    updateESP()
end)

-- อัปเดตเมื่อ Player เข้ามาใหม่
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1) -- รอโหลด Character
        if espEnabled then
            createHighlight(player)
            createNameTag(player)
        end
    end)
end)

-- อัปเดตเมื่อ Player เปลี่ยนค่า Level หรือ Money
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        if espEnabled then
            createHighlight(player)
            createNameTag(player)
        end
    end)

    player:WaitForChild("Level").Changed:Connect(function()
        if player.Character then
            createNameTag(player)
        end
    end)

    player:WaitForChild("Money").Changed:Connect(function()
        if player.Character then
            createNameTag(player)
        end
    end)
end)

ReloadButton.MouseButton1Click:Connect(updateEnemyList)

updateEnemyList()
