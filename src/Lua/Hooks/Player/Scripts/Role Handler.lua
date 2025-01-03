local roles = MM.require "Variables/Data/Roles"

return function(p) -- Role handler
	if not (roles[p.mm.role].weapon) then return end

	if not MM:pregame()
	and not p.mm.got_weapon
		if not MM_N.dueling
			MM:GiveItem(p, roles[p.mm.role].weapon)
		else
			MM:GiveItem(p, MM_N.duel_item)
		end
		p.mm.got_weapon = true
	end
end