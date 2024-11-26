return {
	role = MMROLE_INNOCENT,
	spectator = false,
	got_weapon = false,

	clues = {},
	clues_collected = 0,

	-- Never show this info in tab menu.
	alias = nil,
	alias_save = nil,

	permanentcolor = nil,
	permanentskin = nil, -- doesn't set skin, just for ranking hud display
	lastcolor = nil,
	joinedmidgame = false,

	selected_map = false,
	cur_map = 1,

	forwardmove = 0,
	sidemove = 0,
	lastforward = 0,
	lastside = 0,
	buttons = 0,
	
	afktimer = 0,
	afkhelpers = {
		timedout = false,
		timeuntilreset = 0,
		lastangle = 0,
		lastaiming = 0
	},
	
	interact = {
		--the actual points of interests
		points = {},
		interacted = false,
	},
	
	outofbounds = false,
	oob_dist = 0,

	inventory = {
		items = {},
		hidden = true,
		cur_sel = 1,
		count = 5
	}
}