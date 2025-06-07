local peds = require 'data.peds'
local fish = require 'data.fish'

local utils = require 'utils.client'

selling = {}

---@param args { fishName: string, count: number }
function selling.sellFish(args)
    Wait(50)
    local count = inputDialog(locale('sell_fish'), {
        {
            type = 'number',
            placeholder = locale('sell_fish_placeholder'),
            min = 1,
            label = locale('amount'),
            description = locale('sell_fish_sell_all')
        }
    })?[1] --[[@as number?]]

    if not count or count > args.count then count = args.count end

    local success = lib.callback.await('prp_fishing:sellFish', false, args.fishName, count)

    if success then
        notify(locale('sold_fish', math.floor(success)), 'success')
    end
end

---@param index integer
function selling.openMenu(index)
    local coords = peds.locations[index]?.coords or peds.locations[index]

    if #(GetEntityCoords(cache.ped) - coords?.xyz) > 2.0 then
        notify(locale('far_away'), 'error')
        return
    end

    ---@type string[]?
    local fishes = lib.callback.await('prp_fishing:getPlayerFishes', false)

    local options = {}
    for _, fishName in ipairs(fishes) do
        -- Check if fish is already in options
        for _, option in ipairs(options) do
            if option.title == utils.GetItemLabel(fishName) then
                option.count = option.count + 1
                option.metadata = {
                    { label = locale('sell_fish_total_count'), value = option.count .. 'x' },
                    { label = locale('sell_fish_price_per_inch'), value = '$' .. fish[fishName].pricePerInch }
                }
                option.args = { fishName = fishName, count = option.count }

                goto continue
            end
        end

        table.insert(options, {
            title = utils.GetItemLabel(fishName),
            count = 1,
            metadata = {
                { label = locale('sell_fish_total_count'), value = 1 .. 'x' },
                { label = locale('sell_fish_price_per_inch'), value = '$' .. fish[fishName].pricePerInch }
            },
            icon = getInventoryIcon(fishName),
            onSelect = selling.sellFish,
            args = { fishName = fishName, count = 1 }
        })

       ::continue::
    end

    contextMenu({
        title = locale('sell_fish_menu'),
        id = 'prp_fishing:openSellMenu',
        options = {
            {
                title = locale('information'),
                description = locale('sell_fish_description')
            },
            table.unpack(options)
        }
    }, true)
end