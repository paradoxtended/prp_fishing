---@class ShopItem
---@field name string
---@field label? string
---@field price number
---@field rarity? 'common' | 'uncommon' | 'rare' | 'epic' | 'legendary'
---@field imageUrl? string

---@class FishingRod : ShopItem
---@field breakChance number

---@class FishingHook : ShopItem
---@field progress? { add: number?, remove: number? }

---@class FishingBait : ShopItem
---@field waitDivisor number
---@field catchTime? number

---@class CoolerBox : ShopItem
---@field slots integer
---@field maxWeight number

---@class FishingNet : ShopItem
---@field slots integer
---@field maxWeight number
---@field prop? string

return {
    ---@type FishingRod[]
    rods = {
        { name = 'basic_rod', price = 150, breakChance = 35, rarity = 'uncommon', imageUrl = getInventoryIcon('basic_rod') },
        { name = 'graphite_rod', price = 300, breakChance = 20, rarity = 'rare', imageUrl = getInventoryIcon('graphite_rod') },
        { name = 'titanium_rod', price = 500, breakChance = 10, rarity = 'epic', imageUrl = getInventoryIcon('titanium_rod') }
    },

    ---@type FishingHook[]
    hooks = {
        { name = 'basic_fishing_hook', price = 50, rarity = 'common' }
    },

    ---@type FishingBait[]
    baits = {
        { name = 'worms', price = 1, waitDivisor = 1.0, rarity = 'common' },
        { name = 'artificial_bait', price = 2, waitDivisor = 2.5, catchTime = 45000, rarity = 'uncommon' }
    },

    ---@type CoolerBox[]
    coolerBoxes = {
        { name = 'fish_cooler_box_small', slots = 10, maxWeight = 15000, price = 500, rarity = 'rare' }
    },

    ---@type FishingNet[]
    fishingNets = {
        { name = 'small_fishing_net', slots = 5, maxWeight = 10000, price = 1000, prop = `prop_dog_cage_02`, rarity = 'epic' }
    }
}