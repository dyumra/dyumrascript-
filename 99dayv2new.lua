repeat task.wait() until game:IsLoaded()

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local VirtualInput = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

-- Mobile Detection
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Chest Cooldown Management
local chestCooldowns = {}
local CHEST_COOLDOWN_TIME = 3 -- seconds

-- ย้ายฟังก์ชันนี้ขึ้นก่อน
local function KeepEsp(Char, Parent)
    if Char then
        local highlight = Char:FindFirstChildOfClass("Highlight")
        if highlight then
            highlight:Destroy()
        end
    end
    if Parent then
        local billboard = Parent:FindFirstChildOfClass("BillboardGui")
        if billboard then
            billboard:Destroy()
        end
    end
end

-- แล้วต่อด้วย CreateEsp
local function CreateEsp(Char, Color, Text, Parent, numberOffset)
    if not Char or not Char:IsA("Model") then return end
    if not Char:FindFirstChild("HumanoidRootPart") then return end
    if not Parent or not Parent:IsA("BasePart") then return end

    KeepEsp(Char, Parent) -- ตอนนี้จะไม่ error แล้ว

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.Adornee = Char
    highlight.FillColor = Color
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.Parent = Char

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Size = UDim2.new(0, 50, 0, 25)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, numberOffset or 3, 0)
    billboard.Adornee = Parent
    billboard.Enabled = true
    billboard.Parent = Parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = Text
    label.TextColor3 = Color
    label.TextScaled = true
    label.Parent = billboard

    task.spawn(function()
        while highlight and billboard and Parent and Parent.Parent do
            local cameraPosition = Camera and Camera.CFrame.Position
            if cameraPosition and Parent:IsA("BasePart") then
                local distance = (cameraPosition - Parent.Position).Magnitude
                if ActiveDistanceEsp then
                    label.Text = Text .. " (" .. math.floor(distance + 0.5) .. " stud)"
                else
                    label.Text = Text
                end
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

-- Improved bring items function with better positioning and mobile support
local function bringItemsByName(name)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, item in ipairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find(name:lower()) then
            local part = item:FindFirstChildWhichIsA("BasePart") or (item:IsA("BasePart") and item)
            if part then
                -- Improved positioning to prevent items from returning
                local offset = Vector3.new(math.random(-8, 8), 2, math.random(-8, 8))
                part.CFrame = root.CFrame + offset
                part.Anchored = false
                part.CanCollide = false
                -- Add a temporary constraint to keep item near player
                task.spawn(function()
                    task.wait(0.1)
                    if part and part.Parent then
                        part.CanCollide = true
                    end
                end)
            end
        end
    end
end

-- Mobile Touch Controls Setup
local touchGui
local function setupMobileControls()
    if not isMobile then return end
    
    touchGui = Instance.new("ScreenGui")
    touchGui.Name = "MobileControls"
    touchGui.Parent = LocalPlayer.PlayerGui
    touchGui.ResetOnSpawn = false
    
    -- Speed/Jump Controls
    local controlFrame = Instance.new("Frame")
    controlFrame.Size = UDim2.new(0, 200, 0, 100)
    controlFrame.Position = UDim2.new(0, 10, 1, -110)
    controlFrame.BackgroundTransparency = 0.3
    controlFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    controlFrame.Parent = touchGui
    
    local speedBtn = Instance.new("TextButton")
    speedBtn.Size = UDim2.new(0, 90, 0, 40)
    speedBtn.Position = UDim2.new(0, 5, 0, 5)
    speedBtn.Text = "Speed+"
    speedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    speedBtn.Parent = controlFrame
    
    local jumpBtn = Instance.new("TextButton")
    jumpBtn.Size = UDim2.new(0, 90, 0, 40)
    jumpBtn.Position = UDim2.new(0, 105, 0, 5)
    jumpBtn.Text = "Jump+"
    jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    jumpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    jumpBtn.Parent = controlFrame
    
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(0, 90, 0, 40)
    resetBtn.Position = UDim2.new(0, 5, 0, 50)
    resetBtn.Text = "Reset"
    resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    resetBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
    resetBtn.Parent = controlFrame
    
    -- Tree Farm Button
    local treeFarmBtn = Instance.new("TextButton")
    treeFarmBtn.Size = UDim2.new(0, 90, 0, 40)
    treeFarmBtn.Position = UDim2.new(0, 105, 0, 50)
    treeFarmBtn.Text = "Tree Farm"
    treeFarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    treeFarmBtn.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
    treeFarmBtn.Parent = controlFrame
    
    -- Mobile button functionality
    speedBtn.MouseButton1Click:Connect(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = math.min(humanoid.WalkSpeed + 20, 200)
        end
    end)
    
    jumpBtn.MouseButton1Click:Connect(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = math.min(humanoid.JumpPower + 20, 200)
        end
    end)
    
    resetBtn.MouseButton1Click:Connect(function()
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 16
            humanoid.JumpPower = 50
        end
    end)
    
    local treeFarmActive = false
    treeFarmBtn.MouseButton1Click:Connect(function()
        treeFarmActive = not treeFarmActive
        treeFarmBtn.Text = treeFarmActive and "Stop Farm" or "Tree Farm"
        treeFarmBtn.BackgroundColor3 = treeFarmActive and Color3.fromRGB(100, 50, 50) or Color3.fromRGB(50, 100, 50)
        -- Trigger tree farm function
        if treeFarmActive then
            -- Auto tree farm logic here
        end
    end)
end

-- Initialize mobile controls if on mobile
if isMobile then
    setupMobileControls()
end

local Confirmed = false
WindUI:Popup({
    Title = "DYHUB Loaded! - 99 Night in the Forest",
    Icon = "star",
    IconThemed = true,
    Content = "DYHUB'S TEAM | Join our (dsc.gg/dyhub)" .. (isMobile and " - Mobile Edition" or ""),
    Buttons = {
        { Title = "Cancel", Variant = "Secondary", Callback = function() end },
        { Title = "Continue", Icon = "arrow-right", Callback = function() Confirmed = true end, Variant = "Primary" }
    }
})
repeat task.wait() until Confirmed

local Window = WindUI:CreateWindow({
    Folder = "DYHUB Config | 99NitF | V3",
    Title = "DYHUB - 99 Night in the Forest @ In-game (Beta)" .. (isMobile and " - Mobile" or ""),
    IconThemed = true,
    Icon = "star",
    Author = "DYHUB (dsc.gg/dyhub)",
    Size = isMobile and UDim2.fromOffset(400, 250) or UDim2.fromOffset(520, 300),
    Transparent = true,
    Theme = "Dark",
})

Window:EditOpenButton({
    Title = "DYHUB - Open",
    Icon = "monitor",
    CornerRadius = UDim.new(0, 6),
    StrokeThickness = 2,
    Color = ColorSequence.new(Color3.fromRGB(30, 30, 30), Color3.fromRGB(255, 255, 255)),
    Draggable = true,
})

local Tabs = {
    Main = Window:Tab({ Title = "Main", Icon = "rocket" }),
    Teleport = Window:Tab({ Title = "Teleport", Icon = "map-pin" }),
    Player = Window:Tab({ Title = "Player", Icon = "user" }),
    Esp = Window:Tab({ Title = "Esp", Icon = "eye" }),
    Bring = Window:Tab({ Title = "Bring Items", Icon = "package" }),
    Hitbox = Window:Tab({ Title = "Hitbox", Icon = "target" }),
    Misc = Window:Tab({ Title = "Misc", Icon = "file-cog" }),
}

local infHungerActive = false
local infHungerThread

Tabs.Main:Toggle({
    Title = "Inf Hunger (Fixed)",
    Default = false,
    Callback = function(state)
        infHungerActive = state
        if state then
            infHungerThread = task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local RequestConsumeItem = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestConsumeItem")
                while infHungerActive do
                    local args = {
                        Instance.new("Model", nil)
                    }
                    RequestConsumeItem:InvokeServer(unpack(args))
                    task.wait(1)
                end
            end)
        else
            if infHungerThread then
                task.cancel(infHungerThread)
                infHungerThread = nil
            end
        end
    end
})

