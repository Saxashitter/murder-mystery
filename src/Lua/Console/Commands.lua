COM_AddCommand("MM_GiveWeapon", function(p, wname)
	if not MM:isMM() then return end

	MM:giveWeapon(p, wname, true)
end, COM_ADMIN)

COM_AddCommand("MM_EndGame", function(p)
	if not MM:isMM() then return end

	MM:endGame(1)
end, COM_ADMIN)