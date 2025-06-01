local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ## GUI สำหรับใส่ Key (หน้าแรก) ##
local KeyScreenGui = Instance.new("ScreenGui")
KeyScreenGui.Name = "KeyEntryGui"
KeyScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- ธีมดำ
KeyFrame.BorderSizePixel = 2
KeyFrame.BorderColor3 = Color3.fromRGB(255, 255, 255) -- ขอบขาว
KeyFrame.CornerRadius = UDim.new(0, 15) -- ขอบกลม
KeyFrame.Draggable = true -- ทำให้ลากได้
KeyFrame.Parent = KeyScreenGui

local KeyPrompt = Instance.new("TextLabel")
KeyPrompt.Name = "KeyPrompt"
KeyPrompt.Size = UDim2.new(1, -20, 0, 30)
KeyPrompt.Position = UDim2.new(0, 10, 0, 20)
KeyPrompt.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
KeyPrompt.BackgroundTransparency = 1
KeyPrompt.Text = "Enter Key to Access GUI"
KeyPrompt.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyPrompt.Font = Enum.Font.SourceSansBold
KeyPrompt.TextSize = 20
KeyPrompt.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Name = "KeyInput"
KeyInput.Size = UDim2.new(0, 250, 0, 40)
KeyInput.Position = UDim2.new(0.5, -125, 0, 60)
KeyInput.PlaceholderText = "Enter your key here..."
KeyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.TextSize = 16
KeyInput.CornerRadius = UDim.new(0, 5)
KeyInput.Parent = KeyFrame

local SubmitKeyButton = Instance.new("TextButton")
SubmitKeyButton.Name = "SubmitKeyButton"
SubmitKeyButton.Size = UDim2.new(0, 100, 0, 35)
SubmitKeyButton.Position = UDim2.new(0.5, -50, 0, 105)
SubmitKeyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
SubmitKeyButton.Text = "Submit"
SubmitKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SubmitKeyButton.Font = Enum.Font.SourceSansBold
SubmitKeyButton.TextSize = 18
SubmitKeyButton.CornerRadius = UDim.new(0, 8) -- ขอบกลม
SubmitKeyButton.Parent = KeyFrame

local correctKey = "dyumra" -- <<< เปลี่ยน Key เป็น "dyumra" แล้ว!

SubmitKeyButton.MouseButton1Click:Connect(function()
    if KeyInput.Text == correctKey then
        KeyScreenGui:Destroy() -- ปิด GUI ใส่ Key
        MainFrame.Visible = true -- แสดง GUI หลัก
        ScreenGui.Enabled = true -- เปิดใช้งาน ScreenGui หลัก
        MainToggleButton.Visible = true -- แสดงปุ่ม Toggle GUI หลัก
        notify("Access Granted!", Color3.fromRGB(0, 200, 0))
    else
        warn("Incorrect Key!")
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Incorrect Key! Try again."
        notify("Access Denied!", Color3.fromRGB(200, 0, 0))
    end
end)

-- Function สำหรับลาก GUI (ใช้ได้ทั้ง KeyFrame และ MainFrame)
local function makeDraggable(guiFrame)
    local dragging = false
    local dragInput
    local dragStart
    local startPos

    guiFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            dragStart = input.Position
            startPos = guiFrame.Position
        end
    end)

    guiFrame.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    guiFrame.InputEnded:Connect(function(input)
        if input == dragInput then
            dragging = false
        end
    end)
end

makeDraggable(KeyFrame) -- ทำให้ KeyFrame ลากได้

-- ## GUI หลัก (แสดงหลังจากใส่ Key ถูกต้อง) ##
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomAdminGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = false -- ปิดไว้ก่อน จะเปิดเมื่อใส่ Key ถูก

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 500)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- ธีมดำ
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255) -- ขอบขาว
MainFrame.CornerRadius = UDim.new(0, 15) -- ขอบกลม
MainFrame.Draggable = true
MainFrame.Visible = false -- ซ่อนไว้ก่อน
MainFrame.Parent = ScreenGui

