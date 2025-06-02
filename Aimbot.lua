-- [ 🌼 Roblox Edition - Powered by @ dyumra. ]
-- [ 💌 Version : 1.5.0 - Final Script ]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "DyumraAimbotGUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 220, 0, 260)
mainFrame.Position = UDim2.new(0, 10, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0, 0)
mainFrame.ClipsDescendants = true
mainFrame.AutomaticSize = Enum.AutomaticSize.None
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Name = "MainFrame"
mainFrame.BackgroundTransparency = 0

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 10)

-- Toggle Button to show/hide the main GUI
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 100, 0, 25)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Text = "Show GUI"
toggleBtn.Name = "ToggleBtn"
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 18
toggleBtn.AutoButtonColor = true
toggleBtn.BackgroundTransparency = 0

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 6)

toggleBtn.MouseButton1Click:Connect(function()
	if mainFrame.Visible then
		mainFrame.Visible = false
		toggleBtn.Text = "Show GUI"
	else
		mainFrame.Visible = true
		toggleBtn.Text = "Hide GUI"
	end
end)

-- Create UI elements (Buttons and Label)
local function createButton(name, posY)
	local btn = Instance.new("TextButton", mainFrame)
	btn.Size = UDim2.new(0, 200, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = name
	btn.Name = name:gsub("%s", "") .. "Btn"

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)

	return btn
end

local aimbotBtn = createButton("Aimbot: Off", 10)
local espBtn = createButton("ESP: Off", 55)
local killBtn = createButton("Kill All: Off", 100)
local hitboxBtn = createButton("Hitbox: Off", 145)

local hitboxLabel = Instance.new("TextLabel", mainFrame)
hitboxLabel.Text = "Hitbox Size (0-50):"
hitboxLabel.Size = UDim2.new(0, 200, 0, 25)
hitboxLabel.Position = UDim2.new(0, 10, 0, 190)
hitboxLabel.BackgroundTransparency = 1
hitboxLabel.TextColor3 = Color3.new(1,1,1)
hitboxLabel.Font = Enum.Font.SourceSans
hitboxLabel.TextSize = 16
hitboxLabel.TextXAlignment = Enum.TextXAlignment.Left

local hitboxInput = Instance.new("TextBox", mainFrame)
hitboxInput.Size = UDim2.new(0, 200, 0, 30)
hitboxInput.Position = UDim2.new(0, 10, 0, 215)
hitboxInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
hitboxInput.TextColor3 = Color3.new(1,1,1)
hitboxInput.Font = Enum.Font.SourceSansBold
hitboxInput.TextSize = 18
hitboxInput.ClearTextOnFocus = false
hitboxInput.Text = "5"
hitboxInput.Name = "HitboxInput"

local inputCorner = Instance.new("UICorner", hitboxInput)
inputCorner.CornerRadius = UDim.new(0, 6)

-- Notification helper
local function showNotify(text)
	StarterGui:SetCore("SendNotification", {
		Title = "Dyumra Script",
		Text = text,
		Duration = 3,
	})
end

-- Variables for toggles and settings
local aimbot = false
local esp = false
local killAll = false
local hitbox = false
local hitboxSize = 5

local killInterval = 0.4
local killTimer = 0

local lockset = nil -- detected body part for aiming: "Torso", "UpperTorso", "HumanoidRootPart"
local currentTarget = nil

-- Detect which body part to lock on (R6 = Torso, R15 = UpperTorso or HumanoidRootPart)
local function detectLockSet(character)
	if character:FindFirstChild("HumanoidRootPart") then
		return "HumanoidRootPart"
	elseif character:FindFirstChild("UpperTorso") then
		return "UpperTorso"
	elseif character:FindFirstChild("Torso") then
		return "Torso"
	end
	return nil
end

-- ESP Highlights handling
local highlights = {}

local function updateHighlights()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local char = plr.Character
			if not highlights[plr] then
				local highlight = Instance.new("Highlight")
				highlight.Adornee = char
				highlight.FillColor = Color3.new(0,1,0)
				highlight.OutlineColor = Color3.new(0,1,0)
				highlight.Parent = screenGui
				highlights[plr] = highlight
			end
		end
	end

	-- Remove highlights for players who left or ESP off
	for plr, highlight in pairs(highlights) do
		if not esp or not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") or not Players:FindFirstChild(plr.Name) then
			highlight:Destroy()
			highlights[plr] = nil
		end
	end
end

-- Hitbox expand / reset functions
local originalSizes = {}

local function updateHitboxes()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character then
			local rootPart = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Torso")
			if rootPart then
				if not originalSizes[plr] then
					originalSizes[plr] = rootPart.Size
				end
				rootPart.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
				rootPart.Transparency = 0.5
				rootPart.Material = Enum.Material.Plastic
				rootPart.Color = Color3.new(1,1,1)
			end
		end
	end
