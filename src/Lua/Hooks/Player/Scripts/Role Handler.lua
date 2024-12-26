local roles = MM.require "Variables/Data/Roles"

return function(p) -- Role handler
	if not (roles[p.mm.role].weapon) then return end

	if not MM:pregame()
	and not p.mm.got_weapon
		if not MM_N.dueling
			MM:GiveItem(p, roles[p.mm.role].weapon)
		--get the other player's weapon, so its always fair (gun-gun, knife-knife)
		else
			local firstjoiner = #players + 1
			for player in players.iterate()
				if #player < firstjoiner then firstjoiner = #player end
			end
			MM:GiveItem(p, roles[players[firstjoiner].mm.role].weapon)
		end
		p.mm.got_weapon = true
	end
end