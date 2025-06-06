local peds = require 'data.peds'

local utils = require 'utils.client'

challenges = {}

---@param index integer
function challenges.claimChallenge(index)
    local success = lib.callback.await('prp_fishing:claimDailyChallenge', false, index)

    if success then
        notify(locale('dch_claimed'), 'success')
    else
        notify(locale('dch_cant_claim'), 'error')
    end
end

---@param index integer
function challenges.openMenu(index)
    local coords = peds.locations[index]?.coords or peds.locations[index]

    if #(GetEntityCoords(cache.ped) - coords?.xyz) > 2.0 then
        notify(locale('far_away'), 'error')
        return
    end

    ---@type DailyChallenges[]
    local dailych = lib.callback.await('prp_fishing:getDailyChallenges', false)

    local options = {}
    
    for challengeIndex, challenge in ipairs(dailych) do
        local toInsert = challenge.type == 'fish' and utils.GetItemLabel(challenge.fish)
                      or challenge.type == 'amount' and locale('dch_fishes') or nil 
        table.insert(options, {
            title = locale('dch_title', challenge.catched, challenge.total, toInsert, challenge.reward),
            description = locale('dch_' .. challenge.type .. '_description'),
            icon = 'trophy',
            metadata = {
                { progress = (challenge.catched / challenge.total) * 100 },
                { label = locale('dch_progress'), value = math.floor((challenge.catched / challenge.total) * 100) .. '%' }
            },
            disabled = challenge.claimed,
            onSelect = challenges.claimChallenge,
            args = challengeIndex
        })
    end

    contextMenu({
        title = locale('daily_fishing_challenges'),
        id = 'prp_fishing:dailyChallenges',
        options = {
            {
                title = locale('information'),
                description = locale('dch_info_content')
            },
            table.unpack(options)
        }
    }, true)
end