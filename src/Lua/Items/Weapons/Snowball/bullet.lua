local zcollide = MM.require "Libs/zcollide"

states[freeslot("S_MM_SNOWBALL_B")] = {
	sprite = SPR_SNB9,
	frame = A|FF_ANIMATE|FF_SEMIBRIGHT,
	
	nextstate = S_MM_REVOLV_B
}

mobjinfo[freeslot("MT_MM_SNOWBALL_BULLET")] = {
	radius = 24*FU,
	height = 24*FU,
	spawnstate = S_MM_SNOWBALL_B,
	--flags = MF_SOLID,
	speed = 64*FRACUNIT,
	deathstate = S_SMOKE1
}

addHook("MobjThinker", function(mobj)
	if mobj and mobj.valid then
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
	
	local power = 65*FRACUNIT
	local punchangle = R_PointToAngle2(tmthing.x, tmthing.y, thing.x, thing.y)
	
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