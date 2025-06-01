local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui") -- For displaying high-level GUI elements like Highlights

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Wait for the PlayerGui to be available before parenting anything to it
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- GUI Setup --
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CheatMenuGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main draggable frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 320) -- Adjust size to fit new buttons
frame.Position = UDim2.new(1, -260, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.3
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true
frame.Visible = true -- Starts visible

-- Toggle menu button
local toggleMenuButton = Instance.new("TextButton")
toggleMenuButton.Name = "ToggleMenuButton"
toggleMenuButton.Size = UDim2.new(0, 100, 0, 30)
toggleMenuButton.Position = UDim2.new(0, 5, 1, -35) -- Bottom-left, above chat icon
toggleMenuButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
toggleMenuButton.TextColor3 = Color3.new(1, 1, 1)
toggleMenuButton.Text = "Hide Menu"
toggleMenuButton.Font = Enum.Font.SourceSansBold
toggleMenuButton.TextSize = 14
toggleMenuButton.BorderSizePixel = 0
toggleMenuButton.Parent = screenGui -- Parent directly to screenGui

local toggleMenuCorners = Instance.new("UICorner")
toggleMenuCorners.CornerRadius = UDim.new(0, 8)
toggleMenuCorners.Parent = toggleMenuButton

-- Function to create rounded GUI elements
local function createRoundedElement(elementType, size, position, backgroundColor, textColor, text, isButton)
    local element = Instance.new(elementType)
    element.Size = size
    element.Position = position
    element.BackgroundColor3 = backgroundColor
    element.BorderSizePixel = 0
    element.Parent = frame -- Most elements are children of the main frame

    local corners = Instance.new("UICorner")
    corners.CornerRadius = UDim.new(0, 8)
    corners.Parent = element

    if elementType == "TextButton" or isButton then
        -- For TextButtons, the text is set directly on the button.
        -- For other elements acting as buttons (e.g., a Frame with a TextLabel that is clickable),
        -- we'd add a TextLabel as a child. Here, we're assuming `elementType` "TextButton".
        element.Text = text or ""
        element.TextColor3 = textColor or Color3.new(1, 1, 1)
        element.Font = Enum.Font.SourceSansBold
        element.TextScaled = true
        return element, element -- Return the button itself for text updates
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

-- GUI Buttons and TextBoxes
local espButton, espText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 10, 0, 10), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "ESP: OFF", true)
local camlockButton, camlockText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 130, 0, 10), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Camlock: OFF", true)
local speedButton, speedText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 10, 0, 55), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Speed: OFF", true)
local flyButton, flyText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 130, 0, 55), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Fly: OFF", true)
local noclipButton, noclipText = createRoundedElement("TextButton", UDim2.new(0, 110, 0, 35), UDim2.new(0, 10, 0, 100), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Noclip: OFF", true)
local speedInputTextBox = createRoundedElement("TextBox", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 145), Color3.fromRGB(60, 60, 60), Color3.new(1, 1, 1), "Enter Speed Value", false)
local teleportNameInputTextBox = createRoundedElement("TextBox", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 190), Color3.fromRGB(60, 60, 60), Color3.new(1, 1, 1), "Enter Player Name", false)
local teleportButton, teleportText = createRoundedElement("TextButton", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 235), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Teleport to Player", true)
local teleportRandomButton, teleportRandomText = createRoundedElement("TextButton", UDim2.new(0, 230, 0, 35), UDim2.new(0, 10, 0, 270), Color3.fromRGB(45, 45, 45), Color3.new(1, 1, 1), "Teleport Random: OFF", true)

-- Highlight Folder
local highlightFolder = Instance.new("Folder")
highlightFolder.Name = "ESPHighlights"
highlightFolder.Parent = CoreGui -- Use CoreGui to display highlights above all other game elements

-- State variables
local espEnabled = false
local camlockEnabled = false
local speedEnabled = false
local flyEnabled = false
local noclipEnabled = false
local flyNoclipSpeed = 50 -- Initial speed for Fly/Noclip/Speed (CFrame)
local teleportRandomEnabled = false
local randomTeleportTarget = nil -- Current target player for Teleport Random
local randomTeleportDeathConnection = nil -- Connection for detecting target player's death

-- Table to store active Highlights for easy management
local activeHighlights = {}

-- Functions for ESP
local function createAndTrackHighlight(character)
    if not character or not character:IsA("Model") or not character:FindFirstChildOfClass("Humanoid") then return end

    -- Check if Highlight for this Character already exists
    if activeHighlights[character] then return end

    local highlight = Instance.new("Highlight")
    highlight.Adornee = character
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red
    highlight.OutlineColor = Color3.fromRGB(255, 100, 100) -- Lighter red outline
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Name = "ESPHighlight_" .. character.Name
    highlight.Parent = highlightFolder

    activeHighlights[character] = highlight -- Store highlight in table for tracking

    -- Connect Humanoid.Died to remove Highlight when player dies
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local diedConnection
        diedConnection = humanoid.Died:Connect(function()
            if activeHighlights[character] then
                activeHighlights[character]:Destroy()
                activeHighlights[character] = nil
            end
            if diedConnection then diedConnection:Disconnect() end
        end)
    end
