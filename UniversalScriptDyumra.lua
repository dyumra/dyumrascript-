-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Default setting
local correctKey = "dyumra"
local wrongAttempts = 0
local maxWrongAttempts = 3

local headless = false
local camlock = false
local esp = false

-- Variables
local camlockTarget = nil -- player ที่ถูกล็อค
local lockPart = "Head" -- "Head" หรือ "Torso" (Torso = HumanoidRootPart)

-- ====== Notification =======
local notification = Instance.new("TextLabel")
notification.Size = UDim2.new(0, 250, 0, 40)
notification.Position = UDim2.new(1, -260, 1, -50)
notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
notification.BackgroundTransparency = 0.6
notification.TextColor3 = Color3.new(1, 1, 1)
notification.Font = Enum.Font.SourceSansBold
notification.TextSize = 18
notification.Visible = false
notification.Text = ""
notification.ZIndex = 10
notification.Parent = playerGui

local function showNotification(msg, duration)
    notification.Text = msg
    notification.Visible = true
    spawn(function()
        wait(duration or 3)
        notification.Visible = false
    end)
end

-- ====== GUI Main =======
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "main"
mainGui.Enabled = false
mainGui.Parent = playerGui

-- Background Frame (red theme, rounded corners)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 300)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
frame.BackgroundTransparency = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.ClipsDescendants = true
frame.Parent = mainGui

-- UI corner (round edges)
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 15)
uicorner.Parent = frame

-- Draggable logic
local dragging
local dragInput
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==== Close/Open Button (top right corner) ====

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 40, 0, 30)
toggleBtn.Position = UDim2.new(1, -45, 0, 5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Text = "X"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.AutoButtonColor = true
toggleBtn.ZIndex = 11
toggleBtn.Parent = frame

local function toggleGui()
    mainGui.Enabled = not mainGui.Enabled
end

toggleBtn.MouseButton1Click:Connect(toggleGui)

-- ==== Title Label ====

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -10, 0, 30)
titleLabel.Position = UDim2.new(0, 5, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Text = "Control Panel"
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 22
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = frame

-- ==== Camlock Button ====

local camlockBtn = Instance.new("TextButton")
camlockBtn.Size = UDim2.new(0, 120, 0, 35)
camlockBtn.Position = UDim2.new(0, 10, 0, 50)
camlockBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
camlockBtn.TextColor3 = Color3.new(1, 1, 1)
camlockBtn.Font = Enum.Font.SourceSansBold
camlockBtn.TextSize = 18
camlockBtn.Text = "Camlock: Off"
camlockBtn.Parent = frame

camlockBtn.MouseButton1Click:Connect(function()
    camlock = not camlock
    camlockBtn.Text = "Camlock: " .. (camlock and "On" or "Off")
    if not camlock then
        camlockTarget = nil
    end
end)

-- ==== Lock Part Button ====

local lockPartBtn = Instance.new("TextButton")
lockPartBtn.Size = UDim2.new(0, 120, 0, 35)
lockPartBtn.Position = UDim2.new(0, 140, 0, 50)
lockPartBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
lockPartBtn.TextColor3 = Color3.new(1, 1, 1)
lockPartBtn.Font = Enum.Font.SourceSansBold
lockPartBtn.TextSize = 18
lockPartBtn.Text = "Lock: Head"
lockPartBtn.Parent = frame

lockPartBtn.MouseButton1Click:Connect(function()
    if lockPart == "Head" then
        lockPart = "Torso"
    else
        lockPart = "Head"
    end
    lockPartBtn.Text = "Lock: " .. lockPart
end)

-- ==== Headless Button ====

local headlessBtn = Instance.new("TextButton")
headlessBtn.Size = UDim2.new(0, 120, 0, 35)
headlessBtn.Position = UDim2.new(0, 270, 0, 50)
headlessBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
headlessBtn.TextColor3 = Color3.new(1, 1, 1)
headlessBtn.Font = Enum.Font.SourceSansBold
headlessBtn.TextSize = 18
headlessBtn.Text = "Headless: Off"
headlessBtn.Parent = frame

headlessBtn.MouseButton1Click:Connect(function()
    headless = not headless
    headlessBtn.Text = "Headless: " .. (headless and "On" or "Off")
    -- update transparency of head and face immediately
    local character = LocalPlayer.Character
    if character then
        local head = character:FindFirstChild("Head")
        local face = head and head:FindFirstChild("face")
        if head then head.Transparency = headless and 1 or 0 end
        if face then face.Transparency = headless and 1 or 0 end
    end
end)

-- ==== Hitbox TextBox and Buttons ====

local hitboxLabel = Instance.new("TextLabel")
hitboxLabel.Size = UDim2.new(0, 150, 0, 25)
hitboxLabel.Position = UDim2.new(0, 10, 0, 100)
hitboxLabel.BackgroundTransparency = 1
hitboxLabel.TextColor3 = Color3.new(1,1,1)
hitboxLabel.Font = Enum.Font.SourceSansBold
hitboxLabel.TextSize = 16
hitboxLabel.Text = "Hitbox Size (e.g 1, 2):"
hitboxLabel.Parent = frame

local hitboxTextBox = Instance.new("TextBox")
hitboxTextBox.Size = UDim2.new(0, 120, 0, 30)
hitboxTextBox.Position = UDim2.new(0, 170, 0, 95)
hitboxTextBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
hitboxTextBox.TextColor3 = Color3.new(0,0,0)
hitboxTextBox.Font = Enum.Font.SourceSans
hitboxTextBox.TextSize = 18
hitboxTextBox.Text = "1"
hitboxTextBox.ClearTextOnFocus = false
hitboxTextBox.Parent = frame

-- ปุ่ม Enter Hitbox
local enterHitboxBtn = Instance.new("TextButton")
enterHitboxBtn.Size = UDim2.new(0, 100, 0, 30)
enterHitboxBtn.Position = UDim2.new(0, 10, 0, 140)
enterHitboxBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
enterHitboxBtn.TextColor3 = Color3.new(1, 1, 1)
enterHitboxBtn.Font = Enum.Font.SourceSansBold
enterHitboxBtn.TextSize = 18
enterHitboxBtn.Text = "Enter Hitbox"
enterHitboxBtn.Parent = frame

-- ปุ่ม Enter Head
local enterHeadBtn = Instance.new("TextButton")
enterHeadBtn.Size = UDim2.new(0, 100, 0, 30)
enterHeadBtn.Position = UDim2.new(0, 130, 0, 140)
enterHeadBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
enterHeadBtn.TextColor3 = Color3.new(1, 1, 1)
enterHeadBtn.Font = Enum.Font.SourceSansBold
enterHeadBtn.TextSize = 18
enterHeadBtn.Text = "Enter Head"
enterHeadBtn.Parent = frame

-- ปุ่ม Enter Humanoid
local enterHumanoidBtn = Instance.new("TextButton")
enterHumanoidBtn.Size = UDim2.new(0, 100, 0, 30)
enterHumanoidBtn.Position = UDim2.new(0, 250, 0, 140)
enterHumanoidBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
enterHumanoidBtn.TextColor3 = Color3.new(1, 1, 1)
enterHumanoidBtn.Font = Enum.Font.SourceSansBold
enterHumanoidBtn.TextSize = 18
enterHumanoidBtn.Text = "Enter Humanoid"
enterHumanoidBtn.Parent = frame

-- ==== ESP Button ====

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 120, 0, 35)
espBtn.Position = UDim2.new(0, 10, 0, 190)
espBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 18
espBtn.Text = "ESP: Off"
espBtn.Parent = frame