-- Improved Auto Cook function with mobile support
Tabs.Main:Button({Title="Auto Cook (Meat) - Mobile Fixed", Callback=function()
    local campfirePos = Vector3.new(1.87, 4.33, -3.67)
    local meatCount = 0
    
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") or item:IsA("BasePart") then
            local name = item.Name:lower()
            if name:find("meat") and not name:find("cooked") then
                local part = item:FindFirstChildWhichIsA("BasePart") or item
                if part then
                    -- Better positioning for mobile
                    local offset = Vector3.new(math.random(-1, 1), 0.5, math.random(-1, 1))
                    part.CFrame = CFrame.new(campfirePos + offset)
                    part.CanCollide = false
                    meatCount = meatCount + 1
                    
                    -- Re-enable collision after a short delay
                    task.spawn(function()
                        task.wait(0.5)
                        if part and part.Parent then
                            part.CanCollide = true
                        end
                    end)
                end
            end
        end
    end
    
    print("Moved " .. meatCount .. " pieces of meat to campfire")
end})

local autoTreeFarmActive = false
local autoTreeFarmThread

Tabs.Main:Toggle({
    Title = "Auto Tree Farm (Mobile Compatible)",
    Default = false,
    Callback = function(state)
        autoTreeFarmActive = state
        if state then
            autoTreeFarmThread = task.spawn(function()
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local ToolDamageObject = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ToolDamageObject")
                local Players = game:GetService("Players")
                local LocalPlayer = Players.LocalPlayer
                local Backpack = LocalPlayer:WaitForChild("Backpack")

                local function getAllTrees()
                    local map = workspace:FindFirstChild("Map")
                    if not map then return {} end
                    local landmarks = map:FindFirstChild("Landmarks") or map:FindFirstChild("Foliage")
                    if not landmarks then return {} end
                    local trees = {}
                    for _, tree in ipairs(landmarks:GetChildren()) do
                        if tree.Name == "Small Tree" and tree:IsA("Model") and tree.Parent then
                            local trunk = tree:FindFirstChild("Trunk") or tree.PrimaryPart
                            if trunk then
                                table.insert(trees, {tree = tree, trunk = trunk})
                            end
                        end
                    end
                    return trees
                end

                local function getAxe()
                    local inv = LocalPlayer:FindFirstChild("Inventory")
                    if not inv then return nil end
                    return inv:FindFirstChild("Strong Axe") or inv:FindFirstChild("Good Axe") or inv:FindFirstChild("Old Axe") or inv:FindFirstChildWhichIsA("Tool")
                end

                while autoTreeFarmActive do
                    local trees = getAllTrees()
                    for _, t in ipairs(trees) do
                        if not autoTreeFarmActive then break end
                        if t.tree and t.tree.Parent then
                            local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                            local hrp = char:FindFirstChild("HumanoidRootPart", 3)
                            if hrp and t.trunk then
                                local treeCFrame = t.trunk.CFrame
                                local rightVector = treeCFrame.RightVector
                                local targetPosition = treeCFrame.Position + rightVector * 3
                                hrp.CFrame = CFrame.new(targetPosition)
                                task.wait(0.3) -- Slightly longer wait for mobile
                                
                                local axe = getAxe()
                                if axe then
                                    if axe.Parent == Backpack then
                                        axe.Parent = char
                                        task.wait(0.2) -- Longer wait for mobile
                                    end
                                    local attempts = 0
                                    while t.tree.Parent and autoTreeFarmActive and attempts < 10 do
                                        pcall(function() 
                                            if isMobile then
                                                -- Mobile-specific activation
                                                VirtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                                                task.wait(0.1)
                                                VirtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                                            else
                                                axe:Activate() 
                                            end
                                        end)
                                        local args = {
                                            t.tree,
                                            axe,
                                            "1_8264699301",
                                            t.trunk.CFrame
                                        }
                                        pcall(function() ToolDamageObject:InvokeServer(unpack(args)) end)
                                        attempts = attempts + 1
                                        task.wait(isMobile and 1.2 or 1) -- Longer wait for mobile
                                    end
                                end
                            end
                        end
                        task.wait(0.7) -- Longer wait between trees for mobile
                    end
                    task.wait(1.5) -- Longer wait between cycles for mobile
                end
            end)
        else
            if autoTreeFarmThread then
                task.cancel(autoTreeFarmThread)
                autoTreeFarmThread = nil
            end
        end
    end
})

