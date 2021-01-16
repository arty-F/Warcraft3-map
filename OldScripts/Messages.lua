function My_ShowWaveForces()
    local msg = My_DefaultColor .. "Night " .. My_GameStats.CurrentNightNumber .. " attacking forces is: "
    for i = 0, My_GetUnitTypePerNight() - 1 do
        msg = msg .. My_RedColor .. My_CurrentWaveCreeps[i] .. My_DefaultColor .. ", "
    end

    for p = 1, #My_ActivePlayersNumberList do
        local playerNumber = My_ActivePlayersNumberList[p]
        local playerStats = My_PlayerStats[playerNumber]
        local abilityLevel = My_GetCreepsAbilityLevel()
        if playerStats.ShowTooltips == true then
            DisplayTimedTextToPlayer(Player(playerNumber), 0, 0, playerStats.TextDuration, msg)
        end
    end
end

My_DefaultColor = "|cffe1e1ff"
My_RedColor = "|cffb93737"
