local roles = MM.require "Variables/Data/Roles"

return function(p) -- Role handler
	if not (roles[p.mm.role].weapon) then return end

	if not MM:pregame()
	and not p.mm.got_weapon
		if not MM_N.dueling
			MM:GiveItem(p, roles[p.mm.role].weapon)
			
			if p.mm.role == MMROLE_MURDERER then
				if P_RandomChance(FRACUNIT/2) then
					local giveitem = P_RandomChance(FRACUNIT/2) and "uno_reverse" or "tripmine"
					
					MM:GiveItem(p, giveitem)
				end
			end
		else
			MM:GiveItem(p, MM_N.duel_item)
		end
		p.mm.got_weapon = true
	end
end