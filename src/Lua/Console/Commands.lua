COM_AddCommand("MM_GiveWeapon", function(p, wname)
	if not MM:isMM() then return end
	if not (IsPlayerAdmin(p) or p == server) then return end

	MM:giveWeapon(p, wname, true)
end)

COM_AddCommand("MM_GiveSecondaryWeapon", function(p, wname)
	if not MM:isMM() then return end
	if not (IsPlayerAdmin(p) or p == server) then return end

	MM:giveWeapon(p, wname, false, 10*TICRATE)
end)