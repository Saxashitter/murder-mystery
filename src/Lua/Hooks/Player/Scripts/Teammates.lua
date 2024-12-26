local stateLUT = {
	[MMROLE_MURDERER] = S_MM_TEAMMATE1,
	[MMROLE_SHERIFF] = S_MM_TEAMMATE2,
}

return function(p)
	if MM:pregame() then return end
	if (p.mm.role == MMROLE_INNOCENT) then return end
	--endgame cutscene
	if (p.mo.flags & MF_NOTHINK) then return end
	
	if not p.mm.teammates
	or (#p.mm.teammates == 0)
		p.mm.teammates = {}
		
		for p2 in players.iterate
			if p2 == p then continue end
			if not (p2.mm) then continue end
			if (p2.mm.spectator or p.spectator) then continue end
			if p2.mm.role ~= p.mm.role then continue end
			
			table.insert(p.mm.teammates,p2)
		end
	end
	
	for k,play in ipairs(p.mm.teammates)
		if not (play.mo and play.mo.valid and play.mo.health)
		or (play.mm.spectator or play.spectator)
			table.remove(p.mm.teammates,k)
			continue
		end
		
		P_SpawnLockOn(p, play.mo, stateLUT[p.mm.role] or S_MM_TEAMMATE1)
	end
end