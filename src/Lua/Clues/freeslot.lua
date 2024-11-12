freeslot "MT_MM_CLUESPAWN"

sfxinfo[freeslot "sfx_cluecl"].caption = "Collected clue!"
mobjinfo[MT_MM_CLUESPAWN] = {
	--$Name Clue Spawner
	--$Sprite SHGNC0
	--$Category SaxaMM
	flags = MF_NOGRAVITY,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	doomednum = 3001,
	spawnstate = S_NULL
}