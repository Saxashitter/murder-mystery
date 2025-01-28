dofile "Clues/freeslot"

local GetMobjSpawnHeight, GetMapThingSpawnHeight = MM.require "Libs/MapThingLib"
local choosething = MM.require "Libs/choosething"
local shallowCopy = MM.require "Libs/shallowCopy"

function MM:spawnClueMobj(p, pos)
	local mobj = P_SpawnMobj(pos.x, pos.y, pos.z, MT_MM_CLUESPAWN)

	mobj.state = S_THOK
	mobj.frame = $|FF_FULLBRIGHT
	mobj.tics = -1
	mobj.fuse = -1
	mobj.drawonlyforplayer = p
	mobj.color = p.skincolor

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
	MM.clues_positions = {}
	local fallbackThings = {}
	--local useNewClues = false
	
	MM.clues_singlemode = false
	if (mapheaderinfo[gamemap]
	and mapheaderinfo[gamemap].mm_singleclues ~= nil)
		MM.clues_singlemode = true
	end

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

		table.insert(MM.clues_positions, newPos)
	end
	
	if not #MM.clues_positions
	and #fallbackThings then
		for _, thing in ipairs(fallbackThings) do
			-- i love copying code!!
			local newPos = {}

			newPos.x = thing.x*FU
			newPos.y = thing.y*FU

			local z = GetMapThingSpawnHeight(MT_MM_CLUESPAWN, thing, newPos.x, newPos.y)
			newPos.z = z

			newPos.flip = (thing.options & MTF_OBJECTFLIP)

			table.insert(MM.clues_positions, newPos)
		end
	end
	
	if not (#MM.clues_positions) then return end
	
	--weird issue where it would default to 5 even if theres more clue amounts?
	amount = min(#MM.clues_positions, amount)
	MM_N.clues_amount = amount
	
	--Bruh
	if (MM_N.dueling) then return end
	
	for p in players.iterate do
		MM:InitPlayerClues(p)
	end
end


MM:addPlayerScript(function(p)
	local removalList = {}

	if (leveltime <= 1) then return end
	if (p.mm.clues == nil) then return end
	
	--we shouldnt have to do this
	p.mm.clues.list = $ or {}
	for i,clue in ipairs(p.mm.clues.list) do
		local pos = clue.ref
		clue.mobj.color = p.skincolor
		if (p.realmo and p.realmo.valid)
			clue.mobj.scale = p.realmo.scale
		end
		
		if p.mm.clues.current ~= nil
		and clue ~= p.mm.clues.current
			clue.mobj.flags2 = $|MF2_DONTDRAW
			continue
		end
		clue.mobj.flags2 = $ &~MF2_DONTDRAW

		if P_RandomChance(FU/2)
			local wind = P_SpawnMobj(
				pos.x + P_RandomRange(-18,18)*p.mo.scale,
				pos.y + P_RandomRange(-18,18)*p.mo.scale,
				pos.z + (p.mo.height/2) + P_RandomRange(-20,20)*p.mo.scale,
				MT_BOXSPARKLE
			)
			wind.frame = $|FF_FULLBRIGHT
			wind.drawonlyforplayer = p
			wind.renderflags = $|RF_FULLBRIGHT
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
		for i,clue in pairs(p.mm.clues.list) do
			if clue == remove then
				local text = "CLUE FOUND!"

				S_StartSound(p.mo, sfx_cluecl,p)
				if clue.mobj.valid then
					P_RemoveMobj(clue.mobj)
				end

				table.remove(p.mm.clues.list, i)
				if p.mm.clues.current ~= nil
					p.mm.clues.current = choosething(unpack(p.mm.clues.list))
				end

				local subtext = tostring(#p.mm.clues.list).."/"..tostring(p.mm.clues.amount).." remaining..."

				if not (#p.mm.clues.list) then
					text = "YOU FOUND THEM ALL!"
					subtext = "Your clues gave you a weapon!"
					
					local reward = ''
					if p.mm.role == MMROLE_MURDERER
						reward = "luger"
					else
						if MM_N.clues_weaponsleft
							if P_RandomChance(FU/6) then
								reward = P_RandomChance(FU/3) and "revolver" or "gun" 
							else
								reward = P_RandomChance(FU/4) and "sword" or "snowball"
								
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
					
					if isdedicatedserver then
						print(string.format('%s [%s] got item "%s" from a clue!', p.name, #p, reward))
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