mobjinfo[freeslot "MT_MM_BULLET"] = {
	radius = 32*FU,
	height = 64*FU,
	spawnstate = S_RRNG1,
	flags = MF_NOGRAVITY
}

addHook("MobjThinker", function(mo)
	if not mo.valid then return end

	if mo.z == mo.floorz
	or mo.z+mo.height == mo.ceilingz then
		P_RemoveMobj(mo)
		return
	end
end, MT_MM_BULLET)

addHook("MobjMoveCollide", function(ring, pmo)
	if not (ring and ring.valid) then return end
	if not (pmo and pmo.valid and pmo.player and pmo.health and pmo.player.mm) then return end
	if (pmo == ring.target) then return end

	if ring.z > pmo.z+pmo.height then return end
	if pmo.z > ring.z+ring.height then return end

	P_DamageMobj(pmo, ring, (ring.target and ring.target.valid) and ring.target or ring, 999, DMG_INSTAKILL)
	P_RemoveMobj(ring)
end, MT_MM_BULLET)

addHook("MobjMoveBlocked", function(ring)
	if not (ring and ring.valid) then return end

	P_RemoveMobj(ring)
end, MT_MM_BULLET)