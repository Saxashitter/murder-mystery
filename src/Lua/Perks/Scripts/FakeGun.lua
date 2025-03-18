local TR = TICRATE

local perk_name = "Fake Gun"
local perk_price = 325 --750

local hud_tween_start = -4*FU
local hud_tween = 0
local icon_name = "MM_PI_FAKEGUN"
local icon_scale = FU/2

local perk_maxtime = 10*TR
local perk_cooldown = 30*TR

local clueItems = {
	"revolver",
	"shotgun",
	"sword",
	"snowball",
	"burger",
}

local function perk_thinker(p)
	p.mm.perk_fake_time = $ or 0
	p.mm.perk_fake_cooldown = $ or 0
	
	if MM_PERKS.perkActiveDown(p,
		(p.mm_save.sec_perk == MMPERK_FAKEGUN)
	)
		p.mm.perk_fake_time = perk_maxtime
		p.mm.perk_fake_cooldown = perk_cooldown + perk_maxtime
		p.mm.perk_fake_item = clueItems[P_RandomRange(1,#clueItems)]
	end
	
	if MM_N.gameover
		p.mm.perk_fake_time = 0
	end
	
	if p.mm.perk_fake_cooldown
		p.mm.perk_fake_cooldown = max($-1,0)
	end
	
	--id put this in whitespace but perks are executed too early
	local knife_def = MM.Items["knife"]
	
	if p.mm.perk_fake_time
		p.mm.perk_fake_time = max($-1, 0)
		
		local fake_def = MM.Items[p.mm.perk_fake_item]
		for i = 1, p.mm.inventory.count
			local item = p.mm.inventory.items[i]
			
			if (item and item.mobj and item.mobj.valid and item.id == "knife")
				if not (item.perkfake_setit)
					item.equipsfx = fake_def.equipsfx
					item.mobj.state = fake_def.state
					item.perkfake_setit = true
				end
				
				if p.mm.perk_fake_time == 0
					item.equipsfx = knife_def.equipsfx
					item.mobj.state = knife_def.state
					item.perkfake_setit = false
				end
			end
		end
	elseif p.mm.perk_fake_cooldown >= (perk_cooldown - perk_maxtime - TR)
		for i = 1, p.mm.inventory.count
			local item = p.mm.inventory.items[i]
			
			if (item and item.mobj and item.mobj.valid and item.id == "knife")
				if (item.perkfake_setit)
					item.equipsfx = knife_def.equipsfx
					item.mobj.state = knife_def.state
					item.perkfake_setit = false
				end
			end
		end
	end
end
--yeah this is SUPER good code


MM_PERKS[MMPERK_FAKEGUN] = {
	primary = perk_thinker,
	secondary = perk_thinker,
	
	drawer = function(v,p,c, slot,props)
		if p.mm.perk_fake_time == nil then return end
		local flags = 0
		local notoggle = false
		
		do
			local x = 5*FU - MMHUD.xoffset
			local y = (slot == 1 and 162 or 170)*FU
			
			if (p.mm.perk_fake_cooldown == 0)
				local action = "Fake gun"
				v.drawString(x,y,
					"[WEAPON"..(slot == 1 and "6" or "7").."] - "..action,
					V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
					"thin-fixed"
				)
			end
		end
		
		if (p.mm.perk_fake_time > 0)
			hud_tween = ease.inquad(FU/2, $, hud_tween_start)
			notoggle = true
		else
			if p.mm.perk_fake_cooldown
				hud_tween = ease.inquad(FU/2, $, 0)
				flags = $|V_50TRANS
				notoggle = true
			end
		end
		
		return hud_tween,flags,notoggle
	end,
	postdraw = function(v,p,c, slot,props)
		if p.mm.perk_fake_time == nil then return end
		
		local timer = ''
		if (p.mm.perk_fake_time > 0)
			timer = p.mm.perk_fake_time/TR
		elseif p.mm.perk_fake_cooldown
			timer = p.mm.perk_fake_cooldown/TR
		end
			
		if timer ~= ''
			v.drawString(
				props.x,
				props.y + 32*props.scale - 8*FU,
				timer,
				(props.flags &~V_ALPHAMASK)|V_YELLOWMAP,
				"thin-fixed"
			)
		end
	end,
	
	icon = icon_name,
	icon_scale = icon_scale,
	name = perk_name,
	flags = MPF_TOGGLEABLEPRI|MPF_TOGGLEABLESEC,

	description = {
		"\x82When equipped:\x80 Pressing [TOSSFLAG] will",
		"change your knife's appearance to a random gun,",
		"fooling Innocents. You can still",
		"kill with it!",
		
		"",
		
		"Lasts 10 seconds with a 30 second cooldown."
	},
	cost = perk_price
}

local id = MM.Shop.addItem({
	name = perk_name,
	price = perk_price,
	category = MM_PERKS.category_id
})
MM.Shop.items[id].perk_id = MMPERK_FAKEGUN