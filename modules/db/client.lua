-----------------------------------------------------------------------------------------------------------------------------
--- MODULE
----------------------------------------------------------------------------------------------------------------------------- 

local peds = require 'data.peds'
local utils = require 'utils.client'
local items = require 'data.items'

local function loadLocaleFile(key)
    local file = LoadResourceFile(cache.resource, ('locales/%s.json'):format(key))
        or LoadResourceFile(cache.resource, 'locales/en.json')

    return file and json.decode(file) or {}
end

table.sort(peds.renting.boats, function (a, b) return b.price < a.price end)

db = {}

local function getVehicleLabel(model)
    local label = GetLabelText(GetDisplayNameFromVehicleModel(model))

    if label == 'NULL' then
        label = GetDisplayNameFromVehicleModel(model)
    end

    return label
end

---@return ShopItem[]
local function convert()
    local shop, boats = {}, {}

    for _, item in pairs(items) do
        for _, data in ipairs(item) do
            table.insert(shop, {
                name = data.name,
                label = data.label or utils.GetItemLabel(data.name),
                imageUrl = data.imageUrl or getInventoryIcon(data.name),
                price = data.price,
                rarity = data.rarity
            })
        end
    end

    for _, boat in ipairs(peds.renting.boats) do
        table.insert(boats, {
            name = getVehicleLabel(boat.model),
            price = boat.price,
            image = boat.image,
            description = boat.description
        })
    end

    table.sort(shop, function(a, b) return b.price < a.price end)

    return shop, boats
end

local shop, boats, locationIndex

---@param index integer
function db.openMenu(index)
    local coords = peds.locations[index]?.coords or peds.locations[index]

    if #(GetEntityCoords(cache.ped) - coords?.xyz) > 2.0 then
        notify(locale('far_away'), 'error')
        return
    end

    if not shop or not boats then 
        shop, boats = convert()
    end
    
    local stats, lb = lib.callback.await('prp_fishing:getPlayerStats', false)
    local gameTime = ('%s:%s %s'):format(GetClockHours() > 12 and GetClockHours() - 12 or GetClockHours(), 
        string.format('%02d', GetClockMinutes()),
        GetClockHours() > 12 and 'PM' or 'AM')

    SetNuiFocus(true, true)
    SendNUIMessage({ 
        action = 'openTablet',
        data = {
            leaderboard = lb,
            statistics = stats,
            shop = shop,
            boats = peds.locations[index]?.renting and boats or {},
            time = gameTime
        }
    })

    locationIndex = index
end

-----------------------------------------------------------------------------------------------------------------------------
--- NUI CALLBACKS
----------------------------------------------------------------------------------------------------------------------------- 

RegisterNUICallback('init', function(_, cb)
    cb(1)

    SendNUIMessage({
        action = 'setLocale',
        data = loadLocaleFile(peds.locale)
    })
end)

RegisterNuiCallback('getFishingData', function(_, cb)
    ---@type DailyChallenges[]
    local dailych = challenges.getChallenges()
    local challenges = {}

    for _, challenge in ipairs(dailych) do
        local toinsert = challenge.type == 'amount' and locale('dch_fishes') or utils.GetItemLabel(challenge.fish)
        table.insert(challenges, {
            title = locale('dch_' .. challenge.type .. '_description'),
            value = challenge.type == 'amount' and ('%s %s'):format(challenge.total, locale('dch_fishes')) or utils.GetItemLabel(challenge.fish),
            description = locale('dch_title', challenge.catched, challenge.total, toinsert, challenge.reward),
            claimed = challenge.claimed
        })
    end

    cb({ challenges = challenges, nickname = Framework.getCharacterName() })
end)

RegisterNUICallback('claimChallenge', function (id, cb)
    cb(1)

    if math.type(tonumber(id)) == 'float' then
        id = math.tointeger(id)
    elseif tonumber(id) then
        id += 1
    end

    challenges.claimChallenge(id)
end)

RegisterNUICallback('reloadDailyChallenge', function(id, cb)
    cb(1)

    if math.type(tonumber(id)) == 'float' then
        id = math.tointeger(id)
    elseif tonumber(id) then
        id += 1
    end

    TriggerServerEvent('prp_fishing:reloadDailyChallenge', id)
end)

RegisterNUICallback('closeTablet', function(_, cb)
    cb(1)
    SetNuiFocus(false, false)

    -- Variable for renting ...
    locationIndex = nil
end)

function db.locationIndex()
    return locationIndex
end