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

local falloffNums = {}

for i = 301, 307 do
	falloffNums[i] = true
end
for i = 330, 335 do
	falloffNums[i] = true -- im lazy to write all of the numbers manually
end

function MM:giveOutClues(amount)
	local cluePositions = {}
	local falloffThings = {}

	for thing in mapthings.iterate do
		if thing.type ~= 3001 then
			if falloffNums[thing.type] then
				table.insert(falloffThings, thing)
			end
			continue
		end

		local newPos = {}

		newPos.x = thing.x*FU
		newPos.y = thing.y*FU

		local z = GetMapThingSpawnHeight(MT_MM_CLUESPAWN, thing, newPos.x, newPos.y)
		newPos.z = z

		newPos.flip = (thing.options & MTF_OBJECTFLIP)

		table.insert(cluePositions, newPos)
	end
	
	if not #cluePositions
	and #falloffThings then
		for _, thing in ipairs(falloffThings) do
			-- i love copying code!!
			local newPos = {}

			newPos.x = thing.x*FU
			newPos.y = thing.y*FU

			local z = GetMapThingSpawnHeight(MT_MM_CLUESPAWN, thing, newPos.x, newPos.y)
			newPos.z = z

			newPos.flip = (thing.options & MTF_OBJECTFLIP)

			table.insert(cluePositions, newPos)
		end
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
		
		if P_RandomChance(FU/2)
			local wind = P_SpawnMobj(
				pos.x + P_RandomRange(-18,18)*p.mo.scale,
				pos.y + P_RandomRange(-18,18)*p.mo.scale,
				pos.z + (p.mo.height/2) + P_RandomRange(-20,20)*p.mo.scale,
				MT_BOXSPARKLE
			)
			wind.drawonlyforplayer = p
			P_SetObjectMomZ(wind,P_RandomRange(1,3)*FU)
		end
		
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