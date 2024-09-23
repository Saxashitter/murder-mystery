addHook("ThinkFrame", do
	if not MM:isMM() then return end

	if MM_N.waiting_for_players then
		local playersIn = 0
		for p in players.iterate do
			playersIn = $+1
		end

		if playersIn >= 2 then
			COM_BufInsertText(server, "map "..G_BuildMapName(gamemap).." -f")
		end
		return
	end

	local innocents = 0
	local murderers = 0

	for p in players.iterate do
		if not (p and p.mo and p.mm and not p.mm.spectator) then continue end

		if p.mm.role == 2 then
			murderers = $+1
			continue
		end

		innocents = $+1
	end

	if not (murderers) then
		MM:endGame(1)
	end
	if not (innocents) then
		MM:endGame(2)
	end
end)