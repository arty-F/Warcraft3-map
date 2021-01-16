function My_DrawHeroSelectScreen()
    My_InitPlayersReady()
    My_DrawSelectScreenToPlayer()
end

function My_PickTimer()
    My_GameStats.PickTimer = My_GameStats.PickTimer - 1
    BlzFrameSetText(My_HeaderFrame, "Select your hero: " .. My_GameStats.PickTimer)
    if My_GameStats.PickTimer == 0 then
        DestroyTimer(GetExpiredTimer())
        My_PickHeroes()
    else
        My_CheckPlayersPrePick()
    end
end

function My_CheckPlayersPrePick()
    local result = true
    for _, v in pairs(My_ActivePlayersNumberList) do
        if My_PlayersIsReady[v] == false then
            result = false
        end
    end
    if result == true then
        DestroyTimer(GetExpiredTimer())
        My_PickHeroes()
    end
end

function My_PickHeroes()
    for _, v in pairs(My_ActivePlayersNumberList) do
        if My_PlayersPrePick[v] ~= nil then
            My_SetPlayerHero(v, My_HeroesList[My_PlayersPrePick[v]])
        else
            My_PickRandomHero(v)
        end
    end
    BlzDestroyFrame(My_MainPickFrame)
end

function My_PickRandomHero(playerIndex)
    local i = 0
    local freeHeroes = {}
    for k, v in pairs(My_HeroesList) do
        if v.CanPick == true then
            freeHeroes[i] = k
            i = i + 1
        end
    end

    local rngHeroIndex = math.random(0, i)
    My_HeroesList[freeHeroes[rngHeroIndex]].CanPick = false
    My_SetPlayerHero(playerIndex, My_HeroesList[freeHeroes[rngHeroIndex]])
end

function My_HeroClickHandler(heroName)
    local playerId = GetPlayerId(GetTriggerPlayer())
    if My_PlayersIsReady[playerId] == false then
        local hero = My_HeroesList[heroName]
        if hero.CanPick == true then
            hero.CanPick = false
            BlzFrameSetTexture(hero.Frame, hero.IconDis, 0, true)
            BlzFrameSetTexture(My_PlayersPrePickFrame[playerId], hero.IconDis, 0, true)
            if My_PlayersPrePick[playerId] ~= nil then
                My_HeroesList[My_PlayersPrePick[playerId]].CanPick = true
                BlzFrameSetTexture(
                    My_HeroesList[My_PlayersPrePick[playerId]].Frame,
                    My_HeroesList[My_PlayersPrePick[playerId]].Icon,
                    0,
                    true
                )
            end
            My_PlayersPrePick[playerId] = heroName
            if (GetTriggerPlayer() == GetLocalPlayer()) then
                BlzFrameSetText(My_DescriptionFrame, hero.Description)
            end
        end
    end
end

function My_SelectOkHandler()
    local player = GetTriggerPlayer()
    local playerId = GetPlayerId(player)
    if My_PlayersPrePick[playerId] ~= nil then
        My_PlayersIsReady[playerId] = true
        BlzFrameSetTexture(My_PlayersPrePickFrame[playerId], My_HeroesList[My_PlayersPrePick[playerId]].Icon, 0, true)
    end
    if (player == GetLocalPlayer()) then
        BlzFrameSetVisible(My_OkButton, false)
    end
end

