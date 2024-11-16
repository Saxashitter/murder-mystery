local INTER_RANGE = 64*FU

--Hacky
--Only interact with the closest point of interest
MM.sortInteracts = function(p,a,b)
	if not (a.mo and a.mo.valid)
		return true
	end
	if not (b.mo and b.mo.valid)
		return false
	end
	
	local aDist = R_PointToDist2(p.mo.x,p.mo.y, a.mo.x,a.mo.y)
	local bDist = R_PointToDist2(p.mo.x,p.mo.y, b.mo.x,b.mo.y)
	print(string.format("adist: %.2f - bdist: %.2f (= %.2f)"..tostring(bDist <= aDist),
		bDist,
		aDist,
		bDist - aDist
	))
	
	if bDist <= aDist then
		return false
	end
	return true
end

MM.canInteract = function(p,mobj) --Point of interest
	local me = p.realmo
	if not (me and me.valid) then return false end
	if not (mobj and mobj.valid)then return false end
	
	if R_PointToDist2(me.x,me.y, mobj.x,mobj.y) > FixedMul(INTER_RANGE,me.scale)+mobj.radius then return false end
	if not P_CheckSight(me,mobj) then return false end
	
	return true
end

return function(p,mobj,name,intertext,button,time,funcid)
	if p.mm.interact == nil then return end
	
	if not MM.canInteract(p,mobj) then return end
	
	for k,inter in ipairs(p.mm.interact)
		--Dont add the same mobj multiple times
		if inter.mo == mobj
			return
		end
	end
	
	table.insert(p.mm.interact,{
		mo = mobj,
		name = name or "Thing",
		interacttext = intertext or "Interact",
		interacttime = time or TICRATE/4,
		interacting = 0,
		button = button or 0,
		timespan = 0,
		--the best way i can think of doing this without archiving a func
		--would be to have a lookup id to a LUT of funcs that another function
		--can add functions to
		func_id = funcid or 0,
		
		--idk what this is for
		hud = {
			xscale = 0,
		}
	})
	if #p.mm.interact > 1
		table.sort(p.mm.interact,function(a,b)
			return MM.sortInteracts(p,a,b)
		end)
	end
end