makeDraggable(MainFrame) -- ทำให้ MainFrame ลากได้

-- ปุ่มเปิด/ปิด GUI หลัก (มุมขวาบน)
-- ย้ายปุ่มนี้ไปอยู่ใน PlayerGui โดยตรง เพื่อให้เห็นได้แม้ GUI หลักจะซ่อนอยู่
local MainToggleButton = Instance.new("TextButton")
MainToggleButton.Name = "MainToggleButton"
MainToggleButton.Size = UDim2.new(0, 40, 0, 40)
MainToggleButton.Position = UDim2.new(1, -50, 0, 10) -- มุมขวาบน
MainToggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MainToggleButton.Text = "O" -- เปลี่ยนเป็น 'O' หรือไอคอนอื่น
MainToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainToggleButton.Font = Enum.Font.SourceSansBold
MainToggleButton.TextSize = 25
MainToggleButton.CornerRadius = UDim.new(0, 20) -- ทำให้กลม
MainToggleButton.Parent = LocalPlayer:WaitForChild("PlayerGui")
MainToggleButton.Visible = false -- ซ่อนไว้ก่อนจนกว่าจะใส่ Key ถูก

MainToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    if MainFrame.Visible then
        notify("Main GUI: Visible", Color3.fromRGB(0, 150, 255))
    else
        notify("Main GUI: Hidden", Color3.fromRGB(0, 150, 255))
    end
end)

makeDraggable(MainToggleButton) -- ทำให้ปุ่ม Toggle GUI หลักลากได้

---

### ส่วนของ Camlock

local camlockTarget = nil
local camlockActive = false
local camlockPart = "Head" -- Default target part

local CamlockButton = Instance.new("TextButton")
CamlockButton.Name = "CamlockButton"
CamlockButton.Size = UDim2.new(0, 120, 0, 40)
CamlockButton.Position = UDim2.new(0.5, -60, 0, 50)
CamlockButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
CamlockButton.Text = "Camlock: Off"
CamlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CamlockButton.Font = Enum.Font.SourceSansBold
CamlockButton.TextSize = 18
CamlockButton.CornerRadius = UDim.new(0, 8)
CamlockButton.Parent = MainFrame

CamlockButton.MouseButton1Click:Connect(function()
    camlockActive = not camlockActive
    if camlockActive then
        CamlockButton.Text = "Camlock: On"
        -- หาเป้าหมายเริ่มต้น
        local playersInGame = Players:GetPlayers()
        for _, player in pairs(playersInGame) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                camlockTarget = player
                break
            end
        end
        if not camlockTarget then
            warn("No valid player found to camlock!")
            camlockActive = false -- ปิด Camlock ถ้าไม่มีเป้าหมาย
            CamlockButton.Text = "Camlock: Off"
            notify("Camlock: No target found!", Color3.fromRGB(200, 0, 0))
        else
            notify("Camlock: Targeting " .. camlockTarget.Name, Color3.fromRGB(0, 150, 255))
        end
    else
        CamlockButton.Text = "Camlock: Off"
        camlockTarget = nil
        notify("Camlock: Off", Color3.fromRGB(200, 0, 0))
    end
end)

-- Lock Part Selector
local LockPartToggle = Instance.new("TextButton")
LockPartToggle.Name = "LockPartToggle"
LockPartToggle.Size = UDim2.new(0, 120, 0, 40)
LockPartToggle.Position = UDim2.new(0.5, -60, 0, 100)
LockPartToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
LockPartToggle.Text = "Lock: Head"
LockPartToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
LockPartToggle.Font = Enum.Font.SourceSansBold
LockPartToggle.TextSize = 18
LockPartToggle.CornerRadius = UDim.new(0, 8)
LockPartToggle.Parent = MainFrame

LockPartToggle.MouseButton1Click:Connect(function()
    if camlockPart == "Head" then
        camlockPart = "Torso"
        LockPartToggle.Text = "Lock: Torso"
    else
        camlockPart = "Head"
        LockPartToggle.Text = "Lock: Head"
    end
    notify("Camlock Part: " .. camlockPart, Color3.fromRGB(0, 150, 255))
end)

