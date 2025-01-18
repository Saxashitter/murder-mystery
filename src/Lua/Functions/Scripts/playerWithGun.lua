return function(self)
	if not self:isMM() then return end

	--YES!!!!!
	if MM_N.gavegun then return true; end
	
	local peoplewithgun = 0
	
	for p in players.iterate do
		if not (p
		and p.mo
		and p.mo.health
		and p.mm
		and not p.mm.spectator) then
			continue
		end

		for i,item in pairs(p.mm.inventory.items) do
			if item.id == "revolver" then
				peoplewithgun = $ + 1
			end
		end
	end
	
	if peoplewithgun >= MM_N.special_count
		return true
	end

	return false
end