local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService") -- Added for mobile input handling

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--- GUI Setup ---
local main = Instance.new("ScreenGui")
main.Name = "FlyGUI"
main.Parent = PlayerGui
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Parent = main
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0.25, 0, 0.35, 0) -- Scaled size for mobile responsiveness (25% width, 35% height of screen)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Dark background
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

-- UI Corner for rounded edges
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8) -- Slightly rounded corners
UICorner.Parent = Frame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Parent = Frame
TitleBar.Size = UDim2.new(1, 0, 0.15, 0) -- Scaled height for title bar
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45) -- Slightly lighter dark
TitleBar.BorderSizePixel = 0

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Parent = TitleBar
TitleLabel.Size = UDim2.new(1, -60, 1, 0) -- Adjusted size to make space for buttons
TitleLabel.Position = UDim2.new(0, 5, 0, 0) -- Small offset from left
TitleLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "FLY GUI V3 - Dyumra"
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
TitleLabel.TextSize = 0.6 -- Scaled text size
TitleLabel.TextScaled = true -- Important for mobile text scaling
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Parent = TitleBar
CloseButton.Size = UDim2.new(0, 30, 1, 0)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Red close button
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 0.7 -- Scaled text size
CloseButton.TextScaled = true

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = TitleBar
MinimizeButton.Size = UDim2.new(0, 30, 1, 0)
MinimizeButton.Position = UDim2.new(1, -60, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70) -- Grey minimize button
MinimizeButton.BorderSizePixel = 0
MinimizeButton.Text = "-"
MinimizeButton.Font = Enum.Font.SourceSansBold
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 0.8 -- Scaled text size
MinimizeButton.TextScaled = true

-- Maximize Button (initially hidden)
local MaximizeButton = Instance.new("TextButton")
MaximizeButton.Name = "MaximizeButton"
MaximizeButton.Parent = TitleBar
MaximizeButton.Size = UDim2.new(0, 30, 1, 0)
MaximizeButton.Position = UDim2.new(1, -60, 0, 0)
MaximizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MaximizeButton.BorderSizePixel = 0
MaximizeButton.Text = "+"
MaximizeButton.Font = Enum.Font.SourceSansBold
MaximizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MaximizeButton.TextSize = 0.8 -- Scaled text size
MaximizeButton.TextScaled = true
MaximizeButton.Visible = false -- Initially hidden

-- Buttons Container
local ButtonsContainer = Instance.new("Frame")
ButtonsContainer.Name = "ButtonsContainer"
ButtonsContainer.Parent = Frame
ButtonsContainer.Size = UDim2.new(1, -10, 0.85, -5) -- Adjusted size, scaled to fit remaining space
ButtonsContainer.Position = UDim2.new(0, 5, 0.15, 0) -- Position below title bar
ButtonsContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ButtonsContainer.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ButtonsContainer
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Padding = UDim.new(0, 5) -- Add some padding between elements
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Fly CFrame Button
local FlyCFrameButton = Instance.new("TextButton")
FlyCFrameButton.Name = "FlyCFrame"
FlyCFrameButton.Parent = ButtonsContainer
FlyCFrameButton.Size = UDim2.new(0.9, 0, 0.18, 0) -- Scaled size
FlyCFrameButton.BackgroundColor3 = Color3.fromRGB(80, 150, 255) -- Blue for CFrame fly
FlyCFrameButton.BorderSizePixel = 0
FlyCFrameButton.Text = "Fly CFrame"
FlyCFrameButton.Font = Enum.Font.SourceSansSemibold
FlyCFrameButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FlyCFrameButton.TextSize = 0.6 -- Scaled text size
FlyCFrameButton.TextScaled = true

-- Walk Fly Button (original functionality)
local WalkFlyButton = Instance.new("TextButton")
WalkFlyButton.Name = "WalkFly"
WalkFlyButton.Parent = ButtonsContainer
WalkFlyButton.Size = UDim2.new(0.9, 0, 0.18, 0) -- Scaled size
WalkFlyButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100) -- Green for Walk fly
WalkFlyButton.BorderSizePixel = 0
WalkFlyButton.Text = "Walk Fly"
WalkFlyButton.Font = Enum.Font.SourceSansSemibold
WalkFlyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
WalkFlyButton.TextSize = 0.6 -- Scaled text size
WalkFlyButton.TextScaled = true

