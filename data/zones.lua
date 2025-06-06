---@class FishingZone
---@field blip? BlipData
---@field message? { enter: string, exit: string }
---@field waitTime { min: integer, max: integer } Waiting time for fish to get caught, in seconds
---@field fishList string[]
---@field locations vector3[]
---@field radius number
---@field includeOutside boolean?

return {
    ---@type FishingZone[]
    zones = {
        {
            waitTime = { min = 10, max = 25 },
            locations = {
                vector3(1297.8751, 4216.8086, 33.9087)
            },
            radius = 50.0,
            includeOutside = true,
            fishList = { 'grouper' }
        }
    },

    outside = {
        waitTime = { min = 10, max = 25 },
        fishList = {
            'trout', 'anchovy', 'haddock', 'salmon'
        }
    }
}