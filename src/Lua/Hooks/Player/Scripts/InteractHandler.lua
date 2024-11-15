--Handle Roblox Interact Hud

local INTER_RANGE = 64*FU

return function(p)
	local me = p.realmo
	
	if not (me and me.valid) then return end
	
	if leveltime == 2*TICRATE
	or leveltime == 3*TICRATE
	or leveltime == 4*TICRATE
		if not p.thokpoint1
			local thok = P_SpawnMobjFromMobj(me,0,0,0,MT_THOK)
			thok.tics = -1
			thok.fuse = -1
			p.thokpoint1 = thok
		elseif not p.thokpoint2
			local thok = P_SpawnMobjFromMobj(me,0,0,0,MT_THOK)
			thok.tics = -1
			thok.fuse = -1
			p.thokpoint2 = thok
		else
			local thok = P_SpawnMobjFromMobj(me,0,0,0,MT_THOK)
			thok.tics = -1
			thok.fuse = -1
			p.thokpoint3 = thok
		end
	end
	MM.interactPoint(p,p.thokpoint1,p.name,nil,BT_CUSTOM3)
	MM.interactPoint(p,p.thokpoint2,p.name,nil,BT_CUSTOM3)
	MM.interactPoint(p,p.thokpoint3,p.name,nil,BT_CUSTOM3)
	
	table.sort(p.mm.interact,function(a,b)
		MM.sortInteracts(p,a,b)
	end)
	
	local interacting = false
	for k,inter in ipairs(p.mm.interact)
		local mo = inter.mo
		
		print(k,string.format("%f",R_PointToDist2(me.x,me.y, mo.x,mo.y)))
		print(not (mo and mo.valid),
			not (P_CheckSight(me,mo)),
			(R_PointToDist2(me.x,me.y, mo.x,mo.y) > FixedMul(INTER_RANGE,me.scale) + mo.radius),
			inter.timespan
		)
		
		if not (mo and mo.valid)
		or not (P_CheckSight(me,mo))
		or (R_PointToDist2(me.x,me.y, mo.x,mo.y) > FixedMul(INTER_RANGE,me.scale) + mo.radius)
			inter.interacting = 0
			if inter.timespan <= 0
				table.remove(p.mm.interact,k)
			else
				inter.timespan = max($-2,0)
			end
			continue
		end
		
		inter.timespan = min($+1,TICRATE/2) --% (5*TICRATE)
		
		--only one thing at a time
		if not interacting
			if (p.cmd.buttons & inter.button)
				inter.interacting = min($+1,inter.interacttime)
				interacting = true
			else
				inter.interacting = $*3/4
			end
		end
	end
end