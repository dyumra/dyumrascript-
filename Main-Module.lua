-- [[ ⚙️ Roblox Execution Module ]]
-- [[ 🔮 Powered by Dyumra's Innovations ]]
-- [[ 📊 Version: 2.14.5 - Authenticated Interface Edition ]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage") 

local aimbot = false
local esp = false
local espTeamCheck = false 
local killAll = false 
local hitbox = false
local hitboxSize = 0 
local hitboxTransparency = 0.7 
local teamCheckHitbox = false 
local currentAimbotTarget = nil
local teleportTarget = nil 
local teleportInterval = 0.15 
local teleportTimer = 0 
local lockParts = {"Head", "Torso", "UpperTorso", "HumanoidRootPart"}
local originalWalkSpeeds = {}
local appliedHitboxes = {} 

local currentLockPartIndex = 2
local lockset = lockParts[currentLockPartIndex]

local TELEPORT_OFFSET_DISTANCE = 0
local TELEPORT_VERTICAL_OFFSET = 0 

local AIMBOT_SWITCH_DISTANCE = 10 

local correctKey = "dev"
local maxAttempts = 3
local currentAttempts = 0

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

local function showNotify(message)
	game.StarterGui:SetCore("SendNotification", {
		Title = "System Notification";
		Text = message;
		Duration = 3;
	})
end

local function kickPlayer(reason)
    if game:IsLoaded() and player then
        local kickEvent = ReplicatedStorage:FindFirstChild("KickPlayer") 
        if kickEvent and kickEvent:IsA("RemoteEvent") then
            kickEvent:FireServer(reason)
        else
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 0
                player.Character.Humanoid.JumpPower = 0
                player.Character.Humanoid.PlatformStand = true
            end
            game.StarterGui:SetCore("SendNotification", {
                Title = "Access Denied";
                Text = reason;
                Duration = 99999;
                Button1 = "OK";
            })
            wait(5)
            game:GetService("TeleportService"):Teleport(game.PlaceId)
        end
    end
end

wait(0.1) 

local keyInputGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
keyInputGui.Name = "KeyInputGui"
keyInputGui.ResetOnSpawn = false

local keyFrame = Instance.new("Frame")
keyFrame.Parent = keyInputGui
keyFrame.Size = UDim2.new(0, 320, 0, 180)
keyFrame.Position = UDim2.new(0.5, -(keyFrame.Size.X.Offset / 2), 0.5, -(keyFrame.Size.Y.Offset / 2))
keyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
keyFrame.BackgroundTransparency = 0
keyFrame.BorderSizePixel = 0
keyFrame.ClipsDescendants = true
keyFrame.AnchorPoint = Vector2.new(0,0)

local keyCorner = Instance.new("UICorner")
keyCorner.Parent = keyFrame
keyCorner.CornerRadius = UDim.new(0, 15)

local keyCorner = Instance.new("UICorner", keyFrame)
keyCorner.CornerRadius = UDim.new(0, 15)

local keyStroke = Instance.new("UIStroke", keyFrame)
keyStroke.Color = Color3.fromRGB(50, 50, 50)
keyStroke.Thickness = 2

local keyGradient = Instance.new("UIGradient", keyFrame)
keyGradient.Color = ColorSequence.new(Color3.fromRGB(40, 40, 40), Color3.fromRGB(20, 20, 20))
keyGradient.Transparency = NumberSequence.new(0.1, 0.1)
keyGradient.Rotation = 90

local keyTitle = Instance.new("TextLabel")
keyTitle.Parent = keyFrame
keyTitle.Size = UDim2.new(1, 0, 0, 50)
keyTitle.Position = UDim2.new(0, 0, 0, 0)
keyTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 22
keyTitle.Text = "ACCESS AUTHENTICATION"
keyTitle.AnchorPoint = Vector2.new(0,0)

local keyTitleCorner = Instance.new("UICorner")
keyTitleCorner.Parent = keyTitle
keyTitleCorner.CornerRadius = UDim.new(0, 15)

local keyInputBox = Instance.new("TextBox")
keyInputBox.Parent = keyFrame
keyInputBox.Size = UDim2.new(0, 280, 0, 45)
keyInputBox.Position = UDim2.new(0.5, 0, 0, -25)
keyInputBox.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
keyInputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
keyInputBox.Font = Enum.Font.GothamBold
keyInputBox.TextSize = 18
keyInputBox.PlaceholderText = "Enter Access Key..."
keyInputBox.ClearTextOnFocus = false
keyInputBox.AnchorPoint = Vector2.new(0.5, 0.5) 

local keyInputCorner = Instance.new("UICorner", keyInputBox)
keyInputCorner.CornerRadius = UDim.new(0, 10)

local keyInputStroke = Instance.new("UIStroke", keyInputBox)
keyInputStroke.Color = Color3.fromRGB(70, 70, 70)
keyInputStroke.Thickness = 1

local keySubmitBtn = Instance.new("TextButton")
keySubmitBtn.Parent = keyFrame
keySubmitBtn.Size = UDim2.new(0, 140, 0, 40)
keySubmitBtn.Position = UDim2.new(0.5, 0, 0.5, 45)
keySubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
keySubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keySubmitBtn.Font = Enum.Font.GothamBold
keySubmitBtn.TextSize = 18
keySubmitBtn.Text = "SUBMIT KEY"
keySubmitBtn.AnchorPoint = Vector2.new(0.5, 0.5)

local keySubmitCorner = Instance.new("UICorner", keySubmitBtn)
keySubmitCorner.CornerRadius = UDim.new(0, 12)

local keySubmitStroke = Instance.new("UIStroke", keySubmitBtn)
keySubmitStroke.Color = Color3.fromRGB(0, 100, 200)
keySubmitStroke.Thickness = 2

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "AimbotESPGui"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 260, 0, 395) 
mainFrame.Position = UDim2.new(0, 20, 0, 50) 
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.AnchorPoint = Vector2.new(0,0)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false 

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(40, 40, 40)
mainStroke.Thickness = 2

local mainGradient = Instance.new("UIGradient", mainFrame)
mainGradient.Color = ColorSequence.new(Color3.fromRGB(35, 35, 35), Color3.fromRGB(15, 15, 15))
mainGradient.Transparency = NumberSequence.new(0.1, 0.1)
mainGradient.Rotation = 90

local toggleBtn = Instance.new("TextButton", screenGui)
toggleBtn.Size = UDim2.new(0, 60, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
toggleBtn.Text = "MENU"
toggleBtn.AnchorPoint = Vector2.new(0,0)
toggleBtn.Visible = false 

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 8)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Color3.fromRGB(50, 50, 50)
toggleStroke.Thickness = 1

toggleBtn.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

local function createButton(name, pos, parent)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 230, 0, 35)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 18
	btn.Text = name .. ": Off"
	btn.AnchorPoint = Vector2.new(0, 0)
	btn.Parent = parent

	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 10)

    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(65, 65, 65)
    stroke.Thickness = 1

	return btn
