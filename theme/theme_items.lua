local _ = wesnoth.textdomain "wesnoth-Hoplite"

function wesnoth.interface.game_display.killstreak()
	-- Display for the viewing side, not the current side
	local viewing_side = wesnoth.interface.get_viewing_side()

	local side_proxy = wesnoth.sides[viewing_side]
	local val = wml.variables["killstreak"..wesnoth.interface.get_viewing_side()] or 0
	local str = val
	--if (viewing_side ~= wesnoth.current.side) then
	--	str = "<span color='" .. colors.gray .. "'>" .. str .. "</span>"
	--end

	return { { 'element', {
		text = str,
		tooltip = _"<span color='#ff5050'><b>Killstreak</b></span>: \nAmount of units killed in a row. Important for some upgrades, as well as achievements like Frenzy"

	} } }

end

function wesnoth.interface.game_display.orbs()
	-- Display for the viewing side, not the current side
	local viewing_side = wesnoth.interface.get_viewing_side()

	local side_proxy = wesnoth.sides[viewing_side]
	local val = wml.variables["spartan_orbs_of_insight"..wesnoth.interface.get_viewing_side()] or 0
	local str = val
	--if (viewing_side ~= wesnoth.current.side) then
	--	str = "<span color='" .. colors.gray .. "'>" .. str .. "</span>"
	--end

	return { { 'element', {
		text = str,
		tooltip = "<span color='#a456ff'><b>Orbs of Insight</b></span>: \nThese mysterious orbs can be used to reveal hints for hidden achievements, or spent as currency in a certain rare location. Both the hints and the orb itself carry over between playthroughs."

	} } }

end