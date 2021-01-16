function My_InitializePlayerStats()
	for _,v in pairs(My_ActivePlayersNumberList) do
		My_PlayerStats[v] = {}
		My_PlayerStats[v].CritChance = 10
		My_PlayerStats[v].CritDamage = 1.5
		My_PlayerStats[v].Block = 0
		My_PlayerStats[v].Power = 100
		My_PlayerStats[v].Range = 100
		My_PlayerStats[v].Duration = 100
		My_PlayerStats[v].Shield = 0
		My_PlayerStats[v].CdReduction = 0
		My_PlayerStats[v].MeleeDamage = 100
		My_PlayerStats[v].RangeDamage = 100
		My_PlayerStats[v].MagicDamage = 100
		My_PlayerStats[v].HealBonus = 100
	end
	My_DrawStatsFrame()
end


function My_DrawStatsFrame()
	local mainFrame = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    	My_PlayerStatsFrameIcon = BlzCreateFrame('ScoreScreenBottomButtonTemplate', mainFrame, 0, 0)
    	BlzFrameSetPoint(My_PlayerStatsFrameIcon, FRAMEPOINT_CENTER, mainFrame, FRAMEPOINT_BOTTOM, 0.078, 0.068)
	BlzFrameSetSize(My_PlayerStatsFrameIcon, 0.035, 0.035)
	BlzFrameSetVisible(My_PlayerStatsFrameIcon, false)

	local showStatsTrigger = CreateTrigger()
	local hideStatsTrigger = CreateTrigger()
	for _,v in pairs(My_ActivePlayersNumberList) do
		TriggerRegisterPlayerSelectionEventBJ(showStatsTrigger, Player(v), true)
		TriggerRegisterPlayerSelectionEventBJ(hideStatsTrigger, Player(v), false)
	end
	TriggerAddAction(showStatsTrigger, My_ShowPlayerStatsFrame)
	TriggerAddAction(hideStatsTrigger, My_HidePlayerStatsFrame)

	BlzFrameClearAllPoints(BlzGetFrameByName('InfoPanelIconHeroIcon', 6))
	BlzFrameClearAllPoints(BlzGetFrameByName('InfoPanelIconHeroStrengthLabel', 6))

	local background = BlzGetFrameByName('ScoreScreenButtonBackdrop', 0)
	BlzFrameSetTexture(background, 'ReplaceableTextures/CommandButtons/BTNSelectHeroOn', 0, true)

	local tooltipFrame = BlzCreateFrame('ListBoxWar3', mainFrame, 0, 0)
	BlzFrameSetSize(tooltipFrame, 0.16, 0.24)
	BlzFrameSetPoint(tooltipFrame, FRAMEPOINT_BOTTOMRIGHT, mainFrame, FRAMEPOINT_BOTTOMRIGHT, 0, 0.17)
	BlzFrameSetTooltip(My_PlayerStatsFrameIcon, tooltipFrame)

	My_PlayerStatsFrame = BlzCreateFrameByType('TEXT', 'StandardInfoTextTemplate', tooltipFrame, '', 0)
	BlzFrameSetSize(My_PlayerStatsFrame, 0.04, 0.24)
	BlzFrameSetPoint(My_PlayerStatsFrame, FRAMEPOINT_RIGHT, tooltipFrame, FRAMEPOINT_RIGHT, 0, 0)
	BlzFrameSetTextAlignment(My_PlayerStatsFrame, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)

	local playerStatsHeaders = BlzCreateFrameByType('TEXT', 'StandardInfoTextTemplate', tooltipFrame, '', 0)
	BlzFrameSetSize(playerStatsHeaders, 0.13, 0.24)
	BlzFrameSetPoint(playerStatsHeaders, FRAMEPOINT_CENTER, tooltipFrame, FRAMEPOINT_CENTER, 0, 0)
	BlzFrameSetTextAlignment(playerStatsHeaders, TEXT_JUSTIFY_MIDDLE, TEXT_JUSTIFY_LEFT)
	My_SetPlayerStatsFrameHeadersText(playerStatsHeaders)

	local mouseEnterTrigger = CreateTrigger()
	TriggerAddAction(mouseEnterTrigger, My_SetPlayerStatsFrameText)
	BlzTriggerRegisterFrameEvent(mouseEnterTrigger, My_PlayerStatsFrameIcon, FRAMEEVENT_MOUSE_ENTER)
