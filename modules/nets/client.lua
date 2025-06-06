local inventory = exports.ox_inventory

lib.callback.register('prp_fishing:canPlaceFishingNet', function()
    if IsPedSwimming(cache.ped) or IsPedInAnyVehicle(cache.ped, true) then
        notify(locale('cant_swim'), 'error')
        return false
    end
    
    local headCoords = GetPedBoneCoords(cache.ped, 31086, 0.0, 0.0, 0.0)
    local coords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 45.0, -27.5)
    local hasWater, coords = TestProbeAgainstWater(headCoords.x, headCoords.y, headCoords.z, coords.x, coords.y, coords.z)

    if not hasWater or #(GetEntityCoords(cache.ped) - (coords?.xyz or vector3(0, 0, 0))) > 2.0 then
        notify(locale('no_water'), 'error')
        return false
    end

    return coords
end)