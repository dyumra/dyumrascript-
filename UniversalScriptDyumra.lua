-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

-- Local Player
local LocalPlayer = Players.LocalPlayer
local PlayerCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- Global Variables
local isCamlockOn = false
local lockedPlayer = nil
local lockedPart = "Torso" -- Default lock part
local isHeadlessOn = false
local currentHighlights = {}
local isEspOn = false
local guiKey = "dev"
local typedKey = ""
local incorrectKeyAttempts = 0
local maxIncorrectAttempts = 3

-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ProGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Enabled = false -- GUI is initially hidden

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 480) -- Slightly larger
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(178, 34, 34) -- Deeper Red (FireBrick)
MainFrame.BorderColor3 = Color3.fromRGB(139, 0, 0) -- Darker Red (DarkRed)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true -- Make the frame draggable
MainFrame.Parent = ScreenGui

-- Rounded corners for MainFrame
local UICornerMain = Instance.new("UICorner")
UICornerMain.CornerRadius = UDim.new(0, 18) -- More rounded
UICornerMain.Parent = MainFrame

-- Add a UIStroke for a subtle border effect on the frame
local UIStrokeFrame = Instance.new("UIStroke")
UIStrokeFrame.Color = Color3.fromRGB(255, 100, 100)
UIStrokeFrame.Transparency = 0.5
UIStrokeFrame.Thickness = 1.5
UIStrokeFrame.Parent = MainFrame

-- GUI Toggle Button (Top Right)
local toggleGuiButton = Instance.new("TextButton")
toggleGuiButton.Size = UDim2.new(0, 35, 0, 35) -- Slightly larger
toggleGuiButton.Position = UDim2.new(1, -40, 0, 7)
toggleGuiButton.AnchorPoint = Vector2.new(1, 0)
toggleGuiButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80) -- Brighter red for visibility
toggleGuiButton.BorderColor3 = Color3.fromRGB(200, 0, 0)
toggleGuiButton.BorderSizePixel = 1
toggleGuiButton.Text = "X"
toggleGuiButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiButton.Font = Enum.Font.GothamBold -- Modern font
toggleGuiButton.TextSize = 20
toggleGuiButton.Name = "ToggleGUIButton"
toggleGuiButton.Parent = MainFrame

local UICornerToggle = Instance.new("UICorner")
UICornerToggle.CornerRadius = UDim.new(0, 10)
UICornerToggle.Parent = toggleGuiButton

toggleGuiButton.MouseButton1Click:Connect(function()
    ScreenGui.Enabled = false -- Hide the entire GUI
end)

---
## Notification System

local function showNotification(title, message, duration, iconAssetId)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = message,
        Duration = duration or 3,
        ToastDuration = duration or 3,
        Button1 = "Dismiss",
        Image = iconAssetId or "rbxassetid://6063462828", -- Default Roblox icon, consider using your own
        Icon = iconAssetId or "rbxassetid://6063462828",
        ForceShow = true,
        Callback = nil,
        Vibration = Enum.VibrationPattern.None
    })
end

---
## Camlock Module

local camlockButton = Instance.new("TextButton")
camlockButton.Size = UDim2.new(0.85, 0, 0, 45) -- Larger button
camlockButton.Position = UDim2.new(0.075, 0, 0.1, 0)
camlockButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
camlockButton.BorderColor3 = Color3.fromRGB(50, 0, 0)
camlockButton.BorderSizePixel = 1
camlockButton.Text = "CAMLOCK: OFF" -- Capitalized for emphasis
camlockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
camlockButton.Font = Enum.Font.GothamBold -- Modern font
camlockButton.TextSize = 20
camlockButton.Parent = MainFrame

local UICornerCamlock = Instance.new("UICorner")
UICornerCamlock.CornerRadius = UDim.new(0, 10)
UICornerCamlock.Parent = camlockButton

