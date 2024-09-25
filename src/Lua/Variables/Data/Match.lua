local match_time = 300*TICRATE

return {
	time = match_time+10*TICRATE,
	maxtime = match_time,
	waiting_for_players = false,
	gameover = false,
	end_ticker = 0,
	murderers = {},
	innocents = {},
	mapVote = {}
}