-- อัปเดตกล้อง
RunService.RenderStepped:Connect(function()
    if camlockActive and camlockTarget and camlockTarget.Character and camlockTarget.Character:FindFirstChild(camlockPart) and camlockTarget.Character:FindFirstChild("Humanoid") and camlockTarget.Character.Humanoid.Health > 0 then
        local partToLock = camlockTarget.Character[camlockPart]
        if partToLock then
            -- ตั้งค่ากล้องให้มองไปยังส่วนของเป้าหมาย
            LocalPlayer.CameraMode = Enum.CameraMode.Scriptable
            LocalPlayer.Camera.CFrame = CFrame.lookAt(LocalPlayer.Camera.CFrame.Position, partToLock.Position)
            -- ป้องกันการขยับตัวละครของผู้เล่น (ทำไม่ได้โดยตรงบน LocalScript ในทุกกรณี)
            -- การตั้งค่า CameraMode เป็น Scriptable อาจทำให้ผู้เล่นขยับกล้องได้ยาก
            -- แต่ไม่ได้ "ล็อคตัวละคร" ไม่ให้เคลื่อนไหว
            -- สำหรับการล็อคตัวละครจริงๆ ต้องทำผ่าน ServerScript
        end
    elseif camlockActive and (not camlockTarget or not camlockTarget.Character or not camlockTarget.Character:FindFirstChild("Humanoid") or camlockTarget.Character.Humanoid.Health <= 0) then
        -- เป้าหมายตายหรือไม่มีอยู่แล้ว ให้หาเป้าหมายใหม่
        local foundNewTarget = false
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                camlockTarget = player
                foundNewTarget = true
                notify("Camlock: New target - " .. camlockTarget.Name, Color3.fromRGB(0, 150, 255))
                break
            end
        end
        if not foundNewTarget then
            camlockActive = false
            CamlockButton.Text = "Camlock: Off"
            LocalPlayer.CameraMode = Enum.CameraMode.Follow -- กลับสู่โหมดกล้องปกติ
            LocalPlayer.CameraTarget = nil
            notify("Camlock: No more valid targets, turning off.", Color3.fromRGB(200, 0, 0))
        end
    elseif not camlockActive and LocalPlayer.CameraMode == Enum.CameraMode.Scriptable then
        LocalPlayer.CameraMode = Enum.CameraMode.Follow -- กลับสู่โหมดกล้องปกติเมื่อปิด Camlock
        LocalPlayer.CameraTarget = nil
    end
end)

---

### ส่วนของ Headless

local headlessActive = false

local HeadlessButton = Instance.new("TextButton")
HeadlessButton.Name = "HeadlessButton"
HeadlessButton.Size = UDim2.new(0, 120, 0, 40)
HeadlessButton.Position = UDim2.new(0.5, -60, 0, 160)
HeadlessButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
HeadlessButton.Text = "Headless: Off"
HeadlessButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HeadlessButton.Font = Enum.Font.SourceSansBold
HeadlessButton.TextSize = 18
HeadlessButton.CornerRadius = UDim.new(0, 8)
HeadlessButton.Parent = MainFrame

HeadlessButton.MouseButton1Click:Connect(function()
    headlessActive = not headlessActive
    if headlessActive then
        HeadlessButton.Text = "Headless: On"
        notify("Headless: On", Color3.fromRGB(0, 150, 255))
    else
        HeadlessButton.Text = "Headless: Off"
        notify("Headless: Off", Color3.fromRGB(200, 0, 0))
    end
    local character = LocalPlayer.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            local face = head:FindFirstChildOfClass("Decal") or head:FindFirstChildOfClass("Texture") or head:FindFirstChild("face") -- เพิ่ม "face" สำหรับ R15
            if headlessActive then
                head.Transparency = 1
                if face then face.Transparency = 1 end
            else
                head.Transparency = 0
                if face then face.Transparency = 0 end
            end
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    if headlessActive then
        local head = character:WaitForChild("Head")
        local face = head:FindFirstChildOfClass("Decal") or head:FindFirstChildOfClass("Texture") or head:FindFirstChild("face")
        head.Transparency = 1
        if face then face.Transparency = 1 end
        if face and not face.IsLoaded then
            -- รอโหลด Face ให้ครบก่อนแล้วค่อยปรับ (กรณี Face เป็น Decal/Texture ที่โหลดช้า)
            face.Changed:Connect(function(property)
                if property == "Texture" and face.IsLoaded then
                    face.Transparency = 1
                end
            end)
        end
    end
end)

