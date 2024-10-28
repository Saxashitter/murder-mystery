freeslot "MT_MM_CLUESPAWN"
mobjinfo[MT_MM_CLUESPAWN] = {
	radius = 1,
	height = 1,
	doomednum = 3001,
	spawnstate = S_NULL
}

addHook("MobjSpawn", function(spwn)
	MM:spawnClue(spwn)
end, MT_MM_CLUESPAWN)