return function(self, player, amount)
	if player.mm_save and player.mm_save.rings ~= nil then
		player.mm_save.rings = tonumber(amount)
	end
end