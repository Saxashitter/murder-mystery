return function(self)
	local innocent = false
	local murderer = false

	if MM_N.waiting_for_players then
		return false
	end
	
	if not MM_N.ignore_missing_roles then
		for p in players.iterate do
			if not (p and p.mo and p.mm and not p.mm.spectator) then continue end

			if p.mm.role == MMROLE_MURDERER then
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
	end

	-- redundant?
	if MM_N.allow_respawn then
		return false
	end
	
	return false
end