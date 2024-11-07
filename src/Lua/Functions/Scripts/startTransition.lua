return function(self)
	local theme = MM.themes[MM_N.theme or "srb2"]

	for p in players.iterate do
		if not (p and p.mm and p.mm.alias_save) then continue end

		local alias = p.mm.alias_save

		R_SetPlayerSkin(p, alias.skin)
		p.skincolor = alias.skincolor
	end

	if not theme.transition then
		MM:startVote()
		return
	end

	MM_N.transition = true
	MM_N.transition_time = theme.transition_time
end