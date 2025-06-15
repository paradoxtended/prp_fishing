----------------------------------------------------------------------------------------------------------
--- Editable
----------------------------------------------------------------------------------------------------------

---@param data ContextMenuProps
---@param shouldOpen? boolean
function contextMenu(data, shouldOpen)
    prp.registerContext(data)

    if shouldOpen then
        ---@diagnostic disable-next-line: undefined-field
        prp.showContext(data.id)
    end
end

function alertDialog(data)
    return prp.alertDialog(data)
end

lib.callback.register('prp_fishing:alertDialog', alertDialog)

---@param heading string
---@param rows string[] | InputDialogRowProps[]
---@param options InputDialogOptionsProps[]?
---@return string[] | number[] | boolean[] | nil
function inputDialog(heading, rows, options)
    return prp.inputDialog(heading, rows, options)
end

---@param content string
---@param type 'error' | 'success' | 'inform'
function notify(content, type)
    prp.notify({
        description = content,
        type = type
    })
end

---Returns the NUI path of an icon.
---@param itemName string
---@return string?
---@diagnostic disable-next-line: duplicate-set-field
function getInventoryIcon(itemName)
    return ('nui://ox_inventory/web/images/%s.png'):format(itemName) .. '?height=128'
end

---@param label string
---@param duration number
---@param canCancel? boolean
---@param anim? { dict?: string, clip: string, flag?: number, blendIn?: number, blendOut?: number, duration?: number, playbackRate?: number, lockX?: boolean, lockY?: boolean, lockZ?: boolean, scenario?: string, playEnter?: boolean }
---@param prop? { model: string, bone?: number, pos: vector3, rot: vector3, rotOrder?: number }
function showProgressBar(label, duration, canCancel, anim, prop)
    return prp.progressBar({
        duration = duration,
        label = label,
        useWhileDead = false,
        canCancel = canCancel,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = anim,
        prop = prop
    })
end

lib.callback.register('prp_fishing:progressBar', showProgressBar)

---@param options { key: string?, text: string }[]
function showTextUI(options)
    prp.showTextUI(options)
end

function hideTextUI()
    prp.hideTextUI()
end

RegisterNetEvent('prp_fishing:notify', notify)

-- Do not touch
local minigameSuccess

---@class FishingMinigame
---@field duration? number
---@field speed? number
---@field progress? { add: number?, remove: number? }

---@param data? FishingMinigame | FishingMinigame[]
---@return boolean | nil
local function fishingMinigame(data)
    if minigameSuccess then return end
    minigameSuccess = promise.new()

    SetNuiFocus(true, true)

    SendNUIMessage({
        action = 'fishingMinigame',
        data = data
    })

    return Citizen.Await(minigameSuccess)
end

----------------------------------------------------------------------------------------------------------
--- Script, don't touch unless you know what you're doing
----------------------------------------------------------------------------------------------------------

local Peds = require 'data.peds'
local Items = require 'data.items'
local Fish = require 'data.fish'
local Zones = require 'data.zones'

local Utils = require 'utils.client'

require 'modules.shops.client'
require 'modules.sell.client'
require 'modules.challenges.client'
require 'modules.rent.client'
require 'modules.anchor.client'
require 'modules.nets.client'
require 'modules.db.client'

---@type { index: integer, locationIndex: integer }?
local currentZone

for locationIndex, loc in ipairs(Peds.locations) do
    local coords = type(loc) ~= 'table' and loc or loc.coords
    local model = type(Peds.model) == 'string' and Peds.model or Utils.RandomFromTable(Peds.model)

    Utils.CreatePed(coords, model, {
        {
            label = locale('open_tablet'),
            icon = 'tablet',
            onSelect = db.openMenu,
            args = locationIndex
        }
    })

    if Peds.blip then
        Utils.CreateBlip(coords, Peds.blip)
    end
end

if Zones.zones and table.type(Zones.zones) ~= 'empty' then
    for index, data in pairs(Zones.zones) do
        for locationIndex, coords in ipairs(data.locations) do
            lib.zones.sphere({
                coords = coords.xyz,
                radius = data.radius,
                onEnter = function()
                    if currentZone?.index == index and currentZone?.locationIndex == locationIndex then return end

                    currentZone = { index = index, locationIndex = locationIndex }

                    if data.message?.enter then
                        notify(data.message.enter, 'inform')
                    end
                end,
                onExit = function()
                    if currentZone?.index ~= index and currentZone?.locationIndex ~= locationIndex then return end

                    currentZone = nil

                    if data.message?.exit then
                        notify(data.message.exit, 'inform')
                    end
                end
            })

            if data.blip then
                Utils.CreateBlip(coords, data.blip)
                Utils.CreateRadiusBlip(coords, data.radius, data.blip.color)
            end
        end
    end
