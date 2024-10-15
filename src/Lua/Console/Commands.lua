COM_AddCommand("MM_GiveItem", function(p, name)
	if not MM:isMM() then return end

	MM:GiveItem(p, name)
end, COM_ADMIN)

COM_AddCommand("MM_EndGame", function(p)
	if not MM:isMM() then return end

	MM:endGame(1)
	MM_N.killing_end = false
	MM_N.disconnect_end = true
	MM_N.end_ticker = 3*TICRATE - 1
	S_StartSound(nil,sfx_s253)
end, COM_ADMIN)

COM_AddCommand("MM_StartShowdown", function(p)
	if not MM:isMM() then return end
	if MM_N.showdown then return end
	
	MM_N.showdown = true
	MM_N.showdown_song = "SHWDW"..tostring(P_RandomRange(1, 3))
end, COM_ADMIN)
