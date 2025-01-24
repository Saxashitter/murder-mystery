MM_PERKS[MMPERK_NINJA] = {
	primary = function(p)
		local item = p.mm.inventory.items[p.mm.inventory.cur_sel]
		if not (item and item.id == "knife") then return end
		
		item.mobj.alpha = FU/2
		
		item.equipsfx = nil
		item.hitsfx = nil
		item.misssfx = nil
		item.silencedkill = true
	end,
	
	secondary = function(p)
		local item = p.mm.inventory.items[p.mm.inventory.cur_sel]
		if not (item and item.id == "knife") then return end
		
		item.mobj.alpha = FU
		
		item.equipsfx = nil
		item.hitsfx = nil
		item.misssfx = nil
	end,
	
	icon = "MM_PI_NINJA",
	name = "Ninja"
}