function removeMemberFromParty(playerId, membername)
    local player = Player(playerId)
    local member = Player(membername)
    
    -- Check if player exists
    if not player or not member then
        print("Player or Member not found.")
        return
    end
    
    local party = player:getParty()
    
    -- Check if party exists
    if not party then
        print("Player is not in a party.")
        return
    end

    -- Iterates through all members of the party and remove the member if he belongs to it.
    local memberRemoved = false
    for k,v in pairs(party:getMembers()) do
        if v == member then
            party:removeMember(member)
            memberRemoved = true
        end
    end

    -- Check if member was removed from player's party
    if not memberRemoved then
        print("Member not removed from Player's party, he is not in it")
        return
    end
end