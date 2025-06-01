--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Variables
local guiVisible = true
local camlockOn = false
local camlockPart = "Head"
local headlessOn = false
local espEnabled = false
local lockedPlayer
local wrongKeyCount = 0

--// GUI Creation
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "ControlGUI"
ScreenGui.ResetOnSpawn = false

-- Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 400)
Main.Position = UDim2.new(0, 100, 0, 100)
Main.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Name = "MainFrame"
Main.Visible = true
Main.BackgroundTransparency = 0.1
Main.ClipsDescendants = true
Main.AnchorPoint = Vector2.new(0, 0)
Main.AutoLocalize = false
Main:TweenSize(UDim2.new(0, 300, 0, 400), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3)

-- UICorner
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 15)

-- Toggle GUI Button
local toggleButton = Instance.new("TextButton", ScreenGui)
toggleButton.Size = UDim2.new(0, 120, 0, 30)
toggleButton.Position = UDim2.new(1, -130, 0, 20)
toggleButton.Text = "Toggle GUI"
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.TextScaled = true
toggleButton.Draggable = true
Instance.new("UICorner", toggleButton)

toggleButton.MouseButton1Click:Connect(function()
	guiVisible = not guiVisible
	Main.Visible = guiVisible
end)

-- Helper Function
local function createButton(name, posY)
	local btn = Instance.new("TextButton", Main)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
	btn.Text = name
	btn.TextColor3 = Color3.new(1,1,1)
	btn.TextScaled = true
	Instance.new("UICorner", btn)
	return btn
end

local camlockBtn = createButton("Camlock: Off", 0.02)
local partBtn = createButton("Lock: Head", 0.10)
local headlessBtn = createButton("Headless: Off", 0.18)
local espBtn = createButton("ESP: Off", 0.26)

-- TextBox + Hitbox Editor
local hitboxInput = Instance.new("TextBox", Main)
hitboxInput.Size = UDim2.new(1, -20, 0, 30)
hitboxInput.Position = UDim2.new(0, 10, 0, 0.34)
hitboxInput.PlaceholderText = "Hitbox size (e.g., 5)"
hitboxInput.Text = ""
hitboxInput.BackgroundColor3 = Color3.fromRGB(255, 120, 120)
hitboxInput.TextColor3 = Color3.new(1,1,1)
hitboxInput.TextScaled = true
Instance.new("UICorner", hitboxInput)

local enterBtn = createButton("Enter Hitbox", 0.43)
local headBtn = createButton("Head", 0.51)
local humanoidBtn = createButton("HumanoidRootPart", 0.59)

-- Key Entry
local keyInput = Instance.new("TextBox", Main)
keyInput.Size = UDim2.new(1, -20, 0, 30)
keyInput.Position = UDim2.new(0, 10, 0, 0.67)
keyInput.PlaceholderText = "Enter Key"
keyInput.BackgroundColor3 = Color3.fromRGB(255, 140, 140)
keyInput.TextColor3 = Color3.new(1,1,1)
keyInput.TextScaled = true
Instance.new("UICorner", keyInput)

--// Notifications
local function notify(text)
	game.StarterGui:SetCore("SendNotification", {
		Title = "System";
		Text = text;
		Duration = 4;
	})
end

--// Camlock Logic
RunService.RenderStepped:Connect(function()
	if camlockOn and lockedPlayer and lockedPlayer.Character and lockedPlayer.Character:FindFirstChild(camlockPart) then
		workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, lockedPlayer.Character[camlockPart].Position)
	end
end)

local function findTarget()
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
			return p
		end
	end
	return nil
end

-- Update Target Automatically
RunService.Stepped:Connect(function()
	if camlockOn and lockedPlayer and (not lockedPlayer.Character or lockedPlayer.Character.Humanoid.Health <= 0) then
		lockedPlayer = findTarget()
	end
end)

-- Toggle Camlock
camlockBtn.MouseButton1Click:Connect(function()
	camlockOn = not camlockOn
	camlockBtn.Text = "Camlock: " .. (camlockOn and "On" or "Off")
	if camlockOn then
		lockedPlayer = findTarget()
	end
end)

-- Lock Part Toggle
partBtn.MouseButton1Click:Connect(function()
	camlockPart = (camlockPart == "Head") and "Torso" or "Head"
	partBtn.Text = "Lock: " .. camlockPart
end)

-- Headless Toggle
headlessBtn.MouseButton1Click:Connect(function()
	headlessOn = not headlessOn
	headlessBtn.Text = "Headless: " .. (headlessOn and "On" or "Off")
end)

-- Force Headless Loop
RunService.RenderStepped:Connect(function()
	if headlessOn and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
		LocalPlayer.Character.Head.Transparency = 1
		if LocalPlayer.Character.Head:FindFirstChild("face") then
			LocalPlayer.Character.Head.face.Transparency = 1
		end
	end
end)

-- ESP Function
local function addESP(player)
	local function createHighlight()
		local hl = Instance.new("Highlight")
		hl.FillColor = Color3.fromRGB(255, 0, 0)
		hl.OutlineColor = Color3.fromRGB(255, 0, 0)
		hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		return hl
	end

	if player.Character and not player.Character:FindFirstChild("ESP") then
		local hl = createHighlight()
		hl.Name = "ESP"
		hl.Parent = player.Character
		hl.Adornee = player.Character
	end

	player.CharacterAdded:Connect(function(char)
		local hl = createHighlight()
		hl.Name = "ESP"
		hl.Parent = char
		hl.Adornee = char
	end)
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = "ESP: " .. (espEnabled and "On" or "Off")
	if espEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then addESP(p) end
		end
		Players.PlayerAdded:Connect(function(p)
			if espEnabled and p ~= LocalPlayer then
				addESP(p)
			end
		end)
	end
end)

-- Hitbox Editor
local function expand(partName)
	local size = tonumber(hitboxInput.Text)
	if not size then return end
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(partName) then
			local part = p.Character[partName]
			part.Size = Vector3.new(size, size, size)
			part.Transparency = 0.5
			part.CanCollide = false
		end
	end
end

enterBtn.MouseButton1Click:Connect(function() expand("HumanoidRootPart") end)
headBtn.MouseButton1Click:Connect(function() expand("Head") end)
humanoidBtn.MouseButton1Click:Connect(function() expand("HumanoidRootPart") end)

-- Key Verification
keyInput.FocusLost:Connect(function(enter)
	if not enter then return end
	if keyInput.Text ~= "dyumra" then
		wrongKeyCount += 1
		notify("Wrong key! ("..wrongKeyCount.."/3)")
		if wrongKeyCount >= 3 then
			LocalPlayer:Kick("Banned: 100 days")
		end
	else
		notify("Key accepted.")
	end
end)
