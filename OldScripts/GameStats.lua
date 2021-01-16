function My_RefreshInGamePlayers()
    local index = 1
    for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
        local player = Player(i)
        if GetPlayerController(player) == MAP_CONTROL_USER and GetPlayerSlotState(player) == PLAYER_SLOT_STATE_PLAYING then
            My_GameStats.PlayersInGame = My_GameStats.PlayersInGame + 1
            My_ActivePlayersNumberList[index] = i
            index = index + 1
        end
    end
end

function My_InitializePlayerStats()
    for i = 1, #My_ActivePlayersNumberList do
        My_PlayerStats[My_ActivePlayersNumberList[i]] = {}
        My_PlayerStats[My_ActivePlayersNumberList[i]].ShowTooltips = true
        My_PlayerStats[My_ActivePlayersNumberList[i]].TextDuration = 6
    end
end

function My_InitializeHeroStats()
    for i = 1, #My_ActivePlayersNumberList do
        My_HeroStats[My_ActivePlayersNumberList[i]] = {}
        My_HeroStats[My_ActivePlayersNumberList[i]].Power = 2
    end
end

function My_SetBaseDifficulty()
    My_GameStats.Difficulty = 1.0
end

My_GameStats = {
    BaseIsAlive = true,
    PlayersInGame = 0,
    PickTimer = 25,
    Difficulty = 1.0,
    DifficultyIncome = 0,
    CurrentWaveNumber = 0,
    CurrentNightNumber = 0,
    CreepsAbilityLevel = 0,
    BossPower = 3,
    ElitePower = 2
}

My_HeroStats = {}

My_PlayerStats = {}

My_ActivePlayersNumberList = {}
