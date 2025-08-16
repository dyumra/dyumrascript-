-- version 1

-- Services
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Loader guard
if getgenv().LoaderV2 == nil then
    getgenv().LoaderV2 = true
end
if not getgenv().LoaderV2 then return end

-- Load Buyer list safely
local success, buyerList = pcall(function()
    local code = game:HttpGet("https://raw.githubusercontent.com/dyumra/Whitelist/refs/heads/main/DYHUB-PREMIUM.lua")
    local func = loadstring(code)
    return func and func() or error("Failed to parse Buyer list")
end)

if not success or type(buyerList) ~= "table" or not next(buyerList) then
    StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Please contact support at (dsc.gg/dyhub)",
        Duration = 7,
    })
    task.wait(7)
    player:Kick("❌ Failed to load Buyer list.\n⚠️ Please contact support at (dsc.gg/dyhub)")
    return
end

-- Player info
local playerName = player and player.Name or ""
local playerKey = getgenv().DYHUBKEY or ""

-- Function to find owner of a key
local function findKeyOwner(key)
    for name, data in pairs(buyerList) do
        if data.Key == key then
            return name, data
        end
    end
    return nil, nil
end

local buyerData = buyerList[playerName]
local keyOwnerName, keyOwnerData = findKeyOwner(playerKey)

-- Key & Buyer checks
if buyerData then
    -- Player is in Buyer list
    if playerKey ~= buyerData.Key and playerKey ~= "DYHUB-NEED2ROBUX" then
        -- ใส่ Key ของคนอื่น → ขึ้นข้อความ Invalid Key
        StarterGui:SetCore("SendNotification", {
            Title = "Invalid Key",
            Text = "Your key is invalid, please check your key",
            Duration = 6,
        })
        task.wait(6)
        player:Kick("❌ Your key is invalid.\n💳 Please check your key at (dsc.gg/dyhub)")
        return
    end
elseif keyOwnerData then
    -- ใส่ Key ของคนอื่น → ขึ้นข้อความ The first Buyer must reset HWID
    StarterGui:SetCore("SendNotification", {
        Title = "Access Denied",
        Text = "The first Buyer must reset HWID before proceeding",
        Duration = 6,
    })
    task.wait(6)
    player:Kick("❌ The first Buyer must reset HWID before proceeding\n💳 Please reset the HWID at (dsc.gg/dyhub)")
    return
else
    -- Key ไม่ถูกต้อง / ไม่มี Key
    StarterGui:SetCore("SendNotification", {
        Title = "Invalid Key",
        Text = "Please purchase a Premium Key at (dsc.gg/dyhub)",
        Duration = 6,
    })
    task.wait(6)
    player:Kick("❌ Your key is invalid or missing.\n💳 Please purchase a Premium Key at (dsc.gg/dyhub)")
    return
end

-- Subscription / Expire checks
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
        StarterGui:SetCore("SendNotification", {
            Title = "Subscription Expired",
            Text = "Your subscription has expired.",
            Duration = 7,
        })
        task.wait(7)
        player:Kick("❌ Your subscription has expired.\n💳 Please renew at (dsc.gg/dyhub)")
        return
    end
end

-- Save global info
getgenv().UserTag = buyerData.Tag
getgenv().ExpireTime = timeValue or dayValue

-- Load main script
loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Dupe-Anime-Rails/refs/heads/main/Hip.lua"))()
