freeslot("MT_MM_CLUESPAWN")
mobjinfo[MT_MM_CLUESPAWN] = {
	radius = 1,
	height = 1,
	spawnstate = S_THOK
}

local function do_spawn(mo)
end

addHook("MobjSpawn", function(spwn)
	MM:spawnClue(spwn)
	if spwn.valid then
		P_RemoveMobj(spwn)
	end
end)