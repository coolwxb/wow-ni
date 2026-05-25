local build = select(4, GetBuildInfo());
local wotlk = build == 30300 or false;
if wotlk then
local items = {
	settingsfile = "Mage - Fire PvE by Dreams.json",
	{ type = "title", text = "Mage - Fire PvE by |c0000CED1Dreams" },
	{ type = "separator" },
	{ type = "title", text = "|cffFFFF00Settings" },
	{ type = "entry", text = "\124T"..GetItemIcon(36799)..":26:26\124t Use Mana Gem < MP%", tooltip = "Use Mana Gem < MP%", enabled = true, value = 70, key = "ManaGem" },
	{
		type = "entry",
		text = "Enable AOE",
		tooltip = "When nearby enemy count reaches this number, switch to AoE mode.",
		enabled = true,
		key = "UseAOE"
	},
	{
		type = "entry",
		text = "AOE Count",
		tooltip = "AoE starts when the enemy count in range >= this value.",
		enabled = true,
		value = 3,
		key = "AoeCount"
	},
	{
		type = "entry",
		text = "Mark Target Skull",
		tooltip = "Mark current attack target as Skull.",
		enabled = false,
		key = "MarkSkull"
	},
	{
		type = "entry",
		text = "\124T"..select(3, GetSpellInfo(45438))..":26:26\124t Ice Block < HP%",
		tooltip = "Emergency cast when HP falls below this value.",
		enabled = true,
		value = 15,
		key = "IceBlock"
	},
	{
		type = "entry",
		text = "\124T"..GetItemIcon(36194)..":26:26\124t Fel Healthstone < HP%",
		tooltip = "Use Fel Healthstone when HP falls below this value.",
		enabled = true,
		value = 35,
		key = "FelHealthstone"
	},
	{
		type = "entry",
		text = "\124T"..GetItemIcon(33447)..":26:26\124t Runic Healing Potion < HP%",
		tooltip = "Use Runic Healing Potion when HP falls below this value.",
		enabled = true,
		value = 30,
		key = "RunicHealingPotion"
	},
	{
		type = "entry",
		text = "\124T"..select(3, GetSpellInfo(1953))..":26:26\124t Blink < HP%",
		tooltip = "Emergency Blink when HP falls below this value.",
		enabled = true,
		value = 25,
		key = "Blink"
	},
	{
		type = "entry",
		text = "\124T"..select(3, GetSpellInfo(1463))..":26:26\124t Mana Shield < HP%",
		tooltip = "Use Mana Shield when HP falls below this value.",
		enabled = true,
		value = 45,
		key = "ManaShield"
	},
	{
		type = "entry",
		text = "\124T"..select(3, GetSpellInfo(11426))..":26:26\124t Ice Barrier < HP%",
		tooltip = "Use Ice Barrier when HP falls below this value.",
		enabled = true,
		value = 55,
		key = "IceBarrier"
	},
	{
		type = "entry",
		text = "\124T"..select(3, GetSpellInfo(6143))..":26:26\124t Frost Ward < HP%",
		tooltip = "Keep Frost Ward for low HP moments.",
		enabled = true,
		value = 70,
		key = "FrostWard"
	},
	{
		type = "entry",
		text = "\124T"..select(3, GetSpellInfo(122))..":26:26\124t Frost Nova < HP%",
		tooltip = "Use Frost Nova when HP falls below this value.",
		enabled = true,
		value = 30,
		key = "FrostNova"
	},
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(12051))..":26:26\124t Use Evocation < MP%", tooltip = "Use Evocation < MP%", enabled = true, value = 10, key = "Evocation" },
	{ type = "entry", text = "\124T"..GetItemIcon(33448)..":26:26\124t Runic Mana Potion < MP%", tooltip = "Use Runic Mana Potion when MP falls below this value.", enabled = true, value = 20, key = "RunicManaPotion" },
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(55342))..":26:26\124t Use Mirror Image", tooltip = "Use Mirror Image", enabled = true, key = "MirrorImage" },
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(12472))..":26:26\124t Use Icy Veins", tooltip = "Use Icy Veins", enabled = true, key = "IcyVeins" },
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(11129))..":26:26\124t Use Combustion", tooltip = "Use Combustion", enabled = true, key = "Combustion" },
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(42859))..":26:26\124t Use Scorch", tooltip = "Use Scorch", enabled = true, key = "Scorch" },
	{ type = "entry", text = "\124T"..select(3, GetSpellInfo(42873))..":26:26\124t Use Fireblast while moving", tooltip = "Use Fireblast", enabled = true, key = "Fireblast" },
};
 
