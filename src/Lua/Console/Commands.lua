COM_AddCommand("MM_GiveWeapon", function(p, wname)
	if not MM:isMM() then return end

	MM:giveWeapon(p, wname, true)
end, COM_ADMIN)