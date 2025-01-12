return function()
	local count = 0
	local innocents = 0
	local murderers = 0

	for p in players.iterate do
		if not (p and p.mo and p.mm) then continue end
		if p.mm.joinedmidgame then continue end
		if p.mm_save.afkmode then continue end

		count = $+1

		if p.mm.spectator then continue end
		if p.mm.role == MMROLE_MURDERER then
			murderers = $+1
			continue
		end

		innocents = $+1
	end

	return count, innocents, murderers
end