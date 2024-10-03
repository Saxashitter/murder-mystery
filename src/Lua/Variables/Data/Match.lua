local match_time = 300*TICRATE

return {
	time = match_time+10*TICRATE,
	maxtime = match_time,
	waiting_for_players = false,
	gameover = false,
	voting = false,
	showdown = false,
	end_ticker = 0,
	showdown_ticker = 0,
	ping_positions = {},
	murderers = {},
	innocents = {},
	mapVote = {},
	max_ping_time = 30*TICRATE,
	ping_approx = FU,
	ping_time = 0,
	pings_done = 0,
	corpses = {},
	knownDeadPlayers = {},
	--round ended because all innocents/murderers left the game
	disconnect_end = false,
	killing_end = false,
	overtime_point = nil,
	overtime_ticker = 0,
}