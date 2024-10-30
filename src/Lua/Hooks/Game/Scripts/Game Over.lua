sfxinfo[freeslot "sfx_mmsnp1"].caption = "Spot on!"
sfxinfo[freeslot "sfx_mmsnp2"].caption = "Good shot, mate!"
sfxinfo[freeslot "sfx_mmsnp3"].caption = "Fine shot, mate!"

local function calcRollX(time)
	if time <= 0 then
		return 0
	end
	local x = 0
	local xv = 0
	for _=1,time do
		x = $ + xv
		xv = $ + (FU/MM_N.mapVote.rollvel)
	end
	return x
end

return function()
	MM_N.end_ticker = $+1

	if MM_N.voting then
		MM_N.mapVote.ticker = $ - 1
		if MM_N.mapVote.state == "voting" and MM_N.mapVote.ticker <= 0 then
			local pool = {}
			local mapc = 0
			for _,map in ipairs(MM_N.mapVote.maps) do
				if map.votes then
					mapc = $ + 1
					for _=1,map.votes do
						table.insert(pool, map.map)
					end
				end
			end
			if mapc == 1 then
				MM_N.mapVote.state = "done"
				MM_N.mapVote.selected_map = pool[1]
				MM_N.mapVote.ticker = 3*TICRATE
				MM_N.mapVote.unanimous = true
				S_StartSound(nil, sfx_s3kb3)
			else
				if not #pool then
					for _,map in ipairs(MM_N.mapVote.maps) do
						table.insert(pool, map.map)
					end
				end
				-- Fisher-Yates shuffle algorithm
				for i = #pool, 2, -1 do
				local j = P_RandomRange(1, i)
					pool[i], pool[j] = pool[j], pool[i]
				end
				MM_N.mapVote.pool = pool
				MM_N.mapVote.selected_map = pool[1]
				MM_N.mapVote.state = "rolling"
				MM_N.mapVote.ticker = P_RandomRange(4*TICRATE, 7*TICRATE)
				MM_N.mapVote.rollvel = P_RandomRange(320, 480)
				MM_N.mapVote.rollx = calcRollX(MM_N.mapVote.ticker)
			end
		elseif MM_N.mapVote.state == "rolling" then
			local newx = calcRollX(MM_N.mapVote.ticker)
			if FixedFloor(MM_N.mapVote.rollx+FU/2) != FixedFloor(newx+FU/2) then
				S_StartSound(nil, sfx_tink)
			end
			MM_N.mapVote.rollx = newx

			if MM_N.mapVote.ticker <= 0 then
				MM_N.mapVote.state = "done"
				MM_N.mapVote.ticker = 3*TICRATE
				S_StartSound(nil, sfx_s3kb3)
			end
		elseif MM_N.mapVote.state == "done" and MM_N.mapVote.ticker <= 0 then
			G_SetCustomExitVars(MM_N.mapVote.selected_map, 2)
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
	if MM_N.sniped_end and MM_N.end_ticker == releaseTic+8 then
		S_StartSound(nil, sfx_mmsnp1 + P_RandomRange(0, 2))
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