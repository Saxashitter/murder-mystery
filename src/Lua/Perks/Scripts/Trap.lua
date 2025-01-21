MM.addHook("GiveStartWeapon",function(p)
	if (p.mm.role ~= MMROLE_MURDERER) then return end
	
	if (p.mm_save.pri_perk == MMPERK_TRAP)
		MM:giveItem(p, "tripmine")
	elseif (p.mm_save.sec_perk == MMPERK_TRAP)
		--TODO: bear traps
	end
end)