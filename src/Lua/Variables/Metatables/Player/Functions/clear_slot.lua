return function(...)
	local self = select(1, ...)
	
	return MM:ClearInventorySlot(self.player, select(2, ...))
end