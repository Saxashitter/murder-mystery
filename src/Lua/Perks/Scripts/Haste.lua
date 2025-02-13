MM:RegisterEffect("perk.primary.haste", {
	modifiers = {
		normalspeed_multi = tofixed("1.20") -- no luigi, i hate srb2 division
	},
})

MM:RegisterEffect("perk.secondary.haste", {
	modifiers = {
		normalspeed_multi = tofixed("1.10")
	},
})

local hud_tween_start = -55*FU
local hud_tween = hud_tween_start
local icon_name = "MM_PI_HASTE"
local icon_scale = FU/2

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
	end,
	
	drawer = function(v,p,c, order)
		local x = 5*FU
		local y = 100*FU
		local scale = FU/2
		local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM
		if order == "sec" then y = $ + 18*FU end
		
		local knifeequiped = true
		local item = p.mm.inventory.items[p.mm.inventory.cur_sel]
		if not (item and item.id == "knife") then knifeequiped = false; end
		if p.mm.inventory.hidden then knifeequiped = false; end
		
		if knifeequiped
			hud_tween = ease.inquad(FU/2, $, 0)
		else
			hud_tween = ease.inquad(FU/4, $, hud_tween_start)
		end
		x = $ + hud_tween

		v.drawScaled(x,
			y,
			FixedMul(scale, icon_scale),
			v.cachePatch(icon_name),
			flags
		)
	end,
	
	--this icon is so fucking goofy
	--its placeholder for a reason bruh
	icon = icon_name,
	icon_scale = icon_scale,
	name = "Haste",

	description = {
		"\x82Primary:\x80 Speed up 20% when holding",
		"your knife out!",
		
		"",
		
		"\x82Secondary:\x80 Speed up 10% when holding",
		"your knife out!",
	},
	cost = FU*10,
}