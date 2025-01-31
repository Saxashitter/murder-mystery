freeslot("S_MM_RING", "S_MM_RING_SPARKLE", "SPR_MMCN", "SPR_MMSP")

local SPARKLE_FRAMES = 7
local SPARKLE_SPEED = 2
states[S_MM_RING] = {SPR_MMCN, A|FF_ANIMATE, -1, nil, 7, 3, S_MM_RING}
states[S_MM_RING_SPARKLE] = {SPR_MMSP, A|FF_ANIMATE, SPARKLE_FRAMES*SPARKLE_SPEED, nil, SPARKLE_FRAMES, 2, S_NULL}

addHook("MobjSpawn", function(mo)
	if mo and mo.valid
		if not mo.override
			mobjinfo[MT_RING].spawnstate = S_MM_RING
			mobjinfo[MT_RING].deathstate = S_MM_RING_SPARKLE
			mobjinfo[MT_RING].deathsound = sfx_S3K33
			--mo.scale = $+(FU/3)
			mo.override = true
		end
	elseif mo.override == true
		mo.override = false
	end
end, MT_RING)