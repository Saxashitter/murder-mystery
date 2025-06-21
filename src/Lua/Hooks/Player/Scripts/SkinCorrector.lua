-- Corrects the player's skin and/or color in case they're cringe and change it
return function(p)
	if MM:pregame() then return end
	if MM_N.waiting_for_players then return end
	if (p.spectator or p.mm.spectator) then return end
	
	local alias = p.mm.alias
	
	if (alias)
		if p.skincolor ~= alias.skincolor
			p.skincolor = alias.skincolor
			p.mo.color = p.skincolor
		end
		if p.mo.skin ~= alias.skin
			R_SetPlayerSkin(p, alias.skin)
		end
		return
	end
	
	if p.mm.savedcolor ~= nil
		if p.skincolor ~= p.mm.savedcolor
			p.skincolor = p.mm.savedcolor
			p.mo.color = p.skincolor
		end
	end
end