---

### ส่วนของ Hitbox Modifier (เน้นย้ำ: CLIENT-SIDE VISUAL ONLY)

local targetPlayerHitbox = nil
local hitboxExpansionValue = 0 -- ค่าเริ่มต้นการขยาย hitbox

local HitboxPlayerInput = Instance.new("TextBox")
HitboxPlayerInput.Name = "HitboxPlayerInput"
HitboxPlayerInput.Size = UDim2.new(0, 200, 0, 220)
HitboxPlayerInput.Position = UDim2.new(0.5, -100, 0, 220)
HitboxPlayerInput.PlaceholderText = "Player Name for Hitbox"
HitboxPlayerInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HitboxPlayerInput.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxPlayerInput.TextSize = 16
HitboxPlayerInput.CornerRadius = UDim.new(0, 5)
HitboxPlayerInput.Parent = MainFrame

local HitboxValueInput = Instance.new("TextBox")
HitboxValueInput.Name = "HitboxValueInput"
HitboxValueInput.Size = UDim2.new(0, 200, 0, 30)
HitboxValueInput.Position = UDim2.new(0.5, -100, 0, 260)
HitboxValueInput.PlaceholderText = "Enter hitbox expansion value (e.g., 0.5)"
HitboxValueInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
HitboxValueInput.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxValueInput.TextSize = 16
HitboxValueInput.CornerRadius = UDim.new(0, 5)
HitboxValueInput.Parent = MainFrame

HitboxValueInput.Changed:Connect(function(property)
    if property == "Text" then
        local num = tonumber(HitboxValueInput.Text)
        if num and num >= 0 then
            hitboxExpansionValue = num
            HitboxValueInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- สีปกติ
        else
            HitboxValueInput.BackgroundColor3 = Color3.fromRGB(150, 50, 50) -- สีแดงเตือน
        end
    end
end)

local originalSizes = {} -- เก็บขนาดเดิมของ Part สำหรับ Hitbox (Local Only)

local function applyHitboxModifications(character, transparency, expansion)
    if not character then return end

    -- รีเซ็ตขนาดเดิมก่อน ถ้ามีการปรับไปแล้ว
    for part, originalSize in pairs(originalSizes) do
        if part and part.Parent == character then -- ตรวจสอบว่า part ยังอยู่กับ character
            part.Size = originalSize
        end
    end
    originalSizes = {} -- ล้างค่าเก่า

    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then -- พิจารณาเฉพาะ Part ที่ชนได้
            if part.Name ~= "HumanoidRootPart" and part.Name ~= "Head" then
                -- ขยาย Hitbox (Visual Only)
                originalSizes[part] = part.Size -- เก็บขนาดเดิม
                part.Size = part.Size + Vector3.new(expansion, expansion, expansion)
            end

            -- ปรับ Transparency
            if part.Name ~= "Head" and part.Name ~= "HumanoidRootPart" then
                part.Transparency = transparency
                if part:IsA("MeshPart") then
                    part.Material = Enum.Material.Plastic -- หรือ Material อื่นๆ ที่เหมาะสม
                end
            end
        end
    end

    -- HumanoidRootPart และ Head ยังคงปรับ Transparency ได้ตามปุ่มแยก
    -- แต่ไม่ได้ถูกขยายด้วยค่า expansion ทั่วไป
end

