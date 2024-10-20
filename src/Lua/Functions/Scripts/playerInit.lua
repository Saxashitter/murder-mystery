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
	else
		if p.mo and p.mo.valid then
			p.mo.skin = skins[p.skin].name -- Set skin to your skin in character select menu.
		end
	end

	MM.runHook("PlayerInit", p, midgame)
end