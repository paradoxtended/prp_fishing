local inventory = exports.ox_inventory

local fishingNets = require 'data.items'.fishingNets
local Utils = require 'utils.server'

local nets = {}

---@type string[], string[]
local numbers, chars = {}, {}

for i = 48, 57 do table.insert(numbers, string.char(i)) end
for i = 65, 90 do table.insert(chars, string.char(i)) end

---@param length integer
---@return string
local function generateId(length)
    while true do
        local id = 'prp_fishing:fishingNet_'

        for _ = 1, length do
            id = id .. (math.random(2) == 1 and Utils.RandomFromTable(chars) or Utils.RandomFromTable(numbers))
        end

        if not MySQL.single.await('SELECT * FROM lunar_jobscreator_vehicles WHERE plate = ?') then
            return id
        end

        Wait(0)
    end
end

for _, net in ipairs(fishingNets) do
    Framework.registerUsableItem(net.name, function(source)
        local player = Framework.getPlayerFromId(source)
        if not player then return end

        local coords = lib.callback.await('prp_fishing:canPlaceFishingNet', source)
        if not coords then return end

        local success = lib.callback.await('prp_fishing:progressBar', source, locale('placing_net'), 7500, true, {
            dict = 'mini@repair', clip = 'fixing_a_ped'
        })
        if not success then return end

        local id = generateId(3)

        inventory:RegisterStash(id, locale('fishing_net'), net.slots, net.maxWeight, false, false, coords)
    end)
end