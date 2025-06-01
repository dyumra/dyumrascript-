--[ Roblox Edition - @ by dyumra]
--[ Version: 5.3.0 ]


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui") -- สำหรับซ่อน/แสดงปุ่มเมนูหลักจาก Roblox

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI Setup --
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Frame ข้างหลัง (สามารถลากได้)
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 320) -- ปรับขนาดให้ใหญ่ขึ้นเพื่อรองรับปุ่มใหม่
frame.Position = UDim2.new(1, -260, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Visible = true -- เริ่มต้นให้มองเห็นได้

-- ปุ่มเปิด/ปิดเมนูหลัก
local toggleMenuButton = Instance.new("TextButton")
toggleMenuButton.Name = "ToggleMenuButton"
toggleMenuButton.Size = UDim2.new(0, 100, 0, 30)
toggleMenuButton.Position = UDim2.new(0, 5, 1, -35) -- มุมล่างซ้าย เหนือไอคอนแชท
toggleMenuButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleMenuButton.TextColor3 = Color3.new(1, 1, 1)
toggleMenuButton.Text = "Hide Menu"
toggleMenuButton.Font = Enum.Font.SourceSansBold
toggleMenuButton.TextSize = 14
toggleMenuButton.BorderSizePixel = 0
toggleMenuButton.Parent = screenGui

local toggleMenuCorners = Instance.new("UICorner")
toggleMenuCorners.CornerRadius = UDim.new(0, 8)
toggleMenuCorners.Parent = toggleMenuButton

-- ฟังก์ชันสำหรับสร้างส่วนประกอบ GUI ที่มีขอบโค้ง
local function createRoundedElement(elementType, size, position, backgroundColor, textColor, text, isButton)
    local element = Instance.new(elementType)
    element.Size = size
    element.Position = position
    element.BackgroundColor3 = backgroundColor
    element.BorderSizePixel = 0
    element.Parent = frame

    local corners = Instance.new("UICorner")
    corners.CornerRadius = UDim.new(0, 8)
    corners.Parent = element

    if elementType == "TextButton" or isButton then
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Text = text or ""
        textLabel.TextColor3 = textColor or Color3.new(1, 1, 1)
        textLabel.BackgroundColor3 = Color3.new(1, 1, 1)
        textLabel.BackgroundTransparency = 1
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.TextScaled = true
        textLabel.Parent = element
        return element, textLabel
    elseif elementType == "TextBox" then
        element.Text = text or ""
        element.TextColor3 = textColor or Color3.new(1, 1, 1)
        element.Font = Enum.Font.SourceSansBold
        element.TextScaled = true
        element.PlaceholderText = text or ""
        element.ClearTextOnFocus = false
        return element
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

-- Textbox สำหรับใส่ค่าความเร็ว Fly/Speed
local speedInputTextBox = createRoundedElement("TextBox", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 145), Color3.fromRGB(60, 60, 60), Color3.new(1, 1, 1), "Enter Speed Value", false)

-- Textbox สำหรับใส่ชื่อผู้เล่นสำหรับ Teleport
local teleportNameInputTextBox = createRoundedElement("TextBox", UDim2.new(0, 230, 0, 145), UDim2.new(0, 10, 0, 190), Color3.fromRGB(60, 60, 60), Color3.new(1, 1, 1), "Enter Player Name", false)
-- ปรับตำแหน่งใหม่ของ teleportNameInputTextBox ให้เลื่อนลงไป

-- ปุ่ม Teleport to Player (ใช้ Textbox ใหม่)
local teleportButton, teleportText = createRoundedElement("TextButton", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 235), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Teleport to Player", true)
-- ปรับตำแหน่งใหม่ของ teleportButton ให้เลื่อนลงไป

-- ปุ่ม Teleport Random
local teleportRandomButton, teleportRandomText = createRoundedElement("TextButton", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 270), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Teleport Random: OFF", true)
-- ปรับตำแหน่งใหม่ของ teleportRandomButton ให้เลื่อนลงไป


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
local flyNoclipSpeed = 50 -- ค่าความเร็วเริ่มต้นสำหรับ Fly/Noclip/Speed (CFrame)
local teleportRandomEnabled = false
local currentRandomTarget = nil -- ผู้เล่นเป้าหมายปัจจุบันสำหรับ Teleport Random
local randomTeleportConnection = nil -- Connection สำหรับการตรวจจับการตายของผู้เล่น


