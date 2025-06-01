local WALK_SPEED = 185 -- Adjust the walk speed as desired
 
local character = script.Parent
if not character or not character:IsA("Model") or not character:FindFirstChild("Humanoid") then
    return
end
 
-- Variables
local userInputService = game:GetService("UserInputService")
local moveDirection = Vector3.new()
 
-- Function to handle the user input
local function handleInput(input, isKeyDown)
    if input.KeyCode == Enum.KeyCode.W then
        moveDirection = Vector3.new(0, 0, -1)
    elseif input.KeyCode == Enum.KeyCode.A then
        moveDirection = Vector3.new(-1, 0, 0)
    elseif input.KeyCode == Enum.KeyCode.S then
        moveDirection = Vector3.new(0, 0, 1)
    elseif input.KeyCode == Enum.KeyCode.D then
        moveDirection = Vector3.new(1, 0, 0)
    end
 
    character.Humanoid.WalkSpeed = isKeyDown and WALK_SPEED or 0
 
    character.Humanoid:MoveTo(character.HumanoidRootPart.Position + moveDirection)
end
 
userInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or
        input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
        handleInput(input, true)
    end
end)
 
userInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.A or
        input.KeyCode == Enum.KeyCode.S or input.KeyCode == Enum.KeyCode.D then
        handleInput(input, false)
    end
end)