-- =================================
-- ฟังก์ชันช่วย

local function resizePart(part, size, transparency)
    if part and part:IsA("BasePart") then
        part.Size = Vector3.new(size, size, size)
        part.Transparency = transparency
    end
end

local function resizeHead(character, size, transparency)
    local head = character and character:FindFirstChild("Head")
    if head then
        resizePart(head, size, transparency)
    end
end

local function resizeHumanoidRootPart(character, size, transparency)
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then
        resizePart(root, size, transparency)
    end
end

local function createHighlight(player)
    -- ตรวจสอบว่า player.Character อยู่
    if not player.Character then return end
    local char = player.Character
    local highlight = char:FindFirstChild("ESPHighlight")
    if highlight then highlight:Destroy() end
    
    highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = char
end

local function removeHighlight(player)
    if not player.Character then return end
    local highlight = player.Character:FindFirstChild("ESPHighlight")
    if highlight then
        highlight:Destroy()
    end
end

-- ฟังก์ชัน update headless
local function updateHeadless()
    local character = LocalPlayer.Character
    if character then
        local head = character:FindFirstChild("Head")
        local face = head and head:FindFirstChild("face")
        if head then head.Transparency = headless and 1 or 0 end
        if face then face.Transparency = headless and 1 or 0 end
    end
end

-- ฟังก์ชัน update hitbox ตามขนาดใน textbox
local function updateHitbox(sizeNum)
    local character = LocalPlayer.Character
    if not character then return end
    local size = tonumber(sizeNum)
    if not size or size <= 0 then
        showNotification("Invalid size! Use positive number.", 3)
        return
    end
    local head = character:FindFirstChild("Head")
    if head then
        resizePart(head, size, 0.7)
    end
end

-- ฟังก์ชัน Enter Head (เปลี่ยน head เป็นขนาดที่ textbox ระบุ)
local function enterHead()
    local size = tonumber(hitboxTextBox.Text)
    if not size or size <= 0 then
        showNotification("Invalid size for head!", 3)
        return
    end
    local character = LocalPlayer.Character
    if not character then return end
    resizeHead(character, size, 0.7)
end

