function My_InitializeWaveCreepsTable()
	local i = 0
    	for key,value in pairs(My_Creeps) do
		My_WaveCreepsTable[i] = key
		i = i + 1
	end
end


function My_TheNightCome()
	My_GameStats.CurrentWaveNumber = 0
	My_GameStats.CurrentNightNumber = My_GameStats.CurrentNightNumber + 1
	My_SelectCurrentWaveCreeps()
end


function My_SelectCurrentWaveCreeps()
	local indexes = {}
	for i = 0, My_GetUnitTypePerNight() - 1 do
		local isUnique
		repeat
			isUnique = true
			indexes[i] = math.random(0, #My_WaveCreepsTable)
			if i > 0 then
				for j = 0, i - 1 do
					if indexes[i] == indexes[j] then
						isUnique = false
					end
				end
			end
		until isUnique == true
		My_CurrentWaveCreeps[i] = My_WaveCreepsTable[indexes[i]]
	end
	My_ShowWaveForces()
end


function My_CheckStopedUnits()
	for index = BlzGroupGetSize(My_CreepsGroup) - 1, 0, -1 do
		local unit = BlzGroupUnitAt(My_CreepsGroup, index)
		if GetUnitLifePercent(unit) <= 0 then
			GroupRemoveUnit(My_CreepsGroup, unit)
		else
			if GetUnitCurrentOrder(unit) == 0 then 
				IssuePointOrderLocBJ(unit, "attack", GetRandomLocInRect(udg_Base) )
			end
		end
	end
end


function My_AddEliteAbility(unit, abilityId)
	local abilityLevel = My_GetCreepsAbilityLevel()
	if abilityLevel > 10 then
		abilityLevel = 10
	end

	if GetUnitAbilityLevel(unit, FourCC(abilityId)) == 0 then
		UnitAddAbility(unit, FourCC(abilityId))
	end
	SetUnitAbilityLevel(unit, FourCC(abilityId), abilityLevel)
	BlzSetUnitAbilityManaCost(unit, FourCC(abilityId), abilityLevel, 0)
end


function My_GetCreepsAbilityLevel()
	return math.floor( My_GameStats.Difficulty / 2 )
end


function My_GetPackCount()
	return 2 + My_GameStats.PlayersInGame + math.floor(My_GameStats.Difficulty / 4)
end


function My_GetEliteChance()
	return  math.floor(6 + ( My_GameStats.CurrentWaveNumber * 2 ) + ( My_GameStats.Difficulty * 2 ))
end


function My_GetBossChance()
	return  math.floor(4 + ( My_GameStats.CurrentWaveNumber * 3 ) + ( My_GameStats.Difficulty * 2 ))
end


function My_GetUnitTypePerNight()
	return 3
end


function My_UpgrageStats(unit, unitType, additionalMultiplier)
	local name = GetUnitName(unit)
	BlzSetUnitMaxHP(unit, My_Creeps[name].Hp * additionalMultiplier)
	SetUnitLifePercentBJ(unit, 100)
	if My_Creeps[name].BaseMana > 0 then
		BlzSetUnitMaxMana(unit, My_Creeps[name].Mana * additionalMultiplier)
		SetUnitManaPercentBJ(unit, 100)
	end
	BlzSetUnitBaseDamage(unit, My_Creeps[name].Damage * additionalMultiplier, 0)
	BlzSetUnitArmor(unit, My_Creeps[name].Armor * additionalMultiplier)
end


function My_UpgradeToElite(unit, unitType, additionalMultiplier)
	local scale = 1.4 * unitType.Scaling
	SetUnitScale(unit, scale, scale, scale)
	SetUnitVertexColor(unit, 110, 110, 110, 255)
	My_UpgrageStats(unit, unitType, additionalMultiplier)
	My_AddEliteAbility(unit, unitType.AbilityId)
end


function My_UpgradeToBoss(unit, unitType, additionalMultiplier)
	local scale = 1.8 * unitType.Scaling
	SetUnitScale(unit, scale, scale, scale)
	SetUnitVertexColor(unit, 125, 30, 30, 255)
	My_UpgrageStats(unit, unitType, additionalMultiplier)
	My_AddEliteAbility(unit, unitType.AbilityId)
end


function My_CreateUnit(unitType, upgradeFunction, respId, additionalMultiplier, unitGroup)
    	local unit = CreateUnitAtLoc(Player(11), FourCC(unitType.Id), GetRandomLocInRect(udg_UdResp[respId]), 270)
	IssuePointOrderLocBJ(unit, "attack", GetRandomLocInRect(udg_Base) )
	GroupAddUnit(unitGroup, unit)
	upgradeFunction(unit, unitType, additionalMultiplier)
end


function My_CreateCreeps()
	local time = GetTimeOfDay()
	if (time > 18 or time < 6) or (not My_GameStats.BaseIsAlive) then
		if BlzGroupGetSize(My_CreepsGroup) > 100 then return end
		My_GameStats.CurrentWaveNumber = My_GameStats.CurrentWaveNumber + 1
		print('Wave '..My_GameStats.CurrentWaveNumber)
		local packCount = My_GetPackCount()
		
		for p = 1, packCount do
			local respId = GetRandomInt(0, #udg_UdResp)
			local unitType = My_Creeps[My_CurrentWaveCreeps[math.random(0, #My_CurrentWaveCreeps)]]
			local upgradeFunc = My_UpgrageStats
			local additionalMultiplier = 1
			local eliteChance = My_GetEliteChance()
			if math.random( 1, 100 ) <= eliteChance then
				upgradeFunc = My_UpgradeToElite
				additionalMultiplier = My_GameStats.ElitePower
			end
			for i = 1, unitType.Count do
				My_CreateUnit(unitType, upgradeFunc, respId, additionalMultiplier, My_CreepsGroup)
			end	
		end

		local bossChance = My_GetBossChance()
		repeat
			if math.random( 1, 100 ) <= bossChance then
				local unitType = My_Creeps[My_CurrentWaveCreeps[math.random(0, #My_CurrentWaveCreeps)]]
				My_CreateUnit(unitType, My_UpgradeToBoss, GetRandomInt(0, #udg_UdResp), unitType.Count * My_GameStats.BossPower, My_CreepsGroup)
			end
			bossChance = bossChance - 100
		until bossChance <= 0
	end
end


My_CreepsGroup = CreateGroup()

My_WaveCreepsTable = {}

My_CurrentWaveCreeps = {}