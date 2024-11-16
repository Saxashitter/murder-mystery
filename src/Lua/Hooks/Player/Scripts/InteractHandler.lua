--Handle Roblox Interact Hud

local INTER_RANGE = 64*FU
local TWEENTIME = TICRATE/2

/*
local inter_func_id = MM.addInteraction(function(p,mo)
	print(p.name..": Interaction success!")
end,"TEST1")
local inter_func_id2 = MM.addInteraction(function(p,mo)
	print(p.name..": Interaction removed this thok")
	P_RemoveMobj(mo)
end,"TEST2")
*/

return function(p)
	local me = p.realmo
	
	if not (me and me.valid) then return end
	
	/*
	if leveltime < 5
		p.thokpoint1,p.thokpoint2,p.thokpoint3 = nil,nil,nil
	end
	
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
	MM.interactPoint(p,p.thokpoint1,"Thok 1",nil,BT_CUSTOM3,TICRATE,inter_func_id)
	MM.interactPoint(p,p.thokpoint2,"Thok 2","Remove",BT_CUSTOM3,TICRATE,inter_func_id2)
	MM.interactPoint(p,p.thokpoint3,"Thok 3",nil,BT_CUSTOM3,TICRATE,inter_func_id)
	*/
	
	if #p.mm.interact.points > 1
		table.sort(p.mm.interact.points,function(a,b)
			return MM.sortInteracts(p,a,b)
		end)
	end
	
	local mminter = p.mm.interact
	local interacting = false
	for k,inter in ipairs(mminter.points)
		local mo = inter.mo
		
		/*
		print(k,string.format("%f",R_PointToDist2(me.x,me.y, mo.x,mo.y)))
		print(not (mo and mo.valid),
			not (P_CheckSight(me,mo)),
			(R_PointToDist2(me.x,me.y, mo.x,mo.y) > FixedMul(INTER_RANGE,me.scale) + mo.radius),
			MM.canInteract(p,mo),
			inter.timespan
		)
		*/
		
		if not (inter.interacting or mminter.interacted)
			inter.hud.xscale = ease.outquad(FU/4,$,FixedDiv(inter.timespan*FU,TWEENTIME*FU))
		end
		
		if not MM.canInteract(p,mo)
			inter.interacting = 0
			if inter.timespan <= 0
				table.remove(mminter.points,k)
				mminter.interacted = false
			else
				inter.timespan = max($-2,0)
			end
			continue
		end
		
		inter.timespan = min($+2,TWEENTIME) --% (5*TICRATE)
		
		--only one thing at a time
		if not interacting
			if (p.cmd.buttons & inter.button)
				inter.hud.xscale = ease.outquad(FU/2,$,0)
				
				if not (mminter.interacted)
					local old_int = inter.interacting
					inter.interacting = min($+1,inter.interacttime)
					
					if inter.interacting == inter.interacttime
					and old_int ~= inter.interacttime
						mminter.interacted = true
						
						local oldpos = {mo.x,mo.y,mo.z}
						MM.interactFunction(p,mo,inter.func_id)
						
						--for hud
						if not (mo and mo.valid)
							inter.backup = P_SpawnMobj(oldpos[1],oldpos[2],oldpos[3],MT_THOK)
							inter.backup.flags2 = $|MF2_DONTDRAW
							inter.backup.fuse,inter.backup.tics = TWEENTIME,TWEENTIME
							mminter.interacted = false
							continue
						end
					end
				else
					inter.interacting = $*3/4
				end
				interacting = true
			else
				mminter.interacted = false
				inter.interacting = $*3/4
			end
		else
			inter.interacting = $*3/4
		end
	end
	if #mminter.points == nil then mminter.interacted = false end
end