local autoBreakActive = false
local autoBreakSpeed = 1
local autoBreakThread

Tabs.Main:Slider({
    Title = "Auto Hit Speed",
    Min = 0.1,
    Max = 2,
    Default = 1,
    Callback = function(val)
        autoBreakSpeed = val
    end
})

Tabs.Main:Toggle({
    Title = "Auto Hit (Auto Break) - Mobile Fixed",
    Default = false,
    Callback = function(state)
        autoBreakActive = state
        if state then
            autoBreakThread = task.spawn(function()
                local player = game.Players.LocalPlayer
                local camera = workspace.CurrentCamera
                while autoBreakActive do
                    local function getWeapon()
                        local inv = player:FindFirstChild("Inventory")
                        return inv and (inv:FindFirstChild("Spear")
                        or inv:FindFirstChild("Strong Axe")
                            or inv:FindFirstChild("Good Axe")
                            or inv:FindFirstChild("Old Axe"))
                    end
                    local weapon = getWeapon()
                    if weapon then
                        local ray = workspace:Raycast(camera.CFrame.Position, camera.CFrame.LookVector * 15)
                        if ray and ray.Instance and ray.Instance.Name == "Trunk" then
                            pcall(function()
                                game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(
                                    ray.Instance.Parent, weapon, "4_7591937906", CFrame.new(ray.Position)
                                )
                            end)
                        end
                    end
                    task.wait(autoBreakSpeed * (isMobile and 1.5 or 1)) -- Longer wait for mobile
                end
            end)
        else
            if autoBreakThread then
                task.cancel(autoBreakThread)
                autoBreakThread = nil
            end
        end
    end
})

-- ========= Esp Tab
local ActiveEspPlayer = false

local ActiveEspItems = false
local ActiveEspEnemy = false
local ActiveEspChildren = false
local ActiveEspPeltTrader = false
local ActiveDistanceEsp = false

