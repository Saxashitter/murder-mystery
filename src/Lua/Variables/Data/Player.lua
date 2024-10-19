return {
	role = MMROLE_INNOCENT,
	spectator = false,
	got_weapon = false,

	-- Never show this info in tab menu.
	alias = {
		name = nil, -- String
		skin = nil, -- String
		skincolor = nil, -- SKINCOLOR_...
		perm_level = nil, -- | None: 0 | Admin: 1 | Server: 2 |
	},

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