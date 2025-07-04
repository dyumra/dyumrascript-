local validKey = "DYHUB-8JY5A-Q3RTW-IK7OL-FRJL2-IPL7W-LIFETIME"
local allowedUsername = "Yavib_Aga"
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local StarterGui = game:GetService("StarterGui")

if not player or player.Name ~= allowedUsername then
    StarterGui:SetCore("SendNotification", {
        Title = "Access Denied",
        Text = "The first user must reset HWID before proceeding.",
        Duration = 5,
    })
elseif getgenv().Key ~= validKey then
    StarterGui:SetCore("SendNotification", {
        Title = "Invalid Key",
        Text = "Your key is invalid or missing. The script will not run.",
        Duration = 5,
    })
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/DYHUB-Universal/refs/heads/main/Key1%2B1.lua"))()
end
