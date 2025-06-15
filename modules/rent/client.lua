-----------------------------------------------------------------------------------------------------------------------------
--- Editable
-----------------------------------------------------------------------------------------------------------------------------

local function setVehicleOwner(plate)
    if Framework.name == 'es_extended' then
        -- Not implemented
    elseif Framework.name == 'qb-core' then
        TriggerEvent("vehiclekeys:client:SetOwner", plate)
    end
end

local function setVehicleFuel(vehicle, fuelLevel)
    if GetResourceState('LegacyFuel') == 'started' then
        exports['LegacyFuel']:SetFuel(vehicle, fuelLevel)
    elseif GetResourceState('ox_fuel') then
        Entity(vehicle).state.fuel = fuelLevel
    end
end

-----------------------------------------------------------------------------------------------------------------------------
--- Script, do not touch unless you know what you're doing
-----------------------------------------------------------------------------------------------------------------------------

local peds = require 'data.peds'

---@CPoint?
local point
local shown = false

local function getBoatPrice(vehicle)
    for _, boat in ipairs(peds.renting.boats) do
        if boat.model == GetEntityModel(vehicle) then
            return boat.price
        end
    end
end

local bind = lib.addKeybind({
    name = 'fishing_interaction',
    description = 'The main interaction keybind.',
    defaultKey = 'E',
    defaultMapper = 'keyboard',
    onReleased = function()
        if not point then return end

        local price = getBoatPrice(cache.vehicle)
        if not price then return end

        local confirmed = alertDialog({
            header = locale('return_boat'),
            content = locale('return_content', math.floor(price / peds.renting.returnDivider)),
        }) == 'confirm'

        if not confirmed then return end

        local netId = NetworkGetNetworkIdFromEntity(cache.vehicle)
        local success = lib.callback.await('prp_fishing:returnBoat', false, netId)

        if success then
            TaskLeaveAnyVehicle(cache.ped)
            hideTextUI()
            notify(locale('returned_boat'), 'success')
        end
    end
})

rent = {}

---@param boat BoatData
---@param locationIndex integer
function rent.spawnBoat(boat, locationIndex)
    local coords = peds.locations[locationIndex]?.renting
    if not coords then return end

    Framework.spawnVehicle(boat.model, coords.xyz, coords.w, function(vehicle)
        setVehicleOwner(GetVehicleNumberPlateText(vehicle))
        setVehicleFuel(vehicle, 100.0)
        TriggerServerEvent('prp_fishing:registerBoat', NetworkGetNetworkIdFromEntity(vehicle))
    end)
end

---@param index integer
function rent.rentBoat(index)
    local boat = peds.renting.boats[index]

    if not boat then return end

    local success, msg = lib.callback.await('prp_fishing:rentBoat', false, index)
    local locationIndex = db.locationIndex()

    if success and locationIndex then
        rent.spawnBoat(boat, locationIndex)
        notify(locale('rented_boat'), 'success')
    else
        notify(msg or locale('not_enough_' .. peds.account), 'error')
    end
end

RegisterNUICallback('rentVehicle', function (id, cb)
    cb(1)

    if math.type(tonumber(id)) == 'float' then
        id = math.tointeger(id)
    elseif tonumber(id) then
        id += 1
    end

    rent.rentBoat(id)
end)

---@param locationIndex integer
function rent.openMenu(locationIndex)
    local coords = peds.locations[locationIndex]?.coords

    if not coords or #(GetEntityCoords(cache.ped) - coords?.xyz) > 2.0 then
        notify(locale('far_away'), 'error')
        return
    end

    local options = {}
    for index, boat in ipairs(peds.renting.boats) do
        table.insert(options, {
            title = getVehicleLabel(boat.model),
            description = locale('rent_price', boat.price),
            onSelect = rent.rentBoat,
            args = { locationIndex = locationIndex, index = index }
        })
    end

    contextMenu({
        title = locale('rent_boat'),
        id = 'prp_fishing:rentBoat',
        options = options
    }, true)
end

---@param coords vector3
function rent.createReturnZone(coords)
    lib.points.new({
        coords = coords,
        distance = peds.renting.returnRadius or 30.0,
        onEnter = function(self)
            point = self

            if not getBoatPrice(cache.vehicle) then return end

            showTextUI({
                { key = bind:getCurrentKey(), text = locale('return_boat'):upper() }
            })
            shown = true
        end,
        onExit = function(self)
            if point ~= self then return end

            point = nil

            if not shown then return end

            hideTextUI()
            shown = false
        end
    })
end

do
    for _, location in ipairs(peds.locations) do
        if location.renting then
            rent.createReturnZone(location.renting.xyz)
        end
    end
end