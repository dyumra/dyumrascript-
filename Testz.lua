-- keysystem

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

if getgenv().LoaderV2 == nil then
    getgenv().LoaderV2 = true
end
if not getgenv().LoaderV2 then return end

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

local playerName = player and player.Name or ""
local playerKey = getgenv().DYHUBKEY or ""

local function findKeyOwner(key)
    for _, data in pairs(buyerList) do
        if data.Key == key then
            return data
        end
    end
    return nil
end

local buyerData = buyerList[playerName]

-- ตรวจสอบ Key สำหรับผู้ที่อยู่ใน Buyer list
if buyerData then
    if playerKey ~= buyerData.Key and playerKey ~= "DYHUB-NEED2ROBUX" then
        StarterGui:SetCore("SendNotification", {
            Title = "Access Denied",
            Text = "The first Buyer must reset HWID before proceeding",
            Duration = 6,
        })
        task.wait(6)
        player:Kick("❌ The first Buyer must reset HWID before proceeding\n💳 Please reset the HWID at (dsc.gg/dyhub)")
        return
    end
else
    -- กรณีไม่มีชื่อใน Buyer list
    local keyOwner = findKeyOwner(playerKey)
    if keyOwner then
        StarterGui:SetCore("SendNotification", {
            Title = "Access Denied",
            Text = "The first Buyer must reset HWID before proceeding",
            Duration = 6,
        })
        task.wait(6)
        player:Kick("❌ The first Buyer must reset HWID before proceeding\n💳 Please reset the HWID at (dsc.gg/dyhub)")
    else
        StarterGui:SetCore("SendNotification", {
            Title = "Invalid Key",
            Text = "Please purchase a Premium Key at (dsc.gg/dyhub)",
            Duration = 6,
        })
        task.wait(6)
        player:Kick("❌ Your key is invalid or missing.\n💳 Please purchase a Premium Key at (dsc.gg/dyhub)")
    end
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

getgenv().UserTag = buyerData.Tag
getgenv().ExpireTime = timeValue or dayValue

loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/kuy/refs/heads/main/Error.lua"))()
