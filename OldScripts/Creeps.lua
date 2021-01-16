function My_RefreshCreepStats()
    for key, value in pairs(My_Creeps) do
        value["Hp"] = math.floor(value["BaseHp"] * My_GameStats.Difficulty)
        if value["BaseMana"] > 0 then
            value["Mana"] = math.floor(value["BaseMana"] * My_GameStats.Difficulty)
        end
        value["Damage"] = math.floor(value["BaseDamage"] * My_GameStats.Difficulty)
        value["Armor"] = value["BaseArmor"] * My_GameStats.Difficulty
    end
end

My_Creeps = {
    ["Ghoul"] = {
        BaseHp = 245.0,
        BaseMana = 0,
        BaseDamage = 8.0,
        BaseArmor = 2.0,
        Count = 4,
        Id = "u000",
        Scaling = 1.1,
        AbilityId = "A00B"
    },
    ["Skeleton"] = {
        BaseHp = 215.0,
        BaseMana = 0,
        BaseDamage = 22.0,
        BaseArmor = 7.0,
        Count = 3,
        Id = "u001",
        Scaling = 1,
        AbilityId = "A008"
    },
    ["Scarab"] = {
        BaseHp = 675.0,
        BaseMana = 0,
        BaseDamage = 14.0,
        BaseArmor = 5.0,
        Count = 2,
        Id = "u002",
        Scaling = 1.4,
        AbilityId = "A006"
    },
    ["Abomination"] = {
        BaseHp = 1190.0,
        BaseMana = 0,
        BaseDamage = 35.0,
        BaseArmor = 3.0,
        Count = 1,
        Id = "u003",
        Scaling = 0.65,
        AbilityId = "A004"
    },
    ["Zombie"] = {
        BaseHp = 280.0,
        BaseMana = 0,
        BaseDamage = 18.0,
        BaseArmor = 1.0,
        Count = 4,
        Id = "u004",
        Scaling = 1.25,
        AbilityId = "A009"
    },
    ["Spawn"] = {
        BaseHp = 350.0,
        BaseMana = 200.0,
        BaseDamage = 6.0,
        BaseArmor = 3.0,
        Count = 3,
        Id = "u005",
        Scaling = 1.1,
        AbilityId = "A007"
    },
    ["Gargoyle"] = {
        BaseHp = 310.0,
        BaseMana = 0,
        BaseDamage = 33.0,
        BaseArmor = 8.0,
        Count = 2,
        Id = "u006",
        Scaling = 0.9,
        AbilityId = "A000"
    },
    ["Grunt"] = {
        BaseHp = 750.0,
        BaseMana = 0,
        BaseDamage = 47.0,
        BaseArmor = 12.0,
        Count = 1,
        Id = "u007",
        Scaling = 0.95,
        AbilityId = "A00A"
    },
    ["Banshee"] = {
        BaseHp = 215.0,
        BaseMana = 100,
        BaseDamage = 9.0,
        BaseArmor = 1.0,
        Count = 4,
        Id = "u008",
        Scaling = 0.9,
        AbilityId = "A002"
    },
    ["Necromancer"] = {
        BaseHp = 310.0,
        BaseMana = 150,
        BaseDamage = 20.0,
        BaseArmor = 2.0,
        Count = 3,
        Id = "u009",
        Scaling = 0.95,
        AbilityId = "A00D"
    },
    ["Fiend"] = {
        BaseHp = 465.0,
        BaseMana = 0,
        BaseDamage = 23.0,
        BaseArmor = 3.0,
        Count = 2,
        Id = "u00A",
        Scaling = 0.7,
        AbilityId = "A00C"
    },
    ["Destroyer"] = {
        BaseHp = 875.0,
        BaseMana = 250,
        BaseDamage = 47.0,
        BaseArmor = 7.0,
        Count = 1,
        Id = "u00B",
        Scaling = 0.55,
        AbilityId = "A003"
    }
}
