dofile "Clues/freeslot"

local GetMobjSpawnHeight, GetMapThingSpawnHeight = MM.require "Libs/MapThingLib"

function MM:spawnClueMobj(p, pos)
	local mobj = P_SpawnMobj(pos.x, pos.y, pos.z, MT_MM_CLUESPAWN)

	mobj.state = S_THOK
	mobj.frame = $|FF_FULLBRIGHT
	mobj.tics = -1
	mobj.fuse = -1
	mobj.drawonlyforplayer = p
	mobj.color = p.mo.color

	if pos.flip then
		mobj.flags2 = $|MF2_OBJECTFLIP
	end

	return mobj
end

function MM:giveOutClues(amount)
	local cluePositions = {}

	for thing in mapthings.iterate do
		if thing.type ~= 3001 then continue end

		local newPos = {}

		newPos.x = thing.x*FU
		newPos.y = thing.y*FU

		local z = GetMapThingSpawnHeight(MT_MM_CLUESPAWN, thing, newPos.x, newPos.y)
		newPos.z = z

		newPos.flip = (thing.options & MTF_OBJECTFLIP)

		table.insert(cluePositions, newPos)
	end

	if not (#cluePositions) then return end

	amount = min(#cluePositions, amount)
	MM_N.clues_amount = amount

	for p in players.iterate do
		local clues = {}
		local found = {}
	
		clues.amount = amount
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

	for i,clue in ipairs(p.mm.clues) do
		local pos = clue.ref

		if abs(p.mo.x-pos.x) > p.mo.radius*3/2
		or abs(p.mo.y-pos.y) > p.mo.radius*3/2
		or abs(p.mo.z-pos.z) > p.mo.height*3/2 then
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
				local text = "CLUE FOUND!"

				S_StartSound(p.mo, sfx_cluecl)
				if clue.mobj.valid then
					P_RemoveMobj(clue.mobj)
				end

				table.remove(p.mm.clues, i)
				local subtext = tostring(#p.mm.clues).."/"..tostring(p.mm.clues.amount).." remaining..."

				if not (#p.mm.clues) then
					text = "YOU FOUND THEM ALL!"
					subtext = "Your clues gave you a shotgun!"
					MM:GiveItem(p, "gun")
				end

				if p == displayplayer then
					MMHUD:PushToTop(3*TICRATE, text, subtext)
				end
				break
			end
		end
	end
end)