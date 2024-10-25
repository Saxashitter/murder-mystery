return function()
	-- time management
	MM_N.time = max(0, $-1)

	if not (MM_N.time)
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
	
	--Overtime storm
	if MM_N.showdown 
	or not MM_N.time
		if MM_N.overtime_ticker == 0 then
			S_StartSound(nil,sfx_kc4b)
			if mapmusname ~= MM_N.showdown_song then
				mapmusname = MM_N.showdown_song
				S_ChangeMusic(MM_N.showdown_song, true)
			end
		end
		MM:handleOvertime()
	end
end