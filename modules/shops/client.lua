---@param data { cart: { name: string, count: number }[], type: 'bank' | 'money' }
RegisterNUICallback('buyItem', function(data, cb)
    local success = lib.callback.await('prp_fishing:buyItem', false, data)

    if success then
        notify(locale('purchased'), 'success')
    elseif success == false then
        notify(locale('not_enough_' .. data.type), 'error')
    end

    cb(success)
end)