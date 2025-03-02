return function()
	if #MM_N.safe_sectors <= 0 then return end
	if gamestate ~= GS_LEVEL then return end
	if MM_N.gameover then return end
	
	local printer_key = P_RandomRange(1, #MM_N.safe_sectors)
	local printer_ptr = MM_N.safe_sectors[printer_key]
	local printer = printer_ptr.sector
	
	local p_x
	--try to keep your sectors small man
	if abs((printer_ptr.left_bound >> FRACBITS) - (printer_ptr.right_bound >> FRACBITS)) > 65535
		error("Sector "..#printer.." is too big to automatically spawn coins. (left-right bounds > 65535 units)")
		table.remove(MM_N.safe_sectors, printer_key)
		return
	else
		p_x = (P_RandomRange(
			printer_ptr.left_bound >> FRACBITS,
			printer_ptr.right_bound >> FRACBITS
		) << FRACBITS) + P_RandomFixed()
	end
	
	local p_y
	--try to keep your sectors small man
	if abs((printer_ptr.bottom_bound >> FRACBITS) - (printer_ptr.top_bound >> FRACBITS)) > 65535
		error("Sector "..#printer.." is too big to automatically spawn coins. (top-bottom bounds > 65535 units)")
		table.remove(MM_N.safe_sectors, printer_key)
		return
	else
		p_y = (P_RandomRange(
			printer_ptr.bottom_bound >> FRACBITS,
			printer_ptr.top_bound >> FRACBITS
		) << FRACBITS) + P_RandomFixed()
	end
	
	local test_print = R_PointInSubsectorOrNil(p_x, p_y)
	if not test_print then return end
	if test_print.sector ~= printer then return end
	
	print("try spawn")
end