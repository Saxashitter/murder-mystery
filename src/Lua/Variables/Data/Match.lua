local match_time = 190*TICRATE

return {
	time = match_time+10*TICRATE,
	maxtime = match_time,

	special_count = 0,

	murderers = {},
	innocents = {},

	theme = "srb2",

	transition = false,
	transition_time = 0,

	clues_amount = 0,
	clues_in_map = false,
	clues = {},

	speed_cap = 28*FU,

	waiting_for_players = false,
	found_player = false,
	waiting_start_time = 7*TICRATE,

	showdown = false,
	showdown_song = "MMOVRT",
	showdown_ticker = 0,
	showdown_left = {},
	showdown_right = {},

	overtime = false,
	overtime_ticker = 0,

	storm_point = nil,
	storm_ticker = 0,
	storm_startingdist = 6000*FU,
	storm_usedpoints = false,
	
	gameover = false,
	voting = false,
	mapVote = {},
	results_ticker = 0,
	end_ticker = 0,

	pings_done = 0,
	ping_time = 0,
	ping_approx = FU,
	max_ping_time = 30*TICRATE,
	ping_positions = {},

	corpses = {},
	knownDeadPlayers = {},
	minimum_killed = 0,
	peoplekilled = 0,

	--round ended because all innocents/murderers left the game
	disconnect_end = false,
	killing_end = false,
	sniped_end = false
}