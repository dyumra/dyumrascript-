local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

if getgenv().LoaderV2 == nil then
    getgenv().LoaderV2 = true
end
if not getgenv().LoaderV2 then return end

local function notifyAndKick(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5,
    })
    task.wait(duration or 5)
    player:Kick(text)
end

local success, buyerList = pcall(function()
    local code = game:HttpGet("https://raw.githubusercontent.com/dyumra/Whitelist/refs/heads/main/DYHUB-PREMIUM.lua")
    local func = loadstring(code)
    return func and func() or error("Failed to parse Buyer list")
end)

if not success or type(buyerList) ~= "table" or not next(buyerList) then
    notifyAndKick("Error", "Failed to load Buyer list.\nPlease contact support at (dsc.gg/dyhub)", 7)
    return
end

local playerName = player and player.Name or ""
local playerKey = getgenv().DYHUBKEY or ""
local INVALID_KEY_MSG = "Your key is invalid or missing. Please purchase a Premium Key at (dsc.gg/dyhub)"

local function findKeyOwner(key)
    for _, data in pairs(buyerList) do
        if data.Key == key then
            return data
        end
    end
    return nil
end

local buyerData = buyerList[playerName]

if not buyerData then
    local keyOwner = findKeyOwner(playerKey)
    if keyOwner then
        notifyAndKick("Access Denied", "The first Buyer must reset HWID before proceeding", 6)
    else
        notifyAndKick("Invalid Key", INVALID_KEY_MSG, 6)
    end
    return
end

local keyOwner = findKeyOwner(playerKey)
if not keyOwner and playerKey ~= "DYHUB-NEED2ROBUX" then
    notifyAndKick("Invalid Key", INVALID_KEY_MSG, 6)
    return
end

local timeValue = buyerData.Time
if timeValue == "Lifetime" or tonumber(timeValue) == -1 then
    timeValue = "999999999"
else
    timeValue = nil
end

local dayValue = tonumber(buyerData.Day) or 0
if dayValue > 0 and timeValue ~= "999999999" then
    local firstLogin = getgenv().BuyerFirstLoginTime or os.time()
    local expireTimestamp = firstLogin + dayValue * 24 * 60 * 60
    if os.time() > expireTimestamp then
        notifyAndKick("Subscription Expired", "Your subscription has expired. Please renew at (dsc.gg/dyhub)", 7)
        return
    end
end

getgenv().UserTag = buyerData.Tag
getgenv().ExpireTime = timeValue or dayValue

loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Premium/refs/heads/main/Premium.savekey"))()
