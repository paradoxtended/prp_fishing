---@diagnostic disable: duplicate-set-field
---@diagnostic disable: duplicate-doc-field

if GetResourceState('qb-core') ~= 'started' then return end

Framework = { name = 'qb-core' }
local sharedObject = exports['qb-core']:GetCoreObject()
Framework.object = sharedObject

function Framework.isPlayerLoaded()
    return next(sharedObject.Functions.GetPlayerData()) ~= nil
end

Framework.onPlayerLoaded = function(cb)
    if Framework.isPlayerLoaded() then
        cb()
    end

    AddEventHandler('QBCore:Client:OnPlayerLoaded', cb)
end

Framework.onPlayerLogout = function(cb)
    AddEventHandler('QBCore:Client:OnPlayerUnload', cb)
end

function Framework.getJob()
    if not Framework.isPlayerLoaded() then
        return false
    end

    return sharedObject.Functions.GetPlayerData().job.name
end

function Framework.getJobGrade()
    return sharedObject.Functions.GetPlayerData().job.grade.level
end

Framework.hasItem = function(name)
    return exports.ox_inventory:GetItemCount(name) > 0
end

Framework.getInventory = function()
    return sharedObject.Functions.GetPlayerData().items
end

---@param name 'hunger' | 'thirst'
---@return integer
Framework.getStatus = function(name)
    local playerState = sharedObject.Functions.GetPlayerData()

    -- compatibility for ESX style values
    return playerState.Functions.GetMetaData(name) * 10000
end

---@param values table<'hunger' | 'thirst', integer>
Framework.setStatus = function(values)
    local playerState = sharedObject.Functions.GetPlayerData()
    for name, value in pairs(values) do
        -- compatibility for ESX style values
        if value > 100 or value < -100 then
            value = value * 0.0001
        end

        playerState.Functions.SetMetaData(name, playerState.Functions.GetMetaData(name) + value)
    end
end

function Framework.spawnVehicle(model, coords, heading, cb)
    sharedObject.Functions.SpawnVehicle(model, cb, vector4(coords.x, coords.y, coords.z, heading), true)
end

function Framework.spawnLocalVehicle(model, coords, heading, cb)
    sharedObject.Functions.SpawnVehicle(model, cb, vector4(coords.x, coords.y, coords.z, heading), false)
end

Framework.getIdentifier = function()
    local playerData = sharedObject.Functions.GetPlayerData()
    return playerData.citizenid
end

Framework.getCharacterName = function()
    local playerData = sharedObject.Functions.GetPlayerData()
    return playerData.charinfo.firstname .. ' ' .. playerData.charinfo.lastname
end

Framework.deleteVehicle = sharedObject.Functions.DeleteVehicle

Framework.getPlayersInArea = sharedObject.Functions.GetPlayersFromCoords