dofile "Clues/freeslot"

function MM:spawnClueMobj(p, pos)
	local mobj = P_SpawnMobj(pos.x, pos.y, pos.z)

	mobj.state = S_THOK
	mobj.tics = -1
	mobj.fuse = -1
	mobj.drawonlyforplayer = p

	return p
end

function MM:spawnClue(pos)
	if not MM:isMM() then return end

	MM_N.clues_in_map = true

	MM_N.clues[#MM_N.clues+1] = {
		x = pos.x,
		y = pos.y,
		z = pos.z
	}
end

function MM:giveOutClues(amount)
	if not MM_N.clues_in_map then return end

	amount = min(#MM_N.clues, amount)
	MM_N.clues_amount = amount

	for p in players.iterate do
		local clues = {}
		local found = {}

		clues.collected = 0
	
		for i = 1, amount do
			local clue

			while not clue do
				local key = P_RandomRange(1, #MM_N.clues)
				if found[key] then continue end
	
				clue = MM_N.clues[key]
				found[key] = true
			end

			clues[#clues+1] = {
				ref = clue,
				mobj = MM:spawnClueMobj(p, clue)
			}
		end
	
		p.mm.clues = clues
	end
end


MM:addPlayerScript(function(p)
	for k,clue in pairs(p.mm.clues) do
		print "valid clue"
	end
end)