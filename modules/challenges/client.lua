local peds = require 'data.peds'

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

function challenges.getChallenges()
    ---@type DailyChallenges[]
    return lib.callback.await('prp_fishing:getDailyChallenges', false)
end

---@param index integer
function challenges.openMenu(index)
    local coords = peds.locations[index]?.coords or peds.locations[index]

    if #(GetEntityCoords(cache.ped) - coords?.xyz) > 2.0 then
        notify(locale('far_away'), 'error')
        return
    end

    local options = challenges.getChallenges()

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