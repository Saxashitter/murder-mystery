MM.endTypes = {
	{
		name = "Innocents win!",
		color = V_GREENMAP,
		results = "innocents"
	},
	{
		name = "Murderer wins!",
		color = V_REDMAP,
		results = "murderers"
	}
}

return function(self, endType)
	if MM_N.gameover then return end

	local endType = MM.endTypes[endType] or 1

	MM_N.endType = endType
	MM_N.gameover = true

	S_StopMusic(consoleplayer)
	
	for mo in mobjs.iterate()
		if not (mo and mo.valid) then continue end
		if (mo == MM_N.end_camera) then continue end
		
		if mo.flags & MF_NOTHINK
			mo.notthinking = true
			continue
		end
		
		mo.flags = $|MF_NOTHINK
		S_StopSound(mo)
	end
	
	/*
	MM_N.mapVote = {}

	mapmusname = "_INTER"
	S_ChangeMusic(mapmusname)
	
	local addedMaps = 0
	while addedMaps < 3 do
		local map = P_RandomRange(1, 1024)
		if not mapheaderinfo[map] then continue end

		local data = mapheaderinfo[map]

		local mapWasIn = false
		for _,oldmap in ipairs(MM_N.mapVote) do
			if map == oldmap.map then mapWasIn = true break end
		end
		if mapWasIn then continue end

		if not (data.typeoflevel & TOL_MATCH) then
			continue
		end
		if data.bonustype then continue end

		table.insert(MM_N.mapVote, {
			map = map,
			votes = 0
		})
		addedMaps = $+1
	end
	
	for p in players.iterate do
		if not (p and p.mm) then continue end

		if p.mm.role == 2 then
			table.insert(MM_N.murderers, p)
			continue
		end
		table.insert(MM_N.innocents, p)
	end
	*/

end