camlockButton.MouseButton1Click:Connect(function()
    isCamlockOn = not isCamlockOn
    if isCamlockOn then
        camlockButton.Text = "CAMLOCK: ON"
        showNotification("Camlock Engaged!", "Camera will now follow other players.", 3)
        local playersInGame = Players:GetPlayers()
        for _, player in pairs(playersInGame) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                lockedPlayer = player
                LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
                local targetPart = lockedPlayer.Character:FindFirstChild(lockedPart)
                if targetPart then
                    game.Workspace.CurrentCamera.CFrame = CFrame.new(targetPart.Position) * CFrame.Angles(0, math.rad(90), 0)
                end
                break
            end
        end
    else
        camlockButton.Text = "CAMLOCK: OFF"
        showNotification("Camlock Disengaged!", "Camera control is now manual.", 3)
        lockedPlayer = nil
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end
end)

-- Lock Part Selection
local lockPartLabel = Instance.new("TextLabel")
lockPartLabel.Size = UDim2.new(0.85, 0, 0, 25) -- Slightly larger
lockPartLabel.Position = UDim2.new(0.075, 0, 0.21, 0)
lockPartLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
lockPartLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
lockPartLabel.Text = "TARGET PART:"
lockPartLabel.Font = Enum.Font.GothamBold
lockPartLabel.TextSize = 16
lockPartLabel.Parent = MainFrame

local lockHeadButton = Instance.new("TextButton")
lockHeadButton.Size = UDim2.new(0.4, 0, 0, 35) -- Larger buttons
lockHeadButton.Position = UDim2.new(0.075, 0, 0.28, 0)
lockHeadButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
lockHeadButton.BorderColor3 = Color3.fromRGB(50, 0, 0)
lockHeadButton.BorderSizePixel = 1
lockHeadButton.Text = "HEAD"
lockHeadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockHeadButton.Font = Enum.Font.GothamBold
lockHeadButton.TextSize = 18
lockHeadButton.Parent = MainFrame

local UICornerHeadLock = Instance.new("UICorner")
UICornerHeadLock.CornerRadius = UDim.new(0, 8)
UICornerHeadLock.Parent = lockHeadButton

lockHeadButton.MouseButton1Click:Connect(function()
    lockedPart = "Head"
    showNotification("Target Part Set!", "Camlock will now focus on the Head.", 2)
    if isCamlockOn and lockedPlayer and lockedPlayer.Character then
        local targetPart = lockedPlayer.Character:FindFirstChild(lockedPart)
        if targetPart then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(targetPart.Position) * CFrame.Angles(0, math.rad(90), 0)
        end
    end
end)

local lockTorsoButton = Instance.new("TextButton")
lockTorsoButton.Size = UDim2.new(0.4, 0, 0, 35)
lockTorsoButton.Position = UDim2.new(0.525, 0, 0.28, 0)
lockTorsoButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
lockTorsoButton.BorderColor3 = Color3.fromRGB(50, 0, 0)
lockTorsoButton.BorderSizePixel = 1
lockTorsoButton.Text = "TORSO"
lockTorsoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lockTorsoButton.Font = Enum.Font.GothamBold
lockTorsoButton.TextSize = 18
lockTorsoButton.Parent = MainFrame

local UICornerTorsoLock = Instance.new("UICorner")
UICornerTorsoLock.CornerRadius = UDim.new(0, 8)
UICornerTorsoLock.Parent = lockTorsoButton

lockTorsoButton.MouseButton1Click:Connect(function()
    lockedPart = "Torso"
    showNotification("Target Part Set!", "Camlock will now focus on the Torso.", 2)
    if isCamlockOn and lockedPlayer and lockedPlayer.Character then
        local targetPart = lockedPlayer.Character:FindFirstChild(lockedPart)
        if targetPart then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(targetPart.Position) * CFrame.Angles(0, math.rad(90), 0)
        end
    end
})

-- Camlock Logic (Update camera, switch target on death)
RunService.RenderStepped:Connect(function()
    if isCamlockOn and lockedPlayer and lockedPlayer.Character then
        local targetPart = lockedPlayer.Character:FindFirstChild(lockedPart)
        if targetPart then
            game.Workspace.CurrentCamera.CFrame = CFrame.new(targetPart.Position) * CFrame.Angles(0, math.rad(90), 0)
        else
            local playersInGame = Players:GetPlayers()
            local newTargetFound = false
            for _, player in pairs(playersInGame) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    lockedPlayer = player
                    showNotification("Target Lost!", "Camlock automatically switched to a new player.", 3)
                    newTargetFound = true
                    break
                end
            end
            if not newTargetFound then
                isCamlockOn = false
                camlockButton.Text = "CAMLOCK: OFF"
                showNotification("Camlock Deactivated!", "No other live players found.", 3)
                lockedPlayer = nil
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
            end
        end
    end
end)

