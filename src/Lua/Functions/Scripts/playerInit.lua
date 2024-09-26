local shallowCopy = MM.require "Libs/shallowCopy"
local playerVars = MM.require "Variables/Data/Player"

return function(self, p, mapchange)
	p.mm = shallowCopy(playerVars)

	if not mapchange
	and leveltime > 10*TICRATE then
		p.mm.joinedmidgame = true
		p.mm.spectator = true
	end
end