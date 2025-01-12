local function can_be_role(p, count)
	/*if count < 2 then
		return true
	end
	
	return true*/

	return true
end

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

return function(self, count)
	local pcount = getCount()

	local murderer_chance_table = {} 
	local sheriff_chance_table = {}

	-- Insert each player's chances in their tables.
	for p in players.iterate do
		if not (p and p.valid and p.mm) 
		and not can_be_role(p, pcount) then continue end
		
		if p.mm_save.afkmode then continue end
		
		for i=1,p.mm_save.murderer_chance_multi do
			table.insert(murderer_chance_table, p)
		end
		for i=1,p.mm_save.sheriff_chance_multi do
			table.insert(sheriff_chance_table, p)
		end
	end

	-- Select players.
	local murderers = {}
	local sheriffs = {}
	local i = 0

	while i < count do
		local mp = select_player_from_table(p, murderer_chance_table)
		local sp = select_player_from_table(p, sheriff_chance_table)

		if mp ~= sp
		and not (murderers[mp])
		and not (sheriffs[sp]) then
			mp.mm.role = MMROLE_MURDERER
			mp.mm_save.murderer_chance_multi = 1

			sp.mm.role = MMROLE_SHERIFF
			sp.mm_save.sheriff_chance_multi = 1

			murderers[mp] = true
			sheriffs[sp] = true

			i = $+1
		end
	end

	return murderers, sheriffs
end