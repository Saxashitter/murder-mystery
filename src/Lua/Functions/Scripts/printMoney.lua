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
		if P_RandomChance(FU/2)
			p_x = (P_RandomRange(
				printer_ptr.left_bound/FU + P_RandomRange(-128,128),
				printer_ptr.right_bound/FU + P_RandomRange(-128,128)
			)*FU) + P_RandomFixed()
		else
			p_x = printer_ptr.left_bound + (P_RandomRange(
				P_RandomRange(-128,128),
				abs(abs(printer_ptr.right_bound) - abs(printer_ptr.left_bound))/FU + P_RandomRange(-128,128)
			)*FU) + P_RandomFixed()
		end
	end
	
	local p_y
	--try to keep your sectors small man
	if abs((printer_ptr.bottom_bound/FU) - (printer_ptr.top_bound/FU)) > 65535
		error("Sector "..#printer.." is too big to automatically spawn coins. (top-bottom bounds > 65535 units)")
		table.remove(MM_N.safe_sectors, printer_key)
		return
	else
		if P_RandomChance(FU/2)
			p_y = (P_RandomRange(
				printer_ptr.bottom_bound/FU + P_RandomRange(-128,128),
				printer_ptr.top_bound/FU + P_RandomRange(-128,128)
			)*FU) + P_RandomFixed()
		else
			p_y = printer_ptr.bottom_bound + (P_RandomRange(
				P_RandomRange(-128,128),
				abs(abs(printer_ptr.top_bound) - abs(printer_ptr.bottom_bound))/FU + P_RandomRange(-128,128)
			)*FU) + P_RandomFixed()
		end
	end
	
	local test_print = R_PointInSubsectorOrNil(p_x, p_y)
	if not test_print then return end
	if not MM_N.safe_sectors_ud[test_print.sector] then return end
	
	local spawn_height = GetMobjSpawnHeight(MT_RING, p_x,p_y, 0, false, FU) + 24*FU
	local ring = P_SpawnMobj(p_x,p_y,
		--should be safe to add 24 directly, we wont be flipping anyway
		spawn_height,
		MT_RING
	)
	ring.state = S_MM_RING
	
	for rover in ring.subsector.sector.ffloors()
		if (rover.flags & FOF_BLOCKPLAYER) == 0 then continue end
		if (rover.flags & FF_EXISTS) == 0 then continue end
		
		local rover_top = rover.topheight
		if rover.t_slope
			rover_top = P_GetZAt(rover.t_slope, ring.x,ring.y)
		end
		
		local rover_bot = rover.bottomheight
		if rover.b_slope
			rover_bot = P_GetZAt(rover.b_slope, ring.x,ring.y)
		end
		
		-- over/under
		--TODO: fof control sectors have some sort of effect
		--		to allow rings to spawn on top of them
		if (ring.z > rover_top)
		or ring.z + ring.height <= rover_bot - FU
			
			continue
		end
		
		P_SetOrigin(ring, ring.x,ring.y, rover_top + 24*ring.scale)
		
		if CV_MM.debug.value
			ring.colorized = true
			ring.color = SKINCOLOR_GALAXY
			
			rover.bottompic = "GKS"
			rover.toppic = "GKS"
			
			local th = P_SpawnMobjFromMobj(ring,0,0,0,MT_THOK)
			th.z = rover_top
			th.fuse = 10*TICRATE
			th.tics = th.fuse
		end
	end

	if CV_MM.debug.value
		local th = P_SpawnMobjFromMobj(ring,0,0,0,MT_THOK)
		th.color = SKINCOLOR_RED
		th.z = spawn_height - 24*FU
		th.fuse = 10*TICRATE
		th.tics = th.fuse
	end
end