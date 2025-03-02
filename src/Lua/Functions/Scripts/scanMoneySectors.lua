return function()
	MM_N.safe_sectors = {}
	
	for sector in sectors.iterate
		if not (sector.specialflags & SSF_RETURNFLAG) then continue end
		
		/*
		print(
			sector.lines,
			sector.lines[0],
			#sector.lines,
			sector.lines[#sector.lines - 1]
		)
		*/
		
		local first = getTimeMicros()
		local leftmost
		local rightmost
		local bottommost
		local topmost
		for i = 0, #sector.lines - 1
			local line = sector.lines[i]
			local leftest_v = min(line.v1.x, line.v2.x)
			local rightest_v = max(line.v1.x, line.v2.x)
			local bottomest_v = min(line.v1.y, line.v2.y)
			local topest_v = max(line.v1.y, line.v2.y)
			
			if leftmost == nil
				leftmost = leftest_v
			else
				leftmost = min($, leftest_v)
			end
			if rightmost == nil
				rightmost = rightest_v
			else
				rightmost = max($, rightest_v)
			end

			if bottommost == nil
				bottommost = bottomest_v
			else
				bottommost = min($, bottomest_v)
			end
			if topmost == nil
				topmost = topest_v
			else
				topmost = max($, topest_v)
			end
		end
		print(getTimeMicros() - first)
		
		table.insert(MM_N.safe_sectors, {
			sector = sector,
			left_bound = leftmost,
			right_bound = rightmost,
			top_bound = topmost,
			bottom_bound = bottommost
		})
		print("safe sector")
	end
end