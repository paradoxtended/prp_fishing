local fishes = require 'data.fish'
local peds = require 'data.peds'

---@class FishingStats
---@field fishCaught number
---@field longestFish number
---@field earned number

---@type table<string, FishingStats>
local levels = {}

local tables = {
    [[
        CREATE TABLE IF NOT EXISTS `prp_fishing_users` (
            `user_identifier` varchar(50) NOT NULL,
            `data` longtext NOT NULL,
            PRIMARY KEY (`user_identifier`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]]
}

MySQL.ready(function()
    for i = 1, #tables do
        MySQL.query.await(tables[i])
    end

    local data = MySQL.query.await('SELECT * FROM prp_fishing_users')

    for _, entry in ipairs(data) do
        levels[entry.user_identifier] = json.decode(entry.data)
    end
end)

db = {}

function db.save()
    local query = 'UPDATE prp_fishing_users SET data = ? WHERE user_identifier = ?'
    local parameters = {}
    local size = 0

    for identifier, data in pairs(levels) do
        size += 1
        parameters[size] = {
            json.encode(data),
            identifier
        }
    end

    if size > 0 then
        print('Saving player fishing progress.')
        MySQL.prepare.await(query, parameters)
    end
end

lib.cron.new('*/10 * * * *', db.save)
AddEventHandler('txAdmin:events:serverShuttingDown', db.save)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining ~= 60 then return end

	db.save()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == cache.resource then
		db.save()
	end
end)

---@param identifier string
function db.createPlayer(identifier)
    levels[identifier] = {
        earned = 0,
        fishCaught = 0,
        longestFish = 0
    }
    MySQL.insert.await('INSERT INTO prp_fishing_users (user_identifier, data) VALUES (?, ?)', { identifier, json.encode(levels[identifier]) })
end

---@param identifier string
---@param fish string
function db.addFish(identifier, fish)
    local player = Framework.getPlayerFromIdentifier(identifier)
    if not player then return end

    if not fishes[fish]
    or not player:hasItem(fish) then
        return
    end

    levels[identifier].fishCaught += 1
end

---@param identifier string
---@param amount number
function db.addTotalEarned(identifier, amount)
    local player = Framework.getPlayerFromIdentifier(identifier)
    if not player then return end

    if player:getAccountMoney(peds.account) < amount then return end

    levels[identifier].earned += amount
end

---@param identifier string
---@param fish string
---@param length number
function db.changeLongestFish(identifier, fish, length)
    local player = Framework.getPlayerFromIdentifier(identifier)
    if not player then return end

    if not fishes[fish]
    or not player:hasItem(fish)
    or levels[identifier].longestFish > length
    or fishes[fish]?.length.min > length
    or fishes[fish]?.length.max < length then
        return
    end

    levels[identifier].longestFish = length
end

exports('addTotalFish', db.addFish)
exports('addTotalEarned', db.addTotalEarned)
exports('changeLongestFish', db.changeLongestFish)

---@param source number
---@return FishingStats?, table<string, FishingStats>?
lib.callback.register('prp_fishing:getPlayerStats', function(source)
    local player = Framework.getPlayerFromId(source)
    if not player then return end

    local identifier = player:getIdentifier()

    if not levels[identifier] then
        db.createPlayer(identifier)
    end

    local lb = {}
    
    for id, stat in pairs(levels) do
        local player = Framework.getPlayerFromIdentifier(id)

        if player then
            table.insert(lb, {
                name = ('%s %s'):format(player:getFirstName(), player:getLastName()),
                longestFish = stat.longestFish,
                earned = stat.earned,
                fishCaught = stat.fishCaught,
                me = identifier == id
            })
        end
    end

    return levels[identifier], lb
end)