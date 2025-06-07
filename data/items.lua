---@class FishingRod
---@field name string
---@field price number
---@field breakChance number

---@class FishingHook
---@field name string
---@field price number
---@field progress? { add: number?, remove: number? }

---@class FishingBait
---@field name string
---@field price number
---@field waitDivisor number
---@field catchTime? number

---@class CoolerBox
---@field name string
---@field slots integer
---@field maxWeight number
---@field price number

---@class FishingNet
---@field name string
---@field slots integer
---@field maxWeight number
---@field price number
---@field prop? string

return {
    ---@type FishingRod[]
    rods = {
        { name = 'basic_rod', price = 150, breakChance = 35 },
        { name = 'graphite_rod', price = 300, breakChance = 20 },
        { name = 'titanium_rod', price = 500, breakChance = 10 }
    },

    ---@type FishingHook[]
    hooks = {
        { name = 'basic_fishing_hook', price = 50 }
    },

    ---@type FishingBait[]
    baits = {
        { name = 'worms', price = 5, waitDivisor = 1.0 },
        { name = 'artificial_bait', price = 10, waitDivisor = 2.5, catchTime = 45000 }
    },

    ---@type CoolerBox[]
    coolerBoxes = {
        { name = 'fish_cooler_box_small', slots = 10, maxWeight = 15000, price = 500 }
    },

    ---@type FishingNet[]
    fishingNets = {
        { name = 'small_fishing_net', slots = 5, maxWeight = 10000, price = 1000, prop = `prop_dog_cage_02` }
    }
}