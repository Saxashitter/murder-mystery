local function_list = {}
local INTER_RANGE = 64*FU

--adds a function to the LUT and returns its ID
--use this funcion as an include, at the top and in whitespace (dont use during runtime)
--@identifier is a string to be used as a name/identifier
MM.addInteraction = function(func,identifier)
	if func == nil
		error("MM.addInteraction(): argument 1 must be a function",2)
		return
	end
	if identifier == nil
		error("MM.addInteraction(): argument 2 must be a string identifier",2)
		return
	end
	
	--does this func already exist?
	for k,thisfunc in ipairs(function_list)
		if thisfunc.func == func then
			return k
		end
	end
	
	table.insert(function_list,#function_list+1,{
		func = func,
		iden = identifier
	})
	return #function_list
end

--returns a function based on its identifier
MM.getInteraction = function(identifier)
	for k,thisfunc in ipairs(function_list)
		if thisfunc.iden == identifier then
			return thisfunc.func
		end
	end
	return nil
end

MM.interactFunction = function(p,mo,funcid)
	if funcid == 0 then return end
	if function_list[funcid] == nil then return end
	
	return function_list[funcid].func(p,mo)
end

--Only interact with the closest point of interest
MM.sortInteracts = function(p,a,b)
	if (a == nil) then return true end
	if (b == nil) then return false end
	
	if not (a.mo and a.mo.valid)
		return true
	end
	if not (b.mo and b.mo.valid)
		return false
	end
	
	local aDist = R_PointToDist2(p.mo.x,p.mo.y, a.mo.x,a.mo.y)
	local bDist = R_PointToDist2(p.mo.x,p.mo.y, b.mo.x,b.mo.y)
	
	if bDist <= aDist then
		return false
	end
	return true
end

MM.canInteract = function(p,mobj) --Point of interest
	if p.mm.interact == nil then return false end
	if (p.spectator or p.mm.spectator) then return false end
	
	local me = p.realmo
	
	if not (me.health) then return false end
	if not (me and me.valid) then return false end
	if not (mobj and mobj.valid)then return false end
	
	if R_PointToDist2(me.x,me.y, mobj.x,mobj.y) > FixedMul(INTER_RANGE,me.scale)+mobj.radius then return false end
	if not P_CheckSight(me,mobj) then return false end
	
	return true
end

MM.interactPoint = function(p,mobj,name,intertext,button,time,funcid)
	if not MM.canInteract(p,mobj) then return end
	if (p.mm.interact.interacted) then return end
	
	for k,inter in ipairs(p.mm.interact.points)
		--Dont add the same mobj multiple times
		if inter.mo == mobj
			return
		end
	end
	
	table.insert(p.mm.interact.points,{
		mo = mobj,
		name = name or "Thing",
		
		interacttext = intertext or "Interact",
		interacttime = time or TICRATE/4,
		interacting = 0,
		timesinteracted = 0,
		
		button = button or 0,
		timespan = 0,
		
		--the best way i can think of doing this without archiving a func
		--would be to have a lookup id to a LUT of funcs that another function
		--can add functions to
		func_id = funcid or 0,
		
		--idk what this is for
		hud = {
			xscale = 0,
			goingaway = false,
		}
	})
	if #p.mm.interact > 1
		table.sort(p.mm.interact.points,function(a,b)
			return MM.sortInteracts(p,a,b)
		end)
	end
end

local MT_Interaction = MM.addInteration(function(p,mo)
	if mo.calling_tag ~= 0
		P_LinedefExecute(mo.calling_tag,p.mo)
	end
end,"MapthingInteraction")

freeslot("MT_MM_INTERACT_POINT")
mobjinfo[MT_MM_INTERACT_POINT] = {
	--$Name Interaction Point
	--$Sprite UNKNB0
	--$Category SaxaMM

	--$Arg0 Name ID
	--$Arg0Default 0
	--$Arg0Type 0

	--$Arg1 Interaction Desc. ID
	--$Arg1Default 0
	--$Arg1Type 0
	
	--$Arg2 Interact Duration
	--$Arg2Default 0
	--$Arg2Type 0
	
	--$Arg3 Button
	--$Arg3Type 11
	--$Arg3Enum {128="Spin"; 1024="Toss flag"; 4096="Fire Normal", 8196="Custom 1"; 16385="Custom 2"; 32768="Custom 3"}
	--$Arg3Flags {128="Spin"; 1024="Toss flag"; 4096="Fire Normal", 8196="Custom 1"; 16385="Custom 2"; 32768="Custom 3"}
	flags = MF_NOGRAVITY|MF_NOSECTOR|MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOCLIPTHING,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	doomednum = 5000,
	spawnstate = S_INVISIBLE
}

addHook("MapThingSpawn",function(mt,mo)
	
end,MT_MM_INTERACT_POINT)
addHook("MobjThinker",function(point)
	for p in players.iterate
		MM.interactPoint(p,point,
			point.name,
			point.desc,
			point.button,
			point.duration,
			MT_Interaction
		)
	end
end,MT_MM_INTERACT_POINT)