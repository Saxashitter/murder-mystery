local possibleItems = {
	"gun",
	"revolver",
	"luger",
	"knife",
	"sword"
}

return function()
	--starting countdown
	if (leveltime >= (MM_N.pregame_time - 4*TICRATE - 1) and leveltime <= MM_N.pregame_time - TICRATE)
	and (leveltime % TICRATE == 0)
		S_StartSound(nil,leveltime == MM_N.pregame_time - TICRATE and sfx_s3kad or sfx_s3ka7)
	end
	
	local numplay = 0
	local innocents = 0
	for p in players.iterate do
		if not (p.mm) then continue end
		if (p.spectator or p.mm.specator) then continue end
		
		if (p.mm.role ~= MMROLE_MURDERER)
			innocents = $+1
		end
		numplay = $+1
	end
	
	if MM:pregame()
		MM_N.dueling = numplay == 2
		MM_N.duel_item = possibleItems[P_RandomRange(1,#possibleItems)]
	end
	
	--people might've joined or left, so recalc minimum kills
	if leveltime == MM_N.pregame_time
		if isserver then
			CV_Set(CV_FindVar("restrictskinchange"),1)
		end
		
		MM_N.minimum_killed = max(1,innocents/3)
		
		--we're for SURE dueling
		if MM_N.dueling
			MM_N.time = MM_N.duel_time
			MM_N.maxtime = MM_N.duel_time
		end
	end
	
	if CV_MM.debug.value
		MM:handleStorm()
	end
	
	-- time management
	MM_N.time = max(0, $-1)
	if not (MM_N.time)
	and not MM_N.overtime then
		if not MM_N.dueling
			if MM_N.peoplekilled >= MM_N.minimum_killed
			or MM_N.showdown
			or (CV_MM.debug.value)
				MM:startOvertime()
			else
				MM:endGame(1)
				MM_N.disconnect_end = true
				MM_N.end_ticker = 3*TICRATE - 1
				S_StartSound(nil,sfx_s253)
			end
		elseif not MM_N.showdown
			MM:startShowdown()
		end
	end

	if MM_N.overtime
	and not MM_N.showdown then 
		if not MM_N.ping_time then
			MM_N.pings_done = $+1

			if MM_N.pings_done >= 2 then
				MM_N.pings_done = 0
				MM_N.max_ping_time = max(6, $/2)
			end

			MM_N.ping_time = MM_N.max_ping_time
			MM_N.ping_approx = FixedDiv(MM_N.ping_time, 30*TICRATE)

			MM:pingMurderers(min(MM_N.max_ping_time, 5*TICRATE), MM_N.ping_approx)
		end
		MM_N.ping_time = max(0, $-1)

		for k,pos in pairs(MM_N.ping_positions) do
			pos.time = max($-1, 0)
			if not (pos.time) then
				table.remove(MM_N.ping_positions, k)
			end
		end
	end

	if MM_N.overtime then
		if not MM_N.showdown
		and mapmusname ~= "MMOVRT" then
			mapmusname = "MMOVRT"
			S_ChangeMusic(mapmusname, true)
		end

		MM_N.overtime_ticker = $+1
	end

	--Overtime storm
	if MM_N.showdown 
	or MM_N.overtime then
		MM:handleStorm()
	end
end