local function GetSetting(name)
    for k, v in ipairs(items) do
        if v.type == "entry"
         and v.key ~= nil
         and v.key == name then
            return v.value, v.enabled
        end
    end
end;

local function OnLoad()
	ni.GUI.AddFrame("Mage - Fire PvE by Dreams", items);
end

local function OnUnLoad()  
	ni.GUI.DestroyFrame("Mage - Fire PvE by Dreams");
end

local function ResolveSpell(candidates)
    if IsSpellKnown then
        for _, id in ipairs(candidates) do
            local name = GetSpellInfo(id);
            if name ~= nil and IsSpellKnown(id) then
                return { id = id, name = name };
            end
        end
    end

    for _, id in ipairs(candidates) do
        local name = GetSpellInfo(id);
        if name ~= nil then
            return { id = id, name = name };
        end
    end
    return { id = candidates[1], name = GetSpellInfo(candidates[1]) };
end

local spells = {
	ConjureManaGem = {id = 42985, name = GetSpellInfo(42985)},
	MoltenArmor = {id = 43046, name = GetSpellInfo(43046)},
	ArcaneBrilliance = {id = 43002, name = GetSpellInfo(43002)},
	Evocation = {id = 12051, name = GetSpellInfo(12051)},
	Pyroblast = ResolveSpell({42891, 11366}),
	Scorch = {id = 42859, name = GetSpellInfo(42859)},
	LivingBomb = ResolveSpell({55360, 44457}),
	MirrorImage = {id = 55342, name = GetSpellInfo(55342)},
	IcyVeins = {id = 12472, name = GetSpellInfo(12472)},
	Combustion = {id = 11129, name = GetSpellInfo(11129)},
	Fireblast = {id = 42873, name = GetSpellInfo(42873)},
	Fireball = {id = 42833, name = GetSpellInfo(42833)},
	IceBlock = ResolveSpell({45438}),
	Blink = ResolveSpell({1953}),
	ManaShield = ResolveSpell({1463}),
	IceBarrier = ResolveSpell({11426}),
	FrostWard = ResolveSpell({6143}),
	FrostNova = ResolveSpell({122})
};

local manaGemIds = {36799, 33312};

local function HasManaGem()
	for _, itemId in ipairs(manaGemIds) do
		if ni.player.hasitem(itemId) then
			return true, itemId;
		end
	end
	return false, nil;
end

local queue = {
    "Molten Armor",
    "Arcane Brilliance",
	"Target Switch",
	"Skull Mark",
	"Defensive",
	"Conjure Mana Gem",
	"Mana Gem",
	"Runic Mana Potion",
	"Fireblast",
    "Evocation",
    "Pyroblast",
    "Living Bomb",
    "Scorch",
	"Mirror Image",
	"Icy Veins",
    "Combustion",
    "Fireball"
};

local function enemyCount(range)
    local enemies = ni.player.enemiesinrange(range or 10) or {};
    return #enemies;
end

local function useAoe()
	local _, enabled = GetSetting("UseAOE");
	if enabled ~= true then
		return false;
	end
	local thresholdValue = GetSetting("AoeCount");
	local threshold = tonumber(thresholdValue) or 3;
	return threshold > 0 and enemyCount(10) >= threshold;
end

local function castLivingBombAtMissingTarget(range)
	range = range or 10;
	local enemies = ni.player.enemiesinrange(range) or {};

	for i = 1, #enemies do
		if enemies[i] ~= nil and enemies[i].guid ~= nil then
			local guid = enemies[i].guid;
			if ni.unit.debuff(guid, spells.LivingBomb.id, "player") == nil then
				if UnitGUID("target") ~= guid then
					ni.player.runtext("/cleartarget");
					ni.player.target(guid);
				end
				if not ni.unit.isfacing("player", "target", 90) then
					ni.player.lookat("target");
				end
				ni.spell.cast(spells.LivingBomb.name, "target");
				return true;
			end
		end
	end
	return false;
