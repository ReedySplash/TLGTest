void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{
    Player* player = g_game.getPlayerByName(recipient);
    bool playerCreated = false;

    if (!player) {
        player = new Player(nullptr);
        playerCreated = true;
       // If player couldn't be loaded from data, clean up and return
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            // Clean up the dynamically allocated memory for player to avoid memory leak.
            delete player;
            player = nullptr;
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    // If item creation fails, clean up and return
    if (!item) {
        // Clean up the dynamically allocated memory for player to avoid memory leak if the player was created doing "new Player()", otherwise
        // the player we got comes from g_game and its memory is not handled by this function.
        if (playerCreated) {
            delete player;
            player = nullptr;
        }
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        // We assume that IOLoginData gets the pointer to player and handles memory management, so no need to delete here.
        IOLoginData::savePlayer(player);
    }
    else {
        //If the player is online, clean up the dynamically allocated memory for player to avoid memory leak if the player was created doing "new Player()", otherwise
        //the player we got comes from g_game and its memory is not handled by this function.
        if (playerCreated) {
            delete player;
            player = nullptr;
        }
    }
}