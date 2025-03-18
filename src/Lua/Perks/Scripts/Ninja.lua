local perk_name = "Ninja"
local perk_price = 150 --250

local hud_tween_start = -4*FU
local hud_tween = 0

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
	drawer = function(v,p,c, slot,props)
		local flags = V_50TRANS
		
		local knifeequiped = true
		local item = p.mm.inventory.items[p.mm.inventory.cur_sel]
		if not (item and item.id == "knife") then knifeequiped = false; end
		if p.mm.inventory.hidden then knifeequiped = false; end
		
		if knifeequiped
			hud_tween = ease.inquad(FU/2, $, hud_tween_start)
			flags = 0
		else
			hud_tween = ease.inquad(FU/2, $, 0)
		end
		return hud_tween,flags
	end,
	
	icon = "MM_PI_NINJA",
	name = perk_name,
	flags = 0,

	description = {
		"\x82Primary:\x80 Your knife is 50% invisible.",
		"Equiping, swinging, and kills will be 100%",
		"silent.",
		
		"",
		
		"\x82Secondary:\x80 Everything about your knife",
		"is 100% silent. Still fully visible, though."
	},
	cost = perk_price,
}

local id = MM.Shop.addItem({
	name = perk_name,
	price = perk_price,
	category = MM_PERKS.category_id
})
MM.Shop.items[id].perk_id = MMPERK_NINJA