-- ฟังก์ชัน Enter HumanoidRootPart
local function enterHumanoid()
    local size = tonumber(hitboxTextBox.Text)
    if not size or size <= 0 then
        showNotification("Invalid size for humanoid!", 3)
        return
    end
    local character = LocalPlayer.Character
    if not character then return end
    resizeHumanoidRootPart(character, size, 0.7)
end

-- ======= Event Connect ======

enterHitboxBtn.MouseButton1Click:Connect(function()
    updateHitbox(hitboxTextBox.Text)
end)

enterHeadBtn.MouseButton1Click:Connect(enterHead)

enterHumanoidBtn.MouseButton1Click:Connect(enterHumanoid)

espBtn.MouseButton1Click:Connect(function()
    esp = not esp
    espBtn.Text = "ESP: " .. (esp and "On" or "Off")
    if not esp then
        for _, plr in pairs(Players:GetPlayers()) do
            removeHighlight(plr)
        end
    end
end)

-- ==== Camlock Implementation ====
RunService.RenderStepped:Connect(function()
    if camlock and camlockTarget and camlockTarget.Character and camlockTarget.Character:FindFirstChild(lockPart == "Head" and "Head" or "HumanoidRootPart") then
        local cam = workspace.CurrentCamera
        local part = camlockTarget.Character[lockPart == "Head" and "Head" or "HumanoidRootPart"]
        cam.CameraType = Enum.CameraType.Scriptable
        cam.CFrame = CFrame.new(cam.CFrame.Position, part.Position)
    else
        local cam = workspace.CurrentCamera
        if cam.CameraType == Enum.CameraType.Scriptable then
            cam.CameraType = Enum.CameraType.Custom
        end
    end
end)

-- เลือกเป้าหมาย camlock โดยคลิกที่ player ในโลก (ใช้ Mouse Target)
local mouse = LocalPlayer:GetMouse()
mouse.Button1Down:Connect(function()
    if camlock then
        local target = mouse.Target
        if target then
            local plr = Players:GetPlayerFromCharacter(target.Parent)
            if plr and plr ~= LocalPlayer then
                camlockTarget = plr
                showNotification("Camlock on " .. plr.Name, 3)
            end
        end
    end
end)

-- ===== Headless Update Loop =====
RunService.RenderStepped:Connect(function()
    updateHeadless()
end)

-- ===== ESP Update Loop =====
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if esp then
            wait(1)
            createHighlight(plr)
        end
    end)
end)

-- รีแอคทีฟ ESP สำหรับคนที่อยู่แล้ว
for _, plr in pairs(Players:GetPlayers()) do
    if esp and plr ~= LocalPlayer then
        if plr.Character then
            createHighlight(plr)
        end
        plr.CharacterAdded:Connect(function()
            wait(1)
            createHighlight(plr)
        end)
    end
end

-- ===== ระบบป้อน Key เปิด GUI =====
local inputGui = Instance.new("ScreenGui")
inputGui.Name = "InputGui"
inputGui.Parent = playerGui

local inputFrame = Instance.new("Frame")
inputFrame.Size = UDim2.new(0, 300, 0, 120)
inputFrame.Position = UDim2.new(0.5, -150, 0.5, -60)
inputFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
inputFrame.BackgroundTransparency = 0
inputFrame.AnchorPoint = Vector2.new(0.5, 0.5)
inputFrame.Parent = inputGui

local inputUICorner = Instance.new("UICorner")
inputUICorner.CornerRadius = UDim.new(0, 10)
inputUICorner.Parent = inputFrame

local promptLabel = Instance.new("TextLabel")
promptLabel.Size = UDim2.new(1, -20, 0, 30)
promptLabel.Position = UDim2.new(0, 10, 0, 10)
promptLabel.BackgroundTransparency = 1
promptLabel.TextColor3 = Color3.new(1, 1, 1)
promptLabel.Font = Enum.Font.SourceSansBold
promptLabel.TextSize = 20
promptLabel.Text = "Enter Key to Universal Script"
promptLabel.Parent = inputFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(1, -20, 0, 40)
keyBox.Position = UDim2.new(0, 10, 0, 50)
keyBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
keyBox.TextColor3 = Color3.new(0, 0, 0)
keyBox.Font = Enum.Font.SourceSansBold
keyBox.TextSize = 25
keyBox.ClearTextOnFocus = true
keyBox.PlaceholderText = "Type key here..."
keyBox.Parent = inputFrame

local function resetKeyBox()
    keyBox.Text = ""
end

keyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        if keyBox.Text:lower() == correctKey then
            mainGui.Enabled = true
            inputGui.Enabled = false
            showNotification("Welcome! GUI Enabled.", 3)
        else
            wrongAttempts = wrongAttempts + 1
            showNotification("Wrong key! Attempts: " .. wrongAttempts, 3)
            if wrongAttempts >= maxWrongAttempts then
                LocalPlayer:Kick("Too many wrong key attempts!")
            else
                resetKeyBox()
            end
        end
    end
end)