-- Up Button
local UpButton = Instance.new("TextButton")
UpButton.Name = "Up"
UpButton.Parent = ButtonsContainer
UpButton.Size = UDim2.new(0.9, 0, 0.18, 0) -- Scaled size
UpButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
UpButton.BorderSizePixel = 0
UpButton.Text = "Up"
UpButton.Font = Enum.Font.SourceSansSemibold
UpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
UpButton.TextSize = 0.6 -- Scaled text size
UpButton.TextScaled = true

-- Down Button
local DownButton = Instance.new("TextButton")
DownButton.Name = "Down"
DownButton.Parent = ButtonsContainer
DownButton.Size = UDim2.new(0.9, 0, 0.18, 0) -- Scaled size
DownButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
DownButton.BorderSizePixel = 0
DownButton.Text = "Down"
DownButton.Font = Enum.Font.SourceSansSemibold
DownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DownButton.TextSize = 0.6 -- Scaled text size
DownButton.TextScaled = true

-- Speed controls (plus, speed display, minus)
local SpeedContainer = Instance.new("Frame")
SpeedContainer.Name = "SpeedContainer"
SpeedContainer.Parent = ButtonsContainer
SpeedContainer.Size = UDim2.new(0.9, 0, 0.18, 0) -- Scaled size
SpeedContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedContainer.BackgroundTransparency = 1

local SpeedLayout = Instance.new("UIListLayout")
SpeedLayout.Parent = SpeedContainer
SpeedLayout.FillDirection = Enum.FillDirection.Horizontal
SpeedLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SpeedLayout.Padding = UDim.new(0, 5)

local MinusButton = Instance.new("TextButton")
MinusButton.Name = "Minus"
MinusButton.Parent = SpeedContainer
MinusButton.Size = UDim2.new(0.2, 0, 1, 0) -- Scaled width, full height
MinusButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
MinusButton.BorderSizePixel = 0
MinusButton.Text = "-"
MinusButton.Font = Enum.Font.SourceSansBold
MinusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusButton.TextSize = 0.8 -- Scaled text size
MinusButton.TextScaled = true

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "Speed"
SpeedLabel.Parent = SpeedContainer
SpeedLabel.Size = UDim2.new(0.4, 0, 1, 0) -- Scaled width, full height
SpeedLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedLabel.BorderSizePixel = 0
SpeedLabel.Text = "1"
SpeedLabel.Font = Enum.Font.SourceSansSemibold
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 0.6 -- Scaled text size
SpeedLabel.TextScaled = true

local PlusButton = Instance.new("TextButton")
PlusButton.Name = "Plus"
PlusButton.Parent = SpeedContainer
PlusButton.Size = UDim2.new(0.2, 0, 1, 0) -- Scaled width, full height
PlusButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
PlusButton.BorderSizePixel = 0
PlusButton.Text = "+"
PlusButton.Font = Enum.Font.SourceSansBold
PlusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusButton.TextSize = 0.8 -- Scaled text size
PlusButton.TextScaled = true

--- Variables ---
local currentSpeed = 1
local isWalkFlyActive = false
local isCFrameFlyActive = false

local tpwalking = false
local flyConnection = nil
local upConnection = nil
local downConnection = nil
local cframeFlyLoop = nil

--- Utility Functions ---
local function disableHumanoidStates(humanoid)
    if not humanoid then return end
    local states = Enum.HumanoidStateType:GetEnumItems()
    for _, state in ipairs(states) do
        humanoid:SetStateEnabled(state, false)
    end
end

local function enableHumanoidStates(humanoid)
    if not humanoid then return end
    local states = Enum.HumanoidStateType:GetEnumItems()
    for _, state in ipairs(states) do
        humanoid:SetStateEnabled(state, true)
    end
end

local function stopAllFlyModes()
    isWalkFlyActive = false
    isCFrameFlyActive = false

    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end

    if upConnection then
        upConnection:Disconnect()
        upConnection = nil
    end

    if downConnection then
        downConnection:Disconnect()
        downConnection = nil
    end

    if cframeFlyLoop then
        cframeFlyLoop:Disconnect()
        cframeFlyLoop = nil
    end

    tpwalking = false

    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if hum then
            enableHumanoidStates(hum)
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.Running) -- Reset to running state
        end
        local animate = char:FindFirstChild("Animate")
        if animate then
            animate.Disabled = false
        end
        local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if torso then
            local bg = torso:FindFirstChildOfClass("BodyGyro")
            local bv = torso:FindFirstChildOfClass("BodyVelocity")
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end
    end
