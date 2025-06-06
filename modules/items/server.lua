local Inventory = exports.ox_inventory

local Items = require 'data.items'
local Fish = require 'data.fish'

---@param t any
---@param indexes? boolean
---@return string[]
local function createWhitelist(t, indexes)
    local concated = {}

    if indexes then
        for index, _ in pairs(t) do
            table.insert(concated, index)
        end

        return concated
    end

    for _, data in ipairs(t) do
        if data.name then
            table.insert(concated, data.name)
        else
            table.insert(concated, data)
        end
    end

    return concated
end

local containers = {}

local rodSlots = 3
local rodMaxWeight = 2000

function containers.createContainers()
    -- Rods --
    for _, rod in ipairs(Items.rods) do
        Inventory:setContainerProperties(rod.name, {
            slots = rodSlots,
            maxWeight = rodMaxWeight,
            whitelist = lib.array.merge(createWhitelist(Items.baits), createWhitelist(Items.hooks))
        })
    end

    -- Cooler boxes --
    for _, container in ipairs(Items.coolerBoxes) do
        Inventory:setContainerProperties(container.name, {
            slots = container.slots,
            maxWeight = container.maxWeight,
            whitelist = createWhitelist(Fish, true)
        })
    end
end

---------------------------------------------------------------------------------------------------------------------
--- Code for hooks (only one hook can be attached on fishing rod)
---------------------------------------------------------------------------------------------------------------------

---@param itemName string
---@return boolean?
local function isItemHook(itemName)
    for _, hook in ipairs(Items.hooks) do
        if itemName == hook.name then
            return true
        end
    end
end

local hookId = Inventory:registerHook('swapItems', function(payload)
    if payload.toType ~= 'container' or payload.fromInventory == payload.toInventory then
        return true
    end

    local inv = Inventory:GetInventory(payload.toInventory, false)

    if inv and inv.slots == rodSlots and inv.maxWeight == rodMaxWeight then
        local slot = Inventory:GetSlotWithItem(payload.toInventory, payload.fromSlot.name)
        if slot and isItemHook(payload.fromSlot.name) then
            TriggerClientEvent('prp_fishing:notify', payload.source, locale('has_hook'), 'error')
            return false 
        end
    end

    return true
end)

return containers