end

local function removeHighlight(character)
    if activeHighlights[character] then
        activeHighlights[character]:Destroy()
        activeHighlights[character] = nil
    end
end

local function disableESP()
    for character, highlight in pairs(activeHighlights) do
        highlight:Destroy()
        activeHighlights[character] = nil
    end
end

local function enableESP()
    disableESP() -- Clear all old highlights before creating new ones
    for _, player in pairs(Players:GetPlayers()) do
        -- Check if not self, has a Character, Humanoid, and is alive
        if player ~= localPlayer and player.Character and player.Character:FindFirstChildWhichIsA("Humanoid") and player.Character.Humanoid.Health > 0 then
            createAndTrackHighlight(player.Character)
        end
    end
end

-- Event: When a new player enters the game
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        task.wait(0.5) -- Wait briefly for the character to load
        if espEnabled then
            if player ~= localPlayer and character and character:FindFirstChildWhichIsA("Humanoid") and character.Humanoid.Health > 0 then
                createAndTrackHighlight(character)
            end
        end
    end)
end)

-- Event: When a player leaves the game
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        removeHighlight(player.Character) -- Remove highlight of the leaving player
    end
end)

-- Function to find the closest target for camlock
local function getClosestTarget()
    local centerScreen = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    local closestPlayer = nil
    local closestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        local character = player.Character
        if player ~= localPlayer and character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local rootPart = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")

            if humanoid and rootPart and humanoid.Health > 0 then
                -- Check team: Don't camlock teammates (if teams exist)
                if localPlayer.Team ~= player.Team or localPlayer.Team == nil then
                    local pos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
                    if onScreen then
                        -- Check if target is visible (not behind a wall) using Raycast
                        local rayParams = RaycastParams.new()
                        rayParams.FilterDescendantsInstances = {localPlayer.Character} -- Don't raycast against self
                        rayParams.FilterType = Enum.RaycastFilterType.Exclude

                        local ray = workspace:Raycast(camera.CFrame.Position, (rootPart.Position - camera.CFrame.Position).Unit * 500, rayParams)
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
    return closestPlayer
end

-- Function for No-clip (adjust CanCollide)
local function setNoClip(enabled)
    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if character and rootPart then
        rootPart.CanCollide = not enabled -- Set to false if enabled, true if disabled
        -- PlatformStand is handled in RenderStepped for consistency with Fly/Speed
    end
end

-- Function to Teleport to Player (supports partial names)
local function teleportToPlayer(partialName)
    local targetPlayer = nil
    local lowerPartialName = string.lower(string.gsub(partialName, "%s+", "")) -- Lowercase and remove spaces

    if #lowerPartialName == 0 then
        warn("Please enter a player name for teleport.")
        return
    end

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local lowerPlayerName = string.lower(string.gsub(player.Name, "%s+", ""))
            if string.sub(lowerPlayerName, 1, #lowerPartialName) == lowerPartialName then
                targetPlayer = player
                break
            end
        end
    end

    local character = localPlayer.Character
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and character and rootPart then
        -- Teleport slightly above the target to prevent getting stuck
        character:SetPrimaryPartCFrame(targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))
    else
        warn("Could not find player matching '" .. partialName .. "' or target/local character/HumanoidRootPart is missing.")
    end
end

-- Function for Teleport Random
local function startRandomTeleport()
    -- Ensure localPlayer.Character is ready
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not (character and humanoid and rootPart) then
        localPlayer.CharacterAdded:Wait() -- Wait for character if not ready
        character = localPlayer.Character
        humanoid = character and character:FindFirstChildOfClass("Humanoid")
        rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not (character and humanoid and rootPart) then
            warn("Local character not ready for random teleport. Please retry.")
            teleportRandomEnabled = false
            teleportRandomText.Text = "Teleport Random: OFF"
            return
        end
    end

    local potentialTargets = {}
    for _, player in pairs(Players:GetPlayers()) do
        -- Check for living players who are not self
        if player ~= localPlayer and player.Character and player.Character:FindFirstChildOfClass("Humanoid") and player.Character.Humanoid.Health > 0 then
            table.insert(potentialTargets, player)
        end
    end

    if #potentialTargets > 0 then
        local randomIndex = math.random(1, #potentialTargets)
        randomTeleportTarget = potentialTargets[randomIndex]

        if randomTeleportTarget and randomTeleportTarget.Character and randomTeleportTarget.Character:FindFirstChild("HumanoidRootPart") then
            -- Disconnect old connection if it exists
            if randomTeleportDeathConnection then
                randomTeleportDeathConnection:Disconnect()
                randomTeleportDeathConnection = nil
            end

            -- Teleport to the target
            localPlayer.Character:SetPrimaryPartCFrame(randomTeleportTarget.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0))

            -- Detect when the target player dies
            local targetHumanoid = randomTeleportTarget.Character:FindFirstChildOfClass("Humanoid")
            if targetHumanoid then
                randomTeleportDeathConnection = targetHumanoid.Died:Connect(function()
                    if teleportRandomEnabled then
                        startRandomTeleport() -- Teleport to a new random player
                    end
                })
            end
        else
            -- If the randomly selected player has no Character or HumanoidRootPart, try again
            warn("Selected random target was invalid, trying again...")
            task.wait(0.1) -- Short wait to prevent spamming
            startRandomTeleport()
        end
    else
        warn("No other active players to teleport to for random teleport. Disabling random teleport.")
        teleportRandomEnabled = false
        teleportRandomText.Text = "Teleport Random: OFF"
        if randomTeleportDeathConnection then
            randomTeleportDeathConnection:Disconnect()
            randomTeleportDeathConnection = nil
        end
    end
