local choosething = MM.require "Libs/choosething"
local shallowCopy = MM.require "Libs/shallowCopy"

return function(self, p)
	local amount = self.clues_amount
	local clues = {}
	local found = {}
	--the ACTUAL table of clues, saxa's implemtation of this is weird
	local real_clues = {}
	
	if (p.mm.role == MMROLE_SHERIFF) then return end
	if (p.mm_save and p.mm_save.afkmode) then return end
	
	clues.amount = amount
	
	-- Give murderer less clues.
	if (p.mm.role == MMROLE_MURDERER) then
		local newcluecount = (amount*3) / 4
		
		/*
		--this is weird and doesnt lower the clue count most of the time
		newcluecount = FixedMul($*FU, FixedDiv(3*FU, 4*FU));
		newcluecount = FixedCeil($)/FU;
		*/
		
		clues.amount = newcluecount
	end
	
	for i = 1, clues.amount do
		local clue

		while not clue do
			local key = P_RandomRange(1, #MM.clues_positions)
			if not found[key] then
				found[key] = true
				clue = MM.clues_positions[key]
			end
		end

		table.insert(real_clues, {
			ref = clue,
			mobj = self:spawnClueMobj(p, clue)
		})
	end

	p.mm.clues = {}
	p.mm.clues.list = shallowCopy(real_clues) or {}
	if self.clues_singlemode then
		p.mm.clues.current = choosething(unpack(p.mm.clues.list))
	end
	p.mm.clues.amount = clues.amount
	p.mm.clues.startamount = clues.amount -- the amount you need to find at the start of the game.
end