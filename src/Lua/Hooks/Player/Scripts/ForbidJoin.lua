-- Used by duels mode.

return function(player)
	if not leveltime then return end
	
	if player and player.valid and player.mm and player.mo and player.mo.valid then
		if player.mm.forbid_join == true then
			player.mm.spectator = true
			player.spectator = true
		end
	end
end