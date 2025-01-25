--Handle Roblox Interact Hud
local function onPoint(point1,point2)
	local x1,y1 = FixedFloor(point1.x),FixedFloor(point1.y)
	local x2,y2 = FixedFloor(point2.x),FixedFloor(point2.y)
	return (x1 == x2) and (y1 == y2) --(x1 >= x2 - FU and x1 <= x2 + FU) and (y1 >= y2 - FU and y1 <= y2 + FU)
end

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
	--local lastInteraction
	for k,inter in ipairs(mminter.points)
		local mo = inter.mo
		
		if not (inter.interacting or mminter.interacted)
			inter.hud.xscale = ease.outquad(FU/4,$,FixedDiv(inter.timespan*FU,TWEENTIME*FU))
		end
		
		inter.hud.goingaway = false
		if not MM.canInteract(p,mo)
		--or (lastInteraction and onPoint(mo, lastInteraction.mo))
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
						local caninteract = true
						if (inter.price ~= 0)
							caninteract = p.mm_save.rings >= inter.price
							if caninteract
								p.mm_save.rings = $ - inter.price
								S_StartSound(nil,sfx_chchng,p)
							else
								S_StartSound(nil,sfx_adderr,p)
							end
						end
						
						inter.timesinteracted = $+1
						local oldpos = {mo.x,mo.y,mo.z}
						if caninteract
							MM.interactFunction(p,mo,inter.func_id)
							
							if inter.itemdrop_id then
								MM:SpawnItemDrop(inter.itemdrop_id, mo.x, mo.y, mo.z, mo.angle, 0)
							end
						end
						
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
		--lastInteraction = inter
	end
	if #mminter.points == nil or #mminter.points == 0 then mminter.interacted = false end
end