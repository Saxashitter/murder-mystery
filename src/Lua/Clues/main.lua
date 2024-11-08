dofile "Clues/freeslot"

function MM:spawnClueMobj(p, pos)
	local mobj = P_SpawnMobj(pos.x, pos.y, pos.z, MT_MM_CLUESPAWN)

	mobj.state = S_THOK
	mobj.tics = -1
	mobj.fuse = -1
	mobj.drawonlyforplayer = p
	mobj.color = p.mo.color

	return mobj
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
	local cluePositions = {}

	for thing in mapthings.iterate do
		if thing.type ~= 3001 then continue end

		local newPos = {}

		newPos.x = thing.x*FU
		newPos.y = thing.y*FU

		local z = P_FloorzAtPos(newPos.x, newPos.y, 0, mobjinfo[MT_PLAYER].height)

		newPos.z = z

		table.insert(cluePositions, newPos)
	end

	if not (#cluePositions) then return end

	amount = min(#cluePositions, amount)
	MM_N.clues_amount = amount

	for p in players.iterate do
		local clues = {}
		local found = {}
	
		for i = 1, amount do
			local clue

			while not clue do
				local key = P_RandomRange(1, #cluePositions)
				if not found[key] then
					found[key] = true
					clue = cluePositions[key]
				end
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
	local removalList = {}

	if not (#p.mm.clues) then return end

	for i,clue in pairs(p.mm.clues) do
		local pos = clue.ref

		if abs(p.mo.x-pos.x) > p.mo.radius
		or abs(p.mo.y-pos.y) > p.mo.radius
		or abs(p.mo.z-pos.z) > p.mo.height then
			continue
		end

		if not (clue.mobj and clue.mobj.valid) then
			clue.mobj = MM:spawnClueMobj(p, clue.ref)
		end

		table.insert(removalList, clue)
	end

	for _,remove in pairs(removalList) do
		for i,clue in pairs(p.mm.clues) do
			if clue == remove then
				S_StartSound(p.mo, sfx_cluecl)
				if clue.mobj.valid then
					P_RemoveMobj(clue.mobj)
				end

				table.remove(p.mm.clues, i)

				break
			end
		end
	end

	if not (#p.mm.clues) then -- YOU GOT ALL OF EM
		MM:GiveItem(p, "gun")
	end
end)