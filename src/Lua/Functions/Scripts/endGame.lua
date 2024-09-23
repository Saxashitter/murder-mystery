MM.endTypes = {
	{
		name = "Innocents win!",
		color = V_GREENMAP,
		results = 1
	},
	{
		name = "Murderer wins!",
		color = V_REDMAP,
		results = 2
	}
}

return function(self, endType)
	local endType = MM.endTypes[endType]

	MM_N.endType = endType
	G_ExitLevel()
end