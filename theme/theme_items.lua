local _ = wesnoth.textdomain "wesnoth-Hoplite"

--unfortunately trying to change icons via Lua failed
--function wesnoth.interface.game_display.label()
--	return { { 'element', {
--		icon= "misc/depth_cave.png",
--	} } }
--
--end

--TODO: todo: make depth tooltip also show some info about current biome

function wesnoth.interface.game_display.depth()
	-- Display for the viewing side, not the current side
	local viewing_side = wesnoth.interface.get_viewing_side()

	local side_proxy = wesnoth.sides[viewing_side]
	local val = wml.variables["hoplite_depth"] or 0
	local str = _"Depth".." "..val
	--if (viewing_side ~= wesnoth.current.side) then
	--	str = "<span color='" .. colors.gray .. "'>" .. str .. "</span>"
	--end

	return { { 'element', {
		text = str,
		tooltip = _"<span color='#cc9900'><b>Depth</b></span>: \nThe further you go in the cave, the stronger and more numerous the enemies will become. Some specific depths are guaranteed to have a boss fight. Some biomes only become available after a certain depth."

	} } }

end

function wesnoth.interface.game_display.energy()
	-- Display for the viewing side, not the current side
	local viewing_side = wesnoth.interface.get_viewing_side()

	local side_proxy = wesnoth.sides[viewing_side]
	local val = wml.variables["hoplite_energy"..viewing_side] or 0
	local val2 = wml.variables["hoplite_maxenergy"..viewing_side] or 0
	local str = val.."/"..val2
	local str2 = _"<span color='#ffff99'><b>Energy</b></span>: \nUsed for leaping, as well as some upgrades. You recover some energy when killing enemies or hitting bosses, fully recover energy when moving to the next depth, and some upgrades allow you to recover energy in other ways."

	local mp_otherside
	if viewing_side == 2 then
        mp_otherside = 1
	else 
        mp_otherside = 2
	end

	local other_val = wml.variables["hoplite_energy"..mp_otherside] or 0
	local other_val2 = wml.variables["hoplite_maxenergy"..mp_otherside] or 0
	local other_str = other_val.."/"..other_val2

	if wml.variables["hoplite_multiplayer"] ~= nil then
		str2 = str2.."\n \n Other Player's Energy: <span color='#ffff99'>"..other_str.."</span>"
	end


	--if (viewing_side ~= wesnoth.current.side) then
	--	str = "<span color='" .. colors.gray .. "'>" .. str .. "</span>"
	--end

	return { { 'element', {
		text = str,
		tooltip = str2
	} } }

end

function wesnoth.interface.game_display.killstreak()
	-- Display for the viewing side, not the current side
	local viewing_side = wesnoth.interface.get_viewing_side()

	local side_proxy = wesnoth.sides[viewing_side]
	local val = wml.variables["killstreak"..viewing_side] or 0
	local str = val
	--if (viewing_side ~= wesnoth.current.side) then
	--	str = "<span color='" .. colors.gray .. "'>" .. str .. "</span>"
	--end

	local str2 = _"<span color='#ff5050'><b>Killstreak</b></span>: \nAmount of enemies killed in a row (resets if you spend a turn without killing enemies or hitting bosses). Important for some upgrades, as well as achievements like Frenzy"

	local mp_otherside
	if viewing_side == 2 then
        mp_otherside = 1
	else 
        mp_otherside = 2
	end

	local other_val = wml.variables["killstreak"..mp_otherside] or 0

	if wml.variables["hoplite_multiplayer"] ~= nil then
		str2 = str2.."\n \n Other Player's Killstreak: <span color='#ffff99'>"..other_val.."</span>"
	end

	return { { 'element', {
		text = str,
		tooltip = str2
	} } }

end

function wesnoth.interface.game_display.orbs()
	-- Display for the viewing side, not the current side
	local viewing_side = wesnoth.interface.get_viewing_side()

	local side_proxy = wesnoth.sides[viewing_side]
	local val = wml.variables["spartan_orbs_of_insight"..viewing_side] or 0
	local str = val
	--if (viewing_side ~= wesnoth.current.side) then
	--	str = "<span color='" .. colors.gray .. "'>" .. str .. "</span>"
	--end

	local str2 = _"<span color='#a456ff'><b>Orbs of Insight</b></span>: \nThese mysterious orbs can be used to reveal hints for hidden achievements, or spent as currency in a certain rare location. Both the hints and the orb itself carry over between playthroughs."

	local mp_otherside
	if viewing_side == 2 then
        mp_otherside = 1
	else 
        mp_otherside = 2
	end

	local other_val = wml.variables["spartan_orbs_of_insight"..mp_otherside] or 0

	if wml.variables["hoplite_multiplayer"] ~= nil then
		str2 = str2.."\n \n Other Player's Orbs: <span color='#ffff99'>"..other_val.."</span>"
	end

	return { { 'element', {
		text = str,
		tooltip = str2

	} } }

end

