---@class PedData
---@field model string | string[]
---@field blip BlipData
---@field name string
---@field locations ({ coords: vector4, renting: vector4 } | vector4)[]
---@field scenarios string[] Ped will play one of the scenarios
---@field account 'money' | 'bank' | 'black_money'
---@field renting { boats: BoatData[], returnDivider: number, returnRadius: number }
---@field locale string Locale for fishing tablet

---@class BoatData
---@field model string
---@field price number
---@field image? string
---@field description? string

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
            { model = `speeder`, price = 500, image = 'https://i.postimg.cc/mDSqWj4P/164px-Speeder.webp', description = 'One of the smaller boats but on the other hand it is extremly fast.' },
            { model = `dinghy`, price = 750, image = 'https://i.postimg.cc/ZKzjZgj0/164px-Dinghy2.webp' },
            { model = `tug`, price = 1000, image = 'https://i.postimg.cc/jq7vpKHG/164px-Tug.webp', description = 'A slow but giant boat. Better for further destination.' }
        },
        returnDivider = 5,
        returnRadius = 30.0
    },
    locale = 'en'
}