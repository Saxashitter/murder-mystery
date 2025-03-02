local GetMobjSpawnHeight, GetMapThingSpawnHeight = MM.require("Libs/MapThingLib")


return function()
	if #MM_N.safe_sectors <= 0 then return end
	if gamestate ~= GS_LEVEL then return end
	if MM_N.gameover then return end
	
	local printer_key = P_RandomRange(1, #MM_N.safe_sectors)
	local printer_ptr = MM_N.safe_sectors[printer_key]
	local printer = printer_ptr.sector
	
	local p_x
	--try to keep your sectors small man
	if abs((printer_ptr.left_bound/FU) - (printer_ptr.right_bound/FU)) > 65535
		error("Sector "..#printer.." is too big to automatically spawn coins. (left-right bounds > 65535 units)")
		table.remove(MM_N.safe_sectors, printer_key)
		return
	else
		p_x = (P_RandomRange(
			printer_ptr.left_bound/FU + P_RandomRange(-128,128),
			printer_ptr.right_bound/FU + P_RandomRange(-128,128)
		)*FU) + P_RandomFixed()
	end
	
	local p_y
	--try to keep your sectors small man
	if abs((printer_ptr.bottom_bound/FU) - (printer_ptr.top_bound/FU)) > 65535
		error("Sector "..#printer.." is too big to automatically spawn coins. (top-bottom bounds > 65535 units)")
		table.remove(MM_N.safe_sectors, printer_key)
		return
	else
		p_y = (P_RandomRange(
			printer_ptr.bottom_bound/FU + P_RandomRange(-128,128),
			printer_ptr.top_bound/FU + P_RandomRange(-128,128)
		)*FU) + P_RandomFixed()
	end
	
	local test_print = R_PointInSubsectorOrNil(p_x, p_y)
	if not test_print then return end
	if not MM_N.safe_sectors_ud[test_print.sector] then return end
	
	local ring = P_SpawnMobj(p_x,p_y,
		GetMobjSpawnHeight(MT_RING, p_x,p_y, 24*FU, false, FU),
		MT_RING
	)
	ring.state = S_MM_RING
	
	for rover in test_print.sector.ffloors()
		if not (rover.flags & (FF_EXISTS|FOF_BLOCKPLAYER)) then continue end
		
		local rover_top = rover.t_slope and P_GetZAt(rover.t_slope, ring.x,ring.y) or rover.topheight
		if (ring.z > rover_top) then continue end
		
		P_SetOrigin(ring, ring.x,ring.y, (rover_top) + 24*ring.scale)
	end
end