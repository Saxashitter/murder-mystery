return function(...)
	local self = select(1, ...)
	
	return MM:GiveItem(self.player, select(2, ...))
end