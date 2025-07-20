local validKey = "DYHUB-C43VH-E51F3-L78VG-P6R31-K7T8-FREE7DAYS"
local allowedUsernames = {"bunso9523", "name2", "name3"}
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local function isAllowed(name)
    for _, allowedName in ipairs(allowedUsernames) do
        if name == allowedName then
            return true
        end
    end
    return false
end

if not player or not isAllowed(player.Name) then
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
    loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Loader/refs/heads/main/LoaderV2"))()
end
