local fishes = require 'data.fish'
local peds = require 'data.peds'

---@class FishingStats
---@field totalFish number
---@field longestFish number
---@field totalEarned number

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

---@param identifier string
function db.createPlayer(identifier)
    levels[identifier] = {
        totalEarned = 0,
        totalFish = 0,
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

    levels[identifier].totalFish += 1
end

---@param identifier string
---@param amount number
function db.addTotalEarned(identifier, amount)
    local player = Framework.getPlayerFromIdentifier(identifier)
    if not player then return end

    if player:getAccountMoney(peds.account) < amount then return end

    levels[identifier].totalEarned += amount
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
lib.callback.register('prp_fishing:getPlayerStats', function(source)
    local player = Framework.getPlayerFromId(source)
    if not player then return end

    local identifier = player:getIdentifier()

    if not levels[identifier] then
        db.createPlayer(identifier)
    end

    return levels[identifier]
end)