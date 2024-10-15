return {
	role = MMROLE_INNOCENT,
	spectator = false,
	got_weapon = false,

	joinedmidgame = false,

	selected_map = false,
	cur_map = 1,

	forwardmove = 0,
	sidemove = 0,
	lastforward = 0,
	lastside = 0,
	buttons = 0,
	
	outofbounds = false,
	oob_dist = 0,

	inventory = {
		items = {},
		hidden = true,
		cur_sel = 1,
		count = 5
	}
}