end

--- Walk Fly Logic ---
local function toggleWalkFly()
    stopAllFlyModes() -- Stop any other active fly modes
    isWalkFlyActive = not isWalkFlyActive

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")

    if isWalkFlyActive then
        StarterGui:SetCore("SendNotification", {
            Title = "Walk Fly Activated";
            Text = "Press WASD to move!";
            Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
            Duration = 3;
        })

        if hum then
            disableHumanoidStates(hum)
            hum:ChangeState(Enum.HumanoidStateType.Swimming)

            flyConnection = RunService.Heartbeat:Connect(function()
                if hum.MoveDirection.Magnitude > 0 then
                    char:TranslateBy(hum.MoveDirection * currentSpeed)
                end
            end)

            local animate = char:FindFirstChild("Animate")
            if animate then
                animate.Disabled = true
            end
        end
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Walk Fly Deactivated";
            Text = "Flight mode off.";
            Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
            Duration = 3;
        })
    end
end

--- CFrame Fly Logic ---
local function toggleCFrameFly()
    stopAllFlyModes() -- Stop any other active fly modes
    isCFrameFlyActive = not isCFrameFlyActive

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
    local torso = char and (char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso"))

    if isCFrameFlyActive then
        StarterGui:SetCore("SendNotification", {
            Title = "CFrame Fly Activated";
            Text = "Use WASD and mouse for precise flight!";
            Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
            Duration = 3;
        })

        if hum then
            hum.PlatformStand = true
            disableHumanoidStates(hum)
        end

        if torso then
            local bg = Instance.new("BodyGyro", torso)
            bg.P = 9e4
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.cframe = torso.CFrame

            local bv = Instance.new("BodyVelocity", torso)
            bv.velocity = Vector3.new(0, 0.1, 0)
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

            local ctrl = {f = 0, b = 0, l = 0, r = 0}
            local inputConnections = {}

            -- Input handling for CFrame fly (Supports PC & Mobile)
            inputConnections.InputBegan = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.W then ctrl.f = 1 end
                if input.KeyCode == Enum.KeyCode.S then ctrl.b = -1 end
                if input.KeyCode == Enum.KeyCode.A then ctrl.l = -1 end
                if input.KeyCode == Enum.KeyCode.D then ctrl.r = 1 end
            end)

            inputConnections.InputEnded = UserInputService.InputEnded:Connect(function(input, gameProcessed)
                if gameProcessed then return end
                if input.KeyCode == Enum.KeyCode.W then ctrl.f = 0 end
                if input.KeyCode == Enum.KeyCode.S then ctrl.b = 0 end
                if input.KeyCode == Enum.KeyCode.A then ctrl.l = 0 end
                if input.KeyCode == Enum.KeyCode.D then ctrl.r = 0 end
            end)

            cframeFlyLoop = RunService.RenderStepped:Connect(function()
                if not isCFrameFlyActive or not char or not hum or hum.Health <= 0 then
                    -- Clean up if fly mode is deactivated or player dies
                    for _, conn in pairs(inputConnections) do
                        conn:Disconnect()
                    end
                    if bg then bg:Destroy() end
                    if bv then bv:Destroy() end
                    if hum then hum.PlatformStand = false end
                    cframeFlyLoop = nil
                    return
                end

                local camera = game.Workspace.CurrentCamera
                local moveVector = Vector3.new()

                if ctrl.f == 1 then moveVector += camera.CFrame.lookVector end
                if ctrl.b == -1 then moveVector -= camera.CFrame.lookVector end
                if ctrl.l == -1 then moveVector -= camera.CFrame.rightVector end
                if ctrl.r == 1 then moveVector += camera.CFrame.rightVector end

                local finalVelocity = moveVector.Unit * currentSpeed * 20 -- Adjust 20 for base speed

                bv.velocity = finalVelocity
                bg.cframe = camera.CFrame
            end)
        end
    else
        StarterGui:SetCore("SendNotification", {
            Title = "CFrame Fly Deactivated";
            Text = "Flight mode off.";
            Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
            Duration = 3;
        })
    end
