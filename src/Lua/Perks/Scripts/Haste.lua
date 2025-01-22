MM:RegisterEffect("perk.primary.haste", {
	modifiers = {
		normalspeed_multi = tofixed("1.12") -- no luigi, i hate srb2 division
	},
})

MM:RegisterEffect("perk.secondary.haste", {
	modifiers = {
		normalspeed_multi = tofixed("1.06")
	},
})

MM_PERKS[MMPERK_HASTE] = {
	primary = function(p)
		local item = p.mm.inventory.items[p.mm.inventory.cur_sel]
		if not (item and item.id == "knife") then return end
		if p.mm.inventory.hidden then return end

		MM:ApplyPlayerEffect(p, "perk.primary.haste")
	end,
	
	secondary = function(p)
		local item = p.mm.inventory.items[p.mm.inventory.cur_sel]
		if not (item and item.id == "knife") then return end
		if p.mm.inventory.hidden then return end

		MM:ApplyPlayerEffect(p, "perk.secondary.haste")
	end
}