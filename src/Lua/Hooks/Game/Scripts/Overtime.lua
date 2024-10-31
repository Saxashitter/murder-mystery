return function()
	-- time management
	MM_N.time = max(0, $-1)
	if not (MM_N.time)
	and not MM_N.overtime then
		MM:startOvertime()
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