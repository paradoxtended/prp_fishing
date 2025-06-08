local Inventory = exports.ox_inventory

local Items = require 'data.items'
local Peds = require 'data.peds'

local Shop = {}

function Shop.Convert()
    local items, locations = {}, {}

    for _, item in pairs(Items) do
        for _, data in ipairs(item) do
            table.insert(items, {
                name = data.name,
                price = data.price
            })
        end
    end

    for _, coords in ipairs(Peds.locations) do
        if coords.coords then
            table.insert(locations, coords.coords.xyz)
        else
            table.insert(locations, coords.xyz)
        end
    end

    return items, locations
end

---@param title string Shop's title
function Shop.CreateShops(title)
    local inventory, locations = Shop.Convert()

    Inventory:RegisterShop('prp_fishing:fishing_equipment', {
        name = title,
        inventory = inventory,
        locations = locations
    }) 
end

return Shop