end


function My_SetPlayerHero(playerIndex, hero)
	local player = Player(playerIndex)
	My_PlayerHeroes[playerIndex] = CreateUnitAtLoc(Player(playerIndex), FourCC(hero.Id), GetRandomLocInRect(udg_Base), 270)
	SetCameraPositionForPlayer(player, GetUnitX(My_PlayerHeroes[playerIndex]), GetUnitY(My_PlayerHeroes[playerIndex]))
	SelectUnitForPlayerSingle(My_PlayerHeroes[playerIndex], player)
	My_PlayerStats[playerIndex].BaseHp = hero.Hp
	My_PlayerStats[playerIndex].Hp = hero.Hp
	My_PlayerStats[playerIndex].HpRegen = hero.HpRegen
	My_PlayerStats[playerIndex].BaseMp = hero.Mp
	My_PlayerStats[playerIndex].Mp = hero.Mp
	My_PlayerStats[playerIndex].MpRegen = hero.MpRegen
	My_PlayerStats[playerIndex].Armor = hero.Armor
end


function My_ShowPlayerStatsFrame()
	if (GetTriggerPlayer() == GetLocalPlayer()) then
		local playerId = GetPlayerId(GetTriggerPlayer())
		if (GetTriggerUnit() == My_PlayerHeroes[playerId]) then
			BlzFrameSetVisible(My_PlayerStatsFrameIcon, true)
		end
	end
end


function My_HidePlayerStatsFrame()
	if (GetTriggerPlayer() == GetLocalPlayer()) then
		local playerId = GetPlayerId(GetTriggerPlayer())
		if (GetTriggerUnit() == My_PlayerHeroes[playerId]) then
			BlzFrameSetVisible(My_PlayerStatsFrameIcon, false)
		end
	end
end


function My_SetPlayerStatsFrameHeadersText(frame)
	BlzFrameSetText(frame, 
		'Base Hp:'..
		'\nCurrent Hp:'..
		'\nHp regen:'..
		'\n'..
		'\nBase Mp:'..
		'\nCurrent Mp:'..
		'\nMp regen:'..
		'\n'..
		'\nArmor:'..
		'\nBlock chance:'..
		'\n'..
		'\nPower:'..
		'\nRange:'..
		'\nDuration:'..
		'\n'..
		'\nCrit chance:'..
		'\nCrit damage:'..
		'\n'..
		'\nSlash damage:'..
		'\nPierce damage:'..
		'\nMagick damage:'..
		'\nHeal bonus:'
		)
end


function My_SetPlayerStatsFrameText()
	if(GetTriggerPlayer()==GetLocalPlayer())then
		local playerId = GetPlayerId(GetTriggerPlayer())
	
		BlzFrameSetText(My_PlayerStatsFrame, 
			My_PlayerStats[playerId].BaseHp..
			'\n'..My_PlayerStats[playerId].Hp..
			'\n'..My_PlayerStats[playerId].HpRegen..
			'\n'..
			'\n'..My_PlayerStats[playerId].BaseMp..
			'\n'..My_PlayerStats[playerId].Mp..
			'\n'..My_PlayerStats[playerId].MpRegen..
			'\n'..
			'\n'..My_PlayerStats[playerId].Armor..
			'\n'..My_PlayerStats[playerId].Block..
			'\n'..
			'\n'..My_PlayerStats[playerId].Power..
			'\n'..My_PlayerStats[playerId].Range..
			'\n'..My_PlayerStats[playerId].Duration..
			'\n'..
			'\n'..My_PlayerStats[playerId].CritChance..
			'\n'..My_PlayerStats[playerId].CritDamage..
			'\n'..
			'\n'..My_PlayerStats[playerId].SlashDamage..
			'\n'..My_PlayerStats[playerId].PierceDamage..
			'\n'..My_PlayerStats[playerId].MagicDamage..
			'\n'..My_PlayerStats[playerId].HealBonus
			)
	end
end


My_PlayerStats = {}

My_PlayerHeroes = {}

My_PlayerStatsFrameIcon = nil

My_PlayerStatsFrame = nil