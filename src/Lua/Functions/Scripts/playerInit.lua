local shallowCopy = MM.require "Libs/shallowCopy"
local playerVars = MM.require "Variables/Data/Player"

return function(self, p, mapchange)
	p.mm = shallowCopy(playerVars)
	if not p.mm_save then
		p.mm_save = {}
	end

	local midgame = not mapchange and leveltime > 10*TICRATE

	if midgame then
		p.mm.joinedmidgame = true
		p.mm.spectator = true
	end

	MM.runHook("PlayerInit", p, midgame)
end