end

local function hasWaterInFront()
    if IsPedSwimming(cache.ped) or IsPedInAnyVehicle(cache.ped, true) then
        return false
    end
    
    local headCoords = GetPedBoneCoords(cache.ped, 31086, 0.0, 0.0, 0.0)
    local coords = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 45.0, -27.5)
    local hasWater = TestProbeAgainstWater(headCoords.x, headCoords.y, headCoords.z, coords.x, coords.y, coords.z)

    if not hasWater then
        notify(locale('no_water'), 'error')
    end

    return hasWater
end

lib.callback.register('prp_fishing:getCurrentZone', function()
    return hasWaterInFront(), currentZone
end)

local function createRodObject()
    local model = `prop_fishing_rod_01`

    lib.requestModel(model)

    local coords = GetEntityCoords(cache.ped)
    local object = CreateObject(model, coords.x, coords.y, coords.z, true, true, false)
    local boneIndex = GetPedBoneIndex(cache.ped, 18905)

    AttachEntityToEntity(object, cache.ped, boneIndex, 0.1, 0.05, 0.0, 70.0, 120.0, 160.0, true, true, false, true, 1, true)
    SetModelAsNoLongerNeeded(model)

    return object
end

local function setCanRagdoll(state)
    SetPedCanRagdoll(cache.ped, state)
    SetPedCanRagdollFromPlayerImpact(cache.ped, state)
    SetPedRagdollOnCollision(cache.ped, not state)
end

---@param baitIndex integer
---@param hookIndex integer
---@param fishName string
lib.callback.register('prp_fishing:itemUsed', function(baitIndex, hookIndex, fishName)
    local zone = Zones.outside
    local bait = Items.baits[baitIndex]
    local fish = Fish[fishName]
    local hook = Items.hooks[hookIndex]

    local object = createRodObject()
    lib.requestAnimDict('mini@tennis')
    lib.requestAnimDict('amb@world_human_stand_fishing@idle_a')
    setCanRagdoll(false)
    showTextUI({{ key = 'E', text = locale('cancel') }})

    local p = promise.new()

    local interval = SetInterval(function()
        if IsControlPressed(0, 38)
        or (not IsEntityPlayingAnim(cache.ped, 'mini@tennis', 'forehand_ts_md_far', 3)
        and not IsEntityPlayingAnim(cache.ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 3)) then
            hideTextUI()
            p:resolve('cancel')
        end
    end, 100) --[[@as number?]]

    local function wait(milliseconds)
        Wait(milliseconds)

        return p.state == 0
    end

    CreateThread(function()
        TaskPlayAnim(cache.ped, 'mini@tennis', 'forehand_ts_md_far', 3.0, 3.0, 1500, 16, 0, false, false, false)
        
        if not wait(1500) then return end

        TaskPlayAnim(cache.ped, 'amb@world_human_stand_fishing@idle_a', 'idle_c', 3.0, 3.0, -1, 11, 0, false, false, false)

        if not wait(math.random(zone.waitTime.min, zone.waitTime.max) / bait.waitDivisor * 1000) then return end

        hideTextUI()
        notify(locale('felt_bite'), 'inform')

        if interval then
            ClearInterval(interval)
            interval = nil
        end

        if not wait(math.random(2000, 4000)) then return end

        local success = fishingMinigame((function()
            local minigames = {}
            
            if fish.catchCount then
                for i=1, fish.catchCount do
                    minigames[i] = { duration = bait?.catchTime, progress = hook?.progress and { add = hook.progress?.add, remove = hook.progress?.remove } or nil }
                end

                return minigames
            end

            table.insert(minigames, { duration = bait?.catchTime, progress = hook?.progress and { add = hook.progress?.add, remove = hook.progress?.remove } or nil })
            return minigames
        end)())

        if not success then
            notify(locale('fishing_fail'), 'error')
        end

        p:resolve(success)
    end)

    local success = Citizen.Await(p)

    if interval then
        ClearInterval(interval)
        interval = nil
    end

    DeleteEntity(object)
    ClearPedTasks(cache.ped)
    setCanRagdoll(true)

    return success
end)

RegisterNUICallback('catchFish', function (completed, cb)
    cb(1)
    SetNuiFocus(false, false)

    local promise = minigameSuccess
    minigameSuccess = nil

    promise:resolve(completed)
end)