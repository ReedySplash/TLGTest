function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
    
    --We need to iterate through all results and print each guild name if we found any
    if resultId then
        repeat
            local guildName = result.getDataString(resultId, "name")
            print(guildName)
        until not result.next(resultId)
    else
        print("No results found or query failed.")
        return
    end

    -- Free the result set
    result.free(resultId)
end