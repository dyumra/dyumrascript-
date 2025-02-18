local player = game.Players.LocalPlayer
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.ResetOnSpawn = false

-- ปุ่มเปิด GUI
local button = Instance.new("TextButton", screenGui)
button.Size = UDim2.new(0, 50, 0, 50)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "D"
button.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
button.TextColor3 = Color3.new(1, 1, 1)

-- GUI หลัก
local guiFrame = Instance.new("Frame", screenGui)
guiFrame.Size = UDim2.new(0, 400, 0, 300)
guiFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
guiFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
guiFrame.Visible = false

-- ปุ่มปิด GUI
local closeButton = Instance.new("TextButton", guiFrame)
closeButton.Size = UDim2.new(0, 40, 0, 40)
closeButton.Position = UDim2.new(1, -50, 0, 10)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)

-- แถบด้านซ้าย
local menuFrame = Instance.new("Frame", guiFrame)
menuFrame.Size = UDim2.new(0, 100, 0.765, 0)
menuFrame.Position = UDim2.new(0, 4.5, 0, 60)
menuFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

local menuLayout = Instance.new("UIListLayout", menuFrame)
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- พื้นที่แสดงเนื้อหา
local contentFrame = Instance.new("Frame", guiFrame)
contentFrame.Size = UDim2.new(1, -110, 1, -20)
contentFrame.Position = UDim2.new(0, 110, 0, 10)
contentFrame.BackgroundColor3 = Color3.fromRGB(90, 90, 90)

-- ข้อความแสดงเนื้อหา
local contentLabel = Instance.new("TextLabel", contentFrame)
contentLabel.Size = UDim2.new(1, -20, 0, 50)
contentLabel.Position = UDim2.new(0, 10, 0, 10)
contentLabel.BackgroundTransparency = 1
contentLabel.TextColor3 = Color3.new(1, 1, 1)
contentLabel.TextSize = 18
contentLabel.TextWrapped = true
contentLabel.Text = "เลือกเมนูจากด้านซ้าย"
local fastMenuTitle = Instance.new("TextLabel", contentFrame)
            fastMenuTitle.Size = UDim2.new(1, -20, 0, 30)
            fastMenuTitle.Position = UDim2.new(0, -190, 0, 10)
            fastMenuTitle.BackgroundTransparency = 1
            fastMenuTitle.TextColor3 = Color3.new(1, 1, 1)
            fastMenuTitle.TextSize = 16
            fastMenuTitle.RichText = true
            fastMenuTitle.Text = "<b>Skibidi</b>"

