---@class PedData
---@field model string | string[]
---@field blip BlipData
---@field name string
---@field locations { coords: vector4, renting: vector4 } | vector4[]
---@field scenarios string[] Ped will play one of the scenarios
---@field account 'money' | 'bank' | 'black_money'
---@field renting { boats: BoatData[], returnDivider: number, returnRadius: number }

---@class BoatData
---@field model string
---@field price number

---@class BlipData
---@field name string
---@field sprite integer
---@field color integer
---@field scale number

---@type PedData
return {
    model = 'ig_old_man2',
    name = 'Fisherman',
    blip = {
        name = 'Fishing',
        color = 67,
        sprite = 317,
        scale = 0.8
    },
    locations = {
        { coords = vector4(1302.3389, 4218.7354, 33.9087, 258.0397), renting = vector4(1313.9196, 4223.1748, 29.6230, 258.3909) }
    },
    scenarios = {
        /*'WORLD_HUMAN_AA_COFFEE',
        'WORLD_HUMAN_AA_SMOKE',
        'WORLD_HUMAN_SMOKING',*/
        'WORLD_HUMAN_STAND_FISHING'
    },
    account = 'money',
    renting = {
        boats = {
            { model = `speeder`, price = 500 }
        },
        returnDivider = 5,
        returnRadius = 30.0
    }
}