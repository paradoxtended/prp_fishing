local items = require 'data.items'

---Returning if bought item is valid (not some strange, f.e. weapon or money...) and the second parameter is item's data
---@param cart { name: string, count: number }[]
---@return boolean, ShopItem?
local function getItemData(cart)
    for _, item in pairs(items) do
        for _, data in ipairs(item) do
            for _, cartItem in ipairs(cart) do
                if data.name == cartItem.name then
                    return true, data
                end
            end
        end
    end

    return false
end

---@param cart { name: string, count: number }[]
---@return integer
local function getTotalPrice(cart)
    local price = 0

    local valid, data = getItemData(cart)

    if valid and data then
        price += data.price
    end

    return price
end

---@param source integer
---@param data { cart: { name: string, count: number }[], type: 'bank' | 'money' }
lib.callback.register('prp_fishing:buyItem', function(source, data)
    local player = Framework.getPlayerFromId(source)

    if not player then return end

    ---@type { name: string, count: number }[], 'bank' | 'money'
    local cart, type in data

    local valid = getItemData(cart)

    if not valid then return end

    local price = getTotalPrice(cart)

    if price > 0 and player:getAccountMoney(type) >= price then
        for _, cart in ipairs(cart) do
            player:addItem(cart.name, cart.count)
            player:removeAccountMoney(type, price)
        end

        return true
    end

    return false
end)