local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI Setup --
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Frame ข้างหลัง (สามารถลากได้)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 250) -- ปรับขนาดให้ใหญ่ขึ้นเพื่อรองรับปุ่มใหม่
frame.Position = UDim2.new(1, -260, 0, 10) -- ปรับตำแหน่ง
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- สีดำเข้ม
frame.BackgroundTransparency = 0.3 -- โปร่งใสเล็กน้อย
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true -- สำคัญสำหรับขอบโค้ง

-- ฟังก์ชันสำหรับสร้างส่วนประกอบ GUI ที่มีขอบโค้ง
local function createRoundedElement(elementType, size, position, backgroundColor, textColor, text, isButton)
    local element = Instance.new(elementType)
    element.Size = size
    element.Position = position
    element.BackgroundColor3 = backgroundColor
    element.BorderSizePixel = 0
    element.Parent = frame

    local corners = Instance.new("UICorner")
    corners.CornerRadius = UDim.new(0, 8) -- ปรับค่านี้เพื่อเปลี่ยนความโค้งของขอบ
    corners.Parent = element

    if elementType == "TextButton" or isButton then -- ใช้ TextLabel ข้างในสำหรับปุ่ม
        local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.Text = text or ""
    textLabel.TextColor3 = textColor or Color3.new(1, 1, 1)
    textLabel.BackgroundColor3 = Color3.new(1, 1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextScaled = true
    textLabel.Parent = element
    return element, textLabel -- คืนทั้งปุ่มและ TextLabel
    elseif elementType == "TextBox" then
        element.Text = text or ""
        element.TextColor3 = textColor or Color3.new(1, 1, 1)
        element.Font = Enum.Font.SourceSansBold
        element.TextScaled = true
        element.PlaceholderText = text or ""
        element.ClearTextOnFocus = false
        return element -- คืนเฉพาะ Textbox
    end
    return element
end

-- ปุ่ม ESP
local espButton, espText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 10, 0, 10), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "ESP: OFF", true)

-- ปุ่ม Camlock
local camlockButton, camlockText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 130, 0, 10), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Camlock: OFF", true)

-- ปุ่ม Speed
local speedButton, speedText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 10, 0, 55), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Speed: OFF", true)

-- ปุ่ม Fly
local flyButton, flyText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 130, 0, 55), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Fly: OFF", true)

-- ปุ่ม No-clip
local noclipButton, noclipText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 10, 0, 100), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Noclip: OFF", true)

-- Textbox สำหรับใส่ค่า (เช่น ความเร็ว, ชื่อผู้เล่น)
local inputTextBox = createRoundedElement("TextBox", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 145), Color3.fromRGB(60, 60, 60), Color3.new(1, 1, 1), "Enter Speed / Player Name", false)

-- ปุ่ม Teleport
local teleportButton, teleportText = createRoundedElement("TextButton", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 190), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Teleport to Player", true)

-- Highlight Folder
local highlightFolder = Instance.new("Folder")
highlightFolder.Name = "ESPHighlights"
highlightFolder.Parent = game:GetService("CoreGui") -- ใช้ CoreGui เพื่อแสดง GUI ระดับสูงสุด

-- ตัวแปรสถานะ
local espEnabled = false
local camlockEnabled = false
local speedEnabled = false
local flyEnabled = false
local noclipEnabled = false
local currentSpeedValue = 16 -- ค่าความเร็วในการเดินเริ่มต้นของ Roblox
local flyNoclipSpeed = 50 -- ค่าความเร็วเริ่มต้นสำหรับ Fly/Noclip

-- ฟังก์ชันสร้าง Highlight พร้อมตั้งสีตามทีม
local function createHighlight(character, color)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = color
    highlight.OutlineColor = color:lerp(Color3.new(1,1,1), 0.5) -- สีขอบจะอ่อนกว่าสีเติมเล็กน้อย
    highlight.Name = "ESPHighlight"
    highlight.Parent = highlightFolder
    return highlight
end

local function getTeamColor(player)
    -- ตรวจสอบว่าผู้เล่นมี Team และ TeamColor เป็นสีที่ถูกต้อง
    if player.Team and player.TeamColor and player.TeamColor ~= BrickColor.new("White") then
        return player.TeamColor.Color
    else
        return Color3.new(1, 1, 1) -- สีขาวเป็นค่าเริ่มต้นสำหรับผู้ที่ไม่มีทีมหรือทีมสีขาว
    end
end

local function disableESP()
    for _, highlight in pairs(highlightFolder:GetChildren()) do
        highlight:Destroy()
    end
end

