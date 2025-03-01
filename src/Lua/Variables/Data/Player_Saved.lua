return {
	rings = 0,
	
	--primary and secondary perks
	pri_perk = MMPERK_FOOTSTEPS,
	sec_perk = 0,
	
	afkmode = false,
	timesafk = 0,
	
	murderer_chance_multi = 1,
	sheriff_chance_multi = 1,
	
	--used by role hud
	cons_murderer_chance = 0,
	cons_sheriff_chance = 0,
	
	lastRole = nil,
	
	purchased = {
		/*
		[item_id] = true
		*/
	}
}