end

local function resetHitboxes()
	for plr, size in pairs(originalSizes) do
		if plr.Character then
			local rootPart = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Torso")
			if rootPart then
				rootPart.Size = size
				rootPart.Transparency = 0
				rootPart.Material = Enum.Material.Plastic
				rootPart.Color = Color3.new(1,1,1)
			end
		end
	end
	originalSizes = {}
end

-- Find closest player to mouse (target)
local function getClosestTarget()
	local closest = nil
	local shortestDist = math.huge
	local mousePos = UserInputService:GetMouseLocation()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild(lockset or "HumanoidRootPart") then
			local part = plr.Character[lockset or "HumanoidRootPart"]
			local screenPoint = Camera:WorldToViewportPoint(part.Position)
			if screenPoint.Z > 0 then
				local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
				if dist < shortestDist then
					shortestDist = dist
					closest = plr
				end
			end
		end
	end
	return closest
end

-- Teleport player in front of target (2 studs ahead)
local function teleportToTarget(plr)
	if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local targetPos = plr.Character.HumanoidRootPart.Position
	local lookVector = plr.Character.HumanoidRootPart.CFrame.LookVector

	hrp.CFrame = CFrame.new(targetPos + lookVector * 2)
end

-- KillAll function (kills one target per interval)
local function killAllTargets(dt)
	if not killAll then return end
	killTimer = killTimer + dt
	if killTimer >= killInterval then
		killTimer = 0
		local killTarget = getClosestTarget()
		if killTarget and killTarget.Character and killTarget.Character:FindFirstChild("Humanoid") then
			local humanoid = killTarget.Character.Humanoid
			if humanoid.Health > 0 then
				teleportToTarget(killTarget)
				humanoid.Health = 0
				showNotify("Killed " .. killTarget.Name)
			end
		end
	end
end

-- Update GUI Button Texts
local function updateLockBtn()
	-- Can add lockset display if needed
end

-- Button Events
aimbotBtn.MouseButton1Click:Connect(function()
	aimbot = not aimbot
	aimbotBtn.Text = "Aimbot: " .. (aimbot and "On" or "Off")
	showNotify("Aimbot " .. (aimbot and "Enabled" or "Disabled"))
end)

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "ESP: " .. (esp and "On" or "Off")
	if not esp then
		-- Remove all highlights immediately
		for _, highlight in pairs(highlights) do
			highlight:Destroy()
		end
		highlights = {}
	end
	showNotify("ESP " .. (esp and "Enabled" or "Disabled"))
	updateHighlights()
end)

killBtn.MouseButton1Click:Connect(function()
	killAll = not killAll
	killBtn.Text = "Kill All: " .. (killAll and "On" or "Off")
	showNotify("Kill All " .. (killAll and "Enabled" or "Disabled"))
end)

hitboxBtn.MouseButton1Click:Connect(function()
	hitbox = not hitbox
	hitboxBtn.Text = "Hitbox: " .. (hitbox and "On" or "Off")
	if hitbox then
		updateHitboxes()
		showNotify("Hitbox Enabled")
	else
		resetHitboxes()
		showNotify("Hitbox Disabled")
	end
end)

hitboxInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local val = tonumber(hitboxInput.Text)
		if val and val >= 0 and val <= 50 then
			hitboxSize = val
			if hitbox then
				updateHitboxes()
			end
			showNotify("Hitbox size set to " .. hitboxSize)
		else
			showNotify("Invalid hitbox size! Must be 0-50")
			hitboxInput.Text = tostring(hitboxSize)
		end
	end
end)

-- Setup lockset on character spawn
local function setupLockset()
	local char = player.Character or player.CharacterAdded:Wait()
	lockset = detectLockSet(char)
	updateLockBtn()
end

player.CharacterAdded:Connect(function(char)
	lockset = detectLockSet(char)
	updateLockBtn()
	resetHitboxes()
	if hitbox then updateHitboxes() end
end)

-- Main update loop
RunService.RenderStepped:Connect(function(dt)
	if aimbot and lockset and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		currentTarget = getClosestTarget()
		if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild(lockset) then
			local targetPart = currentTarget.Character[lockset]
			local cameraPos = Camera.CFrame.Position
			local targetPos = targetPart.Position
			local direction = (targetPos - cameraPos).Unit
			local newCFrame = CFrame.new(cameraPos, cameraPos + direction)
			Camera.CFrame = newCFrame
		end
	end

	if killAll then
		killAllTargets(dt)
	end

	if esp then
		updateHighlights()
	end
end)

-- Repeated highlight update every 1 second (in case)
while true do
	wait(1)
	if esp then
		updateHighlights()
	end
end

-- Credit footer (optional)
print("Nice by @dyumra.")
