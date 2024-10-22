return function(self)
	if MM_N.voting then return end
	
	MM_N.voting = true
	MM_N.end_ticker = 0
	
	MM_N.mapVote = {}

	mapmusname = "MMINTR"
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

		if p.mm.role == MMROLE_MURDERER then
			table.insert(MM_N.murderers, p)
			continue
		end
		table.insert(MM_N.innocents, p)
	end
end