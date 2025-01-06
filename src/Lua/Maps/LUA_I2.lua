freeslot("MT_TAKIS_MAN2CAMEO","S_TAKIS_MAN2CAMEO","SPR_M2TC")
sfxinfo[freeslot("sfx_man2sk")] = {
	flags = SF_X4AWAYSOUND,
	caption = "Skibidi hawl hawk."
}

states[S_TAKIS_MAN2CAMEO] = {
	sprite = SPR_M2TC,
	frame = A,
	tics = -1,
	nextstate = S_TAKIS_MAN2CAMEO
}
mobjinfo[MT_TAKIS_MAN2CAMEO] = {
	--$Name Takis Cameo
	--$Sprite M2TCA0
	--$Category Mansion2
	doomednum = 12302,
	spawnstate = S_TAKIS_MAN2CAMEO,
	spawnhealth = 10,
	height = 62*FRACUNIT,
	radius = 35*FRACUNIT,
	flags = MF_NOCLIPTHING|MF_NOGRAVITY
}

addHook("MobjThinker",function(me)
	if not (me and me.valid) then return end
	
	if not P_IsObjectOnGround(me)
		me.spriteyoffset = (sin(leveltime*2*ANG2))
	else
		me.spriteyoffset = 0
	end
	me.color = SKINCOLOR_FOREST
end,MT_TAKIS_MAN2CAMEO)