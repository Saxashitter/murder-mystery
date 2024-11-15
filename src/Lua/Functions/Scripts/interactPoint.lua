local INTER_RANGE = 64*FU

--Hacky
MM.sortInteracts = function(p,a,b)
	if not (a.mo and a.mo.valid)
		return true
	end
	if not (b.mo and b.mo.valid)
		return false
	end
	if R_PointToDist2(p.mo.x,p.mo.y, b.mo.x,b.mo.y) <
	R_PointToDist2(p.mo.x,p.mo.y, a.mo.x,a.mo.y) then
		return false
	end
end

return function(p,mobj,name,intertext,button,time,funcid)
	if p.mm.interact == nil then return end
	
	if not (mobj and mobj.valid) then return end
	if not P_CheckSight(p.mo,mobj) then return end
	if R_PointToDist2(p.mo.x,p.mo.y, mobj.x,mobj.y) > FixedMul(INTER_RANGE,p.mo.scale)+mobj.radius then return end
	
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
	})
	table.sort(p.mm.interact,function(a,b)
		MM.sortInteracts(p,a,b)
	end)
end