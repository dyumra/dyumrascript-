-- สร้าง GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer.PlayerGui

-- สร้าง Frame สำหรับเมนู (ปรับแต่งสีแดงดำ และทำให้ลากได้)
local MenuFrame = Instance.new("Frame")
MenuFrame.Parent = ScreenGui
MenuFrame.Size = UDim2.new(0, 300, 0, 250)
MenuFrame.Position = UDim2.new(0.4, 0, 0.2, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
MenuFrame.BorderSizePixel = 2
MenuFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MenuFrame.Active = true
MenuFrame.Draggable = true

-- ลูกเล่น: รูปลูกตาและใยแมลงมุม
local EyeImage = Instance.new("ImageLabel")
EyeImage.Parent = MenuFrame
EyeImage.Size = UDim2.new(0, 50, 0, 50)
EyeImage.Position = UDim2.new(0.5, -25, 0, 5)
EyeImage.Image = "rbxassetid://YOUR_EYE_IMAGE_ID" -- ใส่รูปตา
EyeImage.BackgroundTransparency = 1

local WebImage = Instance.new("ImageLabel")
WebImage.Parent = MenuFrame
WebImage.Size = UDim2.new(0, 100, 0, 100)
WebImage.Position = UDim2.new(0, -20, 0, -20)
WebImage.Image = "rbxassetid://YOUR_WEB_IMAGE_ID" -- ใส่รูปใยแมลงมุม
WebImage.BackgroundTransparency = 1

-- ช่องกรอกข้อมูล
local MobNameBox = Instance.new("TextBox")
MobNameBox.Parent = MenuFrame
MobNameBox.Size = UDim2.new(0, 250, 0, 30)
MobNameBox.Position = UDim2.new(0, 25, 0, 60)
MobNameBox.PlaceholderText = "Enter Mob Name"
MobNameBox.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
MobNameBox.TextColor3 = Color3.fromRGB(255, 255, 255)

-- รายการมอนสเตอร์ใน Enemies
local MobList = Instance.new("ScrollingFrame")
MobList.Parent = MenuFrame
MobList.Size = UDim2.new(0, 250, 0, 100)
MobList.Position = UDim2.new(0, 25, 0, 100)
MobList.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
MobList.CanvasSize = UDim2.new(0, 0, 0, 0)

-- ปุ่มเริ่ม / หยุด
local StartButton = Instance.new("TextButton")
StartButton.Parent = MenuFrame
StartButton.Size = UDim2.new(0, 200, 0, 50)
StartButton.Position = UDim2.new(0, 50, 0, 210)
StartButton.Text = "Start"
StartButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local farming = false

local function updateMobList()
    for _, child in pairs(MobList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local enemiesFolder = game.Workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            local MobButton = Instance.new("TextButton")
            MobButton.Parent = MobList
            MobButton.Size = UDim2.new(1, 0, 0, 30)
            MobButton.Text = enemy.Name
            MobButton.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
            MobButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            MobButton.MouseButton1Click:Connect(function()
                MobNameBox.Text = enemy.Name
            end)
        end
    end
end

MobNameBox:GetPropertyChangedSignal("Text"):Connect(function()
    if MobNameBox.Text == "Enemies" then
        updateMobList()
    end
end)

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