Tabs.Esp:Toggle({
    Title = "Esp (Player)",
    Default = false,
    Callback = function(state)
        ActiveEspPlayer = state
        task.spawn(function()
            while ActiveEspPlayer do
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        local char = player.Character
                        if not char:FindFirstChildOfClass("Highlight") and not char.HumanoidRootPart:FindFirstChildOfClass("BillboardGui") then
                            CreateEsp(char, Color3.fromRGB(0, 255, 0), player.Name, char.HumanoidRootPart, 2)
                        end
                    end
                end
                task.wait(0.1)
            end
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local char = player.Character
                    KeepEsp(char, char.HumanoidRootPart)
                end
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Items)",
    Default = false,
    Callback = function(state)
        ActiveEspItems = state
        task.spawn(function()
            while ActiveEspItems do
                for _, Obj in pairs(game.Workspace.Items:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(255, 255, 0), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Items:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Enemies)",
    Default = false,
    Callback = function(state)
        ActiveEspEnemy = state
        task.spawn(function()
            while ActiveEspEnemy do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name ~= "Lost Child" and Obj.Name ~= "Lost Child2" and Obj.Name ~= "Lost Child3" and Obj.Name ~= "Lost Child4" and Obj.Name ~= "Pelt Trader") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(255, 0, 0), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

local espTypes = {
    ["Fuel All"] = {
        color = Color3.fromRGB(255, 140, 0),
        items = { "Log", "Fuel Canister", "Coal", "Oil Barrel" }
    },
    ["Scraps All"] = {
        color = Color3.fromRGB(169, 169, 169),
        items = { "Sheet Metal", "Broken Fan", "UFO Junk", "Bolt", "Old Radio", "UFO Scrap", "Broken Microwave" }
    },
    ["Ammo All"] = {
        color = Color3.fromRGB(0, 255, 0),
        items = { "Rifle Ammo", "Revolver Ammo" }
    },
    ["Guns All"] = {
        color = Color3.fromRGB(255, 0, 0),
        items = { "Rifle", "Revolver" }
    },
    ["Food All"] = {
        color = Color3.fromRGB(255, 255, 0),
        items = { "Meat? Sandwich", "Cake", "Carrot", "Morsel" }
    },
    ["body All"] = {
        color = Color3.fromRGB(255, 255, 255),
        items = { "Leather Body", "Iron Body" }
    },
    ["Bandage"] = {
        color = Color3.fromRGB(255, 192, 203),
        items = { "Bandage" }
    },
    ["Medkit"] = {
        color = Color3.fromRGB(255, 0, 255),
        items = { "MedKit" }
    },
    ["Coin"] = {
        color = Color3.fromRGB(255, 215, 0),
        items = { "Coin Stack" }
    },
    ["Radio"] = {
        color = Color3.fromRGB(135, 206, 235),
        items = { "Old Radio" }
    },
    ["tyre"] = {
        color = Color3.fromRGB(105, 105, 105),
        items = { "Tyre" }
    },
    ["broken fan"] = {
        color = Color3.fromRGB(112, 128, 144),
        items = { "Broken Fan" }
    },
    ["broken microwave"] = {
        color = Color3.fromRGB(47, 79, 79),
        items = { "Broken Microwave" }
    },
    ["bolt"] = {
        color = Color3.fromRGB(0, 191, 255),
        items = { "Bolt" }
    },
    ["Sheet Metal"] = {
        color = Color3.fromRGB(192, 192, 192),
        items = { "Sheet Metal" }
    },
    ["SeedBox"] = {
        color = Color3.fromRGB(124, 252, 0),
        items = { "Seed Box" }
    },
    ["Chair"] = {
        color = Color3.fromRGB(210, 180, 140),
        items = { "Chair" }
    },
}

for category, data in pairs(espTypes) do
    Tabs.Esp:Toggle({
        Title = "ESP (" .. category .. ")",
        Default = false,
        Callback = function(state)
            local active = state
            task.spawn(function()
                while active do
                    for _, obj in pairs(game.Workspace.Items:GetChildren()) do
                        if obj:IsA("Model") and obj.PrimaryPart and not obj:FindFirstChildOfClass("Highlight") and not obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                            for _, itemName in pairs(data.items) do
                                if string.lower(obj.Name) == string.lower(itemName) then
                                    CreateEsp(obj, data.color, obj.Name, obj.PrimaryPart, 2)
                                    break
                                end
                            end
                        end
                    end
                    task.wait(0.25)
                end
                for _, obj in pairs(game.Workspace.Items:GetChildren()) do
                    for _, itemName in pairs(data.items) do
                        if string.lower(obj.Name) == string.lower(itemName) then
                            KeepEsp(obj, obj.PrimaryPart)
                            break
                        end
                    end
                end
            end)
        end
    })
end

Tabs.Esp:Toggle({
    Title = "Esp (Children)",
    Default = false,
    Callback = function(state)
        ActiveEspChildren = state
        task.spawn(function()
            while ActiveEspChildren do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and (Obj.Name == "Lost Child" or Obj.Name == "Lost Child2" or Obj.Name == "Lost Child3" or Obj.Name == "Lost Child4") and not Obj:FindFirstChildOfClass("Highlight") and not Obj.PrimaryPart:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(0, 255, 0), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

Tabs.Esp:Toggle({
    Title = "Esp (Pelt Trader)",
    Default = false,
    Callback = function(state)
        ActiveEspPeltTrader = state
        task.spawn(function()
            while ActiveEspPeltTrader do
                for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                    if Obj:IsA("Model") and Obj.PrimaryPart and Obj.Name == "Pelt Trader" and not Obj:FindFirstChildOfClass("Highlight") and not Obj:FindFirstChildOfClass("BillboardGui") then
                        CreateEsp(Obj, Color3.fromRGB(0, 255, 255), Obj.Name, Obj.PrimaryPart, 2)
                    end
                end
                task.wait(0.1)
            end
            for _, Obj in pairs(game.Workspace.Characters:GetChildren()) do
                KeepEsp(Obj, Obj.PrimaryPart)
            end
        end)
    end
})

-----------------------------------------------------------------
-- TELEPORT TAB (Enhanced with more locations)
-----------------------------------------------------------------
Tabs.Teleport:Button({
    Title="Teleport to Camp",
    Callback=function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(
                13.287363052368164, 3.999999761581421, 0.36212217807769775,
                0.6022269129753113, -2.275036159460342e-08, 0.7983249425888062,
                6.430457055728311e-09, 1, 2.364672191390582e-08,
                -0.7983249425888062, -9.1070981866892e-09, 0.6022269129753113
            )
        end
    end
})

Tabs.Teleport:Button({
    Title="TP to NPC Trader",
    Callback=function()
        local pos = Vector3.new(-37.08, 3.98, -16.33)
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = CFrame.new(pos)
    end
})

-- Add crafting place teleport
Tabs.Teleport:Button({
    Title="TP to Crafting Station",
    Callback=function()
        -- Search for crafting table or workbench
        local craftingItems = {"Crafting Table", "Workbench", "Anvil"}
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        
        for _, itemName in pairs(craftingItems) do
            local craftingStation = workspace.Items:FindFirstChild(itemName)
            if craftingStation and craftingStation.PrimaryPart then
                hrp.CFrame = craftingStation.PrimaryPart.CFrame + Vector3.new(0, 0, 3)
                return
            end
        end
        
        -- Fallback to a common crafting area
        hrp.CFrame = CFrame.new(5, 4, -15) -- Approximate crafting area
    end
})

-- Add dungeon stronghold teleport
Tabs.Teleport:Button({
    Title="TP to Dungeon Stronghold",
    Callback=function()
        local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        
        -- Search for dungeon entrance or stronghold
        local dungeonNames = {"Dungeon", "Stronghold", "Underground", "Cave"}
        for _, name in pairs(dungeonNames) do
            local dungeon = workspace:FindFirstChild(name) or workspace.Map:FindFirstChild(name)
            if dungeon and dungeon:FindFirstChildWhichIsA("BasePart") then
                hrp.CFrame = dungeon:FindFirstChildWhichIsA("BasePart").CFrame + Vector3.new(0, 5, 0)
                return
            end
        end
        
        -- Fallback to underground area coordinates
        hrp.CFrame = CFrame.new(-50, -10, -50)
    end
})

Tabs.Teleport:Button({
    Title = "TP to Random Tree",
    Callback = function()
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local hrp = character:FindFirstChild("HumanoidRootPart", 3)
        if not hrp then return end

        local map = workspace:FindFirstChild("Map")
        if not map then return end

        local foliage = map:FindFirstChild("Foliage") or map:FindFirstChild("Landmarks")
        if not foliage then return end

        local trees = {}
        for _, obj in ipairs(foliage:GetChildren()) do
            if obj.Name == "Small Tree" and obj:IsA("Model") then
                local trunk = obj:FindFirstChild("Trunk") or obj.PrimaryPart
                if trunk then
                    table.insert(trees, trunk)
                end
            end
        end

        if #trees > 0 then
            local trunk = trees[math.random(1, #trees)]
            local treeCFrame = trunk.CFrame
            local rightVector = treeCFrame.RightVector
            local targetPosition = treeCFrame.Position + rightVector * 3
            hrp.CFrame = CFrame.new(targetPosition)
        end
    end
})

local lostChildNames = {
    "Lost Child",
    "Lost Child2",
    "Lost Child3",
    "Lost Child4"
}

for i, name in ipairs(lostChildNames) do
    Tabs.Teleport:Button({
        Title = "TP to Lost Child " .. i,
        Callback = function()
            local workspaceCharacters = game.Workspace.Characters
            local targetLostChild = workspaceCharacters:FindFirstChild(name)

            if targetLostChild and targetLostChild:IsA("Model") and targetLostChild.PrimaryPart then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = targetLostChild.PrimaryPart.CFrame
            else
                warn(name .. " not found in Characters or has no PrimaryPart")
            end
        end
    })
end

-- Enhanced chest teleportation with cooldown management
local chestNames = {
    "Item Chest",
    "Item Chest2", 
    "Item Chest3",
    "Item Chest4",
    "Item Chest5",
    "Item Chest6"
}

for i, name in ipairs(chestNames) do
    Tabs.Teleport:Button({
        Title = "TP to Chest " .. i .. " (Cooldown Fixed)",
        Callback = function()
            local currentTime = tick()
            if chestCooldowns[name] and currentTime - chestCooldowns[name] < CHEST_COOLDOWN_TIME then
                local remaining = CHEST_COOLDOWN_TIME - (currentTime - chestCooldowns[name])
                print("Chest " .. i .. " cooldown: " .. math.ceil(remaining) .. "s remaining")
                return
            end
            
            local workspaceItems = game.Workspace.Items
            local targetChest = workspaceItems:FindFirstChild(name)

            if targetChest and targetChest:IsA("Model") and targetChest.PrimaryPart then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = targetChest.PrimaryPart.CFrame + Vector3.new(0, 0, 3)
                chestCooldowns[name] = currentTime
                print("Teleported to " .. name)
            else
                warn(name .. " not found in Items or has no PrimaryPart")
            end
        end
    })
end

-- Teleport to all chests sequentially
Tabs.Teleport:Button({
    Title = "TP to All Chests (Sequential)",
    Callback = function()
        task.spawn(function()
            for i, name in ipairs(chestNames) do
                local workspaceItems = game.Workspace.Items
                local targetChest = workspaceItems:FindFirstChild(name)
                
                if targetChest and targetChest:IsA("Model") and targetChest.PrimaryPart then
                    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local hrp = character:WaitForChild("HumanoidRootPart")
                    hrp.CFrame = targetChest.PrimaryPart.CFrame + Vector3.new(0, 0, 3)
                    print("Teleported to " .. name)
                    task.wait(CHEST_COOLDOWN_TIME + 0.5) -- Wait for cooldown plus buffer
                end
            end
            print("Finished teleporting to all chests")
        end)
    end
})

local alienChests = {
    "Alien Chest"
}

for i, name in ipairs(alienChests) do
    Tabs.Teleport:Button({
        Title = "TP to Alien Chest " .. i,
        Callback = function()
            local workspaceItems = game.Workspace.Items
            local targetChest = workspaceItems:FindFirstChild(name)

            if targetChest and targetChest:IsA("Model") and targetChest.PrimaryPart then
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local hrp = character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = targetChest.PrimaryPart.CFrame + Vector3.new(0, 0, 3)
            else
                warn(name .. " not found in Items or has no PrimaryPart")
            end
        end
    end)
end

-----------------------------------------------------------------
-- BRING TAB (Enhanced with more items)
-----------------------------------------------------------------
Tabs.Bring:Button({Title="Bring Everything (Fixed Lag)",Callback=function()
    local count = 0
    for _, item in ipairs(workspace.Items:GetChildren()) do
        local part = item:FindFirstChildWhichIsA("BasePart") or item:IsA("BasePart") and item
        if part then
            part.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-7,7), 0, math.random(-7,7))
            part.CanCollide = false
            count = count + 1
            -- Re-enable collision after delay
            task.spawn(function()
                task.wait(0.5)
                if part and part.Parent then
                    part.CanCollide = true
                end
            end)
        end
    end
    print("Brought " .. count .. " items")
end})

Tabs.Bring:Button({Title="Bring Logs", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local count = 0
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("log") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                main.CanCollide = false
                count = count + 1
                task.spawn(function()
                    task.wait(0.3)
                    if main and main.Parent then
                        main.CanCollide = true
                    end
                end)
            end
        end
    end
    print("Brought " .. count .. " logs")
end})

Tabs.Bring:Button({Title="Bring Fuel Canister", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("fuel canister") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                main.CanCollide = false
                task.spawn(function()
                    task.wait(0.3)
                    if main and main.Parent then
                        main.CanCollide = true
                    end
                end)
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Oil Barrel", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("oil barrel") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                main.CanCollide = false
                task.spawn(function()
                    task.wait(0.3)
                    if main and main.Parent then
                        main.CanCollide = true
                    end
                end)
            end
        end
    end
end})

Tabs.Bring:Button({ Title = "Bring Scrap All", Callback = function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local scrapNames = {
        ["tyre"] = true, ["sheet metal"] = true, ["broken fan"] = true, ["bolt"] = true, ["old radio"] = true, ["ufo junk"] = true, ["ufo scrap"] = true, ["broken microwave"] = true,
    }
    local count = 0
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item:IsA("Model") then
            local itemName = item.Name:lower()
            for scrapName, _ in pairs(scrapNames) do
                if itemName:find(scrapName) then
                    local main = item:FindFirstChildWhichIsA("BasePart")
                    if main then
                        main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                        main.CanCollide = false
                        count = count + 1
                        task.spawn(function()
                            task.wait(0.3)
                            if main and main.Parent then
                                main.CanCollide = true
                            end
                        end)
                    end
                    break
                end
            end
        end
    end
    print("Brought " .. count .. " scrap items")
end })

Tabs.Bring:Button({Title="Bring Coal", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        if item.Name:lower():find("coal") and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                main.CanCollide = false
                task.spawn(function()
                    task.wait(0.3)
                    if main and main.Parent then
                        main.CanCollide = true
                    end
                end)
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Meat (Raw & Cooked)", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("meat") or name:find("cooked")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                main.CanCollide = false
                task.spawn(function()
                    task.wait(0.3)
                    if main and main.Parent then
                        main.CanCollide = true
                    end
                end)
            end
        end
    end
end})

Tabs.Bring:Button({Title="Bring Chest", Callback=function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    for _, item in pairs(workspace.Items:GetChildren()) do
        local name = item.Name:lower()
        if (name:find("Item Chest") or name:find("Alien Chest") or name:find("Item Chest2") or name:find("Item Chest3") or name:find("Item Chest4") or name:find("Item Chest5") or name:find("Item Chest6")) and item:IsA("Model") then
            local main = item:FindFirstChildWhichIsA("BasePart")
            if main then
                main.CFrame = root.CFrame * CFrame.new(math.random(-5,5), 0, math.random(-5,5))
                main.CanCollide = false
                task.spawn(function()
                    task.wait(0.3)
                    if main and main.Parent then
                        main.CanCollide = true
                    end
                end)
            end
        end
    end
end})

-- Enhanced item bring functions
Tabs.Bring:Button({Title="Bring Flashlight", Callback=function() bringItemsByName("Flashlight") end})
Tabs.Bring:Button({Title="Bring Nails", Callback=function() bringItemsByName("Nails") end})
Tabs.Bring:Button({Title="Bring Fan", Callback=function() bringItemsByName("Fan") end})
Tabs.Bring:Button({Title="Bring Rope", Callback=function() bringItemsByName("Rope") end})
Tabs.Bring:Button({Title="Bring Scrap", Callback=function() bringItemsByName("Scrap") end})
Tabs.Bring:Button({Title="Bring Wood", Callback=function() bringItemsByName("Wood") end})
Tabs.Bring:Button({Title="Bring Cloth", Callback=function() bringItemsByName("Cloth") end})
Tabs.Bring:Button({Title="Bring Rock", Callback=function() bringItemsByName("Rock") end})
Tabs.Bring:Button({Title="Bring Stone Pickaxe", Callback=function() bringItemsByName("Stone Pickaxe") end})
Tabs.Bring:Button({Title="Bring Knife", Callback=function() bringItemsByName("Knife") end})
Tabs.Bring:Button({Title="Bring Spear", Callback=function() bringItemsByName("Spear") end})
Tabs.Bring:Button({Title="Bring Leather Body", Callback=function() bringItemsByName("Leather Body") end})
Tabs.Bring:Button({Title="Bring Iron Body", Callback=function() bringItemsByName("Iron Body") end})
Tabs.Bring:Button({Title="Bring Revolver", Callback=function() bringItemsByName("Revolver") end})
Tabs.Bring:Button({Title="Bring Rifle", Callback=function() bringItemsByName("Rifle") end})
Tabs.Bring:Button({Title="Bring Bandage", Callback=function() bringItemsByName("Bandage") end})
Tabs.Bring:Button({Title="Bring MedKit", Callback=function() bringItemsByName("MedKit") end})
Tabs.Bring:Button({Title="Bring Old Radio", Callback=function() bringItemsByName("Old Radio") end})
Tabs.Bring:Button({Title="Bring Coin Stack", Callback=function() bringItemsByName("Coin Stack") end})
Tabs.Bring:Button({Title="Bring UFO Junk", Callback=function() bringItemsByName("UFO Junk") end})
Tabs.Bring:Button({Title="Bring UFO Scrap", Callback=function() bringItemsByName("UFO Scrap") end})
Tabs.Bring:Button({Title="Bring Broken Microwave", Callback=function() bringItemsByName("Broken Microwave") end})
Tabs.Bring:Button({Title="Bring Bolt", Callback=function() bringItemsByName("Bolt") end})
Tabs.Bring:Button({Title="Bring Chair", Callback=function() bringItemsByName("Chair") end})
Tabs.Bring:Button({Title="Bring Seed Box", Callback=function() bringItemsByName("Seed Box") end})
Tabs.Bring:Button({Title="Bring Meat? Sandwich", Callback=function() bringItemsByName("Meat? Sandwich") end})
Tabs.Bring:Button({Title="Bring Cake", Callback=function() bringItemsByName("Cake") end})
Tabs.Bring:Button({Title="Bring Carrot", Callback=function() bringItemsByName("Carrot") end})
Tabs.Bring:Button({Title="Bring Morsel", Callback=function() bringItemsByName("Morsel") end})
Tabs.Bring:Button({Title="Bring Tyre", Callback=function() bringItemsByName("Tyre") end})
Tabs.Bring:Button({Title="Bring Broken Fan", Callback=function() bringItemsByName("Broken Fan") end})
Tabs.Bring:Button({Title="Bring Sheet Metal", Callback=function() bringItemsByName("Sheet Metal") end})
Tabs.Bring:Button({Title="Bring Strong Axe", Callback=function() bringItemsByName("Strong Axe") end})
Tabs.Bring:Button({Title="Bring Good Axe", Callback=function() bringItemsByName("Good Axe") end})
Tabs.Bring:Button({Title="Bring Old Axe", Callback=function() bringItemsByName("Old Axe") end})
Tabs.Bring:Button({Title="Bring Rifle Ammo", Callback=function() bringItemsByName("Rifle Ammo") end})
Tabs.Bring:Button({Title="Bring Revolver Ammo", Callback=function() bringItemsByName("Revolver Ammo") end})

-- NEW REQUESTED ITEMS
Tabs.Bring:Button({Title="Bring Saplings", Callback=function() bringItemsByName("Sapling") end})
Tabs.Bring:Button({Title="Bring Stakes", Callback=function() bringItemsByName("Stake") end})
Tabs.Bring:Button({Title="Bring Corn", Callback=function() bringItemsByName("Corn") end})
Tabs.Bring:Button({Title="Bring Pumpkin", Callback=function() bringItemsByName("Pumpkin") end})
Tabs.Bring:Button({Title="Bring Wolf Pelts", Callback=function() bringItemsByName("Wolf Pelt") end})
Tabs.Bring:Button({Title="Bring Bear Pelts", Callback=function() bringItemsByName("Bear Pelt") end})

-- ALIEN WEAPONS
Tabs.Bring:Button({Title="Bring Raygun", Callback=function() bringItemsByName("Raygun") end})
Tabs.Bring:Button({Title="Bring Ray Cannon", Callback=function() bringItemsByName("Ray Cannon") end})
Tabs.Bring:Button({Title="Bring Alien Sword", Callback=function() bringItemsByName("Alien Sword") end})

-- Enhanced Hitbox System
local hitboxSettings = {All=false, Alien=false, Wolf=false, Bunny=false, Cultist=false, Bear=false, Show=false, Size=10, PreventFlying=true}

local function updateHitboxForModel(model)
    if not model or not model.Parent then return end
    local root = model:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local name = model.Name:lower()
    local shouldResize =
        (hitboxSettings.All and (name:find("alien") or name:find("alien elite") or name:find("bear") or name:find("polar bear") or name:find("wolf") or name:find("alpha") or name:find("bunny") or name:find("polar bear") or name:find("cultist") or name:find("cross") or name:find("crossbow cultist"))) or
        (hitboxSettings.Alien and (name:find("alien") or name:find("alien elite"))) or
        (hitboxSettings.Wolf and (name:find("wolf") or name:find("alpha"))) or
        (hitboxSettings.Bunny and name:find("bunny")) or
        (hitboxSettings.Bear and (name:find("bear") or name:find("polar bear"))) or
        (hitboxSettings.Cultist and (name:find("cultist") or name:find("cross") or name:find("crossbow cultist")))
        
    if shouldResize then
        local originalSize = root:GetAttribute("OriginalSize")
        if not originalSize then
            root:SetAttribute("OriginalSize", root.Size)
        end
        
        root.Size = Vector3.new(hitboxSettings.Size, hitboxSettings.Size, hitboxSettings.Size)
        root.Transparency = hitboxSettings.Show and 0.5 or 1
        root.Color = Color3.fromRGB(255, 255, 255)
        root.Material = Enum.Material.Neon
        root.CanCollide = false
        
        -- Prevent flying by anchoring temporarily when hit
        if hitboxSettings.PreventFlying then
            local humanoid = model:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
                -- Add anti-fly constraint
                local bodyPosition = root:FindFirstChild("AntiFlightBodyPosition")
                if not bodyPosition then
                    bodyPosition = Instance.new("BodyPosition")
                    bodyPosition.Name = "AntiFlightBodyPosition"
                    bodyPosition.MaxForce = Vector3.new(0, math.huge, 0)
                    bodyPosition.Position = root.Position
                    bodyPosition.D = 1000
                    bodyPosition.P = 10000
                    bodyPosition.Parent = root
                end
            end
        end
    else
        -- Reset to original if hitbox is disabled
        local originalSize = root:GetAttribute("OriginalSize")
        if originalSize then
            root.Size = originalSize
        end
        root.Transparency = 1
        
        -- Remove anti-flight constraints
        local bodyPosition = root:FindFirstChild("AntiFlightBodyPosition")
        if bodyPosition then
            bodyPosition:Destroy()
        end
        
        local humanoid = model:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end

-- Improved hitbox monitoring
task.spawn(function()
    while true do
        pcall(function()
            for _, model in ipairs(workspace.Characters:GetChildren()) do
                if model:IsA("Model") and model:FindFirstChild("HumanoidRootPart") then
                    updateHitboxForModel(model)
                end
            end
        end)
        task.wait(1) -- Reduced frequency to improve performance
    end
end)

Tabs.Hitbox:Toggle({Title="Expand All Hitbox", Default=false, Callback=function(val) hitboxSettings.All=val end})
Tabs.Hitbox:Toggle({Title="Expand Alien Hitbox", Default=false, Callback=function(val) hitboxSettings.Alien=val end})
Tabs.Hitbox:Toggle({Title="Expand Bear Hitbox", Default=false, Callback=function(val) hitboxSettings.Bear=val end})
Tabs.Hitbox:Toggle({Title="Expand Wolf Hitbox", Default=false, Callback=function(val) hitboxSettings.Wolf=val end})
Tabs.Hitbox:Toggle({Title="Expand Bunny Hitbox", Default=false, Callback=function(val) hitboxSettings.Bunny=val end})
Tabs.Hitbox:Toggle({Title="Expand Cultist Hitbox", Default=false, Callback=function(val) hitboxSettings.Cultist=val end})
Tabs.Hitbox:Slider({Title="Hitbox Size", Value={Min=2, Max=300, Default=10}, Step=1, Callback=function(val) hitboxSettings.Size=val end})
Tabs.Hitbox:Toggle({Title="Show Hitbox (Transparency)", Default=false, Callback=function(val) hitboxSettings.Show=val end})
Tabs.Hitbox:Toggle({Title="Prevent Enemy Flying (Anti-Fling)", Default=true, Callback=function(val) hitboxSettings.PreventFlying=val end})

-- Enhanced Player Tab with mobile compatibility
Tabs.Player:Slider({
    Title = "Set WalkSpeed" .. (isMobile and " (Mobile)" or ""),
    Min = 10,
    Max = 500,
    Default = 16,
    Callback = function(val)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = val
            if isMobile then
                print("Speed set to: " .. val)
            end
        end
    end
})

Tabs.Player:Slider({
    Title = "Set JumpPower" .. (isMobile and " (Mobile)" or ""),
    Min = 10,
    Max = 500,
    Default = 50,
    Callback = function(val)
        local player = game.Players.LocalPlayer
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = val
            if isMobile then
                print("Jump power set to: " .. val)
            end
        end
    end
})

-- Mobile-specific speed/jump presets
if isMobile then
    Tabs.Player:Button({
        Title = "Speed Preset: Fast (100)",
        Callback = function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 100
                print("Speed set to 100")
            end
        end
    })
    
    Tabs.Player:Button({
        Title = "Jump Preset: High (150)",
        Callback = function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = 150
                print("Jump power set to 150")
            end
        end
    })
    
    Tabs.Player:Button({
        Title = "Reset Speed & Jump",
        Callback = function()
            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
                humanoid.JumpPower = 50
                print("Speed and jump reset to default")
            end
        end
    })
end

Tabs.Player:Button({
    Title = "Proximity Prompt (No Delay)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal-Game/refs/heads/main/nodelay.lua"))()
    end
})

Tabs.Player:Button({
    Title = "Fly (Beta)" .. (isMobile and " - Mobile Compatible" or ""),
    Callback = function()
        if isMobile then
            -- Load mobile-compatible fly script
            loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))()
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/dyumrascript-/refs/heads/main/Flua"))()
        end
    end
})

local noclipConnection

Tabs.Player:Toggle({
    Title = "No Clip",
    Default = false,
    Callback = function(state)
        if state then
            noclipConnection = RunService.Stepped:Connect(function()
                local Character = LocalPlayer.Character
                if Character then
                    for _, part in pairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end
            local Character = LocalPlayer.Character
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
})

-- Enhanced No Cooldown for mobile
Tabs.Player:Toggle({
    Title = "No Cooldown (All Tools)" .. (isMobile and " - Mobile" or ""),
    Default = false,
    Callback = function(state)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        
        if state then
            -- Enhanced no cooldown system
            task.spawn(function()
                while state do
                    local character = LocalPlayer.Character
                    if character then
                        -- Remove tool cooldowns
                        for _, tool in pairs(character:GetChildren()) do
                            if tool:IsA("Tool") then
                                local cooldown = tool:FindFirstChild("Cooldown")
                                if cooldown then
                                    cooldown:Destroy()
                                end
                            end
                        end
                        
                        -- Remove humanoid constraints that might cause delays
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            for _, state in pairs(Enum.HumanoidStateType:GetEnumItems()) do
                                if state.Name:find("Physics") or state.Name:find("Ragdoll") then
                                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                                    break
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- Enhanced God Mode
Tabs.Player:Toggle({
    Title = "God Mode (Enhanced)" .. (isMobile and " - Mobile" or ""),
    Default = false,
    Callback = function(state)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        
        if state then
            task.spawn(function()
                while state do
                    local character = LocalPlayer.Character
                    if character then
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            humanoid.Health = humanoid.MaxHealth
                            humanoid.BreakJointsOnDeath = false
                            
                            -- Additional protections
                            for _, part in pairs(character:GetChildren()) do
                                if part:IsA("BasePart") then
                                    part.CanTouch = false
                                end
                            end
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.BreakJointsOnDeath = true
                end
                
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.CanTouch = true
                    end
                end
            end
        end
    end
})

local infinityJumpConnection

Tabs.Player:Toggle({
    Title = "Infinity Jump" .. (isMobile and " - Mobile" or ""),
    Default = false,
    Callback = function(state)
        if infinityJumpConnection then
            infinityJumpConnection:Disconnect()
            infinityJumpConnection = nil
        end
        
        if state then
            infinityJumpConnection = UserInputService.JumpRequest:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
            
            -- Mobile touch support for infinity jump
            if isMobile then
                infinityJumpConnection = UserInputService.TouchTap:Connect(function(touchPositions, gameProcessed)
                    if not gameProcessed then
                        local character = LocalPlayer.Character
                        if character then
                            local humanoid = character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                            end
                        end
                    end
                end)
            end
        end
    end
})

Tabs.Misc:Button({
    Title = "FPS Boost" .. (isMobile and " (Mobile Optimized)" or ""),
    Callback = function()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 0
            lighting.FogEnd = 100
            lighting.GlobalShadows = false
            lighting.EnvironmentDiffuseScale = 0
            lighting.EnvironmentSpecularScale = 0
            lighting.ClockTime = 14
            lighting.OutdoorAmbient = Color3.new(0, 0, 0)
            
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end
            
            for _, obj in ipairs(lighting:GetDescendants()) do
                if obj:IsA("PostEffect") or obj:IsA("BloomEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("SunRaysEffect") or obj:IsA("BlurEffect") then
                    obj.Enabled = false
                end
            end
            
            -- Enhanced mobile optimization
            if isMobile then
                for _, obj in ipairs(game:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                        obj.Enabled = false
                    elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SurfaceGui") then
                        obj.Transparency = 1
                    elseif obj:IsA("Sound") then
                        obj.Volume = 0
                    end
                end
            else
                for _, obj in ipairs(game:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
                        obj.Enabled = false
                    elseif obj:IsA("Texture") or obj:IsA("Decal") then
                        obj.Transparency = 1
                    end
                end
            end
            
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CastShadow = false
                    if isMobile then
                        part.Material = Enum.Material.Plastic
                    end
                end
            end
        end)
        print("✅ FPS Boost Applied" .. (isMobile and " (Mobile Optimized)" or ""))
    end
})

-- Enhanced FPS/Ping display with mobile positioning
local showFPS, showPing = true, true
local fpsText, msText = Drawing.new("Text"), Drawing.new("Text")

local function updateDisplayPosition()
    local xPos = isMobile and Camera.ViewportSize.X - 80 or Camera.ViewportSize.X - 100
    fpsText.Position = Vector2.new(xPos, 10)
    msText.Position = Vector2.new(xPos, 30)
end

fpsText.Size, fpsText.Color, fpsText.Center, fpsText.Outline, fpsText.Visible =
    isMobile and 14 or 16, Color3.fromRGB(0,255,0), false, true, showFPS
msText.Size, msText.Color, msText.Center, msText.Outline, msText.Visible =
    isMobile and 14 or 16, Color3.fromRGB(0,255,0), false, true, showPing

updateDisplayPosition()

local fpsCounter, fpsLastUpdate = 0, tick()

RunService.RenderStepped:Connect(function()
    fpsCounter += 1
    if tick() - fpsLastUpdate >= 1 then
        updateDisplayPosition() -- Update position in case screen rotated
        
        if showFPS then
            fpsText.Text = "FPS: " .. tostring(fpsCounter)
            fpsText.Visible = true
        else
            fpsText.Visible = false
        end
        if showPing then
            local pingStat = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            local ping = pingStat and math.floor(pingStat:GetValue()) or 0
            msText.Text = "Ping: " .. ping .. " ms"
            if ping <= 60 then
                msText.Color = Color3.fromRGB(0, 255, 0)
            elseif ping <= 120 then
                msText.Color = Color3.fromRGB(255, 165, 0)
            else
                msText.Color = Color3.fromRGB(255, 0, 0)
                msText.Text = "Ew Wifi Ping: " .. ping .. " ms"
            end
            msText.Visible = true
        else
            msText.Visible = false
        end
        fpsCounter = 0
        fpsLastUpdate = tick()
    end
end)

Tabs.Misc:Toggle({Title="Show FPS", Default=true, Callback=function(val) showFPS=val; fpsText.Visible=val end})
Tabs.Misc:Toggle({Title="Show Ping (ms)", Default=true, Callback=function(val) showPing=val; msText.Visible=val end})

-- Mobile status indicator
if isMobile then
    Tabs.Misc:Button({
        Title = "📱 Mobile Mode Active",
        Callback = function()
            print("Mobile optimizations are active!")
            print("Touch controls available in bottom-left corner")
        end
    })
end