-- ฟังก์ชันสร้างปุ่มเมนู
local function createMenuButton(name, text)
    local menuButton = Instance.new("TextButton", menuFrame)
    menuButton.Size = UDim2.new(1, 0, 0, 40)
    menuButton.Text = name
    menuButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    menuButton.TextColor3 = Color3.new(1, 1, 1)
    menuButton.LayoutOrder = #menuFrame:GetChildren()

    menuButton.MouseButton1Click:Connect(function()
        contentLabel.Text = text
        for _, v in pairs(contentFrame:GetChildren()) do
            if v:IsA("TextButton") or v:IsA("TextLabel") then 
                v:Destroy() 
            end
        end

        if name == "Main" then
            -- หัวข้อหลัก
            local fastMenuTitle = Instance.new("TextLabel", contentFrame)
            fastMenuTitle.Size = UDim2.new(1, -20, 0, 30)
            fastMenuTitle.Position = UDim2.new(0, 10, 0, 8)
            fastMenuTitle.BackgroundTransparency = 1
            fastMenuTitle.TextColor3 = Color3.new(1, 1, 1)
            fastMenuTitle.TextSize = 25
            fastMenuTitle.RichText = true
            fastMenuTitle.Text = "<b>เมนูดึงไอเท็ม</b>"

local fastMenuTitle = Instance.new("TextLabel", contentFrame)
            fastMenuTitle.Size = UDim2.new(1, -20, 0, 30)
            fastMenuTitle.Position = UDim2.new(0, -190, 0, 10)
            fastMenuTitle.BackgroundTransparency = 1
            fastMenuTitle.TextColor3 = Color3.new(1, 1, 1)
            fastMenuTitle.TextSize = 16
            fastMenuTitle.RichText = true
            fastMenuTitle.Text = "<b>Skibidi</b>"


            -- ปุ่ม Silver Bar
            local silverButton = Instance.new("TextButton", contentFrame)
            silverButton.Size = UDim2.new(1, -20, 0, 30)
            silverButton.Position = UDim2.new(0, 10, 0, 50)
            silverButton.Text = "Silver Bar $25"
            silverButton.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
            silverButton.TextColor3 = Color3.new(1, 1, 1)

            silverButton.MouseButton1Click:Connect(function()
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = character.HumanoidRootPart
                    local vasePart = game.Workspace.RuntimeItems.SilverBar:FindFirstChild("Prop_GoldBar")
                    if vasePart then
                        vasePart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    else
                        warn("Silver Bar ไม่พบ")
                    end
                end
            end)

local silverButton = Instance.new("TextButton", contentFrame)
            silverButton.Size = UDim2.new(1, -20, 0, 30)
            silverButton.Position = UDim2.new(0, 10, 0, 90)
            silverButton.Text = "Gold Bar $50"
            silverButton.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
            silverButton.TextColor3 = Color3.new(1, 1, 1)

            silverButton.MouseButton1Click:Connect(function()
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = character.HumanoidRootPart
                    local vasePart = game.Workspace.RuntimeItems.Goldbar:FindFirstChild("Prop_GoldBar")
                    if vasePart then
                        vasePart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    else
                        warn("Silver Bar ไม่พบ")
                    end
                end
            end)

            -- ปุ่ม Statue Golden
            local statueButton = Instance.new("TextButton", contentFrame)
            statueButton.Size = UDim2.new(1, -20, 0, 30)
            statueButton.Position = UDim2.new(0, 10, 0, 130)
            statueButton.Text = "Statue Golden $45"
            statueButton.BackgroundColor3 = Color3.fromRGB(120, 120, 255)
            statueButton.TextColor3 = Color3.new(1, 1, 1)

            statueButton.MouseButton1Click:Connect(function()
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = character.HumanoidRootPart
                    local vasePart = game.Workspace.RuntimeItems.Statue:FindFirstChild("Angel Lucy Statue II")
                    if vasePart then
                        vasePart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    else
                        warn("Statue ไม่พบ")
                    end
                end
            end)

local statueButton = Instance.new("TextButton", contentFrame)
            statueButton.Size = UDim2.new(1, -20, 0, 30)
            statueButton.Position = UDim2.new(0, 10, 0, 170)
            statueButton.Text = "Barrel - Fuel +25%"
            statueButton.BackgroundColor3 = Color3.fromRGB(120, 0, 120)
            statueButton.TextColor3 = Color3.new(1, 1, 1)

            statueButton.MouseButton1Click:Connect(function()
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = character.HumanoidRootPart
                    local vasePart = game.Workspace.RuntimeItems.Barrel:FindFirstChild("Union")
                    if vasePart then
                        vasePart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    else
                        warn("Statue ไม่พบ")
                    end
                end
            end)

local statueButton = Instance.new("TextButton", contentFrame)
            statueButton.Size = UDim2.new(1, -20, 0, 30)
            statueButton.Position = UDim2.new(0, 10, 0, 210)
            statueButton.Text = "Coal - Fuel +45%"
            statueButton.BackgroundColor3 = Color3.fromRGB(120, 0, 120)
            statueButton.TextColor3 = Color3.new(1, 1, 1)

            statueButton.MouseButton1Click:Connect(function()
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    local humanoidRootPart = character.HumanoidRootPart
                    local vasePart = game.Workspace.RuntimeItems.Coal:FindFirstChild("Coal")
                    if vasePart then
                        vasePart.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    else
                        warn("Statue ไม่พบ")
                    end
                end
            end)

        elseif name == "Auto" then
            local comingSoon = Instance.new("TextLabel", contentFrame)
            comingSoon.Size = UDim2.new(1, -20, 0, 50)
            comingSoon.Position = UDim2.new(0, 10, 0, 60)
            comingSoon.BackgroundTransparency = 1
            comingSoon.TextColor3 = Color3.new(1, 1, 1)
            comingSoon.TextSize = 20
            comingSoon.Text = "Coming Soon"
local fastMenuTitle = Instance.new("TextLabel", contentFrame)
            fastMenuTitle.Size = UDim2.new(1, -20, 0, 30)
            fastMenuTitle.Position = UDim2.new(0, -190, 0, 10)
            fastMenuTitle.BackgroundTransparency = 1
            fastMenuTitle.TextColor3 = Color3.new(1, 1, 1)
            fastMenuTitle.TextSize = 16
            fastMenuTitle.RichText = true
            fastMenuTitle.Text = "<b>Skibidi</b>"
elseif name == "Player" then
            local fastMenuTitle = Instance.new("TextLabel", contentFrame)
            fastMenuTitle.Size = UDim2.new(1, -20, 0, 30)
            fastMenuTitle.Position = UDim2.new(0, 10, 0, 8)
            fastMenuTitle.BackgroundTransparency = 1
            fastMenuTitle.TextColor3 = Color3.new(1, 1, 1)
            fastMenuTitle.TextSize = 25
            fastMenuTitle.RichText = true
            fastMenuTitle.Text = "<b>Noclip</b>"
local fastMenuTitle = Instance.new("TextLabel", contentFrame)
            fastMenuTitle.Size = UDim2.new(1, -20, 0, 30)
            fastMenuTitle.Position = UDim2.new(0, -190, 0, 10)
            fastMenuTitle.BackgroundTransparency = 1
            fastMenuTitle.TextColor3 = Color3.new(1, 1, 1)
            fastMenuTitle.TextSize = 16
            fastMenuTitle.RichText = true
            fastMenuTitle.Text = "<b>Skibidi</b>"

local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Plr = Players.LocalPlayer
local Clipon = false
local Stepped

-- ปุ่ม Toggle Noclip
local statueButton = Instance.new("TextButton")
statueButton.Size = UDim2.new(1, -20, 0, 30)
statueButton.Position = UDim2.new(0, 10, 0, 50)
statueButton.RichText = true
statueButton.Text = "<b>Toggle Noclip</b>"
statueButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
statueButton.TextColor3 = Color3.new(1, 1, 1)
statueButton.Parent = contentFrame

statueButton.MouseButton1Click:Connect(function()
    if not Clipon then
        Clipon = true
        statueButton.Text = "<b>Noclip: ON</b>"
        statueButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

        Stepped = RunService.Stepped:Connect(function()
            if Clipon then
                for _, b in pairs(Workspace:GetChildren()) do
                    if b.Name == Plr.Name then
                        for _, v in pairs(b:GetChildren()) do
                            if v:IsA("BasePart") then
                                v.CanCollide = false
                            end
                        end
                    end
                end
            else
                Stepped:Disconnect()
            end
        end)
    else
        Clipon = false
        statueButton.Text = "<b>Noclip: Off</b>"
        statueButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

local fastMenuTitle = Instance.new("TextLabel", contentFrame)
            fastMenuTitle.Size = UDim2.new(1, -20, 0, 30)
            fastMenuTitle.Position = UDim2.new(0, 10, 0, 90)
            fastMenuTitle.BackgroundTransparency = 1
            fastMenuTitle.TextColor3 = Color3.new(1, 1, 1)
            fastMenuTitle.TextSize = 25
            fastMenuTitle.RichText = true
            fastMenuTitle.Text = "<b>Jump x3</b>"

local Kk = Instance.new("TextButton", contentFrame)
Kk.Size = UDim2.new(1, -20, 0, 30)
Kk.Position = UDim2.new(0, 10, 0, 130)
Kk.RichText = true
Kk.Text = "<b>Toggle Jump</b>"
Kk.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Kk.TextColor3 = Color3.new(1, 1, 1)

local jumpLevels = {
    {power = 50, color = Color3.fromRGB(0, 255, 0), text = "<b>Jump x1</b>"},
    {power = 100, color = Color3.fromRGB(255, 255, 0), text = "<b>Jump x2</b>"},
    {power = 200, color = Color3.fromRGB(255, 0, 0), text = "<b>Jump Max</b>"},
    {power = 50, color = Color3.fromRGB(255, 0, 0), text = "<b>Toggle Jump</b>"} -- รีเซ็ตกลับค่าเดิม
}

local currentIndex = 1
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

Kk.MouseButton1Click:Connect(function()
    if humanoid then
        humanoid.JumpPower = jumpLevels[currentIndex].power
        Kk.BackgroundColor3 = jumpLevels[currentIndex].color
        Kk.Text = jumpLevels[currentIndex].text
        
        currentIndex = currentIndex % #jumpLevels + 1 -- วนลูปเปลี่ยนค่า
    end
end)

local fastMenuTitle = Instance.new("TextLabel", contentFrame)
            fastMenuTitle.Size = UDim2.new(1, -20, 0, 30)
            fastMenuTitle.Position = UDim2.new(0, 10, 0, 170)
            fastMenuTitle.BackgroundTransparency = 1
            fastMenuTitle.TextColor3 = Color3.new(1, 1, 1)
            fastMenuTitle.TextSize = 25
            fastMenuTitle.RichText = true
            fastMenuTitle.Text = "<b>Speed x3</b>"

local Uu = Instance.new("TextButton", contentFrame)
Uu.Size = UDim2.new(1, -20, 0, 30)
Uu.Position = UDim2.new(0, 10, 0, 210)
Uu.RichText = true
Uu.Text = "<b>Toggle Speed</b>"
Uu.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Uu.TextColor3 = Color3.new(1, 1, 1)

local speedLevels = {
    {speed = 16, color = Color3.fromRGB(0, 255, 0), text = "<b>Speed x1</b>"},
    {speed = 30, color = Color3.fromRGB(255, 255, 0), text = "<b>Speed x2</b>"},
    {speed = 35, color = Color3.fromRGB(255, 0, 0), text = "<b>Speed Max</b>"},
    {speed = 16, color = Color3.fromRGB(255, 0, 0), text = "<b>Toggle Speed</b>"} -- รีเซ็ตกลับค่าเดิม
}

local currentIndex = 1
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

Uu.MouseButton1Click:Connect(function()
    if humanoid then
        humanoid.WalkSpeed = speedLevels[currentIndex].speed
        Uu.BackgroundColor3 = speedLevels[currentIndex].color
        Uu.Text = speedLevels[currentIndex].text
        
        currentIndex = currentIndex % #speedLevels + 1 -- วนลูปเปลี่ยนค่า
    end
end)



elseif name == "Esp" then
local fastMenuTitle = Instance.new("TextLabel", contentFrame)
            fastMenuTitle.Size = UDim2.new(1, -20, 0, 30)
            fastMenuTitle.Position = UDim2.new(0, 10, 0, 5)
            fastMenuTitle.BackgroundTransparency = 1
            fastMenuTitle.TextColor3 = Color3.new(1, 1, 1)
            fastMenuTitle.TextSize = 25
            fastMenuTitle.RichText = true
            fastMenuTitle.Text = "<b>Player</b>"
local button = Instance.new("TextButton", contentFrame)
            button.Size = UDim2.new(1, -20, 0, 30)
            button.Position = UDim2.new(0, 10, 0, 50)
            button.RichText = true 
            button.Text = "<b>Esp (NOT TOGGLE)</b>"
            button.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
            button.TextColor3 = Color3.new(1, 1, 1)

-- สร้างปุ่มใน GU

-- เมื่อกดปุ่มให้ทำการไฮไลต์ผู้เล่น
button.MouseButton1Click:Connect(function()
    for _, p in pairs(game.Players:GetPlayers()) do
        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            -- สร้าง Highlight
            local highlight = Instance.new("Highlight")
            highlight.Parent = p.Character
            highlight.FillTransparency = 0.75
            highlight.FillColor = Color3.fromRGB(255, 255, 255)  -- เปลี่ยนสีได้ตามต้องการ
            highlight.OutlineTransparency = 0.2
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            
            -- สร้าง BillboardGui สำหรับแสดงชื่อ
            local billboardGui = Instance.new("BillboardGui")
            billboardGui.Parent = p.Character.HumanoidRootPart
            billboardGui.Size = UDim2.new(0, 200, 0, 50)
            billboardGui.Adornee = p.Character.HumanoidRootPart
            billboardGui.StudsOffset = Vector3.new(0, 3, 0)
            billboardGui.AlwaysOnTop = true
            
            local textLabel = Instance.new("TextLabel")
            textLabel.Parent = billboardGui
            textLabel.Size = UDim2.new(0.7, 0, 0.7, 0)
            textLabel.BackgroundTransparency = 1
            textLabel.Text = p.Name
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextStrokeTransparency = 0.5
            textLabel.TextScaled = true
        end
    end
end)
elseif name == "Cheat" then
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local function setNoCooldown(enabled)
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("ProximityPrompt") then
            part.HoldDuration = enabled and 0 or 1 -- ตั้งค่า HoldDuration เป็น 0 หรือรีเซ็ตเป็น 1 วินาที
        end
    end
end

local fastMenuTitle = Instance.new("TextLabel", contentFrame)
            fastMenuTitle.Size = UDim2.new(1, -20, 0, 30)
            fastMenuTitle.Position = UDim2.new(0, 10, 0, 5)
            fastMenuTitle.BackgroundTransparency = 1
            fastMenuTitle.TextColor3 = Color3.new(1, 1, 1)
            fastMenuTitle.TextSize = 25
            fastMenuTitle.RichText = true
            fastMenuTitle.Text = "<b>ProximityPrompt</b>"
local button = Instance.new("TextButton", contentFrame)
            button.Size = UDim2.new(1, -20, 0, 30)
            button.Position = UDim2.new(0, 10, 0, 50)
            button.RichText = true 
            button.Text = "<b>No Cooldown (NOT TOGGLE) , sell, anything</b>"
            button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            button.TextColor3 = Color3.new(1, 1, 1)

local noCooldownEnabled = false

button.MouseButton1Click:Connect(function()
    noCooldownEnabled = not noCooldownEnabled
    setNoCooldown(noCooldownEnabled)
end)
        end
    end)
end

createMenuButton("Main", "เลือกไอเทมสำหรับฟาร์ม")
createMenuButton("Player", "สคริปพลังพิเศษ")
createMenuButton("Cheat", "ความสะดวกสบาย")
createMenuButton("Esp", "แสดงผู้เล่น")
createMenuButton("Auto", "ระบบออโต้")

-- เปิด/ปิด GUI
button.MouseButton1Click:Connect(function()
    guiFrame.Visible = not guiFrame.Visible
end)

closeButton.MouseButton1Click:Connect(function()
    guiFrame.Visible = false
end)
