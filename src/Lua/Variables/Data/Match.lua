local match_time = 160*TICRATE

return {
	time = match_time+10*TICRATE,
	maxtime = match_time,

	murderers = {},
	innocents = {},

	speed_cap = 28*FU,

	waiting_for_players = false,

	showdown = false,
	showdown_song = "MMOVRT",
	showdown_ticker = 0,

	ptsr_mode = true,
	ptsr_overtime_ticker = 0, -- luigi please fix ur variable names (overtime ticker is showdown ticker)

	overtime_point = nil,
	overtime_ticker = 0,
	overtime_startingdist = 6000*FU,

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

	--round ended because all innocents/murderers left the game
	disconnect_end = false,
	killing_end = false,
}