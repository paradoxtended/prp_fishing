----------------------------------------------------------------------------------------------------------
--- Editable
----------------------------------------------------------------------------------------------------------

---@param content string
---@param type 'error' | 'success' | 'inform'
function notify(content, type)
    local source = source
    TriggerClientEvent('prp_fishing:notify', source, content, type)
end

function closeInventory()
    local source = source
    TriggerClientEvent('ox_inventory:closeInventory', source, true)
end

----------------------------------------------------------------------------------------------------------
--- Script, don't touch unless you know what you're doing
----------------------------------------------------------------------------------------------------------

local Inventory = exports.ox_inventory

local Shop = require 'modules.shops.server'
local containers = require 'modules.items.server'
require 'modules.sell.server'
require 'modules.challenges.server'
require 'modules.rent.server'
require 'modules.nets.server'

local Items = require 'data.items'
local Fish = require 'data.fish'
local Zones = require 'data.zones'

local Utils = require 'utils.server'

local busy = {}

Shop.CreateShops(locale('fishing_equipment'))
containers.createContainers()

if Zones.zones then
    for _, zone in ipairs(Zones.zones) do
        if zone.includeOutside then
            for _, fishName in ipairs(Zones.outside.fishList) do
                table.insert(zone.fishList, fishName)
            end
        end
    end
end

---@param rodName string
---@return FishingRod?
local function getFishingRod(rodName)
    for _, rod in ipairs(Items.rods) do
        if rod.name == rodName then
            return rod
        end
    end
end

---@param fish string[]
local function getRandomFish(fish)
    local sum = 0

    for _, fishName in ipairs(fish) do
        sum += Fish[fishName].chance
    end

    sum = math.floor(sum)

    local value = math.random(sum)
    local last = 1

    for i = 1, #fish do
        local current = Fish[fish[i]].chance

        if value >= last and value < last + current then
            return fish[i]
        end

        last += current
    end
end

--- Function returning if player has a bait item equipped on rod, if so then it returns [true, baitIndex, slotIndex]
---@return boolean, integer?, integer?
local function hasBait(container, source)
    if not container or table.type(container?.items) == 'empty' then
        TriggerClientEvent('prp_fishing:notify', source, locale('no_bait'), 'error')
        return false
    end

    for i=1, container.slots, 1 do
        local slot = container.items[i]

        if slot then
            for baitIndex, bait in ipairs(Items.baits) do
                if slot.name == bait.name then
                    return true, baitIndex, slot.slot
                end
            end
        end
    end

    TriggerClientEvent('prp_fishing:notify', source, locale('no_bait'), 'error')
    return false
end

--- Function returning if player has a hook equipped on rod, if so then it also returns the hook index
---@return boolean, integer?
local function hasHook(container, source)
    if not container or table.type(container?.items) == 'empty' then
        TriggerClientEvent('prp_fishing:notify', source, locale('no_hook'), 'error')
        return false
    end

    for hookIndex, hook in ipairs(Items.hooks) do
        local slot = Inventory:GetSlotWithItem(container, hook.name)
        
        if slot then
            return true, hookIndex
        end
    end

    TriggerClientEvent('prp_fishing:notify', source, locale('no_hook'), 'error')
    return false
end

RegisterNetEvent('prp_fishing:startFishing', function(slotId)
    local source = source

    local player = Framework.getPlayerFromId(source)
    if not player then return end

    if busy[source] then return end

    closeInventory()

    local hasWater, currentZone = lib.callback.await('prp_fishing:getCurrentZone', source)
    if not hasWater then return end

    if currentZone then
        local zone = Zones.zones[currentZone.index]
        local coords = zone?.locations[currentZone.locationIndex]

        if not zone or not coords then return end

        if #(GetEntityCoords(GetPlayerPed(source)) - coords.xyz) > zone.radius then return end
    end

    local container = Inventory:GetContainerFromSlot(source, slotId)

    local hasHook, hookIndex = hasHook(container, source)
    local hasBait, baitIndex, slotIndex = hasBait(container, source)
    
    if not hasHook or not hasBait then return end

    local fishList = currentZone and Zones.zones[currentZone.index].fishList or Zones.outside.fishList
    local bait = Items.baits[baitIndex]

    Inventory:RemoveItem(container.id, bait.name, 1, nil, slotIndex)

    local fishName = getRandomFish(fishList)

    for _=1, 2000 do
        if player:canCarryItem(fishName, 1) then break end
        fishName = getRandomFish(fishList)
    end

    if not player:canCarryItem(fishName, 1) then
        notify(locale('would_not_carry'), 'error')
        return
    end

    local rodName = Inventory:GetSlot(source, slotId)
    local rod = getFishingRod(rodName.name)
    if not rod then return end

    busy[source] = true

    local success = lib.callback.await('prp_fishing:itemUsed', source, baitIndex, hookIndex, fishName)

    if success == true then
        local fish = Fish[fishName]
        local length = randomDecimal(fish.length.min, fish.length.max)

        player:addItem(fishName, 1, {
            length = length,
            description = locale('fish_length', length)
        })

        notify(locale('fish_caught', length, Utils.GetItemLabel(fishName)), 'success')
        challenges.addCatchFish(player:getIdentifier(), fishName)
    elseif math.random(100) <= rod.breakChance and success ~= 'cancel' then
        player:removeItem(rod.name, 1)
        notify(locale('rod_broke'), 'error')
    end

    busy[source] = nil
end)

--- Function yoinked from internet to generate random length of fish on 2 decimals
function randomDecimal(min, max)
    local factor = 10 ^ 2
    local minScaled = math.floor(min * factor + 0.5)
    local maxScaled = math.floor(max * factor + 0.5)
    local randInt = math.random(minScaled, maxScaled)
    return randInt / factor
end