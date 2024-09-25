MM.endTypes = {
	{
		name = "Innocents win!",
		color = V_GREENMAP,
		results = "innocents"
	},
	{
		name = "Murderer wins!",
		color = V_REDMAP,
		results = "murderers"
	}
}

return function(self, endType)
	if MM_N.gameover then return end

	local endType = MM.endTypes[endType] or 1

	MM_N.endType = endType
	MM_N.gameover = true

	for p in players.iterate do
		if not (p and p.mm) then continue end

		if p.mm.role == 2 then
			table.insert(MM_N.murderers, p)
			continue
		end
		table.insert(MM_N.innocents, p)
	end
end