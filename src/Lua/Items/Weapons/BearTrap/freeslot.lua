local TR = TICRATE
local function SafeFreeslot(...)
	for _, item in ipairs({...})
		if rawget(_G, item) == nil
			return freeslot(item)
		end
	end
end

states[SafeFreeslot("S_MM_BEARTRAP_FRIENDLY")] = {
	sprite = SafeFreeslot("SPR_BEARTRAP"),
	frame = A,
	tics = -1
}

states[SafeFreeslot("S_MM_BEARTRAP_WAIT")] = {
	sprite = SPR_BEARTRAP,
	frame = A,
	tics = -1
}

SafeFreeslot("S_MM_BEARTRAP_SNAPPED")
states[SafeFreeslot("S_MM_BEARTRAP_CATCH")] = {
	sprite = SPR_BEARTRAP,
	frame = B|FF_ANIMATE,
	var1 = F - B,
	var2 = 1,
	tics = F,
	nextstate = S_MM_BEARTRAP_SNAPPED
}
states[S_MM_BEARTRAP_SNAPPED] = {
	sprite = SPR_BEARTRAP,
	frame = F,
	tics = 4*TR,
}

mobjinfo[SafeFreeslot("MT_MM_BEARTRAP")] = {
	doomednum = -1,
	spawnstate = S_MM_BEARTRAP_WAIT,
	deathstate = S_MM_BEARTRAP_CATCH,
	deathsound = sfx_thok,
	activesound = sfx_spkdth,
	seesound = sfx_subsmt,
	spawnhealth = 1,
	height = 12*FRACUNIT,
	radius = 16*FRACUNIT,
	flags = MF_RUNSPAWNFUNC
}

MM:RegisterEffect("perk.beartrap.slow", {
	modifiers = {
		normalspeed_multi = FU/3
	},
})

addHook("MobjThinker",function(trap)
	if not (trap and trap.valid) then return end
	if P_IsObjectOnGround(trap)
		trap.flags = $|MF_SPECIAL
	end
	
	if trap.tracer and trap.tracer.valid
	and trap.tracer.player and trap.tracer.player.valid then
		if not trap.target then
			trap.drawonlyforplayer = trap.tracer.player
		end
	end
	
	local me = trap.target
	if not (me and me.valid) then return end
	
	P_MoveOrigin(trap, me.x,me.y,me.z)
	trap.flags = $|MF_NOGRAVITY
	trap.momx,trap.momy,trap.momz = 0,0,0
	trap.dispoffset = me.dispoffset + 1
	
	--fall off
	if trap.tics == 1
	and (trap.state == S_MM_BEARTRAP_SNAPPED)
		trap.state = S_MM_BEARTRAP_SNAPPED
		trap.flags = $ &~MF_NOGRAVITY
		trap.momx,trap.momy = $1 + me.momx, $2 + me.momy
		trap.momz = $ + me.momz
		P_SetObjectMomZ(trap,4*FU,true)
		trap.target = nil
	end
end,MT_MM_BEARTRAP)

addHook("TouchSpecial",function(mine,me)
	if not (mine and mine.valid) then return end
	if not (me and me.valid) then return end
	if not (me.health) then return end
	
	local p = me.player
	
	--dont kill our teammates lol
	local isTeamMate = (p.mm.role == MMROLE_MURDERER
	and mine.tracer.player.mm.role == MMROLE_MURDERER)
	and (me ~= mine.tracer)
	
	if isTeamMate or (me == mine.tracer) then
		mine.health = mine.info.spawnhealth
		mine.flags = $|MF_SPECIAL
		return true
	end
	
	local sfx = P_SpawnGhostMobj(mine)
	sfx.flags2 = $|MF2_DONTDRAW
	sfx.fuse = 3*TR
	
	S_StartSound(sfx,mine.info.deathsound)
	
	--caught
	mine.target = me
	mine.drawonlyforplayer = nil
	MM:ApplyPlayerEffect(p, "perk.beartrap.slow", 4*TR)
	S_StartSound(me,mine.info.activesound)
end,MT_MM_BEARTRAP)

return S_MM_BEARTRAP_FRIENDLY