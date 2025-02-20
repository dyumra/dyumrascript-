local player = game.Players.LocalPlayer
local playerGui = player:FindFirstChild("PlayerGui")

-- **สร้าง ScreenGui**
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Name = "MainUI"
screenGui.ResetOnSpawn = false
screenGui.Enabled = true -- เปิด UI ทันทีหลังจากโหลดเสร็จ

-- **หน้าโหลดเต็มจอ**
local loadingScreen = Instance.new("Frame")
loadingScreen.Size = UDim2.new(1, 0, 1, 0)
loadingScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
loadingScreen.BackgroundTransparency = 0.4 -- สีดำใสกลางๆ
loadingScreen.Parent = playerGui

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0.2, 0)
loadingText.Position = UDim2.new(0, 0, 0.4, 0)
loadingText.Text = "Loading... 0%"
loadingText.TextSize = 30
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.SourceSansBold
loadingText.Parent = loadingScreen

local youtubeText = Instance.new("TextLabel")
youtubeText.Size = UDim2.new(1, 0, 0.1, 0)
youtubeText.Position = UDim2.new(0, 0, 0.6, 0)
youtubeText.Text = "YouTube: ZeFlexz"
youtubeText.TextSize = 24
youtubeText.TextColor3 = Color3.fromRGB(255, 215, 0) -- สีทอง
youtubeText.BackgroundTransparency = 1
youtubeText.Font = Enum.Font.SourceSansBold
youtubeText.Parent = loadingScreen

-- **ฟังก์ชันโหลด (1-100%)**
local function startLoading()
    for i = 1, 100 do
        loadingText.Text = "Loading... " .. i .. "%"
        wait(0.05) -- ค่อยๆ โหลดช้าๆ
    end
    loadingScreen:Destroy() -- ลบหน้าโหลด
    screenGui.Enabled = true -- เปิด UI หลัก
    showNotification("ขอให้สนุกกับสคริปต์!") -- แสดงแจ้งเตือน
end

-- **ฟังก์ชันแสดงแจ้งเตือน**
local function showNotification(text)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0.2, 0, 0.05, 0)
    notification.Position = UDim2.new(0.78, 0, 0.05, 0) -- ขวาบนจอ
    notification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notification.BackgroundTransparency = 0.5 -- สีขาวใส
    notification.Text = text
    notification.TextColor3 = Color3.fromRGB(0, 0, 0)
    notification.TextSize = 18
    notification.Font = Enum.Font.SourceSansBold
    notification.Parent = playerGui

    wait(3) -- แสดงแจ้งเตือน 3 วินาที
    notification:Destroy()
end

-- **ฟังก์ชันตกแต่ง UI (มุมโค้ง + ขอบโปร่งแสง)**
local function applyUIStyle(element, cornerSize, strokeColor)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, cornerSize)
    corner.Parent = element

    local stroke = Instance.new("UIStroke")
    stroke.Color = strokeColor
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    stroke.Parent = element
end

-- **MainFrame (UI หลัก)**
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Position = UDim2.new(0.25, 0, 0.25, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.Parent = screenGui
applyUIStyle(mainFrame, 10, Color3.fromRGB(255, 0, 0))

-- **หัวข้อ "Script By ZeFlexz" พร้อมเอฟเฟกต์สีเปลี่ยน**
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0.15, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.Text = "skibidi"
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 28
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- สีเริ่มต้น
titleLabel.Parent = mainFrame

-- **ฟังก์ชันเปลี่ยนสี Text แบบสุ่มวนลูป**
local function randomColorEffect()
    while true do
        titleLabel.TextColor3 = Color3.fromRGB(math.random(100, 255), math.random(100, 255), math.random(100, 255))
        wait(0.5)
    end
end
spawn(randomColorEffect) -- เรียกใช้งานฟังก์ชัน

-- **ปุ่มเปิด/ปิด UI**
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.1, 0, 0.05, 0)
toggleButton.Position = UDim2.new(0.01, 0, 0.01, 0) 
toggleButton.Text = "UI"
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui
applyUIStyle(toggleButton, 8, Color3.fromRGB(255, 0, 0))

-- **ฟังก์ชันสร้างปุ่ม UI**
local function createButton(text, posY)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.8, 0, 0.15, 0)
    button.Position = UDim2.new(0.1, 0, posY, 0)
    button.Text = text
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = mainFrame
    applyUIStyle(button, 8, Color3.fromRGB(255, 0, 0))
    return button
end

-- **สร้างปุ่มต่าง ๆ**
local giveCashButton = createButton("เสกเงิน 100 ต่อวินาที", 0.3)
local teleportButton = createButton("Menu's Teleport", 0.5)
local killAllButton = createButton("Kill All (Damage 20 player all)", 0.7) -- ปุ่ม Kill All

-- **ฟังก์ชันทำดาเมจทุกผู้เล่น**
local function damageAllPlayers(damageAmount)
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:TakeDamage(damageAmount)
            end
        end
    end
end

-- **เชื่อมต่อปุ่ม Kill All กับฟังก์ชัน damageAllPlayers**
killAllButton.MouseButton1Click:Connect(function()
    damageAllPlayers(20)  -- ทำดาเมจ 20 แก่ผู้เล่นทุกคน
    killAllButton.Text = "Killed All Players"
    wait(2)  -- ตั้งเวลาให้ข้อความแสดงออกมาซักพัก
    killAllButton.Text = "Kill All"  -- รีเซ็ตข้อความ
end)

-- **ฟังก์ชันปิด/เปิด UI**
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- **ฟังก์ชันให้เงินอัตโนมัติ**
local givingCash = false
giveCashButton.MouseButton1Click:Connect(function()
    givingCash = not givingCash
    giveCashButton.Text = givingCash and "หยุดเสก เงิน" or "เสกเงิน"
    
    while givingCash do
        game:GetService("ReplicatedStorage").ClaimCashEvent:FireServer(1000, "Bonus")
        wait(0.5)
    end
end)

-- **ฟังก์ชันเปิด/ปิด Teleport**
local teleportVisible = true
teleportButton.MouseButton1Click:Connect(function()
    teleportVisible = not teleportVisible
    game:GetService("Players").LocalPlayer.PlayerGui.teleport.tele.Visible = teleportVisible
end)

-- **เริ่มต้นโหลด**
startLoading()
