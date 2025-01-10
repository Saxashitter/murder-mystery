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

local fallbackNums = {
	[303] = true,
	[330] = true,
	[331] = true,
	[332] = true,
	[333] = true,
	[334] = true,
	[335] = true
}

function MM:giveOutClues(amount)
	local cluePositions = {}
	local fallbackThings = {}

	for thing in mapthings.iterate do
		if thing.type ~= 3001 then
			if fallbackNums[thing.type] then
				table.insert(fallbackThings, thing)
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
	and #fallbackThings then
		for _, thing in ipairs(fallbackThings) do
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
	
	--weird issue where it would default to 5 even if theres more clue amounts?
	amount = min(#cluePositions, amount)
	MM_N.clues_amount = amount
	
	--Bruh
	if (MM_N.dueling) then return end
	
	for p in players.iterate do
		local clues = {}
		local found = {}
		
		if (p.mm.role == MMROLE_SHERIFF) then continue end
		
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
		
		--TODO: this and dropped item sparkles dont sustain fullbrite
		if P_RandomChance(FU/2)
			local wind = P_SpawnMobj(
				pos.x + P_RandomRange(-18,18)*p.mo.scale,
				pos.y + P_RandomRange(-18,18)*p.mo.scale,
				pos.z + (p.mo.height/2) + P_RandomRange(-20,20)*p.mo.scale,
				MT_BOXSPARKLE
			)
			wind.frame = $|FF_FULLBRIGHT
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

				S_StartSound(p.mo, sfx_cluecl,p)
				if clue.mobj.valid then
					P_RemoveMobj(clue.mobj)
				end

				table.remove(p.mm.clues, i)
				local subtext = tostring(#p.mm.clues).."/"..tostring(p.mm.clues.amount).." remaining..."

				if not (#p.mm.clues) then
					text = "YOU FOUND THEM ALL!"
					subtext = "Your clues gave you a weapon!"
					
					local reward = ''
					if p.mm.role == MMROLE_MURDERER
						reward = "luger"
					else
						if MM_N.clues_weaponsleft
							if P_RandomChance(FU/4) then
								reward = P_RandomChance(FU/2) and "gun" or "revolver"
							else
								reward = P_RandomChance(FU/2) and "snowball" or "sword"
								
								if reward == "snowball" then
									subtext = "Your clues gave you an item!"
								end
							end
							
							MM_N.clues_weaponsleft = $-1
						else
							reward = "burger"
							subtext = "Your clues gave you an item!"
						end
					end
					
					local item = MM:GiveItem(p, reward)
					if p.mm.role ~= MMROLE_MURDERER -- Don't let other people pick up your hard work!
						item.droppable = false
						item.allowdropmobj = false
					end
				end

				if p == displayplayer then
					MMHUD:PushToTop(3*TICRATE, text, subtext)
				end
				break
			end
		end
	end
end)