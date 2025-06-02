-- [ 🌼 Roblox Edition - Powered by @ dyumra. ]
-- [ 💌 Version : 1.9.0 - Final Script ]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local StarterGui = game:GetService("StarterGui")

-- Notify function using Roblox native notification
local function showNotify(text)
    StarterGui:SetCore("SendNotification", {
        Title = "Dyumra Script",
        Text = text,
        Duration = 3,
    })
end

-- Variables
local aimbotEnabled = false
local espEnabled = false
local killAllEnabled = false
local hitboxEnabled = false

local lockSetOptions = {"Torso", "UpperTorso", "Head", "HumanoidRootPart"}
local currentLockSet = "Torso"

local hitboxSizeAdd = 0

local highlights = {}
local highlightFolder = Instance.new("Folder", workspace)
highlightFolder.Name = "DyumraHighlights"

-- GUI creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DyumraGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 380)
mainFrame.Position = UDim2.new(0, 20, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0, 0.5)
mainFrame.Parent = ScreenGui
mainFrame.ClipsDescendants = true
mainFrame.AutoButtonColor = false
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Name = "MainFrame"
mainFrame.Selectable = true
mainFrame.Style = Enum.FrameStyle.RobloxRound -- Modern rounded style

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Dyumra Aimbot & ESP"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 45)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "Status: Idle"
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Button creator function
local function createButton(name, posY, parent)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 130, 0, 40)
    btn.Position = UDim2.new(0, 10 + (name:lower():find("right") and 160 or 0), 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name
    btn.AutoButtonColor = true
    btn.Parent = parent
    btn.Style = Enum.ButtonStyle.RobloxRound
    return btn
end

-- Create buttons
local aimbotBtn = createButton("Aimbot: Off", 85, mainFrame)
local espBtn = createButton("ESP: Off", 135, mainFrame)
local killAllBtn = createButton("Kill All: Off", 185, mainFrame)
local hitboxBtn = createButton("Hitbox: Off", 235, mainFrame)

-- LockSet dropdown
local lockSetLabel = Instance.new("TextLabel")
lockSetLabel.Size = UDim2.new(1, -20, 0, 25)
lockSetLabel.Position = UDim2.new(0, 10, 0, 290)
lockSetLabel.BackgroundTransparency = 1
lockSetLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
lockSetLabel.TextScaled = true
lockSetLabel.Font = Enum.Font.Gotham
lockSetLabel.TextXAlignment = Enum.TextXAlignment.Left
lockSetLabel.Text = "LockSet: Torso"
lockSetLabel.Parent = mainFrame

local lockSetDropdown = Instance.new("TextButton")
lockSetDropdown.Size = UDim2.new(0, 130, 0, 35)
lockSetDropdown.Position = UDim2.new(0, 10, 0, 320)
lockSetDropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
lockSetDropdown.BorderSizePixel = 0
lockSetDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
lockSetDropdown.TextScaled = true
lockSetDropdown.Font = Enum.Font.GothamSemibold
lockSetDropdown.Text = currentLockSet
lockSetDropdown.AutoButtonColor = true
lockSetDropdown.Style = Enum.ButtonStyle.RobloxRound
lockSetDropdown.Parent = mainFrame

-- Dropdown list container
local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0, 130, 0, 0)
dropdownFrame.Position = UDim2.new(0, 10, 0, 355)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.ClipsDescendants = true
dropdownFrame.Parent = mainFrame

local dropdownOpen = false

