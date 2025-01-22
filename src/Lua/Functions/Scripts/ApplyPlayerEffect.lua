local shallowCopy = MM.require "Libs/shallowCopy"

return function(self, player, effect_name, duration)
	local effects = player.mm.effects
	
	if effect_name then
		local copy = shallowCopy(self.player_effects[effect_name])
		copy.fuse = duration or 1
		
		effects[effect_name] = copy
	end
end