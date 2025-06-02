-- [ 🌼 Roblox Edition - Powered by @ dyumra. ]
-- [ 💌 Version : 2.1.0 - Final Script ]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ตั้งค่าเริ่มต้นตัวแปร
local aimbot = false
local esp = false
local killAll = false
local hitbox = false
local hitboxSize = 0
local currentTarget = nil
local killTarget = nil
local killInterval = 0.15
local killTimer = 0
local lockParts = {"Head", "Torso", "UpperTorso", "HumanoidRootPart"}
local lockIndex = 2 -- default to Torso (index 2)
local lockset = nil -- จะตั้งค่าตอนโหลดตัวละคร

-- ฟังก์ชันตรวจสอบพาร์ท lockset ที่มีจริงในตัวละคร
local function detectLockSet(character)
	if character:FindFirstChild("Torso") then
		return "Torso"
	elseif character:FindFirstChild("UpperTorso") then
		return "UpperTorso"
	elseif character:FindFirstChild("HumanoidRootPart") then
		return "HumanoidRootPart"
	elseif character:FindFirstChild("Head") then
		return "Head"
	else
		return nil
	end
end

-- ฟังก์ชันสร้าง Notify แบบ Roblox ของแท้ (มุมขวาล่าง)
local function showNotify(message)
	game.StarterGui:SetCore("SendNotification", {
		Title = "System";
		Text = message;
		Duration = 3;
	})
end

-- สร้าง ScreenGui และ Frame หลักสำหรับ GUI
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "AimbotESPGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 260, 0, 320)
mainFrame.Position = UDim2.new(0, 20, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.AnchorPoint = Vector2.new(0,0)
mainFrame.Active = true
mainFrame.Draggable = true -- ทำให้ลากได้

-- มนมุมและขอบเบาๆ
local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

-- ปุ่ม Toggle GUI (เปิด/ปิด) มุมซ้ายบน
local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 50, 0, 25)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Text = "GUI"
toggleBtn.AnchorPoint = Vector2.new(0,0)

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 8)

toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

-- ฟังก์ชันสร้างปุ่ม TextButton ใน GUI
local function createButton(name, pos, parent)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 230, 0, 35)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Text = name .. ": Off"
	btn.AnchorPoint = Vector2.new(0, 0)
	btn.Parent = parent

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)
	return btn
end

-- ฟังก์ชันสร้าง Label TextBox สำหรับ input ตัวเลข
local function createTextBox(name, pos, parent)
	local box = Instance.new("TextBox")
	box.Name = name
	box.Size = UDim2.new(0, 230, 0, 30)
	box.Position = pos
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.new(1,1,1)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 18
	box.PlaceholderText = "0-50"
	box.Text = tostring(hitboxSize)
	box.ClearTextOnFocus = false
	box.AnchorPoint = Vector2.new(0, 0)
	box.Parent = parent

	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0, 8)
	return box
end

-- ปุ่มและ input ต่างๆ
local aimbotBtn = createButton("Aimbot", UDim2.new(0, 15, 0, 15), mainFrame)
local espBtn = createButton("ESP", UDim2.new(0, 15, 0, 60), mainFrame)
local lockBtn = createButton("Lock Set: Loading...", UDim2.new(0, 15, 0, 105), mainFrame)
local killBtn = createButton("Kill All", UDim2.new(0, 15, 0, 150), mainFrame)
local hitboxBtn = createButton("Hitbox", UDim2.new(0, 15, 0, 195), mainFrame)
local hitboxInput = createTextBox("HitboxInput", UDim2.new(0, 15, 0, 240), mainFrame)

-- ESP Highlight containers
local highlights = {}

-- ฟังก์ชันอัปเดต Highlight ของผู้เล่นทั้งหมดตามทีมและสถานะ
local function updateHighlights()
	-- ลบ Highlight ที่มีแต่ไม่ต้องลบของคนที่ยังเล่นอยู่
	for plr, highlight in pairs(highlights) do
		if not Players:FindFirstChild(plr.Name) or not plr.Character or not plr.Character.Parent then
			highlight:Destroy()
			highlights[plr] = nil
		end
	end

	-- เพิ่ม Highlight ให้ผู้เล่นที่ยังไม่มี
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			if not highlights[plr] then
				local highlight = Instance.new("Highlight")
				highlight.Parent = player.PlayerGui
				highlight.Adornee = plr.Character
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.Enabled = esp

				-- สีตามทีม ถ้าไม่มีทีมสีขาว
				local teamColor = plr.TeamColor.Color
				if plr.Team == nil or plr.TeamColor == nil or plr.TeamColor == BrickColor.new("Institutional white") then
					highlight.FillColor = Color3.new(1,1,1)
					highlight.OutlineColor = Color3.new(1,1,1)
				else
					highlight.FillColor = teamColor
					highlight.OutlineColor = teamColor
				end
				highlights[plr] = highlight
			else
				highlights[plr].Enabled = esp
			end
		end
	end
end

