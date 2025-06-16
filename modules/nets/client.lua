local inventory, target = exports.ox_inventory, exports.ox_target

local items = require 'data.items'

-- Variable handling local objects, where index is stashId and value is the object itself
---@type table<string, integer>
local fishingNets = {}

---@return boolean, vector4?
local function hasWaterInFront()
    if IsPedSwimming(cache.ped) or IsPedInAnyVehicle(cache.ped, true) then
        return false
    end
    
    local headCoords = GetPedBoneCoords(cache.ped, 31086, 0.0, 0.0, 0.0)
    local coords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 45.0, -27.5)
    local hasWater, coords = TestProbeAgainstWater(headCoords.x, headCoords.y, headCoords.z, coords.x, coords.y, coords.z)

    local pedCoords = GetEntityCoords(cache.ped)

    if not hasWater or #(pedCoords - coords?.xyz) > 2.0 then
        notify(locale('no_water'), 'error')
        return false
    end

    if lib.getClosestObject(pedCoords, 5.0) then
        notify(locale('too_close_fishing_net'), 'error')
        return false
    end

    return hasWater, vector4(coords.x, coords.y, coords.z, GetEntityHeading(cache.ped))
end

lib.callback.register('prp_fishing:hasWaterInFront', function()
    return hasWaterInFront()
end)

---@param netIndex integer
---@param coords vector3
local function createFishingNet(netIndex, coords)
    local model = items.fishingNets[netIndex]?.prop or `prop_dog_cage_02`

    lib.requestModel(model)
    local object = CreateObject(model, coords.x, coords.y, coords.z - 1.0, false, true, false)
    SetEntityHeading(object, coords.w)
    SetEntityAsMissionEntity(object, true, true)
    FreezeEntityPosition(object, true)
    PlaceObjectOnGroundProperly(object)
    SetModelAsNoLongerNeeded(model)

    return object
end

---@param stashId string
---@param net integer
---@param coords vector4
local function updateFishingNets(stashId, net, coords)
    if fishingNets[stashId] then return end

    local object = createFishingNet(net, coords)

    fishingNets[stashId] = object

    target:addLocalEntity(object, {
        {
            label = locale('search_fishing_net'),
            icon = 'fas fa-magnifying-glass',
            distance = 2.0,
            onSelect = function()
                if not showProgressBar(locale('searching_fishing_net'), 5000, true, 
                    { dict = 'missexile3', clip = 'ex03_dingy_search_case_a_michael', flag = 1 }) then return end
                inventory:openInventory('stash', { id = stashId })
            end
        },
        {
            label = locale('take_fishing_net'),
            icon = 'fas fa-hands',
            distance = 2.0,
            onSelect = function()
                local success = lib.callback.await('prp_fishing:takeFishingNet', false, stashId)
                if success then
                    notify(locale('took_fishing_net'), 'success')
                end
            end
        }
    })
end

RegisterNetEvent('prp_fishing:fishingNet', updateFishingNets)

RegisterNetEvent('prp_fishing:takeFishingNet', function(stashId)
    if not fishingNets[stashId] then return end
    DeleteEntity(fishingNets[stashId])
end)

Framework.onPlayerLoaded(function()
    local nets = lib.callback.await('prp_fishing:getFishingNets', false)

    for stashId, data in pairs(nets) do
        updateFishingNets(stashId, data.netIndex, data.coords)
    end
end)