end

local function isBossOrElite(unit)
	return ni.unit.isboss(unit) or (ni.unit.iselite ~= nil and ni.unit.iselite(unit));
end

local function hasAttackableTarget(unit)
	unit = unit or "target";
	if not UnitExists(unit) or UnitIsDeadOrGhost(unit) then
		return false;
	end
	if not UnitCanAttack("player", unit) then
		return false;
	end
	return true;
end

local function switchTarget(unit)
	if not hasAttackableTarget(unit) then
		return false;
	end
	local guid = UnitGUID(unit);
	if guid == nil then
		return false;
	end
	if UnitGUID("target") ~= guid then
		ni.player.runtext("/cleartarget");
		ni.player.target(guid);
	end
	if not ni.unit.isfacing("player", "target", 90) then
		ni.player.lookat("target");
	end
	return true;
end

local function switchToTankTarget()
	if switchTarget("targettarget") then
		return true;
	end
	if switchTarget("focustarget") then
		return true;
	end
	if ni.tanks ~= nil then
		local mainTank = ni.tanks();
		if mainTank ~= nil and mainTank.unit ~= nil and switchTarget(mainTank.unit .. "target") then
			return true;
		end
	end
	return false;
end

local function playerHP()
	local hp = ni.unit.hp("player");
	if hp ~= nil then
		return hp;
	end
	local cur = UnitHealth("player");
	local max = UnitHealthMax("player");
	if cur == nil or max == nil or max == 0 then
		return 100;
	end
	return (cur / max) * 100;
end

