local Target = exports.ox_target

local count = 0

local Ped = require 'data.peds'

local Utils = {}

function Utils.RandomFromTable(t)
    if type(t) ~= "table" or table.type(t) == 'empty' then
        error("Table is empty or received wrong type, received: %s", type(t))
    end

    local index = math.random(#t)
    return t[index], index
end

function Utils.CreatePed(coords, model, options)
    if not IsModelValid(model) then
        error('Invalid ped model: %s', model)
    end

    local ped
    lib.points.new({
        coords = coords.xyz,
        distance = 100.0, -- In this distance the ped will be spawned
        onEnter = function()
            lib.requestModel(model)
            ped = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)
            TaskStartScenarioInPlace(ped, Utils.RandomFromTable(Ped.scenarios))
            if options then
                for _, option in pairs(options) do
                    if option.onSelect then
                        count += 1
                        local event = ('options_%p_%s'):format(option.onSelect, count) -- Create unique name
                        ---@type function
                        local onSelect = option.onSelect
                        AddEventHandler(event, function()
                            onSelect(option.args)
                        end)
                        option.event = event
                        option.onSelect = nil
                    end

                    if option.icon and not option.icon:match('^fa%-') then
                        option.icon = ('fa-solid fa-%s'):format(option.icon)
                    end
                end
            end

            Target:addLocalEntity(ped, options)
        end,
        onExit = function()
            DeleteEntity(ped)
            SetModelAsNoLongerNeeded(model)
            ped = nil
        end
    })
end

---@param coords vector3 | vector4
---@param data BlipData
function Utils.CreateBlip(coords, data)
    if not data then return end

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite(blip, data.sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, data.scale)
    SetBlipColour(blip, data.color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(data.name)
    EndTextCommandSetBlipName(blip)

    return blip
end

---@param coords vector3 | vector4
---@param scale number
---@param color integer
function Utils.CreateRadiusBlip(coords, scale, color)
    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, scale)

    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    SetBlipAlpha(blip, 150)

    return blip
end

local labels = {}

lib.callback('prp_fishing:getItemLabels', false, function(data)
    labels = data
end)

---@param name string
function Utils.GetItemLabel(name)
    return labels[name] or labels[name:upper()] or 'ITEM_NOT_FOUND'
end

return Utils