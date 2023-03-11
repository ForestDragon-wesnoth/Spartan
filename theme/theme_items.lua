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
	--if (viewing_side ~= wesnoth.current.side) then
	--	str = "<span color='" .. colors.gray .. "'>" .. str .. "</span>"
	--end

	return { { 'element', {
		text = str,
		tooltip = _"<span color='#ffff99'><b>Energy</b></span>: \nUsed for leaping, as well as some upgrades. You recover some energy when killing enemies or hitting bosses, fully recover energy when moving to the next depth, and some upgrades allow you to recover energy in other ways."

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

	return { { 'element', {
		text = str,
		tooltip = _"<span color='#ff5050'><b>Killstreak</b></span>: \nAmount of enemies killed in a row (resets if you spend a turn without killing enemies or hitting bosses). Important for some upgrades, as well as achievements like Frenzy"

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

	return { { 'element', {
		text = str,
		tooltip = _"<span color='#a456ff'><b>Orbs of Insight</b></span>: \nThese mysterious orbs can be used to reveal hints for hidden achievements, or spent as currency in a certain rare location. Both the hints and the orb itself carry over between playthroughs."

	} } }

end