---
## Headless Feature

local headlessButton = Instance.new("TextButton")
headlessButton.Size = UDim2.new(0.85, 0, 0, 45)
headlessButton.Position = UDim2.new(0.075, 0, 0.4, 0)
headlessButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
headlessButton.BorderColor3 = Color3.fromRGB(50, 0, 0)
headlessButton.BorderSizePixel = 1
headlessButton.Text = "HEADLESS: OFF"
headlessButton.TextColor3 = Color3.fromRGB(255, 255, 255)
headlessButton.Font = Enum.Font.GothamBold
headlessButton.TextSize = 20
headlessButton.Parent = MainFrame

local UICornerHeadless = Instance.new("UICorner")
UICornerHeadless.CornerRadius = UDim.new(0, 10)
UICornerHeadless.Parent = headlessButton

local function setHeadTransparency(character, transparency)
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            head.Transparency = transparency
            local face = head:FindFirstChildOfClass("Decal") -- Face decal
            if face then
                face.Transparency = transparency
            end
        end
    end
end

headlessButton.MouseButton1Click:Connect(function()
    isHeadlessOn = not isHeadlessOn
    if isHeadlessOn then
        headlessButton.Text = "HEADLESS: ON"
        showNotification("Headless Mode Activated!", "Your head is now invisible.", 3)
        setHeadTransparency(PlayerCharacter, 1)
    else
        headlessButton.Text = "HEADLESS: OFF"
        showNotification("Headless Mode Deactivated!", "Your head is visible again.", 3)
        setHeadTransparency(PlayerCharacter, 0)
    end
end)

-- Keep head transparent if Headless is On
LocalPlayer.CharacterAdded:Connect(function(character)
    PlayerCharacter = character
    if isHeadlessOn then
        task.wait(0.1) -- Small delay to ensure head is present
        setHeadTransparency(PlayerCharacter, 1)
    end
end)

---
## Universal Hitbox Adjustment Module

local hitboxLabel = Instance.new("TextLabel")
hitboxLabel.Size = UDim2.new(0.85, 0, 0, 25)
hitboxLabel.Position = UDim2.new(0.075, 0, 0.55, 0)
hitboxLabel.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
hitboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxLabel.Text = "GLOBAL HITBOX EXPANSION (Value):"
hitboxLabel.Font = Enum.Font.GothamBold
hitboxLabel.TextSize = 15 -- Slightly smaller to fit text
hitboxLabel.TextWrapped = true
hitboxLabel.Parent = MainFrame

local hitboxValueTextBox = Instance.new("TextBox")
hitboxValueTextBox.Size = UDim2.new(0.85, 0, 0, 35) -- Taller textbox
hitboxValueTextBox.Position = UDim2.new(0.075, 0, 0.61, 0)
hitboxValueTextBox.PlaceholderText = "Enter expansion value (e.g., 0.5, 1, 2)..."
hitboxValueTextBox.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
hitboxValueTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxValueTextBox.Font = Enum.Font.SourceSansLight
hitboxValueTextBox.TextSize = 16
hitboxValueTextBox.TextXAlignment = Enum.TextXAlignment.Left
hitboxValueTextBox.Text = "0.5" -- Default value
hitboxValueTextBox.Parent = MainFrame

local applyHitboxButton = Instance.new("TextButton")
applyHitboxButton.Size = UDim2.new(0.85, 0, 0, 45)
applyHitboxButton.Position = UDim2.new(0.075, 0, 0.69, 0)
applyHitboxButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
applyHitboxButton.BorderColor3 = Color3.fromRGB(50, 0, 0)
applyHitboxButton.BorderSizePixel = 1
applyHitboxButton.Text = "APPLY HITBOX EXPANSION"
applyHitboxButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyHitboxButton.Font = Enum.Font.GothamBold
applyHitboxButton.TextSize = 18
applyHitboxButton.Parent = MainFrame

local UICornerApplyHitbox = Instance.new("UICorner")
UICornerApplyHitbox.CornerRadius = UDim.new(0, 10)
UICornerApplyHitbox.Parent = applyHitboxButton

