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

addHook("MobjThinker", MM.GenericHitscan, MT_MM_REVOLV_BULLET)
addHook("MobjMoveCollide", MM.BulletHit, MT_MM_REVOLV_BULLET)
addHook("MobjMoveBlocked", function(ring, m,l)
	if not (ring and ring.valid) then return end
	
	MM.BulletDies(ring, m,l)
	P_RemoveMobj(ring)
end, MT_MM_REVOLV_BULLET)

return MT_MM_REVOLV_BULLET