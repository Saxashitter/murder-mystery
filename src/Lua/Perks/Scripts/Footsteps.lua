local function shouldspawnstep(p,me)
	if not P_IsObjectOnGround(me) then return false; end
	
	local halfframe = skins[p.skin].sprites[me.sprite2].numframes
	halfframe = $/2
	local myframe = (me.frame & FF_FRAMEMASK)
	
	if myframe == A
	or myframe == halfframe
	and (myframe ~= player.mo.mm_lastframe
		return true
	end
	
	return false
end

local function FootstepsSpawner(p, secondary)
	for player in players.iterate
		if player.spectator then continue end
		if not (player.mo and player.mo.valid) then continue end
		if not (player.mo.health) then continue end
		if player == p then continue end
		if player.mm.role == MMROLE_MURDERER then continue end
		
		local spawnit = shouldspawnstep(player, player.mo)
		player.mo.mm_lastframe = (player.mo.frame & FF_FRAMEMASK)
		
		print(player.name..": "..tostring(spawnit))
		if not spawnit then continue end
		
		P_SpawnMobjFromMobj(player.mo, 0,0,0, MT_THOK)
	end
end

MM_PERKS[MMPERK_FOOTSTEPS] = {
	primary = function(p)
		FootstepsSpawner(p, false)
	end,
	secondary = function(p)
		FootstepsSpawner(p, true)
	end,
}