local function expandAllHitboxes(expansionValue)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local character = player.Character
            if character then
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                local head = character:FindFirstChild("Head")

                if rootPart then
                    rootPart.Size = rootPart.Size + Vector3.new(expansionValue, expansionValue, expansionValue)
                    rootPart.Transparency = 0.5
                end
                if head then
                    head.Size = head.Size + Vector3.new(expansionValue * 0.5, expansionValue * 0.5, expansionValue * 0.5) -- Head usually smaller
                    head.Transparency = 0.5
                end
            end
        end
    end
    showNotification("Hitbox Expanded!", "All other players' hitboxes expanded by " .. tostring(expansionValue) .. ".", 3)
end

applyHitboxButton.MouseButton1Click:Connect(function()
    local valueText = hitboxValueTextBox.Text
    local expansionValue = tonumber(valueText)
    if expansionValue and expansionValue > 0 then
        expandAllHitboxes(expansionValue)
    else
        showNotification("Invalid Value!", "Please enter a valid positive number for expansion.", 3)
    end
end)

---
## ESP Module

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.85, 0, 0, 45)
espButton.Position = UDim2.new(0.075, 0, 0.8, 0)
espButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
espButton.BorderColor3 = Color3.fromRGB(50, 0, 0)
espButton.BorderSizePixel = 1
espButton.Text = "ESP: OFF"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Font = Enum.Font.GothamBold
espButton.TextSize = 20
espButton.Parent = MainFrame

local UICornerESP = Instance.new("UICorner")
UICornerESP.CornerRadius = UDim.new(0, 10)
UICornerESP.Parent = espButton

local function createPlayerHighlight(player)
    if not currentHighlights[player.UserId] then
        local character = player.Character or player.CharacterAdded:Wait()
        if character then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = character
            highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Red ESP color
            highlight.FillTransparency = 0.8
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineTransparency = 0.1
            highlight.Parent = character
            currentHighlights[player.UserId] = highlight
        end
    end
end

local function removePlayerHighlight(player)
    if currentHighlights[player.UserId] then
        currentHighlights[player.UserId]:Destroy()
        currentHighlights[player.UserId] = nil
    end
end

local function updateAllPlayerHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if isEspOn then
                createPlayerHighlight(player)
            else
                removePlayerHighlight(player)
            end
        end
    end
end

espButton.MouseButton1Click:Connect(function()
    isEspOn = not isEspOn
    if isEspOn then
        espButton.Text = "ESP: ON"
        showNotification("ESP Activated!", "All players are now highlighted.", 3)
        updateAllPlayerHighlights()
    else
        espButton.Text = "ESP: OFF"
        showNotification("ESP Deactivated!", "Player highlights removed.", 3)
        updateAllPlayerHighlights()
    end
end)

Players.PlayerAdded:Connect(function(player)
    if isEspOn then
        createPlayerHighlight(player)
    end
    player.CharacterAdded:Connect(function(character)
        if isEspOn then
            createPlayerHighlight(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removePlayerHighlight(player)
end)

---
## GUI Key Activation & Security

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent then
        local key = input.KeyCode.Name:lower()
        if string.len(typedKey) >= string.len(guiKey) then
            typedKey = string.sub(typedKey, 2) -- Keep typedKey buffer size same as guiKey
        end
        typedKey = typedKey .. key

        if typedKey:endswith(guiKey) then
            ScreenGui.Enabled = not ScreenGui.Enabled
            typedKey = "" -- Reset typed key after activation
            incorrectKeyAttempts = 0 -- Reset attempts on successful key entry
            showNotification("GUI Access Granted!", "Welcome back!", 2)
        else
            -- Check for incorrect attempts only if GUI is currently hidden
            if not ScreenGui.Enabled then
                incorrectKeyAttempts = incorrectKeyAttempts + 1
                showNotification("Access Denied!", "Incorrect key! (" .. incorrectKeyAttempts .. "/" .. maxIncorrectAttempts .. " attempts remaining)", 2)
                if incorrectKeyAttempts >= maxIncorrectAttempts then
                    LocalPlayer:Kick("Banned: 100 days")
                end
            end
        end
    end
end)