-- ฟังก์ชันเลือกเป้าหมายใกล้ที่สุดที่ไม่ถูกบัง (line of sight)
local function getClosestTarget()
	local closestDist = math.huge
	local closestPlayer = nil
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild(lockset) and plr.Character:FindFirstChild("Humanoid") then
			local humanoid = plr.Character.Humanoid
			if humanoid.Health > 0 then
				-- เช็คว่ามองเห็น target หรือไม่ (ไม่บังด้วยกำแพง)
				local origin = Camera.CFrame.Position
				local targetPos = plr.Character[lockset].Position
				local raycastParams = RaycastParams.new()
				raycastParams.FilterDescendantsInstances = {player.Character}
				raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
				local raycastResult = workspace:Raycast(origin, (targetPos - origin), raycastParams)
				if raycastResult then
					if raycastResult.Instance:IsDescendantOf(plr.Character) then
						local dist = (origin - targetPos).Magnitude
						if dist < closestDist then
							closestDist = dist
							closestPlayer = plr
						end
					end
				end
			end
		end
	end
	return closestPlayer
end

-- ฟังก์ชันอัปเดต hitbox ขนาดใหญ่ตาม input
local function updateHitboxes()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild(lockset) then
			local part = p.Character[lockset]
			if part then
				if hitbox then
					part.Size = Vector3.new(1 + hitboxSize, 1 + hitboxSize, 1 + hitboxSize)
					part.Transparency = 0.5
					part.Material = Enum.Material.Neon
					part.Color = Color3.fromRGB(255, 0, 0)
				else
					part.Size = Vector3.new(1,1,1)
					part.Transparency = 0
					part.Material = Enum.Material.Plastic
					part.Color = Color3.new(1,1,1)
				end
			end
		end
	end
end

-- ฟังก์ชัน reset hitbox ขนาดปกติ
local function resetHitboxes()
	for _, p in pairs(Players:GetPlayers()) do
		if p.Character and p.Character:FindFirstChild(lockset) then
			local part = p.Character[lockset]
			if part then
				part.Size = Vector3.new(1,1,1)
				part.Transparency = 0
				part.Material = Enum.Material.Plastic
				part.Color = Color3.new(1,1,1)
			end
		end
	end
end

-- ฟังก์ชัน teleport player ไปข้างหน้าของเป้าหมาย
local function teleportToTarget(plr)
	if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local targetPos = plr.Character.HumanoidRootPart.Position
	local lookVector = plr.Character.HumanoidRootPart.CFrame.LookVector

	-- teleport player ไปหน้าของเป้าหมาย (2 studs หน้าตัวเป้าหมาย)
	hrp.CFrame = CFrame.new(targetPos + lookVector * 2)
end

-- ฟังก์ชัน KillAll (ฆ่าทีละคน)
local function killAllTargets(dt)
	if not killAll then return end
	killTimer = killTimer + dt
	if killTimer >= killInterval then
		killTimer = 0
		killTarget = getClosestTarget()
		if killTarget and killTarget.Character and killTarget.Character:FindFirstChild("Humanoid") then
			local humanoid = killTarget.Character.Humanoid
			if humanoid.Health > 0 then
				-- teleport player ไปหน้าตัวเป้าหมาย
				teleportToTarget(killTarget)

				-- ยิงหรือฆ่า (ขึ้นกับวิธีคุณใช้ เช่น ปิด-เปิด weapon script)
				-- ตัวอย่างการฆ่าโดยตรง:
				humanoid.Health = 0

				showNotify("Killed " .. killTarget.Name)
			end
		end
	end
end

-- อัปเดต GUI Lockset ปุ่ม
local function updateLockBtn()
	lockBtn.Text = "Lock Set: " .. (lockset or "None")
end

-- Event กดปุ่ม
aimbotBtn.MouseButton1Click:Connect(function()
	aimbot = not aimbot
	aimbotBtn.Text = "Aimbot: " .. (aimbot and "On" or "Off")
	if aimbot then showNotify("Aimbot Enabled") else showNotify("Aimbot Disabled") end
end)

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "ESP: " .. (esp and "On" or "Off")
	updateHighlights()
	showNotify(esp and "ESP Enabled" or "ESP Disabled")
end)

killBtn.MouseButton1Click:Connect(function()
	killAll = not killAll
	killBtn.Text = "Kill All: " .. (killAll and "On" or "Off")
	showNotify(killAll and "KillAll Enabled" or "KillAll Disabled")
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
			showNotify("Hitbox Size set to " .. hitboxSize)
		else
			showNotify("Invalid Hitbox size! Must be 0-50")
			hitboxInput.Text = tostring(hitboxSize)
		end
	end
end)

-- อัปเดต lockset ตอนโหลดตัวละครเสร็จ
local function setupLockset()
	local char = player.Character or player.CharacterAdded:Wait()
	lockset = detectLockSet(char)
	updateLockBtn()
end

-- Event ตัวละคร respawn
player.CharacterAdded:Connect(function(char)
	lockset = detectLockSet(char)
	updateLockBtn()
	resetHitboxes()
	if hitbox then updateHitboxes() end
end)

-- เริ่มต้น
setupLockset()

-- อัปเดตทุกเฟรม
RunService.RenderStepped:Connect(function(dt)
	-- Aimbot
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

	-- KillAll
	if killAll then
		killAllTargets(dt)
	end

	-- ESP update
	if esp then
		updateHighlights()
	end
end)

-- อัปเดต Highlight ทุก 1 วินาที
while true do
	wait(1)
	if esp then updateHighlights() end
end
