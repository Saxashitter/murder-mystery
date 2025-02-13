MM.addHook("GiveStartWeapon",function(p)
	if (p.mm.role ~= MMROLE_MURDERER) then return end
	if (MM_N.dueling) then return end
	
	if (p.mm_save.pri_perk == MMPERK_SWAP)
	or (p.mm_save.sec_perk == MMPERK_SWAP) then
		return "swap_gear"
	end
end)

MM_PERKS[MMPERK_SWAP] = {
	icon = "MM_PI_SWAP",
	name = "Swap",

	description = {
		"\x82When equipped:\x80 Earn a Body Swap Potion!",
		"Use it near someone to swap bodies with them!",
	},
	cost = FU*10,
}