local abilities = {
	["Molten Armor"] = function()
		if ni.spell.available(spells.MoltenArmor.id)
			and not ni.unit.ischanneling("player")
			and not ni.player.buff(spells.MoltenArmor.id) then
				ni.spell.cast(spells.MoltenArmor.name)
				return true;
		end
	end,

	["Arcane Brilliance"] = function()
		if ni.spell.available(spells.ArcaneBrilliance.id) 
			and not ni.player.buff(spells.ArcaneBrilliance.id) then
				ni.spell.cast(spells.ArcaneBrilliance.name)
				return true;
		end
	end, 

	["Target Switch"] = function()
		if UnitAffectingCombat("player") and not UnitExists("target") then
			return switchToTankTarget();
		end
		if UnitExists("target") and UnitIsDeadOrGhost("target") then
			return switchToTankTarget();
		end
	end,

	["Skull Mark"] = function()
	local _, enabled = GetSetting("MarkSkull")
		if enabled == true
			and hasAttackableTarget("target")
			and GetRaidTargetIndex("target") ~= 8 then
				SetRaidTarget("target", 8)
				return true;
		end
	end,

	["Defensive"] = function()
		if not UnitAffectingCombat("player") then
			return;
		end
		if ni.unit.ischanneling("player") then
			return;
		end
		local hp = playerHP();

		local thresholdFelHealthstone, enabledFelHealthstone = GetSetting("FelHealthstone");
		if enabledFelHealthstone == true
			and thresholdFelHealthstone ~= nil
			and hp <= tonumber(thresholdFelHealthstone)
			and ni.player.hasitem(36194)
			and ni.player.itemcd(36194) < 1 then
				ni.player.useitem(36194)
				return true;
		end

		local thresholdRunicHealingPotion, enabledRunicHealingPotion = GetSetting("RunicHealingPotion");
		if enabledRunicHealingPotion == true
			and thresholdRunicHealingPotion ~= nil
			and hp <= tonumber(thresholdRunicHealingPotion)
			and ni.player.hasitem(33447)
			and ni.player.itemcd(33447) < 1 then
				ni.player.useitem(33447)
				return true;
		end

		local thresholdIceBlock, enabledIceBlock = GetSetting("IceBlock");
		if enabledIceBlock == true
			and thresholdIceBlock ~= nil
			and hp <= tonumber(thresholdIceBlock)
			and spells.IceBlock ~= nil
			and spells.IceBlock.id ~= nil
			and spells.IceBlock.name ~= nil
			and not ni.player.buff(spells.IceBlock.id)
			and ni.spell.available(spells.IceBlock.id) then
				ni.spell.cast(spells.IceBlock.name)
				return true;
		end

		local thresholdBlink, enabledBlink = GetSetting("Blink");
		if enabledBlink == true
			and thresholdBlink ~= nil
			and hp <= tonumber(thresholdBlink)
			and spells.Blink ~= nil
			and spells.Blink.id ~= nil
			and spells.Blink.name ~= nil
			and ni.spell.available(spells.Blink.id) then
				ni.spell.cast(spells.Blink.name)
				return true;
		end

		local thresholdManaShield, enabledManaShield = GetSetting("ManaShield");
		if enabledManaShield == true
			and thresholdManaShield ~= nil
			and hp <= tonumber(thresholdManaShield)
			and spells.ManaShield ~= nil
			and spells.ManaShield.id ~= nil
			and spells.ManaShield.name ~= nil
			and not ni.player.buff(spells.ManaShield.id)
			and ni.spell.available(spells.ManaShield.id) then
				ni.spell.cast(spells.ManaShield.name)
				return true;
		end

		local thresholdIceBarrier, enabledIceBarrier = GetSetting("IceBarrier");
		if enabledIceBarrier == true
			and thresholdIceBarrier ~= nil
			and hp <= tonumber(thresholdIceBarrier)
			and spells.IceBarrier ~= nil
			and spells.IceBarrier.id ~= nil
			and spells.IceBarrier.name ~= nil
			and not ni.player.buff(spells.IceBarrier.id)
			and ni.spell.available(spells.IceBarrier.id) then
				ni.spell.cast(spells.IceBarrier.name)
				return true;
		end

		local thresholdFrostWard, enabledFrostWard = GetSetting("FrostWard");
		if enabledFrostWard == true
			and thresholdFrostWard ~= nil
			and hp <= tonumber(thresholdFrostWard)
			and spells.FrostWard ~= nil
			and spells.FrostWard.id ~= nil
			and spells.FrostWard.name ~= nil
			and not ni.player.buff(spells.FrostWard.id)
			and ni.spell.available(spells.FrostWard.id) then
				ni.spell.cast(spells.FrostWard.name)
				return true;
		end

		local thresholdFrostNova, enabledFrostNova = GetSetting("FrostNova");
		if enabledFrostNova == true
			and thresholdFrostNova ~= nil
			and hp <= tonumber(thresholdFrostNova)
			and spells.FrostNova ~= nil
			and spells.FrostNova.id ~= nil
			and spells.FrostNova.name ~= nil
			and ni.spell.available(spells.FrostNova.id) then
				ni.spell.cast(spells.FrostNova.name)
				return true;
		end
	end,

	["Conjure Mana Gem"] = function()
		local hasGem, _ = HasManaGem();
		if ni.spell.available(spells.ConjureManaGem.id)
			and not ni.player.ismoving()
			and not UnitAffectingCombat("player")
			and not hasGem -- Mana Sapphire --
			and not ni.unit.ischanneling("player") then 
				ni.spell.cast(spells.ConjureManaGem.name)
				return true;	
		end 
	end,

	["Mana Gem"] = function()
	local value, enabled = GetSetting("ManaGem")
		local hasGem, gemId = HasManaGem();
		if enabled
			and UnitAffectingCombat("player")
			and ni.player.power() <= value
			and not ni.unit.ischanneling("player")
			and hasGem
			and ni.player.itemcd(gemId) < 1 then
				ni.player.useitem(gemId) -- Mana Sapphire --
				return true;
		end
	end,

	["Runic Mana Potion"] = function()
	local value, enabled = GetSetting("RunicManaPotion")
		if enabled
			and UnitAffectingCombat("player")
			and ni.player.power() <= value
			and not ni.unit.ischanneling("player")
			and ni.player.hasitem(33448)
			and ni.player.itemcd(33448) < 1 then
				ni.player.useitem(33448)
				return true;
		end
	end,

	["Evocation"] = function()
	local value, enabled = GetSetting("Evocation")
		if enabled
			and ni.spell.available(spells.Evocation.id)
			and UnitAffectingCombat("player")
			and ni.player.power() <= value
			and not ni.unit.ischanneling("player") then
				ni.spell.cast(spells.Evocation.name, "player")
				return true;
		end 
	end,

	["Pyroblast"] = function()
		if ni.spell.available(spells.Pyroblast.id)
			and hasAttackableTarget("target")
			and (ni.unit.buff("player", 48108, "player") or ni.unit.aura("player", 48108)) -- Hot Streak --
			and not ni.unit.ischanneling("player") then
				ni.spell.cast(spells.Pyroblast.name, "target")
				return true;
		end
	end,

	["Scorch"] = function()
	local _, enabled = GetSetting("Scorch")
		if enabled 
			and ni.spell.available(spells.Scorch.id)
			and hasAttackableTarget("target")
			and not useAoe()
			and ni.unit.isboss("target")
			and ni.unit.debuff("target", 22959, "player") == nil -- Improved Scorch --
			and ni.unit.debuff("target", 17803, "player") == nil -- Improved Shadow Bolt --
			and not ni.unit.ischanneling("player") then
				ni.spell.cast(spells.Scorch.name, "target")
				return true;
		end
	end,

	["Living Bomb"] = function()
		local aoeMode = useAoe();

		if ni.spell.available(spells.LivingBomb.id)
			and hasAttackableTarget("target")
			and aoeMode
			and not ni.unit.ischanneling("player") then
				return castLivingBombAtMissingTarget(10);
		end
		if ni.spell.available(spells.LivingBomb.id)
			and hasAttackableTarget("target")
			and ni.unit.debuff("target", spells.LivingBomb.id, "player") == nil
			and not ni.unit.ischanneling("player") then
				ni.spell.cast(spells.LivingBomb.name, "target")
				return true;
		end
	end,

	["Mirror Image"] = function()
	local _, enabled = GetSetting("MirrorImage")
		if enabled
			and isBossOrElite("target")
			and hasAttackableTarget("target")
			and ni.spell.available(spells.MirrorImage.id)  
			and not ni.unit.ischanneling("player") then
				ni.spell.cast(spells.MirrorImage.name, "player")
				return true;
		end
	end,

	["Icy Veins"] = function()
	local _, enabled = GetSetting("IcyVeins")
		if enabled
			and isBossOrElite("target")
			and hasAttackableTarget("target")
			and ni.spell.available(spells.IcyVeins.id)
			and not ni.unit.ischanneling("player") then
				ni.spell.cast(spells.IcyVeins.name, "player")
				return true;
		end
	end,

	["Combustion"] = function()
	local _, enabled = GetSetting("Combustion")
		if enabled
			and isBossOrElite("target")
			and hasAttackableTarget("target")
			and ni.spell.available(spells.Combustion.id)  
			and not ni.unit.ischanneling("player") then
				ni.spell.cast(spells.Combustion.name, "player")
				return true;
		end
	end,

	["Fireblast"] = function()
	if ni.spell.available(spells.Fireblast.id) 
			and hasAttackableTarget("target")
			and not ni.unit.ischanneling("player") 
			and ni.unit.ismoving("player") then
				ni.spell.cast(spells.Fireblast.name, "target")
				return true;
		end
	end,

	["Fireball"] = function()
	if ni.spell.available(spells.Fireball.id) 
			and hasAttackableTarget("target")
			and not ni.unit.ischanneling("player") then
				ni.spell.cast(spells.Fireball.name, "target")
				return true;
		end
	end,
};

	ni.bootstrap.profile("Mage - Fire PvE by Dreams", queue, abilities, OnLoad, OnUnLoad);	
else
    local queue = {
        "Error",
    };
    local abilities = {
        ["Error"] = function()
            ni.vars.profiles.enabled = false;
			if not wotlk then
				ni.frames.floatingtext:message("This profile for WotLK 3.3.5a!")
            end
        end,
    };
    ni.bootstrap.profile("Mage - Fire PvE by Dreams", queue, abilities);
end;
