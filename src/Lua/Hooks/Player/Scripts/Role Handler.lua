local roles = MM.require "Variables/Data/Roles"

return function(p) -- Role handler
	if not (roles[p.mm.role].weapon) then return end

	if not MM:pregame()
	and not p.mm.got_weapon
		if not MM_N.dueling
			MM:GiveItem(p, roles[p.mm.role].weapon)
		--always get a gun, like a gun game or a real duel
		else
			MM:GiveItem(p, "gun")
		end
		p.mm.got_weapon = true
	end
end