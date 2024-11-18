local shallowCopy = MM.require "Libs/shallowCopy"
local playerVars = MM.require "Variables/Data/Player"
local savedPlayerVars = MM.require "Variables/Data/Player_Saved"

return function(self, p, mapchange)
	p.mm = shallowCopy(playerVars)
	if not p.mm_save then
		p.mm_save = shallowCopy(savedPlayerVars)
	end

	local midgame = not mapchange and leveltime > 10*TICRATE
	if MM_N.waiting_for_players then
		midgame = false
	end

	if midgame then
		p.mm.joinedmidgame = true
		p.mm.spectator = true
		p.spectator = true
	end

	MM.runHook("PlayerInit", p, midgame)
end