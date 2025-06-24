local shallowCopy = MM.require "Libs/shallowCopy"
local deepCopy = MM.require "Libs/deepCopy"
local playerVars = MM.require "Variables/Data/Player"
local savedPlayerVars = MM.require "Variables/Data/Player_Saved"

return function(self, p, mapchange)
	p.mm = deepCopy(playerVars)
	p.mm.player = p -- reference player
	
	if not p.mm_save then
		p.mm_save = shallowCopy(savedPlayerVars)
	end

	local midgame = not mapchange and not MM:pregame()
	if MM_N.waiting_for_players then
		midgame = false
	end

	MM:InitPlayerClues(p)

	if midgame then
		p.mm.joinedmidgame = true
		p.mm.spectator = true
		p.spectator = true
	end

	local hook_event = MM.events["PlayerInit"]
	for i,v in ipairs(hook_event)
		MM.tryRunHook("PlayerInit", v,
			p, midgame
		)
	end
end