local ApplyHitboxButton = Instance.new("TextButton")
ApplyHitboxButton.Name = "ApplyHitboxButton"
ApplyHitboxButton.Size = UDim2.new(0, 80, 0, 40)
ApplyHitboxButton.Position = UDim2.new(0.5, -140, 0, 300)
ApplyHitboxButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ApplyHitboxButton.Text = "Apply All"
ApplyHitboxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ApplyHitboxButton.Font = Enum.Font.SourceSansBold
ApplyHitboxButton.TextSize = 16
ApplyHitboxButton.CornerRadius = UDim.new(0, 8)
ApplyHitboxButton.Parent = MainFrame

ApplyHitboxButton.MouseButton1Click:Connect(function()
    local playerName = HitboxPlayerInput.Text
    local player = Players:FindFirstChild(playerName)
    if player and player ~= LocalPlayer then
        targetPlayerHitbox = player
        if targetPlayerHitbox.Character then
            applyHitboxModifications(targetPlayerHitbox.Character, 0.5, hitboxExpansionValue)
            notify("Applied Hitbox to " .. playerName .. " with expansion: " .. hitboxExpansionValue, Color3.fromRGB(0, 150, 255))
        end
    else
        notify("Player not found or is yourself: " .. playerName, Color3.fromRGB(200, 0, 0))
    end
end)

local HeadTransparencyButton = Instance.new("TextButton")
HeadTransparencyButton.Name = "HeadTransparencyButton"
HeadTransparencyButton.Size = UDim2.new(0, 80, 0, 40)
HeadTransparencyButton.Position = UDim2.new(0.5, -40, 0, 300)
HeadTransparencyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
HeadTransparencyButton.Text = "Head Only"
HeadTransparencyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HeadTransparencyButton.Font = Enum.Font.SourceSansBold
HeadTransparencyButton.TextSize = 16
HeadTransparencyButton.CornerRadius = UDim.new(0, 8)
HeadTransparencyButton.Parent = MainFrame

HeadTransparencyButton.MouseButton1Click:Connect(function()
    if targetPlayerHitbox and targetPlayerHitbox.Character and targetPlayerHitbox.Character:FindFirstChild("Head") then
        targetPlayerHitbox.Character.Head.Transparency = 0.5
        notify("Applied transparency to Head of: " .. targetPlayerHitbox.Name, Color3.fromRGB(0, 150, 255))
    end
end)

local HumanoidTransparencyButton = Instance.new("TextButton")
HumanoidTransparencyButton.Name = "HumanoidTransparencyButton"
HumanoidTransparencyButton.Size = UDim2.new(0, 80, 0, 40)
HumanoidTransparencyButton.Position = UDim2.new(0.5, 60, 0, 300)
HumanoidTransparencyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
HumanoidTransparencyButton.Text = "Humanoid Only"
HumanoidTransparencyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
HumanoidTransparencyButton.Font = Enum.Font.SourceSansBold
HumanoidTransparencyButton.TextSize = 16
HumanoidTransparencyButton.CornerRadius = UDim.new(0, 8)
HumanoidTransparencyButton.Parent = MainFrame

HumanoidTransparencyButton.MouseButton1Click:Connect(function()
    if targetPlayerHitbox and targetPlayerHitbox.Character and targetPlayerHitbox.Character:FindFirstChild("HumanoidRootPart") then
        targetPlayerHitbox.Character.HumanoidRootPart.Transparency = 0.5
        notify("Applied transparency to HumanoidRootPart of: " .. targetPlayerHitbox.Name, Color3.fromRGB(0, 150, 255))
    end
end)

-- เมื่อผู้เล่นเป้าหมายเกิดใหม่ ให้ปรับ hitbox ใหม่
-- ใช้ table เพื่อเก็บ originalSizes สำหรับแต่ละ Character ที่ถูกแก้ไข
local characterModifiedData = {}