-- ฟังก์ชันสร้าง Highlight (สำหรับ ESP)
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

-- ฟังก์ชันลบ Highlights ทั้งหมด
local function disableESP()
    for _, highlight in pairs(highlightFolder:GetChildren()) do
        highlight:Destroy()
    end
end

-- ฟังก์ชันเปิดใช้งาน ESP
local function enableESP()
    disableESP() -- ลบ highlights เก่าทั้งหมดก่อนสร้างใหม่
    for _, player in pairs(Players:GetPlayers()) do
        -- ตรวจสอบว่าไม่ใช่ตัวเอง, มี Character, มี Humanoid และยังมีชีวิตอยู่
        if player ~= localPlayer and player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") and player.Character.Humanoid.Health > 0 then
            -- ไฮไลท์ทุกคน (ยกเว้นตัวเอง) เป็นสีแดง
            createHighlight(player.Character, Color3.fromRGB(255, 0, 0)) -- สีแดง
        end
    end
end

-- Event: เมื่อผู้เล่นใหม่เข้ามาในเกม
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        -- รอสักครู่เพื่อให้ Character โหลดเสร็จและพร้อมใช้งาน
        task.wait(0.5)
        if espEnabled then
            if player ~= localPlayer and character and character:FindFirstChildWhichIsA("Humanoid") and character.Humanoid.Health > 0 then
                createHighlight(character, Color3.fromRGB(255, 0, 0))
            end
        end
        -- เพิ่ม listener สำหรับ Humanoid.Died เพื่อลบ Highlight เมื่อผู้เล่นตาย
        local humanoid = character:FindFirstChildWhichIsA("Humanoid")
        if humanoid then
            humanoid.Died:Connect(function()
                if espEnabled then
                    for _, highlight in pairs(highlightFolder:GetChildren()) do
                        if highlight.Adornee == character then
                            highlight:Destroy()
                            break
                        end
                    end
                end
            end)
        end
    end)
end)