-- Populate dropdown options
local function toggleDropdown()
    dropdownOpen = not dropdownOpen
    if dropdownOpen then
        dropdownFrame:TweenSize(UDim2.new(0, 130, 0, #lockSetOptions*35), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
    else
        dropdownFrame:TweenSize(UDim2.new(0, 130, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
    end
end

lockSetDropdown.MouseButton1Click:Connect(function()
    toggleDropdown()
end)

for i, option in ipairs(lockSetOptions) do
    local optionBtn = Instance.new("TextButton")
    optionBtn.Size = UDim2.new(1, 0, 0, 35)
    optionBtn.Position = UDim2.new(0, 0, 0, (i-1)*35)
    optionBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    optionBtn.BorderSizePixel = 0
    optionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    optionBtn.TextScaled = true
    optionBtn.Font = Enum.Font.GothamSemibold
    optionBtn.Text = option
    optionBtn.Parent = dropdownFrame
    optionBtn.Style = Enum.ButtonStyle.RobloxRound

    optionBtn.MouseButton1Click:Connect(function()
        currentLockSet = option
        lockSetDropdown.Text = currentLockSet
        toggleDropdown()
        showNotify("LockSet changed to "..currentLockSet)
    end)
end

-- Hitbox size input
local hitboxLabel = Instance.new("TextLabel")
hitboxLabel.Size = UDim2.new(0, 100, 0, 25)
hitboxLabel.Position = UDim2.new(0, 150, 0, 290)
hitboxLabel.BackgroundTransparency = 1
hitboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxLabel.TextScaled = true
hitboxLabel.Font = Enum.Font.Gotham
hitboxLabel.TextXAlignment = Enum.TextXAlignment.Left
hitboxLabel.Text = "Hitbox Size +"
hitboxLabel.Parent = mainFrame

local hitboxInput = Instance.new("TextBox")
hitboxInput.Size = UDim2.new(0, 130, 0, 35)
hitboxInput.Position = UDim2.new(0, 150, 0, 320)
hitboxInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
hitboxInput.BorderSizePixel = 0
hitboxInput.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxInput.TextScaled = true
hitboxInput.Font = Enum.Font.GothamSemibold
hitboxInput.ClearTextOnFocus = false
hitboxInput.Text = "0"
hitboxInput.PlaceholderText = "Enter number"
hitboxInput.Parent = mainFrame

hitboxInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(hitboxInput.Text)
        if val and val >= 0 then
            hitboxSizeAdd = val
            showNotify("Hitbox size addition set to "..val)
        else
            hitboxInput.Text = tostring(hitboxSizeAdd)
            showNotify("Invalid hitbox size input")
        end
    end
end)

-- Close/Open GUI button
local toggleGuiBtn = Instance.new("TextButton")
toggleGuiBtn.Size = UDim2.new(0, 40, 0, 40)
toggleGuiBtn.Position = UDim2.new(0, 5, 0.5, -20)
toggleGuiBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleGuiBtn.BorderSizePixel = 0
toggleGuiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleGuiBtn.TextScaled = true
toggleGuiBtn.Font = Enum.Font.GothamBold
toggleGuiBtn.Text = "<"
toggleGuiBtn.Parent = ScreenGui
toggleGuiBtn.Style = Enum.ButtonStyle.RobloxRound

local guiOpen = true
toggleGuiBtn.MouseButton1Click:Connect(function()
    if guiOpen then
        mainFrame:TweenPosition(UDim2.new(0, -310, 0.5, -190), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        toggleGuiBtn.Text = ">"
        guiOpen = false
    else
        mainFrame:TweenPosition(UDim2.new(0, 20, 0.5, -190), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        toggleGuiBtn.Text = "<"
        guiOpen = true
    end
end)

-- Utility to clear highlights
local function clearHighlights()
    for _, h in pairs(highlights) do
        h:Destroy()
    end
    highlights = {}
end

-- Create highlight on part
local function createHighlight(part)
    if highlights[part] then return end
    local hl = Instance.new("Highlight")
    hl.Adornee = part
    hl.FillColor = Color3.fromRGB(0, 255, 0)
    hl.FillTransparency = 0.5
    hl.OutlineColor = Color3.fromRGB(0, 255, 0)
    hl.OutlineTransparency = 0.7
    hl.Parent = highlightFolder
    highlights[part] = hl
end

-- Remove highlight
local function removeHighlight(part)
    if highlights[part] then
        highlights[part]:Destroy()
        highlights[part] = nil
    end
end

-- ESP toggle function
local function toggleESP(state)
    espEnabled = state
    if not espEnabled then
        clearHighlights()
        statusLabel.Text = "ESP: Off"
        showNotify("ESP Disabled")
    else
        statusLabel.Text = "ESP: On"
        showNotify("ESP Enabled")
    end
end

-- Hitbox toggle function
local function toggleHitbox(state)
    hitboxEnabled = state
    if not hitboxEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                for _, part in pairs(plr.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Size = part.Size - Vector3.new(hitboxSizeAdd, hitboxSizeAdd, hitboxSizeAdd)
                    end
                end
            end
        end
        statusLabel.Text = "Hitbox: Off"
        showNotify("Hitbox Disabled")
    else
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                for _, part in pairs(plr.Character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.Size = part.Size + Vector3.new(hitboxSizeAdd, hitboxSizeAdd, hitboxSizeAdd)
                    end
                end
            end
        end
        statusLabel.Text = "Hitbox: On"
        showNotify("Hitbox Enabled")
    end
end

-- Aimbot logic
local currentTarget = nil

local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local part = plr.Character:FindFirstChild(currentLockSet)
            if not part then
                -- fallback if currentLockSet part not found
                part = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Head")
            end
            if part then
                local distance = (part.Position - Mouse.Hit.p).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = plr
                end
            end
        end
    end
    return closestPlayer
end

-- Teleport in front function for Kill All
local function teleportInFront(target)
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetHRP = target.Character.HumanoidRootPart
        local direction = targetHRP.CFrame.LookVector
        local teleportPos = targetHRP.Position + direction * 3 -- 3 studs in front
        character.HumanoidRootPart.CFrame = CFrame.new(teleportPos)
        showNotify("Teleported in front of "..target.Name)
    end
end

-- Kill All logic
local function killAll()
    if not killAllEnabled then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            teleportInFront(plr)
            wait(0.3)
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:TakeDamage(1000) -- simulate kill (or you can implement actual kill logic)
                showNotify("Attacked "..plr.Name)
            end
        end
    end
end

-- Button events
aimbotBtn.MouseButton1Click:Connect(function()
    aimbotEnabled = not aimbotEnabled
    aimbotBtn.Text = "Aimbot: "..(aimbotEnabled and "On" or "Off")
    showNotify("Aimbot "..(aimbotEnabled and "Enabled" or "Disabled"))
end)

espBtn.MouseButton1Click:Connect(function()
    toggleESP(not espEnabled)
    espBtn.Text = "ESP: "..(espEnabled and "On" or "Off")
end)

killAllBtn.MouseButton1Click:Connect(function()
    killAllEnabled = not killAllEnabled
    killAllBtn.Text = "Kill All: "..(killAllEnabled and "On" or "Off")
    showNotify("Kill All "..(killAllEnabled and "Enabled" or "Disabled"))
    if killAllEnabled then
        killAll()
    end
end)

hitboxBtn.MouseButton1Click:Connect(function()
    hitboxEnabled = not hitboxEnabled
    hitboxBtn.Text = "Hitbox: "..(hitboxEnabled and "On" or "Off")
    toggleHitbox(hitboxEnabled)
end)

-- Main loop for Aimbot and ESP
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        currentTarget = getClosestTarget()
        if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild(currentLockSet) then
            -- Aim at target part
            local targetPart = currentTarget.Character[currentLockSet]
            -- Here you would put the actual aimbot aiming code (like setting camera CFrame)
            statusLabel.Text = "Aimbot: Targeting "..currentTarget.Name
        else
            statusLabel.Text = "Aimbot: No target"
        end
    else
        statusLabel.Text = "Status: Idle"
        currentTarget = nil
    end

    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local part = plr.Character:FindFirstChild(currentLockSet) or plr.Character:FindFirstChild("HumanoidRootPart")
                if part then
                    createHighlight(part)
                end
            end
        end
    else
        clearHighlights()
    end
end)

-- Initial setup
showNotify("Dyumra Script Loaded! LockSet: "..currentLockSet)
print("Hi from @dyumra.")