Players.PlayerAdded:Connect(function(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(function(character)
            -- ตรวจสอบว่าผู้เล่นคนนี้เคยถูกปรับ Hitbox หรือไม่
            if characterModifiedData[player.UserId] then
                local data = characterModifiedData[player.UserId]
                -- Reapply modifications
                applyHitboxModifications(character, data.transparency, data.expansion)
                if data.headTransparency then
                    local head = character:FindFirstChild("Head")
                    if head then head.Transparency = data.headTransparency end
                end
                if data.humanoidTransparency then
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if hrp then hrp.Transparency = data.humanoidTransparency end
                end
                notify("Re-applied hitbox to " .. player.Name .. " after respawn.", Color3.fromRGB(0, 150, 255))
            end
        end)
    end
end)

-- Update characterModifiedData when applying
ApplyHitboxButton.MouseButton1Click:Connect(function()
    local playerName = HitboxPlayerInput.Text
    local player = Players:FindFirstChild(playerName)
    if player and player ~= LocalPlayer then
        targetPlayerHitbox = player
        if targetPlayerHitbox.Character then
            applyHitboxModifications(targetPlayerHitbox.Character, 0.5, hitboxExpansionValue)
            characterModifiedData[player.UserId] = {
                transparency = 0.5,
                expansion = hitboxExpansionValue,
                headTransparency = nil,
                humanoidTransparency = nil
            }
            notify("Applied Hitbox to " .. playerName .. " with expansion: " .. hitboxExpansionValue, Color3.fromRGB(0, 150, 255))
        end
    else
        notify("Player not found or is yourself: " .. playerName, Color3.fromRGB(200, 0, 0))
    end
end)

HeadTransparencyButton.MouseButton1Click:Connect(function()
    if targetPlayerHitbox and targetPlayerHitbox.Character and targetPlayerHitbox.Character:FindFirstChild("Head") then
        targetPlayerHitbox.Character.Head.Transparency = 0.5
        if not characterModifiedData[targetPlayerHitbox.UserId] then
            characterModifiedData[targetPlayerHitbox.UserId] = {
                transparency = 0, expansion = 0,
                headTransparency = 0.5, humanoidTransparency = 0
            }
        else
            characterModifiedData[targetPlayerHitbox.UserId].headTransparency = 0.5
        end
        notify("Applied transparency to Head of: " .. targetPlayerHitbox.Name, Color3.fromRGB(0, 150, 255))
    end
end)

HumanoidTransparencyButton.MouseButton1Click:Connect(function()
    if targetPlayerHitbox and targetPlayerHitbox.Character and targetPlayerHitbox.Character:FindFirstChild("HumanoidRootPart") then
        targetPlayerHitbox.Character.HumanoidRootPart.Transparency = 0.5
        if not characterModifiedData[targetPlayerHitbox.UserId] then
            characterModifiedData[targetPlayerHitbox.UserId] = {
                transparency = 0, expansion = 0,
                headTransparency = 0, humanoidTransparency = 0.5
            }
        else
            characterModifiedData[targetPlayerHitbox.UserId].humanoidTransparency = 0.5
        end
        notify("Applied transparency to HumanoidRootPart of: " .. targetPlayerHitbox.Name, Color3.fromRGB(0, 150, 255))
    end
end)


---

### ส่วนของ ESP

local espActive = false
local espConnections = {} -- Keep track of connections for cleanup

local EspButton = Instance.new("TextButton")
EspButton.Name = "EspButton"
EspButton.Size = UDim2.new(0, 120, 0, 360)
EspButton.Position = UDim2.new(0.5, -60, 0, 360)
EspButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
EspButton.Text = "ESP: Off"
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EspButton.Font = Enum.Font.SourceSansBold
EspButton.TextSize = 18
EspButton.CornerRadius = UDim.new(0, 8)
EspButton.Parent = MainFrame

local function createESPOutline(character)
    if not character or not character:FindFirstChildOfClass("Humanoid") or character:FindFirstChild("ESPOutline") then return end

    local humanoid = character.Humanoid
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end

    local outline = Instance.new("BillboardGui")
    outline.Name = "ESPOutline"
    outline.AlwaysOnTop = true
    outline.Size = UDim2.new(2, 0, 2, 0)
    outline.StudsOffset = Vector3.new(0, rootPart.Size.Y / 2, 0)
    outline.Parent = rootPart

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- สีแดง
    frame.BackgroundTransparency = 0.7
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromRGB(255, 255, 255)
    frame.Parent = outline

    local function onHumanoidStateChanged(state)
        if state == Enum.HumanoidStateType.Dead then
            outline.Enabled = true -- Keep ESP even if dead
        end
    end
    local conn = humanoid.StateChanged:Connect(onHumanoidStateChanged)
    table.insert(espConnections, conn)
end

local function removeESPOutline(character)
    if character and character:FindFirstChild("ESPOutline") then
        character.ESPOutline:Destroy()
    end
end

local function toggleESP(active)
    espActive = active
    if espActive then
        EspButton.Text = "ESP: On"
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                if player.Character then
                    createESPOutline(player.Character)
                end
                local charAddedConn = player.CharacterAdded:Connect(function(char)
                    createESPOutline(char)
                end)
                table.insert(espConnections, charAddedConn)
            end
        end
        local playerAddedConn = Players.PlayerAdded:Connect(function(player)
            if player ~= LocalPlayer then
                local charAddedConn = player.CharacterAdded:Connect(function(char)
                    createESPOutline(char)
                end)
                table.insert(espConnections, charAddedConn)
            end
        end)
        table.insert(espConnections, playerAddedConn)
        notify("ESP: On", Color3.fromRGB(0, 150, 255))
    else
        EspButton.Text = "ESP: Off"
        for _, player in pairs(Players:GetPlayers()) do
            removeESPOutline(player.Character)
        end
        for _, conn in pairs(espConnections) do
            if typeof(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        espConnections = {}
        notify("ESP: Off", Color3.fromRGB(200, 0, 0))
    end
end

EspButton.MouseButton1Click:Connect(function()
    toggleESP(not espActive)
end)

---

### ส่วนของ Notify

local function notify(message, color)
    local notifyGui = Instance.new("ScreenGui")
    notifyGui.Name = "NotifyGui"
    notifyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local notifyFrame = Instance.new("Frame")
    notifyFrame.Size = UDim2.new(0, 300, 0, 60)
    notifyFrame.Position = UDim2.new(1, -310, 1, -70) -- มุมขวาล่าง
    notifyFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    notifyFrame.BorderSizePixel = 0
    notifyFrame.CornerRadius = UDim.new(0, 10)
    notifyFrame.Parent = notifyGui

    local notifyText = Instance.new("TextLabel")
    notifyText.Size = UDim2.new(1, 0, 1, 0)
    notifyText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    notifyText.BackgroundTransparency = 1
    notifyText.Text = message
    notifyText.TextColor3 = color or Color3.fromRGB(255, 255, 255) -- สามารถระบุสีได้
    notifyText.Font = Enum.Font.SourceSans
    notifyText.TextSize = 16
    notifyText.TextWrapped = true
    notifyText.TextXAlignment = Enum.TextXAlignment.Center
    notifyText.TextYAlignment = Enum.TextYAlignment.Center
    notifyText.Parent = notifyFrame

    notifyFrame:TweenPosition(UDim2.new(1, -310, 1, -70), "Out", "Quad", 0.5, true, function()
        wait(3)
        notifyFrame:TweenPosition(UDim2.new(1, 310, 1, -70), "In", "Quad", 0.5, true, function() -- เลื่อนออกไปขวา
            notifyGui:Destroy()
        end)
    end)
end

-- ซ่อน GUI หลักไว้ก่อนจนกว่าจะใส่ Key ถูก
ScreenGui.Enabled = true -- ต้องเปิดใช้งาน ScreenGui เพื่อให้เฟรม KeyEntryGui มองเห็นได้
MainFrame.Visible = false
MainToggleButton.Visible = false -- ซ่อนปุ่ม Toggle GUI หลักไว้ก่อน