function My_DrawSelectScreenToPlayer()
    local mainFrame = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    My_MainPickFrame = BlzCreateFrame("QuestButtonBackdropTemplate", mainFrame, 0, 0)
    BlzFrameSetAlpha(My_MainPickFrame, 230)
    BlzFrameSetPoint(My_MainPickFrame, FRAMEPOINT_CENTER, mainFrame, FRAMEPOINT_CENTER, 0, 0.07)
    BlzFrameSetSize(My_MainPickFrame, 0.55, 0.36)

    My_HeaderFrame = BlzCreateFrame("ScoreScreenTabTextSelectedTemplate", My_MainPickFrame, 0, 0)
    BlzFrameSetPoint(My_HeaderFrame, FRAMEPOINT_TOP, My_MainPickFrame, FRAMEPOINT_TOP, 0, 0)
    BlzFrameSetSize(My_HeaderFrame, 0.2, 0.05)
    BlzFrameSetText(My_HeaderFrame, "Select your hero: " .. My_GameStats.PickTimer)

    --Hero pool
    for k, v in pairs(My_HeroesList) do
        local heroFrame = BlzCreateFrame("ScoreScreenBottomButtonTemplate", My_MainPickFrame, 0, 0)
        BlzFrameSetPoint(
            heroFrame,
            FRAMEPOINT_CENTER,
            My_MainPickFrame,
            FRAMEPOINT_CENTER,
            -0.235 + My_xOffset * v.IconXpos,
            0.135 - My_yOffset * v.IconYpos
        )
        BlzFrameSetSize(heroFrame, 0.05, 0.05)
        local background = BlzGetFrameByName("ScoreScreenButtonBackdrop", 0)
        BlzFrameSetTexture(background, v.Icon, 0, true)

        local clickTrigger = CreateTrigger()
        TriggerAddAction(
            clickTrigger,
            function()
                My_HeroClickHandler(k)
            end
        )
        BlzTriggerRegisterFrameEvent(clickTrigger, heroFrame, FRAMEEVENT_CONTROL_CLICK)
        v.Frame = background
    end

    --Description
    My_DescriptionFrame = BlzCreateFrame("ScoreScreenTabTextTemplate", My_MainPickFrame, 0, 0)
    BlzFrameSetPoint(My_DescriptionFrame, FRAMEPOINT_CENTER, My_MainPickFrame, FRAMEPOINT_CENTER, 0, -0.05)
    BlzFrameSetSize(My_DescriptionFrame, 0.52, 0.09)
    BlzFrameSetText(My_DescriptionFrame, "")

    --Prepick
    for _, v in pairs(My_ActivePlayersNumberList) do
        My_PlayersPrePickFrame[v] = BlzCreateFrame("QuestButtonDisabledPushedBackdropTemplate", My_MainPickFrame, 0, 0)
        local offset = -0.285 + (My_xOffset + (My_xOffset / 4.5)) * (v + 1)
        BlzFrameSetPoint(
            My_PlayersPrePickFrame[v],
            FRAMEPOINT_CENTER,
            My_MainPickFrame,
            FRAMEPOINT_BOTTOM,
            offset,
            0.05
        )
        BlzFrameSetSize(My_PlayersPrePickFrame[v], 0.05, 0.05)
        BlzFrameSetTexture(My_PlayersPrePickFrame[v], "ReplaceableTextures/WorldEditUI/Editor-Random-Unit", 0, true)

        local nameFrame = BlzCreateFrame("ScoreScreenColumnHeaderTemplate", My_MainPickFrame, 0, 0)
        BlzFrameSetPoint(nameFrame, FRAMEPOINT_CENTER, My_MainPickFrame, FRAMEPOINT_BOTTOM, offset, 0.08)
        BlzFrameSetSize(nameFrame, 0.2, 0.05)
        BlzFrameSetText(nameFrame, GetPlayerName(Player(v)))
    end

    --Ok button
    My_OkButton = BlzCreateFrame("ScriptDialogButton", My_MainPickFrame, 0, 0)
    BlzFrameSetPoint(My_OkButton, FRAMEPOINT_TOP, My_MainPickFrame, FRAMEPOINT_BOTTOM, 0, 0.0045)
    BlzFrameSetSize(My_OkButton, 0.1, 0.04)
    BlzFrameSetText(My_OkButton, "Ok")

    local okTrigger = CreateTrigger()
    TriggerAddAction(okTrigger, My_SelectOkHandler)
    BlzTriggerRegisterFrameEvent(okTrigger, My_OkButton, FRAMEEVENT_CONTROL_CLICK)
end

function My_InitPlayersReady()
    for _, v in pairs(My_ActivePlayersNumberList) do
        My_PlayersIsReady[v] = false
    end
end

My_xOffset = 0.052
My_yOffset = 0.052
My_MainPickFrame = nil
My_DescriptionFrame = nil
My_HeaderFrame = nil
My_OkButton = nil
My_PlayersIsReady = {}
My_PlayersPrePick = {}
My_PlayersPrePickFrame = {}