end

local function createTextBox(name, pos, parent, placeholder, initialValue)
	local box = Instance.new("TextBox")
	box.Name = name
	box.Size = UDim2.new(0, 230, 0, 30)
	box.Position = pos
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.TextColor3 = Color3.fromRGB(200,200,200)
	box.Font = Enum.Font.GothamBold
	box.TextSize = 18
	box.PlaceholderText = placeholder or ""
	box.Text = tostring(initialValue or "")
	box.ClearTextOnFocus = false
	box.AnchorPoint = Vector2.new(0, 0)
	box.Parent = parent

	local corner = Instance.new("UICorner", box)
	corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", box)
    stroke.Color = Color3.fromRGB(65, 65, 65)
    stroke.Thickness = 1
	return box
end

local aimbotBtn = createButton("Aimbot", UDim2.new(0, 15, 0, 15), mainFrame)
local espBtn = createButton("ESP", UDim2.new(0, 15, 0, 60), mainFrame)
local espTeamBtn = createButton("ESP Team", UDim2.new(0, 15, 0, 105), mainFrame) 
local lockBtn = createButton("Target Lock", UDim2.new(0, 15, 0, 150), mainFrame)
local teleportLoopBtn = createButton("Teleport Loop", UDim2.new(0, 15, 0, 195), mainFrame) 
local hitboxBtn = createButton("Hitbox Enhancement", UDim2.new(0, 15, 0, 240), mainFrame)
local hitboxInput = createTextBox("HitboxSizeInput", UDim2.new(0, 15, 0, 285), mainFrame, "Hitbox Size (0-300)", hitboxSize) 
local hitboxTransparencyInput = createTextBox("HitboxTransparencyInput", UDim2.new(0, 15, 0, 325), mainFrame, "Transparency (0.0-1.0)", hitboxTransparency) 
local teamCheckHitboxBtn = createButton("Hitbox Team Filter", UDim2.new(0, 15, 0, 365), mainFrame) 

