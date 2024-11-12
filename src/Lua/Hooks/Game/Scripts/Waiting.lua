return function()
	if CV_MM.debug.value 
		MM_N.waiting_for_players = false
		return
	end
	
	local playersIn = 0
	for p in players.iterate do
		playersIn = $+1
	end

	if playersIn >= 2 then
		COM_BufInsertText(server, "map "..G_BuildMapName(gamemap).." -f")
		MM_N.waiting_for_players = false
	end
	
	if isserver
	and CV_FindVar("restrictskinchange").value
		CV_Set(CV_FindVar("restrictskinchange"),0)
	end
end, "waiting"