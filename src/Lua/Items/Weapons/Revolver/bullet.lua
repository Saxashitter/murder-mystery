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
	radius = 3*FU,
	height = 6*FU,
	spawnstate = S_MM_REVOLV_B,
	flags = MF_NOGRAVITY,
	deathstate = S_SMOKE1
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

	mo.momx = FixedMul(32*cos(mo.angle), cos(mo.aiming))
	mo.momy = FixedMul(32*sin(mo.angle), cos(mo.aiming))
	mo.momz = 32*sin(mo.aiming)
	mo.bullframe = A
	
	for i = 1,256 do
		if not (mo and mo.valid) then
			return
		end
		
		--we do this so its easier to hit players from farther away, while also 
		--being able to hit players closer up in small areas
		local gs = P_SpawnGhostMobj(mo)
		gs.flags2 = $|MF2_DONTDRAW
		
		mo.radius = $ + mo.scale/4
		if not (mo and mo.valid)
			BulletDies(gs)
			return
		end
		mo.height = $ + mo.scale/2
		
		--drop off
		if (i >= 192)
			if mo.origin.state ~= S_MM_LUGER
				mo.momz = $ - (mo.scale/3)*P_MobjFlip(mo)
			else
				mo.momz = $ - (mo.scale/2)*P_MobjFlip(mo)
			end
		end
		if (i >= 64)
		and mo.origin.state ~= S_MM_LUGER
			mo.momz = $ - (mo.scale/2)*P_MobjFlip(mo)
		end

		if mo.z <= mo.floorz
		or mo.z+mo.height >= mo.ceilingz then
			BulletDies(mo)
			P_RemoveMobj(mo)
			return
		end

		if i % 2 == 0 then
			local ghs = P_SpawnGhostMobj(mo)
			ghs.frame = (mo.bullframe % E)|FF_SEMIBRIGHT
			ghs.fuse = $*2
			mo.bullframe = $ + 1
		end
		
		P_XYMovement(mo)
		
		if not (mo and mo.valid) then
			return
		end
		
		P_ZMovement(mo)
	end

	if mo and mo.valid then
		BulletDies(mo)
		P_RemoveMobj(mo)
	end
end, MT_MM_REVOLV_BULLET)

addHook("MobjMoveCollide", function(ring, pmo)
	if not (ring and ring.valid) then return end
	if not (pmo and pmo.valid and pmo.player and pmo.health and pmo.player.mm) then return end
	if (pmo == ring.target) then return end

	if ring.z > pmo.z+pmo.height then return end
	if pmo.z > ring.z+ring.height then return end
	
	if pmo.player and pmo.player.mm
	and pmo.player.mm.role == ring.target.player.mm.role
		return
	end
	
	P_DamageMobj(pmo, ring, (ring.target and ring.target.valid) and ring.target or ring, 999, DMG_INSTAKILL)
	BulletDies(ring)
	P_RemoveMobj(ring)
end, MT_MM_REVOLV_BULLET)

addHook("MobjMoveBlocked", function(ring)
	if not (ring and ring.valid) then return end
	
	BulletDies(ring)
	P_RemoveMobj(ring)
end, MT_MM_REVOLV_BULLET)

return MT_MM_REVOLV_BULLET