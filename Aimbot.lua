-- Default Settings
local aimbot = false
local esp = false
local lockset = "Torso"
local lockParts = {"Head", "Torso", "UpperTorso"}
local lockIndex = table.find(lockParts, lockset) or 2
local currentTarget = nil

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Notify Function (Roblox Style)
local function showNotify(text)
	StarterGui:SetCore("SendNotification", {
		Title = "Aimbot System",
		Text = text,
		Duration = 3
	})
end

-- Create GUI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "AimbotESP_UI"

-- Frame (Draggable Container)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 140)
frame.Position = UDim2.new(0.5, -120, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Name = "MainFrame"

-- UI Corner
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 8)

-- Font & Button Style
local function makeButton(name, position, text)
	local btn = Instance.new("TextButton", frame)
	btn.Name = name
	btn.Size = UDim2.new(0, 100, 0, 30)
	btn.Position = position
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = text
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 6)
	return btn
end

-- Buttons
local aimbotBtn = makeButton("AimbotBtn", UDim2.new(0, 10, 0, 10), "Aimbot: OFF")
local espBtn = makeButton("ESPBtn", UDim2.new(0, 130, 0, 10), "ESP: OFF")
local lockBtn = makeButton("LockBtn", UDim2.new(0, 10, 0, 50), "Lock Set: Torso")
lockBtn.Size = UDim2.new(1, -20, 0, 30)

-- ESP Highlight Table
local highlights = {}

-- Visibility Checker
local function isVisible(part)
	local origin = Camera.CFrame.Position
	local direction = (part.Position - origin)
	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Blacklist
	rayParams.FilterDescendantsInstances = {LocalPlayer.Character}
	local result = workspace:Raycast(origin, direction, rayParams)
	return not result or result.Instance:IsDescendantOf(part.Parent)
end

-- Get Closest Target
local function getClosestTarget()
	local closest, dist = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(lockset) then
			local part = p.Character[lockset]
			local hum = p.Character:FindFirstChild("Humanoid")
			if hum and hum.Health > 0 and isVisible(part) then
				local screen, onScreen = Camera:WorldToViewportPoint(part.Position)
				local mag = (Vector2.new(screen.X, screen.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
				if onScreen and mag < dist then
					closest = p
					dist = mag
				end
			end
		end
	end
	return closest
end

-- Update ESP
local function updateESP()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and not highlights[p] then
			local h = Instance.new("Highlight")
			h.Name = "ESP_Highlight"
			h.Adornee = p.Character
			h.FillTransparency = 0.7
			h.FillColor = (p.Team and p.Team.TeamColor.Color) or Color3.new(1,1,1)
			h.OutlineColor = Color3.fromRGB(255, 255, 255)
			h.Parent = p.Character
			highlights[p] = h
		end
	end
end

-- Remove ESP
local function removeESP(player)
	if highlights[player] then
		highlights[player]:Destroy()
		highlights[player] = nil
	end
end

-- Button Events
aimbotBtn.MouseButton1Click:Connect(function()
	aimbot = not aimbot
	currentTarget = nil
	aimbotBtn.Text = "Aimbot: " .. (aimbot and "ON" or "OFF")
	aimbotBtn.BackgroundColor3 = aimbot and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
	showNotify("Aimbot: " .. (aimbot and "Enabled" or "Disabled"))
end)

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "ESP: " .. (esp and "ON" or "OFF")
	espBtn.BackgroundColor3 = esp and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
	showNotify("ESP: " .. (esp and "Enabled" or "Disabled"))
	if esp then updateESP() else for _, h in pairs(highlights) do h:Destroy() end highlights = {} end
end)

lockBtn.MouseButton1Click:Connect(function()
	lockIndex += 1
	if lockIndex > #lockParts then lockIndex = 1 end
	lockset = lockParts[lockIndex]
	lockBtn.Text = "Lock Set: " .. lockset
	showNotify("Lock Part set to: " .. lockset)
end)

-- Player Add/Remove
Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function()
		wait(1)
		if esp then updateESP() end
	end)
end)

Players.PlayerRemoving:Connect(removeESP)

-- Loop
RunService.RenderStepped:Connect(function()
	if aimbot then
		if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("Humanoid") and currentTarget.Character:FindFirstChild(lockset) then
			local h = currentTarget.Character.Humanoid
			if h.Health > 0 and isVisible(currentTarget.Character[lockset]) then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, currentTarget.Character[lockset].Position)
			else
				currentTarget = nil
			end
		else
			currentTarget = getClosestTarget()
		end
	end

	if esp then updateESP() end
end)
