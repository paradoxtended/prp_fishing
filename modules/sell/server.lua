local inventory = exports.ox_inventory

local fish = require 'data.fish'
local peds = require 'data.peds'
local containers = require 'data.items'

---@param source number
---@return { name: string, length: number }[]?
lib.callback.register('prp_fishing:getPlayerFishes', function(source)
    local player = Framework.getPlayerFromId(source)
    if not player then return end

    local fishes = {}

    -- Looping through inventory
    for fishName, _ in pairs(fish) do
        local slots = inventory:GetSlotsWithItem(source, fishName)
        
        for _, fish in ipairs(slots) do
            if table.type(fish?.metadata) ~= 'empty' then
                table.insert(fishes, fishName)
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
                    table.insert(fishes, fish.name)
                end
            end
        end
    end

    return fishes
end)

---@param source number
---@param fishName string
---@param count number
lib.callback.register('prp_fishing:sellFish', function(source, fishName, count)
    local player = Framework.getPlayerFromId(source)
    if not player then return end

    local fishData = fish[fishName]
    if not fishData then return end

    local soldFishes, price

    ---@param remove? boolean
    ---@return number
    local function getGoodsPrice(remove)
        soldFishes, price = 0, 0

        -- Firstly it's checking the player's inventory
        local slots = inventory:GetSlotsWithItem(source, fishName)
        for _, fish in ipairs(slots) do
            if fish and table.type(fish.metadata) ~= 'empty' and soldFishes < count then
                if remove then inventory:RemoveItem(source, fishName, 1, nil, fish.slot) end
                soldFishes += 1
                price += fishData.pricePerInch * fish.metadata.length
            end
        end

        -- If count is missing, then check containers(cooler boxes)
        if soldFishes < count then
            for _, container in ipairs(containers.coolerBoxes) do
                local slots = inventory:GetSlotsWithItem(source, container.name)

                for _, slot in ipairs(slots) do
                    local fishes = inventory:GetSlotsWithItem(slot.metadata.container, fishName)
                    for _, fish in ipairs(fishes) do
                        if fish and table.type(fish.metadata) ~= 'empty' and soldFishes < count then
                            if remove then inventory:RemoveItem(slot.metadata.container, fishName, 1, nil, fish.slot) end
                            soldFishes += 1
                            price += fishData.pricePerInch * fish.metadata.length
                        end
                    end
                end
            end
        end
        soldFishes = 0

        return math.floor(price)
    end

    price = getGoodsPrice()

    local confirmed = lib.callback.await('prp_fishing:alertDialog', source, {
        header = locale('sell_goods'),
        content = locale('sell_content', price)
    }) == 'confirm'

    if confirmed then
        player:addAccountMoney(peds.account, price)
        getGoodsPrice(true)
        db.addTotalEarned(player:getIdentifier(), price)

        return price
    end
end)