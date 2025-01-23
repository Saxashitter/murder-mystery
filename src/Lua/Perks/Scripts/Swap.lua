MM.addHook("GiveStartWeapon",function(p)
	if (p.mm.role ~= MMROLE_MURDERER) then return end
	if (MM_N.dueling) then return end
	
	if (p.mm_save.pri_perk == MMPERK_SWAP)
		MM:giveItem(p, "uno_reverse")
	elseif (p.mm_save.sec_perk == MMPERK_SWAP)
		--TODO: swap gun
	end
end)