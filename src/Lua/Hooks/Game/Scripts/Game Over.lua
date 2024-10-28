return function()
	MM_N.end_ticker = $+1

	if MM_N.voting then
		if MM_N.end_ticker > 15*TICRATE then
			local selected_map = 1
			local most_votes = 0
			for _,map in ipairs(MM_N.mapVote) do
				if map.votes < most_votes then continue end

				selected_map = map.map
				most_votes = map.votes
			end
			G_SetCustomExitVars(selected_map, 2)
			G_ExitLevel()
		end
		return
	end

	if (MM_N.end_camera and MM_N.end_camera.valid) then
		MM:startEndCamera()
	end

	local releaseTic = 3*TICRATE
	if MM_N.sniped_end then
		-- for music timing
		releaseTic = 3*TICRATE + MM.sniper_theme_offset
	end
	if MM_N.end_ticker == releaseTic
		for mo in mobjs.iterate()
			if not (mo and mo.valid) then continue end
			
			if mo.notthinking
				continue
			end
			
			mo.flags = $ &~MF_NOTHINK
		end
	end
	
	/*if MM_N.end_ticker >= 5*TICRATE then
		local song = "MMWINR"
		local p = consoleplayer

		if (p and p.mm and p.mm.spectator and not p.mm.joinedmidgame) then
			song = "MMLOSR"
		end

		if MM_N.results_ticker == 0 then
			S_ChangeMusic(song, false)
		end

		MM_N.results_ticker = $+1
	end*/

	if MM_N.end_ticker >= 5*TICRATE then
		MM_N.end_ticker = 1
		MM:startVote()
	end
end, "gameover"