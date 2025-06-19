return function(player)
	if not leveltime then return end
	
	if player and player.valid and player.mm and player.mo and player.mo.valid then
		if player.mm.freeze_angle ~= nil then
			player.mo.angle = player.mm.freeze_angle
			player.cmd.angleturn = (player.mm.freeze_angle >> 16)
		end
	end
end