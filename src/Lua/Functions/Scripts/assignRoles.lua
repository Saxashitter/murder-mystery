/*
local function can_be_role(p, count)
	if count < 2 then
		return true
	end
	
	return true
end
*/

local function select_player_from_table(p, tbl)
	local returnthis
	while not returnthis do
		local i = P_RandomRange(1, #tbl)

		if p ~= tbl[i] then
			returnthis = tbl[i]
			break
		end
	end

	return returnthis
end

local getCount = dofile("Libs/getCount")

--if alreadychosen is true, then we've already set roles, and are just filling up missing slots (people who left)
--murdorsherf: true = only murds, false = only count sheriffs, nil = do nothing
return function(self, count, alreadychosen, murdorsherf)
	local pcount = getCount()

	local murderer_chance_table = {} 
	local sheriff_chance_table = {}
	local total_table = {}

	-- Insert each player's chances in their tables.
	for p in players.iterate do
		if not (p and p.valid and p.mm) 
		/*and not can_be_role(p, pcount)*/ then continue end
		
		if p.mm_save.afkmode then continue end
		if alreadychosen and (p.mm.role ~= MMROLE_INNOCENT) then continue end
		
		for i=1,p.mm_save.murderer_chance_multi do
			table.insert(murderer_chance_table, p)
		end
		for i=1,p.mm_save.sheriff_chance_multi do
			table.insert(sheriff_chance_table, p)
		end
		table.insert(total_table,p)
	end

	-- Select players.
	local murderers = {}
	local sheriffs = {}
	local i = 0

	local firstcount = MM.countPlayers()
	if MM_N.dueling or CV_MM.force_duel.value
		for k, player in ipairs(total_table)
			local result = MM.countPlayers()
			
			if result.murderers == 0
			or result.sheriffs == 0
				player.mm.role = P_RandomChance(FU/2) and MMROLE_MURDERER or MMROLE_SHERIFF
			elseif result.murderers > result.sheriffs
				player.mm.role = MMROLE_SHERIFF
			else
				player.mm.role = MMROLE_MURDERER
			end
		end
		return murderers, sheriffs
	end

	while i < count do
		local mp = select_player_from_table(p, murderer_chance_table)
		local sp = select_player_from_table(p, sheriff_chance_table)
		
		if mp ~= sp
		and not (murderers[mp])
		and not (sheriffs[sp]) then
			if murdorsherf == nil or (murdorsherf == true) then
				mp.mm.role = MMROLE_MURDERER
				mp.mm_save.murderer_chance_multi = 1
				
				if murdorsherf ~= nil
					chatprintf(mp, "\x83*You have been magically made a \x85Murderer!\x82")
				end
				murderers[mp] = true
			end
			
			if murdorsherf == nil or (murdorsherf == false) then
				sp.mm.role = MMROLE_SHERIFF
				sp.mm_save.sheriff_chance_multi = 1
				
				if murdorsherf ~= nil
					chatprintf(mp, "\x83*You have been magically made a \x84Sheriff!\x82")
				end
				sheriffs[sp] = true
			end
			i = $+1
		end
	end

	return murderers, sheriffs
end