function wesnoth.interface.game_display.otherinfo()
	-- Display for the viewing side, not the current side
	local viewing_side = wesnoth.interface.get_viewing_side()

	local side_proxy = wesnoth.sides[viewing_side]

	local str = _"Misc Info"

	local str2 = _"<span color='#ffff99'><b>Misc Information</b></span> (like upgrade cooldowns or healing potions): \n"

	local str2_orig = str2


	--TODO: add if statement

	if wml.variables["healpotionI_unlocked"..viewing_side] ~= nil then
		str2 = str2.._"Healing potions in inventory: <span color='#ffff99'>"..wml.variables["healpotions_in_inventory"..viewing_side].."/"..wml.variables["healpotion_capacity"..viewing_side].."</span>\n"
	end

	if wml.variables["phoenixamulet_unlocked"..viewing_side] ~= nil then
    	if wml.variables["hoplite_revive_cooldown"..viewing_side] > 0 then
    		str2 = str2.._"Phoenix Amulet cooldown: <span color='#ffff99'>"..wml.variables["hoplite_revive_cooldown"..viewing_side].."</span> depths".."\n"
    	else 
    		str2 = str2.._"Phoenix Amulet: <span color='#ffff99'>Ready</span>".."\n"
    	end
	end

	if wml.variables["wizardbeam_unlocked"..viewing_side] ~= nil then
    	if wml.variables["hoplite_wizardbeam_cooldown"..viewing_side] > 0 then
    		str2 = str2.._"Flame Blast cooldown: <span color='#ffff99'>"..wml.variables["hoplite_wizardbeam_cooldown"..viewing_side].."</span> turns".."\n"
    	else 
    		str2 = str2.._"Flame Blast: <span color='#ffff99'>Ready</span>".."\n"
    	end
	end

	if wml.variables["adrenaline_unlocked"..viewing_side] ~= nil then
    	if wml.variables["hoplite_adrenalinerush_cooldown"..viewing_side] > 0 then
    		str2 = str2.._"Adrenaline Rush cooldown: <span color='#ffff99'>"..wml.variables["hoplite_adrenalinerush_cooldown"..viewing_side].."</span> depth".."\n"
    	else 
    		str2 = str2.._"Adrenaline Rush: <span color='#ffff99'>Ready</span>".."\n"
    	end
	end


	if wml.variables["rat_legion_unlocked"..viewing_side] ~= nil then
    	if wml.variables["rat_cooldown"..viewing_side] > 0 then
    		str2 = str2.._"Rat Legion cooldown: <span color='#ffff99'>"..wml.variables["rat_cooldown"..viewing_side].."</span> turns".."\n"
    	else 
    		str2 = str2.._"Rat Legion cooldown: <span color='#ffff99'>Ready</span>".."\n"
    	end
	end

	if wml.variables["shadowclone_unlocked"..viewing_side] ~= nil then
    	if wml.variables["hoplite_shadowclone_cooldown"..viewing_side] > 0 then
    		str2 = str2.._"Shadow Clone cooldown: <span color='#ffff99'>"..wml.variables["hoplite_shadowclone_cooldown"..viewing_side].."</span> depths".."\n"
    	else 
    		str2 = str2.._"Shadow Clone cooldown: <span color='#ffff99'>Ready</span>".."\n"
    	end
	end

	if wml.variables["summonedarcher_unlocked"..viewing_side] ~= nil then
    	if wml.variables["hoplite_summonedarcher_cooldown"..viewing_side] > 0 then
    		str2 = str2.._"Spirit Archer cooldown: <span color='#ffff99'>"..wml.variables["hoplite_summonedarcher_cooldown"..viewing_side].."</span> depths".."\n"
    	else 
    		str2 = str2.._"Spirit Archer cooldown: <span color='#ffff99'>Ready</span>".."\n"
    	end
	end

	if wml.variables["Algadur_stored.id"] ~= nil then
    	if wml.variables["algadur_cooldown"] > 0 then
    		str2 = str2.._"Algadur return cooldown: <span color='#ffff99'>"..wml.variables["algadur_cooldown"].."</span> depths".."\n"
    	else 
    		str2 = str2.._"Algadur return cooldown: <span color='#ffff99'>Ready</span>".."\n"
    	end
	end

	if wml.variables["Elizabeth_stored.id"] ~= nil then
    	if wml.variables["elizabeth_cooldown"] > 0 then
    		str2 = str2.._"Elizabeth return cooldown: <span color='#ffff99'>"..wml.variables["elizabeth_cooldown"].."</span> depths".."\n"
    	else 
    		str2 = str2.._"Elizabeth return cooldown: <span color='#ffff99'>Ready</span>".."\n"
    	end
	end

	if str2 == str2_orig then
    	str2 = str2.._"You don't yet have upgrades with a cooldown listed in this menu.".."\n"
	end


	--TODO:
    	--add Algadur/Elizabeth return cooldowns if either of them is stored

	return { { 'element', {
		text = str,
		tooltip = str2
	} } }

end