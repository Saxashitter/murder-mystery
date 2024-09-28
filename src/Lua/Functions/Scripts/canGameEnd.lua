return function(self)
	local innocent = false
	local murderer = false
	for p in players.iterate do
		if not (p and p.mo and p.mm and not p.mm.spectator) then continue end

		if p.mm.role == 2 then
			murderer = true
		else
			innocent = true
		end

		if (innocent and murderer) then break end
	end

	if not innocent then
		return true, 2
	end
	if not murderer then
		return true, 1
	end

	return false
end