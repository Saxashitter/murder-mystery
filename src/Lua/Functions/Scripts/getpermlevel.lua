-- Get player's level of permissions.

return function(self, player)
	local level = 0
	
	if IsPlayerAdmin(player) then
		level = 1
	end
	
	if player == server then
		level = 2
	end
	
	return level
end