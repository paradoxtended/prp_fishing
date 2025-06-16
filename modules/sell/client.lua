RegisterNUICallback('getSellableFishes', function (_, cb)
    local fishes = lib.callback.await('prp_fishing:getPlayerFishes', false)
    cb(fishes)
end)

RegisterNUICallback('sellFishes', function (fishes, cb)
    if not fishes or #fishes == 0 then
        notify(locale('nothing_to_sell'), 'error')
        cb(false)
        
        return
    end

    local price = lib.callback.await('prp_fishing:sellFish', false, fishes)

    if not price then
        cb(false)
        return
    end
    
    notify(locale('sold_fish', price), 'success')
    cb(true)
end)