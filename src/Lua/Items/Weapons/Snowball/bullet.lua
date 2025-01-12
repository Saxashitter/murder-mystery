local zcollide = MM.require "Libs/zcollide"
local ticsuntilnograv = 6

states[freeslot("S_MM_SNOWBALL_B")] = {
	sprite = SPR_SNB9,
	frame = A|FF_ANIMATE|FF_SEMIBRIGHT,
	
	nextstate = S_MM_REVOLV_B
}

mobjinfo[freeslot("MT_MM_SNOWBALL_BULLET")] = {
	radius = 24*FU,
	height = 24*FU,
	spawnstate = S_MM_SNOWBALL_B,
	flags = MF_NOGRAVITY,
	speed = 80*FRACUNIT,
	deathstate = S_SMOKE1
}

addHook("MobjThinker", function(mobj)
	if mobj and mobj.valid then
		local dead = false
		
		if mobj.state ~= S_MM_SNOWBALL_B then
			mobj.colorized = true
			mobj.color = SKINCOLOR_WHITE
			mobj.scalespeed = 1
			mobj.destscale = 2*FU
			
			mobj.momx = 0
			mobj.momy = 0
			mobj.momz = 0
			
			dead = true
		end
		
		mobj.snowball_tics = $ or 0
		mobj.snowball_tics = $ + 1
		
		if not dead then
			local thok = P_SpawnMobjFromMobj(mobj, 0, 0, 0, MT_THOK)
			thok.state = S_MM_SNOWBALL_B
			thok.scalespeed = FRACUNIT/10
			thok.fuse = 15
			thok.destscale = 1
		end
		
		if mobj.snowball_tics >= ticsuntilnograv
		and (mobj.flags & MF_NOGRAVITY) then
			mobj.flags = $ & ~MF_NOGRAVITY
		end
		
		if (mobj.eflags & MFE_JUSTHITFLOOR) then
			P_ExplodeMissile(mobj)
		end
	end
end, MT_MM_SNOWBALL_BULLET)


addHook("MobjMoveCollide", function(tmthing, thing)
	if not (tmthing and tmthing.valid) then return end
	if not (thing and thing.valid) then return end
	if not zcollide(tmthing, thing) then return end
	if (tmthing.target and tmthing.target == thing) then return end
	if (thing.type ~= MT_PLAYER) then return end
	if (tmthing.state ~= S_MM_SNOWBALL_B) then return end
	
	local power = 65*FRACUNIT
	local punchangle = tmthing.angle
	
	if P_IsObjectOnGround(thing) then
		power = $ * 2
	end
	
	P_Thrust(thing, punchangle, power)
	
	P_ExplodeMissile(tmthing)
end, MT_MM_SNOWBALL_BULLET)

addHook("MobjMoveBlocked", function(mobj)
	if mobj and mobj.valid then
		P_ExplodeMissile(mobj)
	end
end, MT_MM_SNOWBALL_BULLET)