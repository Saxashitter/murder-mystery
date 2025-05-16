-- Get player's level of permissions.

return function(self, player)
	local level = 0
	
	if IsPlayerAdmin(player) then
		level = 1
	end
	
	if player == server then
		level = 2
	end
	
	--yes, this also hides the ~ server indicator too lol
	if (player.mm_save.adminbadge == false and (level > 0))
		level = 0
	end
	
	return level
end