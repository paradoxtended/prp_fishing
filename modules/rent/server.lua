local peds = require 'data.peds'

local pending = {}
local spawned = {}

---@param source number
---@param index number
lib.callback.register('prp_fishing:rentBoat', function(source, index)
    local player = Framework.getPlayerFromId(source)
    if not player then return end

    local boat = peds.renting.boats[index]

    if pending[source] then
        return false, locale('rent_already')
    end

    if player:getAccountMoney(peds.account) > boat.price then
        player:removeAccountMoney(peds.account, boat.price)
        pending[source] = true
        return true
    end

    return false
end)

RegisterNetEvent('prp_fishing:registerBoat', function(netId)
    local source = source

    if pending[source] then
        spawned[netId] = true
    end
end)

local function getBoatPrice(vehicle)
    for _, boat in ipairs(peds.renting.boats) do
        if boat.model == GetEntityModel(vehicle) then
            return boat.price
        end
    end
end

lib.callback.register('prp_fishing:returnBoat', function(source, netId)
    local player = Framework.getPlayerFromId(source)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    local price = getBoatPrice(vehicle) / peds.renting.returnDivider

    if not player
    or not price
    or not spawned[netId]
    or GetPedInVehicleSeat(vehicle, -1) ~= GetPlayerPed(source) then
        return
    end

    player:addAccountMoney(peds.account, price)
    spawned[netId] = nil
    pending[source] = nil

    SetTimeout(1500, function()
        DeleteEntity(vehicle)
    end)

    return true
end)