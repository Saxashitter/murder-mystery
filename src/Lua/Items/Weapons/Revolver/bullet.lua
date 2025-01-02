freeslot("SPR_RBUL")

states[freeslot("S_MM_REVOLV_B")] = {
	sprite = SPR_RBUL,
	frame = A|FF_ANIMATE|FF_SEMIBRIGHT,
	tics = E,
	var1 = E,
	var2 = 1,
	nextstate = S_MM_REVOLV_B
}

mobjinfo[freeslot("MT_MM_REVOLV_BULLET")] = {
	radius = 5*FU,
	height = 10*FU,
	spawnstate = S_MM_REVOLV_B,
	flags = MF_NOGRAVITY,
	deathstate = S_SMOKE1
}

local spread = 10
local function BulletDies(mo)
	local off = P_MobjFlip(mo) == -1 and -FixedDiv(mo.height,mo.scale)/2 or 0
	for i = 0, P_RandomRange(2,5)
		P_SpawnMobjFromMobj(mo,
			P_RandomRange(-spread,spread)*FU,
			P_RandomRange(-spread,spread)*FU,
			P_RandomRange(-spread,spread)*FU + off,
			MT_SMOKE
		)
	end
	
	local sfx = P_SpawnGhostMobj(mo)
	sfx.flags2 = $|MF2_DONTDRAW
	sfx.fuse = TICRATE
	S_StartSound(sfx,sfx_turhit)
end

addHook("MobjThinker", MM.GenericHitscan, MT_MM_REVOLV_BULLET)
addHook("MobjMoveCollide", MM.BulletHit, MT_MM_REVOLV_BULLET)

/*
addHook("MobjMoveBlocked", function(ring)
	if not (ring and ring.valid) then return end
	
	BulletDies(ring)
	P_RemoveMobj(ring)
end, MT_MM_REVOLV_BULLET)
*/

return MT_MM_REVOLV_BULLET