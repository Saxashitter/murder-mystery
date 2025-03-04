freeslot "MT_MM_CLUESPAWN"

freeslot("S_MM_CLUE_DEFAULT", "SPR_MM_CLUE_DEFAULT")
states[S_MM_CLUE_DEFAULT] = {SPR_MM_CLUE_DEFAULT, A|FF_ANIMATE, -1, nil, 15, 2, S_MM_CLUE_DEFAULT}

sfxinfo[freeslot "sfx_cluecl"].caption = "Collected clue!"
--this uses a copied clue sprite because idk if uzb can read long sprites
mobjinfo[MT_MM_CLUESPAWN] = {
	--$Name Clue Spawner
	--$Sprite BGLSJ0
	--$Category SaxaMM
	--$NotAngled
	flags = MF_NOGRAVITY,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	doomednum = 3001,
	spawnstate = S_NULL
}