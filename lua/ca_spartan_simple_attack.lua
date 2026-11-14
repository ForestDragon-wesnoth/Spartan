--copy of the 1.18 simple_attack micro AI, but fixed so that the "if some units are slowed/cannot attack due to specials like shortranged/etc. then often other melee units' turns get skipped" bug
local AH = wesnoth.require "ai/lua/ai_helper.lua"
local BC = wesnoth.require "ai/lua/battle_calcs.lua"
local LS = wesnoth.require "location_set"

local ca_spartan_simple_attack, best_attack = {}, nil

--SPARTAN EDITED CODE: extra funcs - has_special_id, weapon_usable, can_attack and has_combo

local function has_special_id(weapon, id)
    for _,special in ipairs(weapon.specials) do
        if (special[2].id == id) then return true end
    end
    return false
end
-- Can @attacker use @weapon on @target? @moves_first is true when the unit has to move from @src before attacking.
local function weapon_usable(attacker, weapon, target, moves_first, src)
    for _,special in ipairs(weapon.specials) do
        if (special[1] == 'disable') and (special[2].active_on ~= 'defense') then
            local filter_self = wml.get_child(special[2], 'filter_self')
            local filter_opponent = wml.get_child(special[2], 'filter_opponent')
            local active = true
            if filter_self and (not attacker:matches(filter_self)) then active = false end
            if filter_opponent and (not target:matches(filter_opponent)) then active = false end
            if active then return false end
        end
    end

    -- manual check for shortranged for now:
    -- The short-ranged moveto event (hoplite_shortrange_event in utils/abilities.cfg) disables the attack against everything further than 1 hex from where the move started
    if moves_first and has_special_id(weapon, 'shortranged')
        and (wesnoth.map.distance_between(src.x, src.y, target.x, target.y) > 1)
    then
        return false
    end

    return true
end

local function can_attack(attacker, target, att, weapon_number)
    local moves_first = (att.src.x ~= att.dst.x) or (att.src.y ~= att.dst.y)

    if weapon_number and (weapon_number > 0) then
        local weapon = attacker.attacks[weapon_number]
        return (weapon ~= nil) and weapon_usable(attacker, weapon, target, moves_first, att.src)
    end

    -- No weapon given: the engine picks one, and it only looks at weapons with attack_weight > 0
    for _,weapon in ipairs(attacker.attacks) do
        if (weapon.attack_weight > 0) and weapon_usable(attacker, weapon, target, moves_first, att.src) then
            return true
        end
    end
    return false
end

--crude manual check for the combo special for now. TODO: improve it to be a more generalized "unit can potentially attack multiple times in one turn" check later?

local function has_combo(unit)
    for _,weapon in ipairs(unit.attacks) do
        if has_special_id(weapon, 'spartan_combo') then return true end
    end
    return false
end

function ca_spartan_simple_attack:evaluation(cfg)
    best_attack = nil

    local units = AH.get_units_with_attacks {
        side = wesnoth.current.side,
        { "and", wml.get_child(cfg, "filter") }
    }
    if (not units[1]) then return 0 end

    -- If cfg.filter_second is set, set up a map (location set)
    -- of enemies that it is okay to attack
    local enemy_filter = wml.get_child(cfg, "filter_second")
    local enemy_map
    if enemy_filter then
        local enemies = AH.get_attackable_enemies(enemy_filter)
        if (not enemies[1]) then return 0 end

        enemy_map = LS.create()
        for _,enemy in ipairs(enemies) do enemy_map:insert(enemy.x, enemy.y) end
    end

    -- Now find the best of the possible attacks
    local attacks = AH.get_attacks(units, { include_occupied = true })
    if (not attacks[1]) then return 0 end

    local max_targets, max_rating = -1, - math.huge
    for _, att in ipairs(attacks) do
        local valid_target = true
        if enemy_filter and (not enemy_map:get(att.target.x, att.target.y)) then
            valid_target = false
        end

        if valid_target then
            local attacker = wesnoth.units.get(att.src.x, att.src.y)
            local enemy = wesnoth.units.get(att.target.x, att.target.y)

            if can_attack(attacker, enemy, att, cfg.weapon) then
                local dst = { att.dst.x, att.dst.y }
                local rating = BC.attack_rating(attacker, enemy, dst)

                -- Combo units: prefer the hex with the most enemies in reach, so that a kill leaves another target for the extra attack
                local targets = 0
                if has_combo(attacker) then
                    targets = #AH.get_attackable_enemies {
                        { "filter_location", { { "filter_adjacent_location", { x = att.dst.x, y = att.dst.y } } } }
                    }
                end

                if (targets > max_targets) or ((targets == max_targets) and (rating > max_rating)) then
                    max_targets, max_rating, best_attack = targets, rating, att
                end
            end
        end
    end

    if best_attack then
        return cfg.ca_score
    end

    return 0
end

function ca_spartan_simple_attack:execution(cfg)
    AH.robust_move_and_attack(ai, best_attack.src, best_attack.dst, best_attack.target, cfg)
    best_attack = nil
end

return ca_spartan_simple_attack
