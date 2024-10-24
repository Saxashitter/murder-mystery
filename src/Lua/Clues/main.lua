dofile "Clues/freeslot"

function MM:spawnClueMobj(pos)
	local mobj = P_SpawnMobj(pos.x, pos.y, pos.z)

	mobj.state = S_THOK
	mobj.tics = -1
	mobj.fuse = -1
end

function MM:spawnClue(pos)
	if not MM:isMM() then return end

	MM_N.clues_in_map = true

	MM_N.clues[#MM_N.clues+1] = {
		x = pos.x,
		y = pos.y,
		z = pos.z,
		mobj = self:spawnClueMobj(pos)
	}
end

function MM:giveOutClues(amount)
	if not MM_N.clues_in_map then return end

	MM_N.clues_amount = amount

	for p in players.iterate do
		local clues = {}
		clues.collected = 0
	
		for i = 1, amount do
			local key = P_RandomRange(1, #MM_N.clues)
			clues[#clues+1] = MM_N.clues[key]
		end
	
		p.mm.clues = clues
	end
end


addHook("ThinkFrame", do
	if not MM:isMM() then return end

	for k,clue in pairs(MM_N.clues) do
		-- clue thinker
	end
end)