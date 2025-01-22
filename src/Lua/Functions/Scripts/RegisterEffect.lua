return function(self, name, _table)
	if name and _table then
		self.player_effects[name] = _table
	end
end