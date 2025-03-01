local perk_name = "Trap"
local perk_price = 750

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
	name = perk_name,

	description = {
		"\x82Primary:\x80 Get a Subspace Tripmine on spawn.",
		"Once laid, it will turn invisible and explode on",
		"touch. Shooting it will explode it!",
		
		"",
		
		"\x82Secondary:\x80 Get a Beartrap on spawn.",
		"Once laid, it'll only be visible to you, and will",
		"slow down anyone who touches it."
	},
	cost = perk_price
}

local id = MM.Shop.addItem({
	name = perk_name,
	price = perk_price,
	category = MM_PERKS.category_id
})
MM.Shop.items[id].perk_id = MMPERK_TRAP