local function enableESP()
    disableESP() -- ลบ highlights เก่าทั้งหมดก่อนสร้างใหม่
    for _, player in pairs(Players:GetPlayers()) do
        -- ตรวจสอบว่าไม่ใช่ตัวเอง, มี Character, มี Humanoid และยังมีชีวิตอยู่
        if player ~= localPlayer and player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") and player.Character.Humanoid.Health > 0 then
            local teamColor = getTeamColor(player)
            createHighlight(player.Character, teamColor)
        end
    end
end

-- อัปเดต ESP เมื่อมีคนเกิดใหม่
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            task.wait(0.5) -- รอให้ตัวละครโหลดเสร็จและพร้อมใช้งาน
            if player ~= localPlayer and character and character:FindFirstChildWhichIsA("Humanoid") and character.Humanoid.Health > 0 then
                local teamColor = getTeamColor(player)
                createHighlight(character, teamColor)
            end
        end
    end)
end)

-- อัปเดต ESP เมื่อมีคนตาย/ออกจากเกม
Players.PlayerRemoving:Connect(function(player)
    if espEnabled then
        -- ลบ highlight ของคนที่ออก
        for _, highlight in pairs(highlightFolder:GetChildren()) do
            if highlight.Adornee and highlight.Adornee == player.Character then -- ตรวจสอบ Adornee ก่อนใช้งาน
                highlight:Destroy()
            end
        end
    end
end)

-- ฟังก์ชันหา player เป้าหมายสำหรับ camlock
local function getClosestTarget()
    local centerScreen = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and (player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("HumanoidRootPart")) then
            local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
            if humanoid and humanoid.Health > 0 then
                -- เช็คทีม อย่า camlock ทีมเดียวกัน
                if player.Team ~= localPlayer.Team then
                    local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("HumanoidRootPart")
                    if torso then
                        local pos, onScreen = camera:WorldToViewportPoint(torso.Position)
                        if onScreen then
                            -- เช็คว่าผ่านกำแพงไหม โดยใช้ Raycast
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {localPlayer.Character} -- ไม่ raycast โดนตัวเอง
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude

                            local ray = workspace:Raycast(camera.CFrame.Position, (torso.Position - camera.CFrame.Position).Unit * 500, rayParams) -- ยิง Ray ไปไกลหน่อย (500 studs)
                            if ray and ray.Instance then
                                if ray.Instance:IsDescendantOf(player.Character) or ray.Instance.Parent == player.Character then
                                    local screenPos = Vector2.new(pos.X, pos.Y)
                                    local distance = (screenPos - centerScreen).Magnitude
                                    if distance < closestDistance then
                                        closestDistance = distance
                                        closestPlayer = player
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- ฟังก์ชัน Speed
local function setSpeed(speed)
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        localPlayer.Character.Humanoid.WalkSpeed = speed
        currentSpeedValue = speed
    end
end

-- ฟังก์ชัน No-clip
local function setNoClip(enabled)
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = localPlayer.Character.HumanoidRootPart
        if enabled then
            rootPart.CanCollide = false
            -- Humanoid.PlatformStand จะถูกจัดการใน RenderStepped
        else
            rootPart.CanCollide = true
            -- Humanoid.PlatformStand จะถูกจัดการใน RenderStepped
        end
    end
end

-- ฟังก์ชัน Teleport to Player (รองรับชื่อย่อ)
local function teleportToPlayer(partialName)
    local targetPlayer = nil
    local lowerPartialName = string.lower(string.gsub(partialName, "%s+", "")) -- ทำให้เป็นตัวพิมพ์เล็กและลบช่องว่าง

    if #lowerPartialName == 0 then return end -- ไม่ทำอะไรถ้าไม่มีข้อความ

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local lowerPlayerName = string.lower(string.gsub(player.Name, "%s+", ""))
            if string.sub(lowerPlayerName, 1, #lowerPartialName) == lowerPartialName then
                targetPlayer = player
                break
            end
        end
    end

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- ตรวจสอบว่า RootPart ของผู้เล่นปัจจุบันมีอยู่ก่อนที่จะ Teleport
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            localPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)) -- Teleport เหนือเป้าหมายเล็กน้อย
        end
    else
        warn("Could not find player matching '" .. partialName .. "' or target character/HumanoidRootPart is missing.")
    end
end