end

--- Event Connections ---

-- Walk Fly Button Click
WalkFlyButton.MouseButton1Click:Connect(toggleWalkFly)

-- CFrame Fly Button Click
FlyCFrameButton.MouseButton1Click:Connect(toggleCFrameFly)

-- Up Button (Hold to go up)
UpButton.MouseButton1Down:Connect(function()
    upConnection = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char and (isCFrameFlyActive or isWalkFlyActive) then -- Allow up/down for both modes
            char:SetPrimaryPartCFrame(char:GetPrimaryPartCFrame() * CFrame.new(0, 1 * currentSpeed, 0))
        end
    end)
end)

UpButton.MouseButton1Up:Connect(function()
    if upConnection then
        upConnection:Disconnect()
        upConnection = nil
    end
end)

-- Down Button (Hold to go down)
DownButton.MouseButton1Down:Connect(function()
    downConnection = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char and (isCFrameFlyActive or isWalkFlyActive) then -- Allow up/down for both modes
            char:SetPrimaryPartCFrame(char:GetPrimaryPartCFrame() * CFrame.new(0, -1 * currentSpeed, 0))
        end
    end)
end)

DownButton.MouseButton1Up:Connect(function()
    if downConnection then
        downConnection:Disconnect()
        downConnection = nil
    end
end)

-- Plus Button for Speed
PlusButton.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed + 1
    SpeedLabel.Text = tostring(currentSpeed)
    StarterGui:SetCore("SendNotification", {
        Title = "Speed Increased!";
        Text = "Current Speed: " .. currentSpeed;
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
        Duration = 2;
    })
end)

-- Minus Button for Speed
MinusButton.MouseButton1Click:Connect(function()
    if currentSpeed > 1 then
        currentSpeed = currentSpeed - 1
        SpeedLabel.Text = tostring(currentSpeed)
        StarterGui:SetCore("SendNotification", {
            Title = "Speed Decreased!";
            Text = "Current Speed: " .. currentSpeed;
            Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
            Duration = 2;
        })
    else
        SpeedLabel.Text = "Min Speed"
        StarterGui:SetCore("SendNotification", {
            Title = "Speed Limit Reached!";
            Text = "Cannot decrease speed below 1.";
            Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
            Duration = 3;
        })
        task.wait(1)
        SpeedLabel.Text = tostring(currentSpeed)
    end
end)

-- Close Button
CloseButton.MouseButton1Click:Connect(function()
    stopAllFlyModes() -- Stop any active fly modes before closing
    main:Destroy()
    StarterGui:SetCore("SendNotification", {
        Title = "Fly GUI Closed";
        Text = "The GUI has been closed.";
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
        Duration = 2;
    })
end)

-- Minimize Button
MinimizeButton.MouseButton1Click:Connect(function()
    ButtonsContainer.Visible = false
    Frame.Size = UDim2.new(Frame.Size.X.Scale, 0, 0.15, 0) -- Collapse to title bar height (scaled)
    MinimizeButton.Visible = false
    MaximizeButton.Visible = true
    StarterGui:SetCore("SendNotification", {
        Title = "GUI Minimized";
        Text = "Click '+' to maximize.";
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
        Duration = 2;
    })
end)

-- Maximize Button
MaximizeButton.MouseButton1Click:Connect(function()
    ButtonsContainer.Visible = true
    Frame.Size = UDim2.new(Frame.Size.X.Scale, 0, 0.35, 0) -- Restore original scaled height
    MinimizeButton.Visible = true
    MaximizeButton.Visible = false
    StarterGui:SetCore("SendNotification", {
        Title = "GUI Maximized";
        Text = "Interface restored.";
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
        Duration = 2;
    })
end)

-- Character Added Event (to reset on respawn)
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5) -- Small delay to ensure character is fully loaded
    stopAllFlyModes() -- Ensure all fly modes are off when character respawns
    StarterGui:SetCore("SendNotification", {
        Title = "Character Respawned";
        Text = "Fly modes have been reset.";
        Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
        Duration = 3;
    })
end)

-- Initial Notification
StarterGui:SetCore("SendNotification", {
    Title = "FLY MENU | Version 2.15.0";
    Text = "Developed by Dyumra";
    Icon = "rbxthumb://type=Asset&id=5107182114&w=150&h=150";
    Duration = 5;
})
