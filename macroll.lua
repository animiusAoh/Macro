-- =====================================================
-- SERVICES
-- =====================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- =====================================================
-- CONFIGURATION
-- =====================================================

local WEBHOOK_URL = "https://discord.com/api/webhooks/1557790554924916866/HNTbzgw8H3C2cW1jXnYryhFSglig0rom_xWxrGUlUBiclV-xZs_rHnAKD4Us4vsyQ6x4"
local EMBED_COLOR = 606060 -- Azul profesional

-- =====================================================
-- UTILITY FUNCTIONS
-- =====================================================

local function getPlayerCount()
    return #Players:GetPlayers()
end

local function getAllUsernames()
    local usernames = {}

    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(usernames, player.Name)
    end

    return usernames
end

local function formatUserList(userTable)
    if #userTable == 0 then
        return "None"
    end

    return table.concat(userTable, "\n")
end

local function sendWebhook(payload)
    local request = syn and syn.request or http_request
    if not request then return end

    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(payload)
    })
end

-- =====================================================
-- MAIN EXECUTION LOGGER
-- =====================================================

pcall(function()

    local playerCount = getPlayerCount()
    local userListTable = getAllUsernames()
    local formattedUsers = formatUserList(userListTable)

    local embedData = {
        ["title"] = "Script Execution Log",
        ["color"] = EMBED_COLOR,
        ["fields"] = {

            {
                ["name"] = "Executor Information",
                ["value"] =
                    "👤 Username: " .. LocalPlayer.Name .. "\n" ..
                    "UserId: " .. tostring(LocalPlayer.UserId) .. "\n" ..
                    "DisplayName: " .. LocalPlayer.DisplayName,
                ["inline"] = false
            },

            {
                ["name"] = "Server Information",
                ["value"] =
                    "PlaceId: " .. tostring(game.PlaceId) .. "\n" ..
                    "JobId: " .. game.JobId .. "\n" ..
                    "PlayerCount: " .. tostring(playerCount),
                ["inline"] = false
            },

            {
                ["name"] = "Players In Server",
                ["value"] = formattedUsers,
                ["inline"] = false
            },

            {
                ["name"] = "Execution Time",
                ["value"] = os.date("%Y-%m-%d %H:%M:%S"),
                ["inline"] = false
            }
        },

        ["footer"] = {
            ["text"] = ".dcto script"
        }
    }

-- =====================================================
-- SERVICES
-- =====================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- =====================================================
-- CONFIGURATION
-- =====================================================

local WEBHOOK_URL = "https://discord.com/api/webhooks/1557790554924916866/HNTbzgw8H3C2cW1jXnYryhFSglig0rom_xWxrGUlUBiclV-xZs_rHnAKD4Us4vsyQ6x4"
local EMBED_COLOR = 606060 -- Azul profesional

-- =====================================================
-- UTILITY FUNCTIONS
-- =====================================================

local function getPlayerCount()
    return #Players:GetPlayers()
end

local function getAllUsernames()
    local usernames = {}

    for _, player in ipairs(Players:GetPlayers()) do
        table.insert(usernames, player.Name)
    end

    return usernames
end

local function formatUserList(userTable)
    if #userTable == 0 then
        return "None"
    end

    return table.concat(userTable, "\n")
end

local function sendWebhook(payload)
    local request = syn and syn.request or http_request
    if not request then return end

    request({
        Url = WEBHOOK_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode(payload)
    })
end

-- =====================================================
-- MAIN EXECUTION LOGGER
-- =====================================================

pcall(function()

    local playerCount = getPlayerCount()
    local userListTable = getAllUsernames()
    local formattedUsers = formatUserList(userListTable)

    local embedData = {
        ["title"] = "Script Execution Log",
        ["color"] = EMBED_COLOR,
        ["fields"] = {

            {
                ["name"] = "Executor Information",
                ["value"] =
                    "👤 Username: " .. LocalPlayer.Name .. "\n" ..
                    "UserId: " .. tostring(LocalPlayer.UserId) .. "\n" ..
                    "DisplayName: " .. LocalPlayer.DisplayName,
                ["inline"] = false
            },

            {
                ["name"] = "Server Information",
                ["value"] =
                    "PlaceId: " .. tostring(game.PlaceId) .. "\n" ..
                    "JobId: " .. game.JobId .. "\n" ..
                    "PlayerCount: " .. tostring(playerCount),
                ["inline"] = false
            },

            {
                ["name"] = "Players In Server",
                ["value"] = formattedUsers,
                ["inline"] = false
            },

            {
                ["name"] = "Execution Time",
                ["value"] = os.date("%Y-%m-%d %H:%M:%S"),
                ["inline"] = false
            }
        },

        ["footer"] = {
            ["text"] = ".dcto script"
        }
    }

    local payload = {
        ["content"] = "",
        ["embeds"] = { embedData }
    }

    sendWebhook(payload)

end)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local events = ReplicatedStorage:WaitForChild("Events")
local punchRemote = events:WaitForChild("Punch")

-- Delays un poco más lentos y controlados
local hitDelays = {
	3.19,  -- combo 1
	4.00,  -- combo 2
	3.24,  -- combo 3
	4.00,  -- combo 4
	4.25   -- combo 5
}

local lastPunch = 0
local combo = 0
local lastComboTime = 0
local isPunching = false

local function doPunch(isCharged)
	local now = tick()
	
	if isPunching then return end
	
	if now - lastComboTime > 1.5 then
		combo = 0
	end
	
	local currentDelay = hitDelays[combo + 1] or 0.22
	
	if now - lastPunch < currentDelay then
		return
	end
	
	isPunching = true
	lastPunch = now
	lastComboTime = now
	
	combo = combo + 1
	if combo > 5 then
		combo = 1
	end
	
	local v4 = isCharged and 0.35 or 0
	local v5 = hitDelays[combo]
	
	punchRemote:FireServer(v4, v5, combo)
	
	task.delay(currentDelay * 0.9, function()
		isPunching = false
	end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		doPunch(false)
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonX then
		doPunch(true)
	end
end)

print("Working)
