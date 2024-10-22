local shallowCopy = MM.require "Libs/shallowCopy"
local playerVars = MM.require "Variables/Data/Player"
local savedPlayerVars = MM.require "Variables/Data/Player_Saved"

return function(self, p, mapchange)
	p.mm = shallowCopy(playerVars)
	if not p.mm_save then
		p.mm_save = shallowCopy(savedPlayerVars)
	end

	local midgame = not mapchange and leveltime > 10*TICRATE

	if midgame then
		p.mm.joinedmidgame = true
		p.mm.spectator = true
	else
		if p.mo and p.mo.valid then
			-- r_ = restored
			if p.mm_save.r_color ~= nil then
				p.skincolor = p.mm_save.r_color
				p.mo.color = p.skincolor
				p.mm_save.r_color = nil
			end
		end
	end

	MM.runHook("PlayerInit", p, midgame)
end