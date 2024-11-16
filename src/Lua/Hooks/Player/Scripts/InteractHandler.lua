--Handle Roblox Interact Hud

local INTER_RANGE = 64*FU
local TWEENTIME = TICRATE/2

return function(p)
	local me = p.realmo
	
	if not (me and me.valid) then return end
	
	if #p.mm.interact.points > 1
		table.sort(p.mm.interact.points,function(a,b)
			return MM.sortInteracts(p,a,b)
		end)
	end
	
	local mminter = p.mm.interact
	local interacting = false
	for k,inter in ipairs(mminter.points)
		local mo = inter.mo
		
		if not (inter.interacting or mminter.interacted)
			inter.hud.xscale = ease.outquad(FU/4,$,FixedDiv(inter.timespan*FU,TWEENTIME*FU))
		end
		
		inter.hud.goingaway = false
		if not MM.canInteract(p,mo)
			inter.hud.goingaway = true
			if inter.timesinteracted then inter.hud.xscale = 0 end
			
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
						
						inter.timesinteracted = $+1
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