local build = select(4, GetBuildInfo());
local wotlk = build == 30300 or false;

if wotlk then
    local p = "player";
    local t = "target";
    local format = format;

    local enables = {
        AutoTarget = true,
        RequireCombat = false,
        UseThreatFilter = false,
        TestMode = true,
        UseCooldowns = true,
        UseScorch = true,
        UseAOE = true,
        AoeCount = 3,
    };

    local function GUICallback(key, item_type, value)
        if item_type == "enabled" then
            enables[key] = value;
        elseif item_type == "value" then
            enables[key] = value;
        end
    end;

    local items = {
        settingsfile = "Mage - Fire PvE by Dreams - 副本.json",
        callback = GUICallback,
        { type = "title", text = "WLK 3.3.5 Fire Mage" },
        { type = "separator" },
        {
            type = "entry",
            text = "Auto target",
            tooltip = "When current target is invalid, auto select a nearby enemy.",
            enabled = enables.AutoTarget,
            key = "AutoTarget"
        },
        {
            type = "entry",
            text = "Only in combat",
            tooltip = "Disable if you want to train on dummies outside combat.",
            enabled = enables.RequireCombat,
            key = "RequireCombat"
        },
        {
            type = "entry",
            text = "Use threat filter",
            tooltip = "Disable this for training dummies when threat data is weird.",
            enabled = enables.UseThreatFilter,
            key = "UseThreatFilter"
        },
        {
            type = "entry",
            text = "TestMode",
            tooltip = "Bypass attackability/threat checks for training targets.",
            enabled = enables.TestMode,
            key = "TestMode"
        },
        {
            type = "entry",
            text = "Use cooldowns",
            tooltip = "Use cooldowns only if target is boss/elite.",
            enabled = enables.UseCooldowns,
            key = "UseCooldowns"
        },
        {
            type = "entry",
            text = "Keep Scorch debuff",
            tooltip = "Use Scorch when needed.",
            enabled = enables.UseScorch,
            key = "UseScorch"
        },
        {
            type = "entry",
            text = "Enable AOE",
            tooltip = "Use AOE when target count in range reaches this number.",
            enabled = enables.UseAOE,
            value = enables.AoeCount,
            min = 2,
            max = 10,
            step = 1,
            width = 40,
            key = "AoeCount"
        },
    };

    local function ResolveSpell(candidates)
        if IsSpellKnown then
            for _, id in ipairs(candidates) do
                if GetSpellInfo(id) ~= nil and IsSpellKnown(id) then
                    return id;
                end
            end
        end
        for _, id in ipairs(candidates) do
            if GetSpellInfo(id) ~= nil then
                return id;
            end
        end
        return candidates[1];
    end

    local spells = {
        MoltenArmor = 43046,
        ArcaneBrilliance = 43002,
        Evocation = 12051,
        Fireblast = 42873,
        Pyroblast = ResolveSpell({42891, 11366}),
        Scorch = 42859,
        LivingBomb = ResolveSpell({55360, 44457}),
        MirrorImage = 55342,
        Combustion = 11129,
        Fireball = 42833,
    };

    local function canAttackTarget(unit)
        if unit == nil or not ni.unit.exists(unit) or UnitIsDeadOrGhost(unit) then
            return false;
        end

        if not enables.TestMode then
            if not UnitCanAttack(p, unit) then
                return false;
            end
            if not ni.player.los(unit) then
                return false;
            end
        else
            if not UnitCanAttack(p, unit) then
                -- keep TestMode usable for dummy-target checks
            end
        end

        return true;
    end

    local function searchTarget(maxDistance)
        if not enables.AutoTarget then
            return canAttackTarget(t);
        end

        local hasTarget = canAttackTarget(t);
        maxDistance = tonumber(maxDistance) or 40;

        local enemies = ni.player.enemiesinrange(maxDistance);
        local enemy = nil;

        for i = 1, #enemies do
            local guid = enemies[i].guid;
            local ok = true;

            if not enables.TestMode then
                ok = ni.unit.los(p, guid);
                if ok and enables.UseThreatFilter then
                    ok = ni.unit.threat(p, guid) ~= -1;
                end
            end

            if ok and not ni.unit.isimmune(guid) then
                if enemy == nil or enemy.distance > enemies[i].distance then
                    enemy = enemies[i];
                end
            end
        end

        if enemy == nil then
            if hasTarget then
                if not ni.unit.isfacing(p, t, 90) then
                    ni.player.lookat(t);
                end
                return true;
            end
            return false;
        end

        if hasTarget and UnitGUID(t) == enemy.guid then
            return true;
        end

        ni.player.runtext("/cleartarget");
        ni.player.target(enemy.guid);

        if not ni.unit.isfacing(p, t, 90) then
            ni.player.lookat(t);
        end

        ni.debug.print(format("Auto target: %s", enemy.name));
        return true;
    end

    local function enemyCount(range)
        local enemies = ni.player.enemiesinrange(range or 10);
        return #enemies;
    end

    local function canCast(spell)
        return ni.spell.available(spell);
    end

    local function cast(spell, unit)
        unit = unit or t;
        if canCast(spell) then
            ni.spell.cast(spell, unit);
            return true;
        end
        return false;
    end

    local function useItem(slot)
        local start, duration = GetInventoryItemCooldown(p, slot);
        if start == 0 and duration == 0 then
            UseInventoryItem(slot);
            return true;
        end
        return false;
    end

    local function SmartAttack()
        if UnitIsDeadOrGhost(p) then
            return;
        end
        if UnitInVehicle(p) then
            return;
        end
        if ni.unit.iscasting(p) or ni.unit.ischanneling(p) then
            return;
        end
        if ni.spell.gcd() then
            return;
        end
        if enables.RequireCombat and not UnitAffectingCombat(p) then
            return;
        end

        if not searchTarget(40) then
            return;
        end

        ni.player.runtext("/startattack");

        if not ni.unit.isfacing(p, t, 90) then
            ni.player.lookat(t);
            return;
        end

        if not ni.player.buff(spells.MoltenArmor) and canCast(spells.MoltenArmor) then
            return cast(spells.MoltenArmor, p);
        end

        if enables.UseCooldowns and ni.unit.isboss(t) then
            useItem(13);
            useItem(14);

            if canCast(spells.MirrorImage) then
                return cast(spells.MirrorImage, p);
            end

            if canCast(spells.Combustion) then
                return cast(spells.Combustion, p);
            end
        end

        if enables.UseAOE and enemyCount(10) >= tonumber(enables.AoeCount or 3) then
            if canCast(spells.LivingBomb) and ni.unit.debuffremaining(t, spells.LivingBomb, p) <= 0 then
                return cast(spells.LivingBomb, t);
            end
        end

        if ni.unit.aura(p, 48108) and canCast(spells.Pyroblast) then
            return cast(spells.Pyroblast, t);
        end

        if ni.unit.debuffremaining(t, spells.Scorch, p) <= 0 and canCast(spells.Scorch) and enables.UseScorch then
            return cast(spells.Scorch, t);
        end

        if ni.unit.debuffremaining(t, spells.LivingBomb, p) <= 0 and canCast(spells.LivingBomb) then
            return cast(spells.LivingBomb, t);
        end

        if ni.unit.ismoving(p) then
            if canCast(spells.Fireblast) then
                return cast(spells.Fireblast, t);
            end
            return;
        end

        return cast(spells.Fireball, t);
    end

    local queue = { "Attack" };
    local abilities = { ["Attack"] = SmartAttack };

    local function OnLoad()
        ni.GUI.AddFrame("FireMage-335-UI", items);
    end

    local function OnUnload()
        ni.GUI.DestroyFrame("FireMage-335-UI");
    end

    ni.bootstrap.profile("WLK335-火法输出", queue, abilities, OnLoad, OnUnload);
else
    local queue = { "Error" };
    local abilities = {
        ["Error"] = function()
            ni.vars.profiles.enabled = false;
            ni.frames.floatingtext:message("This profile is for WotLK 3.3.5a!");
        end,
    };
    ni.bootstrap.profile("WLK335-火法输出", queue, abilities);
end;