local highlights = {}

local function updateHighlights()
	for plr, highlight in pairs(highlights) do
		if not Players:FindFirstChild(plr.Name) or not plr.Character or not plr.Character.Parent then
			highlight:Destroy()
			highlights[plr] = nil
		end
	end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr == player then
			if highlights[plr] then
				highlights[plr].Enabled = false
			end
			continue 
		end

		if espTeamCheck and player.Team and plr.Team and plr.Team == player.Team then
			if highlights[plr] then
				highlights[plr].Enabled = false
			end
			continue
		end

		if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			if not highlights[plr] then
				local highlight = Instance.new("Highlight")
				highlight.Parent = player.PlayerGui
				highlight.Adornee = plr.Character
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				highlight.Enabled = esp 

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

local function isTargetVisible(targetPlayer, targetPart)
    if not targetPlayer or not targetPlayer.Character or not targetPart then return false end

    local origin = Camera.CFrame.Position
    local targetPos = targetPart.Position
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = workspace:Raycast(origin, (targetPos - origin).Unit * (origin - targetPos).Magnitude, raycastParams)

    if raycastResult then
        return raycastResult.Instance:IsDescendantOf(targetPlayer.Character)
    end
    return false
end

local function getClosestVisibleTarget()
	local closestDist = math.huge
	local closestPlayer = nil
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild(lockset) and plr.Character:FindFirstChild("Humanoid") then
			local humanoid = plr.Character.Humanoid
			if humanoid.Health > 0 then
                local targetPart = plr.Character[lockset]
                if isTargetVisible(plr, targetPart) then
                    local origin = Camera.CFrame.Position
                    local targetPos = targetPart.Position
                    local dist = (origin - targetPos).Magnitude

                    if dist < closestDist then
                        closestDist = dist
                        closestPlayer = plr
                    end
                end
			end
		end
	end
	return closestPlayer
end

local function getRandomLivingTarget()
    local validTargets = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            table.insert(validTargets, plr)
        end
    end
    if #validTargets > 0 then
        return validTargets[math.random(1, #validTargets)]
    end
    return nil
end

local function applyHitboxToPlayer(p)
    if hitbox and p ~= player and p.Character then
        if teamCheckHitbox and player.Team and p.Team and p.Team == player.Team then
            resetHitboxesForPlayer(p) 
            return 
        end

        local part = p.Character:FindFirstChild("HumanoidRootPart") 
        if part then
            part.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize) 
            part.Transparency = hitboxTransparency
            part.Material = Enum.Material.Neon 
            part.BrickColor = BrickColor.new("Really black") 
            part.CanCollide = false 
            
            if not appliedHitboxes[p] or appliedHitboxes[p] == false then
                originalWalkSpeeds[p] = p.Character.Humanoid.WalkSpeed
                p.Character.Humanoid.WalkSpeed = 0
                appliedHitboxes[p] = true
            end
        end
    end
end

local function updateHitboxes()
    for _, p in pairs(Players:GetPlayers()) do
        applyHitboxToPlayer(p)
    end
end

local function resetHitboxesForPlayer(p)
    if p ~= player and p.Character then
        local part = p.Character:FindFirstChild("HumanoidRootPart")
        if part then
            part.Size = Vector3.new(2,2,1) 
            part.Transparency = 1 
            part.Material = Enum.Material.Plastic 
            part.BrickColor = BrickColor.new("Medium stone grey") 
            part.CanCollide = false 
        end
    end
    if originalWalkSpeeds[p] then
        if p.Character and p.Character:FindFirstChild("Humanoid") then
             p.Character.Humanoid.WalkSpeed = originalWalkSpeeds[p]
        end
        originalWalkSpeeds[p] = nil
        appliedHitboxes[p] = nil
    end
end

local function resetAllHitboxes()
    for _, p in pairs(Players:GetPlayers()) do
        resetHitboxesForPlayer(p)
    end
end

local function performTeleport(plr)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = player.Character.HumanoidRootPart

    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local targetHRP = plr.Character.HumanoidRootPart
    local targetPos = targetHRP.Position

    hrp.CFrame = CFrame.new(targetPos) 
end

local function handleTeleportLoop(dt)
	if not killAll then return end 

    if not teleportTarget or not teleportTarget.Character or not teleportTarget.Character:FindFirstChild("Humanoid") or teleportTarget.Character.Humanoid.Health <= 0 then
        teleportTarget = getRandomLivingTarget() 
        if not teleportTarget then
            killAll = false
            teleportLoopBtn.Text = "Teleport Loop: Off"
            showNotify("Teleport Loop: No active targets available.")
            return
        end
    end

	teleportTimer = teleportTimer + dt
	if teleportTimer >= teleportInterval then
		teleportTimer = 0
		if teleportTarget and teleportTarget.Character and teleportTarget.Character:FindFirstChild("Humanoid") then
			local humanoid = teleportTarget.Character.Humanoid
			if humanoid.Health > 0 then
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				    performTeleport(teleportTarget) 
                end
				showNotify("Teleporting to: " .. teleportTarget.Name)
			end
		end
	end
end

local function updateLockBtn()
	lockBtn.Text = "Target Lock: " .. (lockset or "None")
end

aimbotBtn.MouseButton1Click:Connect(function()
	aimbot = not aimbot
	aimbotBtn.Text = "Aimbot: " .. (aimbot and "On" or "Off")
	if aimbot then
		showNotify("Aimbot functionality enabled.")
		currentAimbotTarget = getClosestVisibleTarget() 
		if not currentAimbotTarget then
			showNotify("Aimbot: No immediate targets detected.")
		end
	else
		showNotify("Aimbot functionality disabled.")
		currentAimbotTarget = nil
	end
end)

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = "ESP: " .. (esp and "On" or "Off")
	updateHighlights()
	showNotify(esp and "ESP Display Enabled." or "ESP Display Disabled.")
end)

