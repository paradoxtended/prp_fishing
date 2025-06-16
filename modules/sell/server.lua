---@class SellProps
---@field fishIndex string
---@field label string
---@field rarity? 'common' | 'uncommon' | 'rare' | 'epic' | 'legendary'
---@field price number
---@field length number
---@field metadata? { label: string?, value: any }[]

local inventory = exports.ox_inventory

local Fish = require 'data.fish'
local containers = require 'data.items'
local utils = require 'utils.server'
local peds  = require 'data.peds'

---@param source number
---@return { name: string, length: number }[]?
lib.callback.register('prp_fishing:getPlayerFishes', function(source)
    local player = Framework.getPlayerFromId(source)
    if not player then return end

    ---@type SellProps[]
    local fishes = {}

    -- Looping through inventory
    for fishName, _ in pairs(Fish) do
        local slots = inventory:GetSlotsWithItem(source, fishName)

        for _, fish in ipairs(slots) do
            if table.type(fish?.metadata) ~= 'empty' then
                table.insert(fishes, {
                    label = utils.GetItemLabel(fishName),
                    imageUrl = getInventoryIcon(fishName),
                    rarity = Fish[fishName]?.rarity,
                    price = Fish[fishName].pricePerInch,
                    length = fish.metadata.length,
                    fishIndex = fishName,
                    metadata = {
                        { label = locale('fish_length2'), value = fish.metadata.length .. '"' }
                    }
                })
            end
        end
    end

    -- Looping through containers(cooler boxes)
    for _, container in ipairs(containers.coolerBoxes) do
        local slots = inventory:GetSlotsWithItem(source, container.name)
        for _, slot in ipairs(slots) do
            for i=1, slot.metadata.size[1] do
                local fish = inventory:GetSlot(slot.metadata.container, i)
                
                if fish and table.type(fish?.metadata) ~= 'empty' then
                    table.insert(fishes, {
                        label = utils.GetItemLabel(fish.name),
                        imageUrl = getInventoryIcon(fish.name),
                        rarity = Fish[fish.name]?.rarity,
                        price = Fish[fish.name].pricePerInch,
                        length = fish.metadata.length,
                        fishIndex = fish.name,
                        metadata = {
                            { label = locale('fish_length2'), value = fish.metadata.length .. '"' }
                        }
                    })
                end
            end
        end
    end

    return fishes
end)

---@param source integer
---@param fishes SellProps[]
lib.callback.register('prp_fishing:sellFish', function(source, fishes)
    local player = Framework.getPlayerFromId(source)
    if not player then return end

    local price = 0

    for _, data in pairs(fishes) do
        -- Firstly, check player's inventory
        local slot = inventory:GetSlotWithItem(source, data.fishIndex, {
            length = data.length
        }, false)

        if slot then
            inventory:RemoveItem(source, data.fishIndex, 1, nil, slot.slot)
            local fishData = Fish[data.fishIndex]
            price += slot.metadata.length * fishData.pricePerInch
        else
            -- Check player's cooler boxes
            for _, box in ipairs(containers.coolerBoxes) do
                local slots = inventory:GetSlotsWithItem(source, box.name)
                for _, slot in ipairs(slots) do
                    local coolerBox = inventory:GetSlotWithItem(slot.metadata.container, data.fishIndex, {
                        length = data.length
                    }, false)

                    if coolerBox then
                        inventory:RemoveItem(slot.metadata.container, data.fishIndex, 1, nil, coolerBox.slot)
                        local fishData = Fish[data.fishIndex]
                        price += coolerBox.metadata.length * fishData.pricePerInch
                    end
                end
            end
        end
    end

    price = math.floor(price)

    db.addTotalEarned(player:getIdentifier(), price)
    player:addAccountMoney(peds.account, price)

    return price
end)