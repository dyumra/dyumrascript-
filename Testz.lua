local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

-- Prevent double load
if getgenv().LoaderV2 == nil then
    getgenv().LoaderV2 = true
end
if not getgenv().LoaderV2 then return end

-- Helper: Notify & Kick
local function notifyAndKick(title, text, duration)
    StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration or 5,
    })
    task.wait(duration or 5)
    player:Kick(text)
end

-- Load Buyer list
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

-- Check if key exists in Buyer list
local function findKeyOwner(key)
    for _, data in pairs(buyerList) do
        if data.Key == key then
            return data
        end
    end
    return nil
end

-- Get player data from Buyer list
local buyerData = buyerList[playerName]

-- Case 1: Player not in Buyer list
if not buyerData then
    local keyOwner = findKeyOwner(playerKey)
    if keyOwner then
        notifyAndKick("Access Denied", "The first Buyer must reset HWID before proceeding", 6)
    else
        notifyAndKick("Invalid Key", INVALID_KEY_MSG, 6)
    end
    return
end

-- Case 2: Key invalid
local keyOwner = findKeyOwner(playerKey)
if not keyOwner and playerKey ~= "DYHUB-NEED2ROBUX" then
    notifyAndKick("Invalid Key", INVALID_KEY_MSG, 6)
    return
end

-- Case 3: Expire check based on Days
-- Time = Lifetime flag (999999999 = Lifetime), Day = จำนวนวันที่ซื้อ
if buyerData.Time ~= "999999999" then
    local purchaseTime = tonumber(buyerData.Time) or 0
    local durationDays = tonumber(buyerData.Day) or 0
    local expireTimestamp = purchaseTime + durationDays * 24 * 60 * 60 -- แปลงวันเป็นวินาที

    if os.time() > expireTimestamp then
        notifyAndKick("Subscription Expired", "Your subscription has expired. Please renew at (dsc.gg/dyhub)", 7)
        return
    end
end

-- Case 4: All checks passed
getgenv().UserTag = buyerData.Tag
getgenv().ExpireTime = buyerData.Time
getgenv().KickReason = nil -- for future use

-- Load main script
loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/Premium/refs/heads/main/Premium.savekey"))()
