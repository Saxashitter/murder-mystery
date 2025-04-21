return function(player)
	if player and player.valid and player.mm and player.mo and player.mo.valid then
		local item = player.mm.inventory.items[player.mm.inventory.cur_sel]
		
		if not (item) then
			player.pflags = $ | PF_DIRECTIONCHAR & ~(PF_FORCESTRAFE|PF_ANALOGMODE)
			return 
		end
		
		if item.nostrafe or player.mm.inventory.hidden then
			player.pflags = $ | PF_DIRECTIONCHAR & ~(PF_FORCESTRAFE|PF_ANALOGMODE)
			return
		end
		
		player.pflags = $ | PF_FORCESTRAFE & ~(PF_ANALOGMODE|PF_DIRECTIONCHAR)
	end
end