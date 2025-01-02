mobjinfo[freeslot "MT_MM_BULLET"] = {
	radius = 8*FU,
	height = 16*FU,
	spawnstate = S_MM_REVOLV_B,
	flags = MF_NOGRAVITY,
	deathstate = S_SMOKE1,
	speed = 32*FU
}

local spread = 10
local function BulletDies(mo)
	for i = 0, P_RandomRange(2,5)
		P_SpawnMobjFromMobj(mo,
			P_RandomRange(-spread,spread)*FU,
			P_RandomRange(-spread,spread)*FU,
			P_RandomRange(-spread,spread)*FU,
			MT_SMOKE
		)
	end
	
	local sfx = P_SpawnGhostMobj(mo)
	sfx.flags2 = $|MF2_DONTDRAW
	sfx.fuse = TICRATE
	S_StartSound(sfx,sfx_turhit)
end

addHook("MobjThinker", function(mo)
	if not mo.valid then return end
	
	if mo.z <= mo.floorz
	or mo.z+mo.height >= mo.ceilingz then
		BulletDies(mo)
		P_RemoveMobj(mo)
		return
	end
	
	if mo.timealive == nil
		mo.timealive = 0
	else
		mo.timealive = $+1
	end
	
	local flip = P_MobjFlip(mo)
	local speed = 84
	mo.momx = FixedMul(speed*cos(mo.angle), cos(mo.aiming))
	mo.momy = FixedMul(speed*sin(mo.angle), cos(mo.aiming))
	mo.momz = speed*sin(mo.aiming)
	
	if mo.timealive >= TICRATE/2
		mo.aiming = $ - ANG1*flip
	end
	if mo.timealive >= TICRATE/3
		mo.aiming = $ - (ANG1/3)*flip
	end
	
	if (mo.timealive % 4) == 0
		P_SpawnGhostMobj(mo).frame = $|FF_SEMIBRIGHT
	end
end, MT_MM_BULLET)

addHook("MobjMoveCollide", MM.BulletHit, MT_MM_BULLET)

addHook("MobjMoveBlocked", function(ring)
	if not (ring and ring.valid) then return end
	
	BulletDies(ring)
	P_RemoveMobj(ring)
end, MT_MM_BULLET)

return MT_MM_BULLET