do
    local InitGlobalsOrigin = InitGlobals
    function InitGlobals()
        InitGlobalsOrigin()

        --ИНИЦИАЛИЗАЦИЯ ОСНОВНЫХ ЗНАЧЕНИЙ
        SetTimeOfDay(17.8)
        TimerStart(CreateTimer(), 20, true, My_CreateCreeps) --СОЗДАНИЕ КРИПОВ
        TimerStart(CreateTimer(), 1, true, My_CheckStopedUnits) --ПРОВЕРКА ОСТАНОВИВШИХСЯ ЮНИТОВ
        My_RefreshInGamePlayers()
        My_InitializePlayerStats()
        My_InitializeHeroStats()
        My_SetBaseDifficulty()
        My_RefreshCreepStats()
        --

        --РЕГИСТРАЦИЯ СОБЫТИЯ "НАСТУПАЕТ НОЧЬ" ВЫБОР КРИПОВ ДЛЯ ВОЛН
        My_InitializeWaveCreepsTable()
        local trigSelectCreeps = CreateTrigger()
        TriggerRegisterGameStateEventTimeOfDay(trigSelectCreeps, EQUAL, 18.00)
        TriggerAddAction(trigSelectCreeps, My_TheNightCome)
        --

        My_DrawHeroSelectScreen()
        TimerStart(CreateTimer(), 1, true, My_PickTimer)
    end
end
