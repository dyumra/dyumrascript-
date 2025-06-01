local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Draggable Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 320)
frame.Position = UDim2.new(1, -260, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Visible = true

-- Toggle Menu Button
local toggleMenuButton = Instance.new("TextButton")
toggleMenuButton.Name = "ToggleMenuButton"
toggleMenuButton.Size = UDim2.new(0, 100, 0, 30)
toggleMenuButton.Position = UDim2.new(0, 5, 1, -35)
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

-- Function to Create Rounded GUI Elements
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

-- GUI Elements
local espButton, espText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 10, 0, 10), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "ESP: OFF", true)
local camlockButton, camlockText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 130, 0, 10), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Camlock: OFF", true)
local speedButton, speedText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 10, 0, 55), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Speed: OFF", true)
local flyButton, flyText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 130, 0, 55), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Fly: OFF", true)
local noclipButton, noclipText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 10, 0, 100), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Noclip: OFF", true)
local speedInputTextBox = createRoundedElement("TextBox", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 145), Color3.fromRGB(60, 60, 60), Color3.new(1, 1, 1), "Enter Speed Value", false)
local teleportNameInputTextBox = createRoundedElement("TextBox", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 190), Color3.fromRGB(60, 60, 60), Color3.new(1, 1, 1), "Enter Player Name", false)
local teleportButton, teleportText = createRoundedElement("TextButton", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 235), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Teleport to Player", true)
local teleportRandomButton, teleportRandomText = createRoundedElement("TextButton", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 270), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Teleport Random: OFF", true)

-- Highlight Folder for ESP
local highlightFolder = Instance.new("Folder")
highlightFolder.Name = "ESPHighlights"
highlightFolder.Parent = CoreGui

-- State Variables
local espEnabled = false
local camlockEnabled = false
local speedEnabled = false
local flyEnabled = false
local noclipEnabled = false
local flyNoclipSpeed = 50
local teleportRandomEnabled = false
local currentRandomTarget = nil
local randomTeleportConnection = nil

-- ESP Functions
local function createHighlight(character, color)
    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = color
    highlight.OutlineColor = color:lerp(Color3.new(1, 1, 1), 0.5)
    highlight.Name = "ESPHighlight"
    highlight.Parent = highlightFolder
    return highlight
end

local function disableESP()
    for _, highlight in pairs(highlightFolder:GetChildren()) do
        highlight:Destroy()
    end
end

local function enableESP()
    disableESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") and player.Character.Humanoid.Health > 0 then
            createHighlight(player.Character, Color3.fromRGB(255, 0, 0))
        end
    end
end

-- Player Events for ESP
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if espEnabled and player ~= localPlayer and character and character:FindFirstChildWhichIsA("Humanoid") and character.Humanoid.Health > 0 then
            createHighlight(character, Color3.fromRGB(255, 0, 0))
        end
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

Players.PlayerRemoving:Connect(function(player)
    if espEnabled then
        for _, highlight in pairs(highlightFolder:GetChildren()) do
            if highlight.Adornee and highlight.Adornee == player.Character then
                highlight:Destroy()
            end
        end
    end
end)

-- Camlock Function
local function getClosestTarget()
    local centerScreen = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and (player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("HumanoidRootPart")) then
            local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")
            if humanoid and humanoid.Health > 0 and localPlayer.Team ~= player.Team then
                local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("HumanoidRootPart")
                if torso then
                    local pos, onScreen = camera:WorldToViewportPoint(torso.Position)
                    if onScreen then
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {localPlayer.Character}
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        local ray = workspace:Raycast(camera.CFrame.Position, (torso.Position - camera.CFrame.Position).Unit * 500, rayParams)
                        if ray and ray.Instance and (ray.Instance:IsDescendantOf(player.Character) or ray.Instance.Parent == player.Character) then
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
    return closestPlayer
end

-- Noclip Function
local function setNoClip(enabled)
    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = localPlayer.Character.HumanoidRootPart
        rootPart.CanCollide = not enabled
    end
end