espTeamBtn.MouseButton1Click:Connect(function() 
    espTeamCheck = not espTeamCheck
    espTeamBtn.Text = "ESP Team: " .. (espTeamCheck and "On" or "Off")
    if espTeamCheck then
        showNotify("ESP Team Filter: Only non-team players highlighted.")
    else
        showNotify("ESP Team Filter: All players highlighted (excluding self).")
    end
    updateHighlights() 
end)

lockBtn.MouseButton1Click:Connect(function()
	currentLockPartIndex = currentLockPartIndex + 1
	if currentLockPartIndex > #lockParts then
		currentLockPartIndex = 1
	end
	lockset = lockParts[currentLockPartIndex]
	updateLockBtn()
	showNotify("Target Lockpoint set to: " .. lockset)
end)

teleportLoopBtn.MouseButton1Click:Connect(function() 
	killAll = not killAll 
	teleportLoopBtn.Text = "Teleport Loop: " .. (killAll and "On" or "Off") 

	if killAll then
		teleportTarget = getRandomLivingTarget() 
		if not teleportTarget then
			showNotify("Teleport Loop: No valid targets found.")
			killAll = false
			teleportLoopBtn.Text = "Teleport Loop: Off"
		else
			showNotify("Teleport Loop initiated. Teleporting to: " .. teleportTarget.Name)
		end
	else
		showNotify("Teleport Loop deactivated.")
		teleportTarget = nil
	end
end)

hitboxBtn.MouseButton1Click:Connect(function()
	hitbox = not hitbox
	hitboxBtn.Text = "Hitbox Enhancement: " .. (hitbox and "On" or "Off")

	if hitbox then
		showNotify("Hitbox enhancement enabled for external players. (Size: " .. hitboxSize .. ", Transparency: " .. hitboxTransparency .. ").")
		updateHitboxes() 
		showNotify("Note: Client-side modifications may be reverted by game anti-cheat systems.")
	else
		showNotify("Hitbox enhancement disabled. Restoring default hitboxes.")
		resetAllHitboxes() 
	end
end)

hitboxInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local val = tonumber(hitboxInput.Text)
		if val and val >= 0 and val <= 300 then 
			hitboxSize = val
			if hitbox then
				updateHitboxes()
			end
			showNotify("Hitbox Size updated to: " .. hitboxSize)
		else
			showNotify("Invalid Hitbox size. Please enter a value between 0-300.")
			hitboxInput.Text = tostring(hitboxSize)
		end
	end
end)

hitboxTransparencyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(hitboxTransparencyInput.Text)
        if val and val >= 0.0 and val <= 1.0 then 
            hitboxTransparency = val
            if hitbox then
                updateHitboxes()
            end
            showNotify("Hitbox Transparency updated to: " .. hitboxTransparency)
        else
            showNotify("Invalid Transparency value. Please enter a value between 0.0-1.0.")
            hitboxTransparencyInput.Text = tostring(hitboxTransparency)
        end
    end
end)

teamCheckHitboxBtn.MouseButton1Click:Connect(function()
    teamCheckHitbox = not teamCheckHitbox
    teamCheckHitboxBtn.Text = "Hitbox Team Filter: " .. (teamCheckHitbox and "On" or "Off")
    if teamCheckHitbox then
        showNotify("Hitbox Team Filter enabled: Affects non-team players only.")
    else
        showNotify("Hitbox Team Filter disabled: Affects all players.")
    end
    if hitbox then
        resetAllHitboxes() 
        updateHitboxes()
    end
end)

local function setupGUIAndDefaults()
    updateLockBtn()
    espTeamBtn.Text = "ESP Team: " .. (espTeamCheck and "On" or "Off") 
    teamCheckHitboxBtn.Text = "Hitbox Team Filter: " .. (teamCheckHitbox and "On" or "Off")
    teleportLoopBtn.Text = "Teleport Loop: " .. (killAll and "On" or "Off") 
end

Players.PlayerAdded:Connect(function(newPlayer)
    newPlayer.CharacterAdded:Connect(function(char)
        if hitbox then
            applyHitboxToPlayer(newPlayer)
        end
    end)
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        if hitbox and plr ~= player then 
            applyHitboxToPlayer(plr)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(leavingPlayer)
    if originalWalkSpeeds[leavingPlayer] then
        originalWalkSpeeds[leavingPlayer] = nil
    end
    if appliedHitboxes[leavingPlayer] then
        appliedHitboxes[leavingPlayer] = nil
    end
	if currentAimbotTarget == leavingPlayer then
		currentAimbotTarget = nil
	end
	if teleportTarget == leavingPlayer then 
		teleportTarget = nil 
	end
    updateHighlights() 
end)

local function checkKey()
    local enteredKey = keyInputBox.Text:lower()
    if enteredKey == correctKey then
        keyInputGui:Destroy() 
        mainFrame.Visible = true 
        toggleBtn.Visible = true 
        setupGUIAndDefaults() 
        showNotify("Access granted. Main interface now available.")
	else
        currentAttempts = currentAttempts + 1
        local remainingAttempts = maxAttempts - currentAttempts
        if remainingAttempts > 0 then
            showNotify("Invalid access key. " .. remainingAttempts .. " attempt(s) remaining.")
        else
            showNotify("Multiple invalid attempts. Access denied.")
            kickPlayer("Access to this script has been suspended. (Error Code: Key_Denied_003)")
        end
    end
end

keyInputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        checkKey()
    end
end)

keySubmitBtn.MouseButton1Click:Connect(checkKey)

RunService.RenderStepped:Connect(function(dt)
	if aimbot and lockset and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		if currentAimbotTarget and currentAimbotTarget.Character and currentAimbotTarget.Character:FindFirstChild(lockset) then
			local targetHumanoid = currentAimbotTarget.Character:FindFirstChild("Humanoid")
			local targetPart = currentAimbotTarget.Character[lockset]

			if not targetHumanoid or targetHumanoid.Health <= 0 or not isTargetVisible(currentAimbotTarget, targetPart) then
				currentAimbotTarget = nil
			end
		end

		if not currentAimbotTarget then
			currentAimbotTarget = getClosestVisibleTarget()
		end
		
		if currentAimbotTarget and currentAimbotTarget.Character and currentAimbotTarget.Character:FindFirstChild(lockset) then
			local targetPart = currentAimbotTarget.Character[lockset]
			local cameraPos = Camera.CFrame.Position
			local targetPos = targetPart.Position
			local direction = (targetPos - cameraPos).Unit
			local newCFrame = CFrame.new(cameraPos, cameraPos + direction)
			Camera.CFrame = newCFrame
		end
	else
		currentAimbotTarget = nil
		end

	if killAll then 
		handleTeleportLoop(dt) 
	end

	if esp then
		updateHighlights()
	end
end)

keyInputBox:CaptureFocus() 
showNotify("Please authenticate your access key to proceed.")

while true do
	wait(1)
	if mainFrame.Visible and esp then updateHighlights() end
end
