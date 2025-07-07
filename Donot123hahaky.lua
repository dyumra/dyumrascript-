local validKey = "DYHUB-JYHAG-UYWBH-ERQ4T-OIAH7-PI9K8-LIFETIME"
local allowedUsernames = { "ymh_is666", "YMH012" }

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local StarterGui = game:GetService("StarterGui")

local function isAllowedUsername(name)
    for _, allowedName in pairs(allowedUsernames) do
        if name == allowedName then
            return true
        end
    end
    return false
end

if not player or not isAllowedUsername(player.Name) then
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
