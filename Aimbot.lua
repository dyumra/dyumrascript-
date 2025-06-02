-- [ 🌼 Roblox Edition - Powered by @ dyumra.
-- 💌 Version : 1.0.0 - Final Script ]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- สร้าง GUI หลัก (Frame) ที่ลากได้
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "AimbotEspGui"
mainGui.Parent = playerGui
mainGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 260)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = mainGui

-- ทำให้ mainFrame ลากได้
local dragging = false
local dragInput, mousePos, framePos

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - mousePos
		mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X,
										framePos.Y.Scale, framePos.Y.Offset + delta.Y)
	end
end)

-- สร้างปุ่ม Toggle GUI ที่มุมซ้ายบน
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.BorderSizePixel = 0
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Text = "Toggle GUI"
toggleButton.Parent = playerGui

toggleButton.MouseButton1Click:Connect(function()
	mainGui.Enabled = not mainGui.Enabled
end)

-- ฟังก์ชันแสดง Notify แบบ Roblox default (Notification GUI)
local function showNotify(text)
	game.StarterGui:SetCore("SendNotification", {
		Title = "AimbotESP";
		Text = text;
		Duration = 3;
	})
end

-- ตัวแปรสถานะเริ่มต้น
local aimbot = false
local esp = false
local killAll = false
local hitbox = false
local hitboxSize = 0
local lockParts = {"Head", "Torso", "UpperTorso"}
local lockIndex = 2 -- เริ่มที่ Torso
local lockset = lockParts[lockIndex]

-- สร้างปุ่มแบบง่ายๆ ฟังก์ชันช่วยสร้าง
local function createButton(name, pos)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 120, 0, 30)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.BorderSizePixel = 0
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Text = name
	btn.Parent = mainFrame
	return btn
end

local function createLabel(text, pos)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 120, 0, 20)
	label.Position = pos
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1,1,1)
	label.Text = text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = mainFrame
	return label
end

local aimbotBtn = createButton("Aimbot: Off", UDim2.new(0, 10, 0, 40))
local espBtn = createButton("ESP: Off", UDim2.new(0, 150, 0, 40))
local lockBtn = createButton("Lock Set: "..lockset, UDim2.new(0, 10, 0, 80))
local killBtn = createButton("Kill All: Off", UDim2.new(0, 150, 0, 80))
local hitboxBtn = createButton("Hitbox: Off", UDim2.new(0, 10, 0, 120))

createLabel("Hitbox Size:", UDim2.new(0, 150, 0, 125))

local hitboxInput = Instance.new("TextBox")
hitboxInput.Size = UDim2.new(0, 110, 0, 25)
hitboxInput.Position = UDim2.new(0, 150, 0, 145)
hitboxInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
hitboxInput.BorderSizePixel = 0
hitboxInput.TextColor3 = Color3.new(1,1,1)
hitboxInput.Text = tostring(hitboxSize)
hitboxInput.ClearTextOnFocus = false
hitboxInput.Parent = mainFrame

-- Highlight สำหรับ ESP
local highlightFolder = Instance.new("Folder", mainGui)
highlightFolder.Name = "HighlightFolder"

-- ฟังก์ชันสร้าง Highlight ตามทีม
local function updateHighlights()
	-- เคลียร์ไฮไลท์เก่า
	for _, h in pairs(highlightFolder:GetChildren()) do
		h:Destroy()
	end
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
			local hl = Instance.new("Highlight")
			hl.Adornee = p.Character
			hl.Parent = highlightFolder
			hl.Name = p.Name.."Highlight"
			local teamColor = p.TeamColor.Color
			if p.Team == nil or p.Team == Players:GetPlayers()[1].Team then
				hl.FillColor = Color3.new(1,1,1)
			else
				hl.FillColor = teamColor
			end
			hl.OutlineColor = hl.FillColor
		end
	end
end

