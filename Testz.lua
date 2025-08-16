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

-- ฟังก์ชันหาเจ้าของ Key
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

if buyerData then
    -- กรณีมีชื่อใน Buyer list
    if playerKey == buyerData.Key then
        -- Key ถูก ต้องโหลดสคริปต์ต่อ
        loadstring(game:HttpGet("https://raw.githubusercontent.com/dyumra/kuy/refs/heads/main/Error.lua"))()
    else
        -- Key ผิด
        StarterGui:SetCore("SendNotification", {
            Title = "Invalid Key",
            Text = "Your key does not match your account",
            Duration = 6,
        })
        task.wait(6)
        player:Kick("❌ Your key is invalid.\n💳 Please check your key at (dsc.gg/dyhub)")
        return
    end
else
    -- ไม่มีชื่อใน Buyer list
    if keyOwnerData then
        -- Key ของคนอื่น
        StarterGui:SetCore("SendNotification", {
            Title = "Access Denied",
            Text = "The first Buyer must reset HWID before proceeding",
            Duration = 6,
        })
        task.wait(6)
        player:Kick("❌ The first Buyer must reset HWID before proceeding\n💳 Please reset the HWID at (dsc.gg/dyhub)")
        return
    else
        -- Key ผิด
        StarterGui:SetCore("SendNotification", {
            Title = "Invalid Key",
            Text = "Please purchase a Premium Key at (dsc.gg/dyhub)",
            Duration = 6,
        })
        task.wait(6)
        player:Kick("❌ Your key is invalid or missing.\n💳 Please purchase a Premium Key at (dsc.gg/dyhub)")
        return
    end
end