-- Teleport Functions
local function teleportToPlayer(partialName)
    local lowerPartialName = string.lower(string.gsub(partialName, "%s+", ""))
    if #lowerPartialName == 0 then return end

    local targetPlayer = nil
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local lowerPlayerName = string.lower(string.gsub(player.Name, "%s+", ""))
            if string.sub(lowerPlayerName, 1, #lowerPartialName) == lowerPartialName then
                targetPlayer = player
                break
            end
        end
    end

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character palla

System: Player.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        localPlayer.Character:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
    else
        warn("Could not find player or target character is missing.")
    end
end

local function startRandomTeleport()
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
        localPlayer.CharacterAdded:Wait()
        character = localPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChildOfClass("Humanoid") then
            warn("Local character not ready for random teleport.")
            return
        end
    end

    local potentialTargets = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            table.insert(potentialTargets, player)
        end
    end

    if #potentialTargets > 0 then
        local randomIndex = math.random(1, #potentialTargets)
        currentRandomTarget = potentialTargets[randomIndex]
        if currentRandomTarget and currentRandomTarget.Character and currentRandomTarget.Character:FindFirstChild("HumanoidRootPart") then
            if randomTeleportConnection then
                randomTeleportConnection:Disconnect()
                randomTeleportConnection = nil
            end
            localPlayer.Character:SetPrimaryPartCFrame(currentRandomTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
            local humanoid = currentRandomTarget.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                randomTeleportConnection = humanoid.Died:Connect(function()
                    if teleportRandomEnabled then
                        startRandomTeleport()
                    end
                end)
            end
        else
            startRandomTeleport()
        end
    else
        warn("No other active players to teleport to. Disabling random teleport.")
        teleportRandomEnabled = false
        teleportRandomText.Text = "Teleport Random: OFF"
        if randomTeleportConnection then
            randomTeleportConnection:Disconnect()
            randomTeleportConnection = nil
        end
    end
end

-- Core Movement Loop
RunService.RenderStepped:Connect(function(dt)
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
    end

    -- Character Checks
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not (character and humanoid and rootPart) then
        humanoid = nil
        rootPart = nil
    end

    -- Speed Logic (WalkSpeed)
    if speedEnabled and humanoid then
        local desiredSpeed = tonumber(speedInputTextBox.Text) or 50
        if desiredSpeed > 0 then
            humanoid.WalkSpeed = desiredSpeed
        else
            humanoid.WalkSpeed = 50
        end
    elseif humanoid then
        humanoid.WalkSpeed = 16
    end

    -- Fly/Noclip Logic (CFrame)
    local usingCFrameMovement = flyEnabled or noclipEnabled
    if usingCFrameMovement and humanoid and rootPart then
        humanoid.PlatformStand = true
        rootPart.CanCollide = not noclipEnabled
        humanoid.WalkSpeed = 0

        local cameraCFrame = camera.CFrame
        local directionVector = Vector3.new(0, 0, 0)
        local currentMoveSpeed = tonumber(speedInputTextBox.Text) or flyNoclipSpeed

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
        if flyEnabled or noclipEnabled then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                directionVector = directionVector + Vector3.new(0, 1, 0)
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then
                directionVector = directionVector - Vector3.new(0, 1, 0)
            end
        end

        if directionVector.Magnitude > 0 then
            rootPart.CFrame = rootPart.CFrame + directionVector.Unit * currentMoveSpeed * dt
        end
    elseif humanoid and rootPart then
        humanoid.PlatformStand = false
        rootPart.CanCollide = true
        if not speedEnabled then
            humanoid.WalkSpeed = 16
        end
    end
end)

-- Button Connections
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espText.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    if espEnabled then
        enableESP()
    else
        disableESP()
    end
end)

camlockButton.MouseButton1Click:Connect(function()
    camlockEnabled = not camlockEnabled
    camlockText.Text = camlockEnabled and "Camlock: ON" or "Camlock: OFF"
end)

speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedText.Text = speedEnabled and "Speed: ON" or "Speed: OFF"
    if speedEnabled then
        local desiredSpeed = tonumber(speedInputTextBox.Text)
        flyNoclipSpeed = (desiredSpeed and desiredSpeed > 0) and desiredSpeed or 50
    elseif localPlayer.Character and localPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
        localPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyText.Text = flyEnabled and "Fly: ON" or "Fly: OFF"
    if flyEnabled then
        local desiredSpeed = tonumber(speedInputTextBox.Text)
        flyNoclipSpeed = (desiredSpeed and desiredSpeed > 0) and desiredSpeed or 50
    end
end)

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipText.Text = noclipEnabled and "Noclip: ON" or "Noclip: OFF"
    if noclipEnabled then
        local desiredSpeed = tonumber(speedInputTextBox.Text)
        flyNoclipSpeed = (desiredSpeed and desiredSpeed > 0) and desiredSpeed or 50
        setNoClip(true)
    else
        setNoClip(false)
    end
end)

teleportButton.MouseButton1Click:Connect(function()
    teleportToPlayer(teleportNameInputTextBox.Text)
end)

teleportRandomButton.MouseButton1Click:Connect(function()
    teleportRandomEnabled = not teleportRandomEnabled
    teleportRandomText.Text = teleportRandomEnabled and "Teleport Random: ON" or "Teleport Random: OFF"
    if teleportRandomEnabled then
        startRandomTeleport()
    else
        if randomTeleportConnection then
            randomTeleportConnection:Disconnect()
            randomTeleportConnection = nil
        end
        currentRandomTarget = nil
    end
end)

speedInputTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(speedInputTextBox.Text)
        if value and value > 0 then
            flyNoclipSpeed = value
        else
            flyNoclipSpeed = 50
            speedInputTextBox.Text = "50"
        end
    end
end)

toggleMenuButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleMenuButton.Text = frame.Visible and "Hide Menu" or "Show Menu"
end)

-- Dragging Logic
local dragging, dragInput, dragStart, startPos
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
