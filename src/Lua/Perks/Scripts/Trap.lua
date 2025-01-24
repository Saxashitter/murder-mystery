MM.addHook("GiveStartWeapon",function(p)
	if (p.mm.role ~= MMROLE_MURDERER) then return end
	if (MM_N.dueling) then return end
	
	if (p.mm_save.pri_perk == MMPERK_TRAP)
		return "tripmine"
	elseif (p.mm_save.sec_perk == MMPERK_TRAP)
		return "beartrap"
	end
end)

MM_PERKS[MMPERK_TRAP] = {
	icon = "MM_PI_TRAP",
	icon_scale = FU/2,
	name = "Trap"
}