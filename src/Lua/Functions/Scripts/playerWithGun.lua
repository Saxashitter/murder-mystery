local roles = MM.require "Variables/Data/Roles"

return function(self)
	if not self:isMM() then return end

	for p in players.iterate do
		if not (p
		and p.mo
		and p.mo.health
		and p.mm
		and not p.mm.spectator) then
			continue
		end

		for i,item in pairs(p.mm.inventory.items) do
			if item.id == roles[MMROLE_SHERIFF].weapon then
				return true
			end
		end
	end

	return false
end