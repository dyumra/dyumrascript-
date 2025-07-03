local validKey = "DYHUB-7K3V9-MN2X4-PQ8Z1-R5T7B-W0F6L"
local allowedUsername = "Yolmar_43"
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