-- Event: เมื่อผู้เล่นออกจากเกม
Players.PlayerRemoving:Connect(function(player)
    if espEnabled then
        -- ลบ highlight ของผู้เล่นที่ออกจากเกม
        for _, highlight in pairs(highlightFolder:GetChildren()) do
            if highlight.Adornee and highlight.Adornee == player.Character then
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
                -- เช็คทีม: ไม่ Camlock ทีมเดียวกัน
                if localPlayer.Team ~= player.Team then
                    local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("HumanoidRootPart")
                    if torso then
                        local pos, onScreen = camera:WorldToViewportPoint(torso.Position)
                        if onScreen then
                            -- เช็คว่าผ่านกำแพงไหม โดยใช้ Raycast
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {localPlayer.Character} -- ไม่ Raycast โดนตัวเอง
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude

                            local ray = workspace:Raycast(camera.CFrame.Position, (torso.Position - camera.CFrame.Position).Unit * 500, rayParams)
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

-- ฟังก์ชันสำหรับ No-clip (ปรับเปลี่ยน CanCollide)
local function setNoClip(enabled)
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = localPlayer.Character.HumanoidRootPart
        if enabled then
            rootPart.CanCollide = false
            -- การจัดการ PlatformStand จะอยู่ใน RenderStepped เพื่อรวมกับ Fly/Speed
        else
            rootPart.CanCollide = true
            -- การจัดการ PlatformStand จะอยู่ใน RenderStepped
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
            if string.sub(lowerPlayerName, 1, #lowerPartialName) == lowerPlayerName then
                targetPlayer = player
                break
            end
        end
    end

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- Teleport เหนือเป้าหมายเล็กน้อยเพื่อป้องกันการติดขัด
            localPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
        end
    else
        warn("Could not find player matching '" .. partialName .. "' or target character/HumanoidRootPart is missing.")
    end
end

-- ฟังก์ชันสำหรับ Teleport Random
local function startRandomTeleport()
    -- ตรวจสอบว่า localPlayer.Character พร้อมใช้งาน
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
        -- หากตัวละครยังไม่พร้อม ให้รอ characterAdded หรือออกไปก่อน
        localPlayer.CharacterAdded:Wait()
        character = localPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
            warn("Local character not ready for random teleport.")
            return
        end
    end

    local potentialTargets = {}
    for _, player in pairs(Players:GetPlayers()) do
        -- ตรวจสอบผู้เล่นที่มีชีวิตอยู่และไม่ใช่ตัวเอง
        if player ~= localPlayer and player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            table.insert(potentialTargets, player)
        end
    end

    if #potentialTargets > 0 then
        local randomIndex = math.random(1, #potentialTargets)
        currentRandomTarget = potentialTargets[randomIndex]

        if currentRandomTarget and currentRandomTarget.Character and currentRandomTarget.Character:FindFirstChild("HumanoidRootPart") then
            -- ยกเลิก connection เก่าถ้ามี
            if randomTeleportConnection then
                randomTeleportConnection:Disconnect()
                randomTeleportConnection = nil
            end

            -- เทเลพอร์ตไปหาเป้าหมาย
            localPlayer.Character:SetPrimaryPartCFrame(currentRandomTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))

            -- ตรวจจับเมื่อผู้เล่นเป้าหมายตาย
            local humanoid = currentRandomTarget.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                randomTeleportConnection = humanoid.Died:Connect(function()
                    if teleportRandomEnabled then
                        startRandomTeleport() -- เทเลพอร์ตไปหาคนใหม่
                    end
                end)
            end
        else
            -- ถ้าผู้เล่นที่สุ่มได้ไม่มี Character หรือ HumanoidRootPart ให้ลองสุ่มใหม่
            startRandomTeleport()
        end
    else
        warn("No other active players to teleport to for random teleport. Disabling random teleport.")
        -- ถ้าไม่มีใครให้เทเลพอร์ตหา ให้ปิดฟังก์ชันอัตโนมัติ
        teleportRandomEnabled = false
        teleportRandomText.Text = "Teleport Random: OFF"
        if randomTeleportConnection then
            randomTeleportConnection:Disconnect()
            randomTeleportConnection = nil
        end
    end
end


-- Core loop สำหรับ Camlock, Fly, No-clip, Speed (CFrame)
RunService.RenderStepped:Connect(function(dt) -- dt คือ Delta Time เพื่อการเคลื่อนไหวที่ราบรื่น
    -- Camlock Logic
    if camlockEnabled then
        local target = getClosestTarget()
        if target and target.Character then
            local torso = target.Character:FindFirstChild("Torso") or target.Character:FindFirstChild("UpperTorso") or target.Character:FindFirstChild("HumanoidRootPart")
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

    -- Fly / No-clip / Speed (CFrame) Movement Logic
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not (character and humanoid and rootPart) then -- ออกจากฟังก์ชันถ้า Character ไม่พร้อม
        humanoid = nil -- Set to nil if character is not ready to avoid errors later
        rootPart = nil
    end

    local usingCFrameMovement = flyEnabled or noclipEnabled or speedEnabled

    if usingCFrameMovement and humanoid and rootPart then
        humanoid.PlatformStand = true -- เปิด PlatformStand สำหรับทุกโหมดการเคลื่อนที่แบบ CFrame
        rootPart.CanCollide = not noclipEnabled -- ปิด CanCollide ถ้า Noclip ทำงานอยู่เท่านั้น
        humanoid.WalkSpeed = 0 -- ตั้ง WalkSpeed เป็น 0 เพื่อไม่ให้รบกวนการเคลื่อนที่แบบ CFrame

        local cameraCFrame = camera.CFrame
        local directionVector = Vector3.new(0,0,0)
        local currentMoveSpeed = flyNoclipSpeed -- ใช้ความเร็วจาก textbox

        -- การเคลื่อนที่แนวนอน (WASD)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            directionVector = directionVector + cameraCFrame.LookVector
        elseif UserInputService:IsKeyDown(Enum.KeyCode.S) then
            directionVector = directionVector - cameraCFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            directionVector = directionVector - cameraCFrame.RightVector
        elseif UserInputService:IsKeyDown(Enum.KeyCode.D) then
            directionVector = directionVector + cameraCFrame.RightVector
        end

        -- การเคลื่อนที่แนวตั้ง (Space, Ctrl/C) - เฉพาะ Fly และ Noclip
        if flyEnabled or noclipEnabled then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                directionVector = directionVector + Vector3.new(0,1,0) -- ขึ้น
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then
                directionVector = directionVector - Vector3.new(0,1,0) -- ลง
            end
        end

        -- ใช้ CFrame เพื่อเคลื่อนที่
        if directionVector.Magnitude > 0 then
            rootPart.CFrame = rootPart.CFrame + directionVector.Unit * currentMoveSpeed * dt
        end
    elseif humanoid and rootPart then
        -- เมื่อไม่มี Cheat การเคลื่อนที่แบบ CFrame ทำงาน, คืนค่าฟิสิกส์ปกติ
        humanoid.PlatformStand = false
        rootPart.CanCollide = true
        humanoid.WalkSpeed = 16 -- คืนค่าความเร็วในการเดินเริ่มต้นของ Roblox
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

-- ปุ่มกดเปิด/ปิด Speed (CFrame)
speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        speedText.Text = "Speed: ON"
        local desiredSpeed = tonumber(speedInputTextBox.Text) -- อ่านค่าจาก speedInputTextBox
        if desiredSpeed and desiredSpeed > 0 then
            flyNoclipSpeed = desiredSpeed
        else
            flyNoclipSpeed = 50 -- ค่าเริ่มต้นหากไม่มีการป้อน
        end
    else
        speedText.Text = "Speed: OFF"
    end
end)

-- ปุ่มกดเปิด/ปิด Fly
flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    if flyEnabled then
        flyText.Text = "Fly: ON"
        local desiredSpeed = tonumber(speedInputTextBox.Text) -- อ่านค่าจาก speedInputTextBox
        if desiredSpeed and desiredSpeed > 0 then
            flyNoclipSpeed = desiredSpeed
        else
            flyNoclipSpeed = 50 -- ค่าเริ่มต้น
        end
    else
        flyText.Text = "Fly: OFF"
    end
end)

-- ปุ่มกดเปิด/ปิด No-clip
noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipText.Text = "Noclip: ON"
        local desiredSpeed = tonumber(speedInputTextBox.Text) -- อ่านค่าจาก speedInputTextBox
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

-- ปุ่มกด Teleport (ใช้ Textbox ใหม่)
teleportButton.MouseButton1Click:Connect(function()
    teleportToPlayer(teleportNameInputTextBox.Text) -- ใช้ teleportNameInputTextBox
end)

-- ปุ่มกด Teleport Random
teleportRandomButton.MouseButton1Click:Connect(function()
    teleportRandomEnabled = not teleportRandomEnabled
    if teleportRandomEnabled then
        teleportRandomText.Text = "Teleport Random: ON"
        startRandomTeleport()
    else
        teleportRandomText.Text = "Teleport Random: OFF"
        if randomTeleportConnection then
            randomTeleportConnection:Disconnect()
            randomTeleportConnection = nil
        end
        currentRandomTarget = nil
    end
end)

-- เมื่อ speedInputTextBox เปลี่ยนค่า (ใช้สำหรับ Speed และ Fly/Noclip Speed)
speedInputTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then -- ตรวจสอบว่าผู้ใช้กด Enter
        local value = tonumber(speedInputTextBox.Text)
        if value and value > 0 then
            -- อัปเดตความเร็ว CFrame ทันทีหากโหมดใดๆ ที่ใช้ CFrame ทำงานอยู่
            if speedEnabled or flyEnabled or noclipEnabled then
                flyNoclipSpeed = value
            end
        end
    end
end)

-- ปุ่มเปิด/ปิดเมนู GUI
toggleMenuButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    if frame.Visible then
        toggleMenuButton.Text = "Hide Menu"
    else
        toggleMenuButton.Text = "Show Menu"
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
