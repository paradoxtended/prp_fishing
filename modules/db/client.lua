local peds = require 'data.peds'
local utils = require 'utils.client'

local function loadLocaleFile(key)
    local file = LoadResourceFile(cache.resource, ('locales/%s.json'):format(key))
        or LoadResourceFile(cache.resource, 'locales/en.json')

    return file and json.decode(file) or {}
end

db = {}

---@param index integer
function db.openMenu(index)
    local coords = peds.locations[index]?.coords or peds.locations[index]

    if #(GetEntityCoords(cache.ped) - coords?.xyz) > 2.0 then
        notify(locale('far_away'), 'error')
        return
    end

    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'openTablet' })
end

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
end)