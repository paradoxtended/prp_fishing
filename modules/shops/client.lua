local Inventory = exports.ox_inventory
local Peds = require 'data.peds'

local Shop = {}

---@param index integer
function Shop.OpenShop(index)
    if not index then return end

    local coords = Peds.locations[index]?.coords or Peds.locations[index]
    if not coords then return end

    if #(GetEntityCoords(cache.ped) - coords.xyz) > 2.0 then
        notify(locale('far_away'), 'error')
        return
    end

    Inventory:openInventory('shop', { type = 'prp_fishing:fishing_equipment', id = index })
end

return Shop