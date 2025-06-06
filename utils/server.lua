local Utils = {}

function Utils.RandomFromTable(t)
    if type(t) ~= "table" or table.type(t) == 'empty' then
        error("Table is empty or received wrong type, received: %s", type(t))
    end

    local index = math.random(#t)
    return t[index], index
end

function Utils.ConcatTable(t)
    local concated = {}

    for _, data in ipairs(t) do
        if data.name then
            table.insert(concated, data.name)
        else
            table.insert(concated, data)
        end
    end

    return concated
end

local labels, ready

CreateThread(function()
    while not labels do
        local items = Framework.getItems()
        local temp = {}

        for name, item in pairs(items) do
            temp[item.name or name] = item.label or 'NULL'
        end

        labels = temp

        Wait(100)
    end

    ready = true
end)

lib.callback.register('prp_fishing:getItemLabels', function()
    while not ready do Wait(100) end

    return labels
end)

---@param name string
function Utils.GetItemLabel(name)
    return labels[name] or labels[name:upper()] or 'ITEM_NOT_FOUND'
end

return Utils