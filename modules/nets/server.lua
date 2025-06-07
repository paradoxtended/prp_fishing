local inventory = exports.ox_inventory

local tables = {
    [[
        CREATE TABLE IF NOT EXISTS `prp_fishing` (
            `stashId` varchar(50) NOT NULL,
            `data` longtext NOT NULL,
            PRIMARY KEY (`stashId`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
    ]]
}

local items = require 'data.items'
local zones = require 'data.zones'
local fishes = require 'data.fish'

local Utils = require 'utils.server'

---------------------------------------------------------------------------------------------------------------------------------
--- MODULE
---------------------------------------------------------------------------------------------------------------------------------

---@type table<string, { coords: vector4, netIndex: integer }>
local fishingNets = {}

MySQL.ready(function()
    for i = 1, #tables do
        MySQL.query.await(tables[i])
    end

    local data = MySQL.query.await('SELECT * FROM prp_fishing')

    for _, entry in ipairs(data) do
        local data = json.decode(entry.data)
        fishingNets[entry.stashId] = { coords = data.coords, netIndex = data.netIndex }

        local fishingNet = items.fishingNets[data.netIndex] 
        inventory:RegisterStash(entry.stashId, locale('fishing_net'), fishingNet.slots, fishingNet.maxWeight, false, false, data.coords)
    end
end)

local function save()
    local query = 'UPDATE prp_fishing SET data = ? WHERE stashId = ?'
    local parameters = {}
    local size = 0

    for stashId, data in pairs(fishingNets) do
        size += 1
        parameters[size] = {
            json.encode(data),
            stashId
        }
    end

    if size > 0 then
        print('Saving fishing nets.')
        MySQL.prepare.await(query, parameters)
    end
end

lib.cron.new('*/10 * * * *', save)
AddEventHandler('txAdmin:events:serverShuttingDown', save)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
    if eventData.secondsRemaining ~= 60 then return end

	save()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == cache.resource then
		save()
	end
end)


---@param stashId string
---@param coords vector4
---@param netIndex integer
local function createFishingNet(stashId, coords, netIndex)
    fishingNets[stashId] = { coords = coords, netIndex = netIndex }
    MySQL.insert.await('INSERT INTO prp_fishing (stashId, data) VALUES (?, ?)', { stashId, json.encode(fishingNets[stashId]) })
end

---@type string[], string[]
local numbers, chars = {}, {}

for i = 48, 57 do table.insert(numbers, string.char(i)) end
for i = 65, 90 do table.insert(chars, string.char(i)) end

local function generateId(length)
    while true do
        local stashId = 'prp_fishing:fishingNet_'

        for _ = 1, length do
            stashId = stashId .. (math.random(2) == 1 and Utils.RandomFromTable(chars) or Utils.RandomFromTable(numbers))
        end

        if not MySQL.single.await('SELECT * FROM prp_fishing WHERE stashId = ?') then
            return stashId
        end

        Wait(0)
    end
end

for netIndex, net in ipairs(items.fishingNets) do
    Framework.registerUsableItem(net.name, function(source)
        local player = Framework.getPlayerFromId(source)
        if not player then return end

        ---@type boolean, vector4
        local hasWater, coords = lib.callback.await('prp_fishing:hasWaterInFront', source)
        if not hasWater then return end

        local success = lib.callback.await('prp_fishing:progressBar', source, locale('placing_net'), 7500, true, { dict = 'mini@repair', clip = 'fixing_a_ped', flag = 1 })

        if success then
            player:removeItem(net.name, 1)

            local stashId = generateId(3)
            inventory:RegisterStash(stashId, locale('fishing_net'), net.slots, net.maxWeight, false, false, coords.xyz)
            
            createFishingNet(stashId, coords, netIndex)
            TriggerClientEvent('prp_fishing:fishingNet', -1, stashId, net, coords)
        end
    end)
end

---@param source number
---@param stashId string
lib.callback.register('prp_fishing:takeFishingNet', function(source, stashId)
    local player = Framework.getPlayerFromId(source)
    if not player then return end

    if not fishingNets[stashId] then return end
    local fishingNet = fishingNets[stashId]
    local net = items.fishingNets[fishingNet.netIndex]

    -- Check if it's possible for player to be at the fishing net
    if #(GetEntityCoords(GetPlayerPed(source)) - vec3(fishingNet.coords.x, fishingNet.coords.y, fishingNet.coords.z)) > 2.0 then return end

    local progress = lib.callback.await('prp_fishing:progressBar', source, locale('taking_fishing_net'), 7500, true, { dict = 'mini@repair', clip = 'fixing_a_ped', flag = 1 })

    if progress then
        fishingNets[stashId] = nil
        MySQL.prepare.await('DELETE FROM prp_fishing WHERE stashId = ?', { stashId })
        MySQL.query.await('DELETE FROM ox_inventory WHERE name = ?', {
            stashId
        })
        inventory:RemoveInventory(stashId)

        TriggerClientEvent('prp_fishing:takeFishingNet', -1, stashId)
        player:addItem(net.name, 1)

        return true
    end

    return false
end)

lib.callback.register('prp_fishing:getFishingNets', function() return fishingNets end)

---------------------------------------------------------------------------------------------------------------------------------
--- STASH HOOKS
---------------------------------------------------------------------------------------------------------------------------------

inventory:registerHook('swapItems', function(payload)
    if payload.fromType ~= 'player' then return true end

    return false
end, {
    inventoryFilter = {
        '^prp_fishing:fishingNet_[%w]+'
    }
})

---@return integer?
local function isNetInZone(data)
    for zoneIndex, zone in ipairs(zones.zones) do
        for _, coords in ipairs(zone.locations) do
            if #(vector3(data.coords.x, data.coords.y, data.coords.z) - coords.xyz) <= zone.radius then
                return zoneIndex
            end
        end
    end
end

local interval = 1 * 60000

SetInterval(function()
    for stashId, data in pairs(fishingNets) do
        if inventory:GetEmptySlot(stashId) then
            local zoneIndex = isNetInZone(data)

            local zone = zones.zones[zoneIndex] or zones.outside
            local fishName = exports.prp_fishing:getRandomFish(zone.fishList)
            local fish = fishes[fishName]
            local length = randomDecimal(fish.length.min, fish.length.max)
            
            inventory:AddItem(stashId, fishName, 1, {
                length = length,
                description = locale('fish_length', length)
            })
        end
    end
end, interval)