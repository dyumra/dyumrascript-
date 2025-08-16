-- yoyo
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

if getgenv().LoaderV2 == nil then
    getgenv().LoaderV2 = true
end
if not getgenv().LoaderV2 then return end

-- โหลด Buyer list
local success, buyerList = pcall(function()
    local code = game:HttpGet("https://raw.githubusercontent.com/dyumra/Whitelist/refs/heads/main/DYHUB-PREMIUM.lua")
    if not code or code == "" then error("Failed to download Buyer list") end

    local func, err = loadstring(code)
    if not func then error("Failed to parse Buyer list: "..tostring(err)) end

    local listSuccess, listData = pcall(func)
    if not listSuccess or type(listData) ~= "table" then
        error("Buyer list returned invalid data")
    end
    return listData
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
    for name, data in pairs(buyerList) do
        if data.Key == key then
            return name, data
        end
    end
    return nil, nil
end

local buyerData = buyerList[playerName]
local keyOwnerName, keyOwnerData = findKeyOwner(playerKey)

-- เช็ก Key และ Buyer
if buyerData then
    if keyOwnerData and keyOwnerName ~= playerName then
        -- ใส่ Key ของคนอื่น
        StarterGui:SetCore("SendNotification", {
            Title = "Access Denied",
            Text = "The first Buyer must reset HWID before proceeding",
            Duration = 6,
        })
        task.wait(6)
        player:Kick("❌ The first Buyer must reset HWID before proceeding\n💳 Please reset the HWID at (dsc.gg/dyhub)")
        return
    elseif playerKey ~= buyerData.Key and playerKey ~= "DYHUB-NEED2ROBUX" then
        -- Key ของตัวเองไม่ถูก
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
    -- ชื่อผู้เล่นไม่มี แต่ใส่ Key ของคนอื่น
    StarterGui:SetCore("SendNotification", {
        Title = "Access Denied",
        Text = "The first Buyer must reset HWID before proceeding",
        Duration = 6,
    })
    task.wait(6)
    player:Kick("❌ The first Buyer must reset HWID before proceeding\n💳 Please reset the HWID at (dsc.gg/dyhub)")
    return
else
    -- ชื่อผู้เล่นไม่มี และ Key ไม่ถูกต้อง
    StarterGui:SetCore("SendNotification", {
        Title = "Invalid Key",
        Text = "Please purchase a Premium Key at (dsc.gg/dyhub)",
        Duration = 6,
    })
    task.wait(6)
    player:Kick("❌ Your key is invalid or missing.\n💳 Please purchase a Premium Key at (dsc.gg/dyhub)")
    return
end

-- ตรวจสอบเวลา Subscription
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

-- ตั้งค่า global
getgenv().UserTag = buyerData.Tag
getgenv().ExpireTime = timeValue or dayValue

-- โหลดสคริปต์หลัก
local mainSuccess, mainErr = pcall(function()
    local mainCode = game:HttpGet("https://raw.githubusercontent.com/dyumra/kuy/refs/heads/main/Error.lua")
    if not mainCode or mainCode == "" then error("Failed to download main script") end
    local mainFunc, loadErr = loadstring(mainCode)
    if not mainFunc then error("Failed to parse main script: "..tostring(loadErr)) end
    mainFunc()
end)
if not mainSuccess then
    StarterGui:SetCore("SendNotification", {
        Title = "Error",
        Text = "Failed to load main script",
        Duration = 7,
    })
    task.wait(7)
    player:Kick("❌ Failed to load main script.\n💳 Please contact support at (dsc.gg/dyhub)\nError: "..tostring(mainErr))
    return
end
