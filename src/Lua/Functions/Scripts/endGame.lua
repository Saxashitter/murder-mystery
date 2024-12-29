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

	-- select theme
	local themes = {}
	for k,v in pairs(MM.themes) do
		table.insert(themes, k)
	end

	MM_N.theme = themes[P_RandomRange(1, #themes)]
	if MM.themes[MM_N.theme].init then
		MM.themes[MM_N.theme].init(endType)
	end

	local endType = MM.endTypes[endType] or 1
	MM:discordMessage("***"..endType.name.."***\n")
	
	MM_N.endType = endType
	MM_N.gameover = true

	if not MM_N.sniped_end then
		S_StopMusic(consoleplayer)
	end
	
	for mo in mobjs.iterate()
		if not (mo and mo.valid) then continue end
		if (mo == MM_N.end_camera) then continue end
		
		if mo.flags & MF_NOTHINK
			mo.notthinking = true
			continue
		end
		
		mo.flags = $|MF_NOTHINK
		S_StopSound(mo)
	end
	
end