end

-- Core loop for Camlock, Fly, No-clip, Speed (CFrame)
RunService.RenderStepped:Connect(function(dt) -- dt is Delta Time for smooth movement
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

    -- Fly / No-clip / Speed (CFrame) Movement Logic
    local character = localPlayer.Character
    local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")

    if not (character and humanoid and rootPart) then -- Exit function if Character isn't ready
        -- Reset state if character is lost mid-cheat
        if humanoid then humanoid.PlatformStand = false end
        if rootPart then rootPart.CanCollide = true end
        return
    end

    local usingCFrameMovement = flyEnabled or noclipEnabled or speedEnabled

    if usingCFrameMovement then
        humanoid.PlatformStand = true -- Enable PlatformStand for all CFrame movement modes
        rootPart.CanCollide = not noclipEnabled -- Disable CanCollide only if Noclip is active
        humanoid.WalkSpeed = 0 -- Set WalkSpeed to 0 to prevent interference

        local cameraCFrame = camera.CFrame
        local directionVector = Vector3.new(0, 0, 0)
        local currentMoveSpeed = flyNoclipSpeed -- Use speed from textbox

        -- Horizontal movement (WASD)
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

        -- Vertical movement (Space, Ctrl/C) - Only for Fly and Noclip
        if flyEnabled or noclipEnabled then
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                directionVector = directionVector + Vector3.new(0, 1, 0) -- Up
            elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.C) then
                directionVector = directionVector - Vector3.new(0, 1, 0) -- Down
            end
        end

        -- Apply CFrame movement
        if directionVector.Magnitude > 0 then
            rootPart.CFrame = rootPart.CFrame + directionVector.Unit * currentMoveSpeed * dt
        end
    else
        -- When no CFrame movement cheats are active, restore normal physics
        humanoid.PlatformStand = false
        rootPart.CanCollide = true
        humanoid.WalkSpeed = 16 -- Restore default Roblox walk speed
    end
end)

-- Button click connections
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espText.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    if espEnabled then
        enableESP()
    else
        disableESP()
    end
end)

camlockButton.MouseButton1Click:Connect(function()
    camlockEnabled = not camlockEnabled
    camlockText.Text = "Camlock: " .. (camlockEnabled and "ON" or "OFF")
end)

speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedText.Text = "Speed: " .. (speedEnabled and "ON" or "OFF")
    if speedEnabled then
        local desiredSpeed = tonumber(speedInputTextBox.Text)
        if desiredSpeed and desiredSpeed > 0 then
            flyNoclipSpeed = desiredSpeed
        else
            flyNoclipSpeed = 50
        end
    end
end)

flyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    flyText.Text = "Fly: " .. (flyEnabled and "ON" or "OFF")
    if flyEnabled then
        local desiredSpeed = tonumber(speedInputTextBox.Text)
        if desiredSpeed and desiredSpeed > 0 then
            flyNoclipSpeed = desiredSpeed
        else
            flyNoclipSpeed = 50
        end
    end
end)

noclipButton.MouseButton1Click:Connect(function()
    noclipEnabled = not noclipEnabled
    noclipText.Text = "Noclip: " .. (noclipEnabled and "ON" or "OFF")
    if noclipEnabled then
        local desiredSpeed = tonumber(speedInputTextBox.Text)
        if desiredSpeed and desiredSpeed > 0 then
            flyNoclipSpeed = desiredSpeed
        else
            flyNoclipSpeed = 50
        end
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
    teleportRandomText.Text = "Teleport Random: " .. (teleportRandomEnabled and "ON" or "OFF")
    if teleportRandomEnabled then
        startRandomTeleport()
    else
        if randomTeleportDeathConnection then
            randomTeleportDeathConnection:Disconnect()
            randomTeleportDeathConnection = nil
        end
        randomTeleportTarget = nil
    end
end)

-- speedInputTextBox value change
speedInputTextBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(speedInputTextBox.Text)
        if value and value > 0 then
            -- Update CFrame speed instantly if any CFrame mode is active
            if speedEnabled or flyEnabled or noclipEnabled then
                flyNoclipSpeed = value
            end
        else
            warn("Invalid speed value entered. Please enter a positive number.")
        end
    end
end)

-- Toggle main GUI menu visibility
toggleMenuButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleMenuButton.Text = (frame.Visible and "Hide Menu" or "Show Menu")
end)

-- Drag GUI for mobile and PC
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
