return function()
	MM_N.safe_sectors = {}
	MM_N.safe_sectors_ud = {}
	
	for sector in sectors.iterate
		if not (sector.specialflags & SSF_RETURNFLAG) then continue end
		
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
		
		table.insert(MM_N.safe_sectors, {
			sector = sector,
			left_bound = leftmost,
			right_bound = rightmost,
			top_bound = topmost,
			bottom_bound = bottommost
		})
		MM_N.safe_sectors_ud[sector] = true
	end
end