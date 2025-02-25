local GUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/aaaa"))()

local UI = GUI:CreateWindow("the um","lop")

local Home = UI:addPage("Home",1,true,6)

Home:addLabel("This is a Label","Lol this funny")

Home:addButton("This is a button",function()
    game.StarterGui:SetCore("SendNotification",{
        Title = "Clicked";
        Text = "Lo";
    })
end)

Home:addToggle("This is a Toggle",function(value)
    print(value)
    if value == false then 
        game.StarterGui:SetCore("SendNotification",{
            Title = "Toggle";
            Text = "false";
        })
    else 
        game.StarterGui:SetCore("SendNotification",{
            Title = "Toggle";
            Text = "true";
        })
    end
end)

Home:addSlider("This is a Slider",16,100,function(value)
    print(value)
end)

Home:addTextBox("This is a TextBox","Um",function(value)
    game.StarterGui:SetCore("SendNotification",{
        Title = "Wrote";
        Text = value;
    })
end)

Home:addDropdown("This is a Dropdown",{"Um","Yep","Lop","GG"},1,function(value)
    game.StarterGui:SetCore("SendNotification",{
        Title = "Selected :";
        Text = value;
    }) 
end)

-- Just an example of how you would actually use it i guess

local LP = UI:addPage("Local",2,false,6)

-- Label

LP:addLabel("Local","Don't use in games with anti cheats")

--- Button

LP:addButton("DIE",function()
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
end)

-- Toggle

LP:addToggle("Sprint",function(value)
    if value == false then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 24
    end
end)

-- Slider

LP:addSlider("WalkSpeed",16,150,function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)

-- Textbox

LP:addTextBox("Jump Power / 50 is default","Number here",function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
end)

-- Dropdown 

local PLIST = {}

for i,v in pairs(game:GetService("Players"):GetPlayers()) do
    table.insert(PLIST,v.DisplayName)
end

LP:addDropdown("Teleport to Player",PLIST,4,function(value)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =  game.Players[value].Character.HumanoidRootPart.CFrame * CFrame.new(0,2,1)
end)

-- Create a button to open/close the menu at the top left of the screen
local OpenCloseButton = Instance.new("TextButton")
OpenCloseButton.Size = UDim2.new(0, 150, 0, 50)  -- Button size
OpenCloseButton.Position = UDim2.new(0, 10, 0, 10)  -- Position in the top left corner
OpenCloseButton.Text = "Open Menu"
OpenCloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenCloseButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OpenCloseButton.Parent = game.Players.LocalPlayer.PlayerGui:WaitForChild("ScreenGui")

local isOpen = false  -- Variable to check if the GUI is open or closed

OpenCloseButton.MouseButton1Click:Connect(function()
    if isOpen then
        UI:Close()  -- Close the GUI if it's open
        OpenCloseButton.Text = "Open Menu"  -- Change button text to "Open Menu"
    else
        UI:Open()  -- Open the GUI if it's closed
        OpenCloseButton.Text = "Close Menu"  -- Change button text to "Close Menu"
    end
    isOpen = not isOpen  -- Toggle the isOpen variable
end)
