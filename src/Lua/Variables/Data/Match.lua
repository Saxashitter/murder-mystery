local match_time = 300*TICRATE

return {
	time = match_time+10*TICRATE,
	maxtime = match_time,
	waiting_for_players = false,
	gameover = false,
	showdown = false,
	end_ticker = 0,
	ping_positions = {},
	murderers = {},
	innocents = {},
	mapVote = {},
	max_ping_time = 30*TICRATE,
	ping_approx = FU,
	ping_time = 0,
	pings_done = 0
}