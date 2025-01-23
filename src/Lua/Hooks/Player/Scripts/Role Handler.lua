local roles = MM.require "Variables/Data/Roles"

return function(p) -- Role handler
	if MM:pregame() then return end
	if p.mm.got_weapon then return end
	
	local givenweapon = roles[p.mm.role].weapon
	if MM_N.dueling
		givenweapon = MM_N.duel_item
	end
	
	local newweapon = MM.runHook("GiveStartWeapon", p, givenweapon)
	
	if newweapon ~= nil
		--override
		if newweapon == true
			p.mm.got_weapon = true
			return
		end
		
		givenweapon = newweapon
	end
	
	if not givenweapon
		p.mm.got_weapon = true
		return
	end
	
	MM:GiveItem(p, givenweapon)
	if p.mm.role == MMROLE_MURDERER then
		local giveitem = P_RandomChance(FRACUNIT/2) and "swap_gear" or "tripmine"
		
		MM:GiveItem(p, giveitem)
	end
	p.mm.got_weapon = true
end