return function(self)
	if not self:isMM() then return end

	for p in players.iterate do
		if not (p
		and p.mo
		and p.mo.health
		and p.mm
		and not p.mm.spectator
		and ((p.mm.weapon
		and p.mm.weapon.valid
		and p.mm.weapon.__type == "Gun")
		or (p.mm.weapon2
		and p.mm.weapon2.valid
		and p.mm.weapon2.__type == "Gun")) then
			continue
		end

		return true
	end

	return false
end