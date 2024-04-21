local function releaseStorage(player, id)
    player:setStorageValue(id, -1)
end

function onLogout(player)
    -- Check if player doesn't exist before operating on it to avoid accessing nil.
    if player and player:getStorageValue(1000) == 1 then
        --If "1000" is an ID of a storage, the best way to release the storage is by using an argument that allows us to release different storages as needed.
        --Event seems to be no necessary, we don't need to call the function 1s later, so I remove it and put the call directly.
        releaseStorage(player, 1000)
    end
    return true
end