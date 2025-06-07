---@class Fish
---@field pricePerInch number
---@field chance integer Percentage chance
---@field length { min: number, max: number }
---@field catchCount? integer How many times player will have to complete a fishing minigame

---@type table<string, Fish>
return {
    ['anchovy'] = { pricePerInch = 5.5, chance = 35, length = { min = 4.0, max = 7.0 } },
    ['trout'] = { pricePerInch = 7.2, chance = 35, length = { min = 8.0, max = 15.0 } },
    ['haddock'] = { pricePerInch = 8.5, chance = 20, length = { min = 10.0, max = 15.0 }, catchCount = 2 },
    ['salmon'] = { pricePerInch = 11.0, chance = 10, length = { min = 4.7, max = 6.6 }, catchCount = 2 },
    ['grouper'] = { pricePerInch = 12.5, chance = 25, length = { min = 2.2, max = 5.4 }, catchCount = 3 },
    ['piranha'] = { pricePerInch = 15.0, chance = 25, length = { min = 0.5, max = 2.7 } },
    ['red_snapper'] = { pricePerInch = 14.5, chance = 20, length = { min = 2.4, max = 5.3 } },
    ['mahi_mahi'] = { pricePerInch = 16.0, chance = 20, length = { min = 1.4, max = 3.8 } },
    ['tuna'] = { pricePerInch = 20.0, chance = 5, length = { min = 2.7, max = 5.9 } },
    ['shark'] = { pricePerInch = 25.0, chance = 1, length = { min = 60.0, max = 150.0 } },
}