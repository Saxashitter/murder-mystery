mobjinfo[freeslot "MT_MM_BULLET"] = {
	radius = 32*FU,
	height = 64*FU,
	spawnstate = S_RRNG1,
	flags = MF_NOGRAVITY,
	deathstate = S_SPRK1
}

addHook("MobjThinker", function(mo)
	if not mo.valid then return end

	mo.momx = FixedMul(32*cos(mo.angle), cos(mo.aiming))
	mo.momy = FixedMul(32*sin(mo.angle), cos(mo.aiming))
	mo.momz = 32*sin(mo.aiming)
	mo.radius = 2*mo.scale
	mo.height = 4*mo.scale

	for i = 1,256 do
		if not (mo and mo.valid) then
			return
		end

		--we do this so its easier to hit players from farther away, while also 
		--being able to hit players closer up in small areas
		mo.radius = $ + mo.scale/4
		mo.height = $ + mo.scale/2

		if mo.z <= mo.floorz
		or mo.z+mo.height >= mo.ceilingz then
			P_RemoveMobj(mo)
			return
		end

		if i % 4 == 0 then
			local effect = P_SpawnMobjFromMobj(mo, 0,0,0, MT_THOK)
			effect.tics = -1
			effect.fuse = -1
			effect.state = S_SPRK1
			effect.radius,effect.height = mo.radius,mo.height
		end

		P_XYMovement(mo)

		if not (mo and mo.valid) then
			return
		end

		P_ZMovement(mo)
	end

	if mo and mo.valid then
		P_RemoveMobj(mo)
	end
end, MT_MM_BULLET)

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
	P_RemoveMobj(ring)
end, MT_MM_BULLET)

addHook("MobjMoveBlocked", function(ring)
	if not (ring and ring.valid) then return end

	P_RemoveMobj(ring)
end, MT_MM_BULLET)

return MT_MM_BULLET