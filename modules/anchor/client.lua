---@type boolean, CKeybind
local shown, keybind = false, nil

lib.onCache('vehicle', function(vehicle)
    if not vehicle then
        if shown then
            hideTextUI()
            shown = false
        end

        return
    end

    if IsPedInAnyBoat(cache.ped) then
        local localeName = IsBoatAnchoredAndFrozen(vehicle) and 'raise_anchor' or 'anchor_boat'
        showTextUI({
            { key = keybind.currentKey, text = locale(localeName):upper() }
        })
        shown = true
    end
end)

keybind = lib.addKeybind({
    name = 'anchor_toggle',
    description = 'Toggles the anchor on your boat.',
    defaultKey = 'G',
    defaultMapper = 'keyboard',
    onReleased = function()
        if not IsPedInAnyBoat(cache.ped)
        or #GetEntityVelocity(cache.vehicle) > 3.0 then return end

        if IsBoatAnchoredAndFrozen(cache.vehicle) then
            SetBoatAnchor(cache.vehicle, false)
            showTextUI({
                { key = keybind.currentKey, text = locale('anchor_boat'):upper() }
            })
        else
            SetBoatFrozenWhenAnchored(cache.vehicle, true)
            SetBoatAnchor(cache.vehicle, true)
            showTextUI({
                { key = keybind.currentKey, text = locale('raise_anchor'):upper() }
            })
        end
    end
})