-- Core loop สำหรับ Camlock, Fly, No-clip
RunService.RenderStepped:Connect(function(dt) -- dt คือ Delta Time เพื่อการเคลื่อนไหวที่ราบรื่น
    -- Camlock Logic
    if camlockEnabled then
        targetPlayer = getClosestTarget()
        if targetPlayer and targetPlayer.Character then
            local torso = targetPlayer.Character:FindFirstChild("Torso") or targetPlayer.Character:FindFirstChild("UpperTorso") or targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if torso then
                local camCFrame = camera.CFrame
                local targetPosition = torso.Position
                local direction = (targetPosition - camCFrame.Position).Unit
                local newLookAt = CFrame.new(camCFrame.Position, camCFrame.Position + direction)
                camera.CFrame = newLookAt
            end
        end
    else
        targetPlayer = nil
    end

    -- Fly / No-clip Movement Logic
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
        local rootPart = localPlayer.Character.HumanoidRootPart
        local humanoid = localPlayer.Character.Humanoid

        if flyEnabled or noclipEnabled then
            humanoid.PlatformStand = true -- เปิด PlatformStand ถ้า Fly หรือ Noclip ทำงานอยู่
            rootPart.CanCollide = not noclipEnabled -- ปิด CanCollide ถ้า Noclip ทำงานอยู่

            local cameraCFrame = camera.CFrame
            local direction = Vector3.new(0,0,0)

            local currentMoveSpeed = flyNoclipSpeed

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + cameraCFrame.LookVector
            elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - cameraCFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - cameraCFrame.RightVector
            elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + cameraCFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0,1,0) -- ขึ้น
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then
                direction = direction - Vector3.new(0,1,0) -- ลง
            end

            -- Normalize direction to prevent faster diagonal movement
            if direction.Magnitude > 0 then
                rootPart.CFrame = rootPart.CFrame + direction.Unit * currentMoveSpeed * dt
            end
        else
            -- เมื่อทั้ง Fly และ Noclip ไม่ได้เปิดใช้งาน, ตั้งค่าฟิสิกส์ตัวละครกลับเป็นปกติ
            humanoid.PlatformStand = false
            rootPart.CanCollide = true
        end
    end
end)

-- ปุ่มกดเปิด/ปิด ESP
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espText.Text = "ESP: ON"
        enableESP()
    else
        espText.Text = "ESP: OFF"
        disableESP()
    end
end)

-- ปุ่มกดเปิด/ปิด Camlock
camlockButton.MouseButton1Click:Connect(function()
    camlockEnabled = not camlockEnabled
    if camlockEnabled then
        camlockText.Text = "Camlock: ON"
    else
        camlockText.Text = "Camlock: OFF"
    end
end)

-- ปุ่มกดเปิด/ปิด Speed
speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedText.Text = "Speed: ON"
        local desiredSpeed = tonumber(inputTextBox.Text)
        if desiredSpeed and desiredSpeed > 0 then
            setSpeed(desiredSpeed)
        else
            setSpeed(50) -- ค่าเริ่มต้นหากไม่มีการป้อน
        end
    else
        speedText.Text = "Speed: OFF"
        setSpeed(16) -- ค่าความเร็วในการเดินเริ่มต้นของ Roblox
    end
end)

-- ปุ่มกดเปิด/ปิด Fly
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyText.Text = "Fly: ON"
        local desiredSpeed = tonumber(inputTextBox.Text)
        if desiredSpeed and desiredSpeed > 0 then
            flyNoclipSpeed = desiredSpeed
        else
            flyNoclipSpeed = 50 -- ค่าเริ่มต้น
        end
        -- setFly ถูกจัดการใน RenderStepped แล้ว
    else
        flyText.Text = "Fly: OFF"
    end
end)

-- ปุ่มกดเปิด/ปิด No-clip
noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipText.Text = "Noclip: ON"
        local desiredSpeed = tonumber(inputTextBox.Text)
        if desiredSpeed and desiredSpeed > 0 then
            flyNoclipSpeed = desiredSpeed
        else
            flyNoclipSpeed = 50 -- ค่าเริ่มต้น
        end
        setNoClip(true)
    else
        noclipText.Text = "Noclip: OFF"
        setNoClip(false)
    end
end)

-- ปุ่มกด Teleport
teleportButton.MouseButton1Click:Connect(function()
    teleportToPlayer(inputTextBox.Text)
end)

-- เมื่อ Textbox เปลี่ยนค่า (ใช้สำหรับ Speed และ Fly/Noclip Speed)
inputTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then -- ตรวจสอบว่าผู้ใช้กด Enter
        local value = tonumber(inputTextBox.Text)
        if value and value > 0 then
            if speedEnabled then
                setSpeed(value)
            end
            if flyEnabled or noclipEnabled then
                flyNoclipSpeed = value
            end
        end
    end
end)

-- Drag GUI สำหรับมือถือและ PC
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