-- ฟังก์ชันหาเป้าหมายที่ใกล้ที่สุด
local function getClosestTarget()
	local closest = nil
	local closestDist = math.huge
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild(lockset) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
			local part = p.Character[lockset]
			-- เช็คว่ามองเห็น (raycast) หรือไม่ (ไม่ล็อคหลังผนัง)
			local origin = Camera.CFrame.Position
			local direction = (part.Position - origin).Unit * (part.Position - origin).Magnitude
			local raycastParams = RaycastParams.new()
			raycastParams.FilterDescendantsInstances = {player.Character, workspace.Terrain}
			raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
			local raycastResult = workspace:Raycast(origin, direction, raycastParams)
			if raycastResult then
				if raycastResult.Instance and raycastResult.Instance:IsDescendantOf(p.Character) then
					local dist = (Camera.CFrame.Position - part.Position).Magnitude
					if dist < closestDist then
						closest = p
						closestDist = dist
					end
				end
			end
		end
	end
	return closest
end

local currentTarget = nil

-- ฟังก์ชันอัพเดต Hitbox ขนาด
local function updateHitbox()
	if hitbox and currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild(lockset) then
		local part = currentTarget.Character[lockset]
		if part then
			-- รีเซ็ตขนาดก่อนแล้วเพิ่มขนาดใหม่
			part.Size = Vector3.new(2, 2, 1) + Vector3.new(hitboxSize, hitboxSize, hitboxSize)
		end
	end
end

-- event ปุ่มกดต่างๆ

aimbotBtn.MouseButton1Click:Connect(function()
	aimbot = not aimbot
	aimbotBtn.Text = "Aimbot: "..(aimbot and "On" or "Off")
	showNotify("Aimbot " .. (aimbot and "enabled" or "disabled"))
	if not aimbot then currentTarget = nil end
end)

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "ESP: "..(esp and "On" or "Off")
	showNotify("ESP " .. (esp and "enabled" or "disabled"))
	if esp then
		updateHighlights()
	else
		for _, h in pairs(highlightFolder:GetChildren()) do
			h:Destroy()
		end
	end
end)

lockBtn.MouseButton1Click:Connect(function()
	lockIndex = lockIndex + 1
	if lockIndex > #lockParts then lockIndex = 1 end
	lockset = lockParts[lockIndex]
	lockBtn.Text = "Lock Set: "..lockset
	showNotify("Lockset set to "..lockset)
end)

killBtn.MouseButton1Click:Connect(function()
	killAll = not killAll
	killBtn.Text = "Kill All: "..(killAll and "On" or "Off")
	showNotify("Kill All " .. (killAll and "enabled" or "disabled"))
end)

hitboxBtn.MouseButton1Click:Connect(function()
	hitbox = not hitbox
	hitboxBtn.Text = "Hitbox: " .. (hitbox and "On" or "Off")
	showNotify("Hitbox " .. (hitbox and "enabled" or "disabled"))
	if not hitbox and currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild(lockset) then
		-- รีเซ็ตขนาดถ้าปิด hitbox
		local part = currentTarget.Character[lockset]
		if part then
			part.Size = Vector3.new(2, 2, 1) -- ขนาดเดิมประมาณนี้ (เปลี่ยนตาม model จริง)
		end
	end
end)

hitboxInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local num = tonumber(hitboxInput.Text)
		if num and num >= 0 then
			hitboxSize = num
			showNotify("Hitbox size set to " .. tostring(hitboxSize))
			updateHitbox()
		else
			showNotify("Please enter a valid number >= 0")
			hitboxInput.Text = tostring(hitboxSize)
		end
	end
end)

-- ตัวแปรสำหรับ Kill All
local killInterval = 0.15
local killTimer = 0

RunService.Heartbeat:Connect(function(dt)
	if aimbot then
		local target = getClosestTarget()
		if target and target.Character and target.Character:FindFirstChild(lockset) then
			currentTarget = target
			local targetPos = target.Character[lockset].Position
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPos)
			updateHitbox()
		else
			currentTarget = nil
		end
	end

	if killAll then
		killTimer = killTimer + dt
		if killTimer >= killInterval then
			killTimer = 0
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
					p.Character.Humanoid.Health = 0
				end
			end
		end
	end
end)
