MMHUD.menus = {}

-- https://stackoverflow.com/questions/10989788/format-integer-in-lua
local function format_int(number)

  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

  -- reverse the int-string and append a comma to all blocks of 3 digits
  int = int:reverse():gsub("(%d%d%d)", "%1,")

  -- reverse the int-string back remove an optional comma and put the 
  -- optional minus and fractional part back
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

MMHUD.menus.drawRings = function(v, x,y)
	x = $*FU
	y = $*FU
	local rings = format_int(MM:GetPlayerRings(consoleplayer))
	
	local origin_size = FixedDiv(16*FU, v.cachePatch("MMRING").width*FU) -- Scale to 16 pixels
	local origin_scale = FU*3/4
	
	v.drawScaled(x, y,
		FixedMul(origin_size, origin_scale),
		v.cachePatch("MMRING"),
		0
	)
	v.drawString(x + 14*FU,
		y + 3*FU,
		rings,
		0,
		"thin-fixed"
	)	

end

MMHUD.menus.drawPerkItem = function(v, x,y, perk, nofunc)
	local perk_t = MM_PERKS[perk]
	if perk_t == nil
		perk_t = {
			name = "None",
			icon = "MM_NOITEM",
		}
	end
	
	local pressfunc = (not nofunc) and function()
		if (#MenuLib.client.popups)
			MenuLib.initPopup(-1, true)
		end
		MenuLib.initPopup(MenuLib.findMenu("Shop_Popup_"..(perk_t.name)))
	end or nil
	
	MenuLib.addButton(v, {
		x = x,
		y = y,
		
		width = 32,
		height = 41,
		
		name = "",
		color = 13,
		outline = 19,
		
		pressFunc = pressfunc,
		id = (not nofunc) and perk or nil,
		
	})
	
	v.drawScaled(x*FU, y*FU,
		perk_t.icon_scale or FU,
		v.cachePatch(perk_t.icon),
		0
	)
	v.drawFill(x, y + 32, 32, 1, 19)
	
	v.drawString(
		x + 16,
		y + 35,
		perk_t.name,
		V_ALLOWLOWERCASE,
		"small-thin-center"
	)
end

MMHUD.menus.tryPerkEquip = function(perk_id, slot, mm_slot)
	if MMHUD.menus.tryingEquip then return end
	
	if (consoleplayer and consoleplayer.valid)
	and (consoleplayer.mm_save and consoleplayer.mm_save[mm_slot] == perk_id)
		MMHUD.menus.tryEquippingThis = "mm_equipperk "..slot.." none"
	else
		MMHUD.menus.tryEquippingThis = "mm_equipperk "..slot.." "..perk_id
	end
	MMHUD.menus.tryEquippingSlot = mm_slot
	MMHUD.menus.iWantThisSlot = perk_id
	
	MMHUD.menus.tryingEquip = TICRATE
	
	MenuLib.initPopup(MenuLib.findMenu("Shop_Equipping"))
end

MMHUD.menus.equippop = {
	timer = 0,
	last = 0,
}

MenuLib.addMenu({
	stringId = "Shop_Equipping",
	
	x = 160 - 35,
	y = 100 - 20,
	
	width = 70,
	height = 40,
	color = 27,
	outline = 30,
	
	title = "",
	ps_flags = PS_NOXBUTTON|PS_NOSLIDEIN,
	
	drawer = function(v, ML, menu, props)
		local x,y = props.corner_x, props.corner_y
		if (menu.lifetime == nil)
			menu.lifetime = 0
		end
		menu.lifetime = $ + 1
		
		v.drawString(x + menu.width/2,
			y + menu.height/2 - 3,
			"Equipping...",
			V_ALLOWLOWERCASE,
			"thin-center"
		)
		
		MMHUD.menus.equippop.last = MMHUD.menus.equippop.timer
		MMHUD.menus.equippop.timer = $ + 1
		
		--auto-close
		if (MMHUD.menus.last_tryingEquip
		and not MMHUD.menus.tryingEquip)
		--something has gone horribly wrong
		or (menu.lifetime >= TICRATE)
		
			MenuLib.initPopup(-1,true)
			
			--close the other one too
			MenuLib.initPopup(-1,true)
			MMHUD.menus.equippop.timer = $ - 1
		end
	end
})

local itemid_to_perkid = {}
local perkit_to_itemid = {}
do
	local cate = MM_PERKS.category_ptr
	
	for i = 1, #cate.items
		local item = MM.Shop.items[cate.items[i]]
		
		itemid_to_perkid[i] = item.perk_id
		perkit_to_itemid[item.perk_id] = i
	end
end

for i = 1, MM_PERKS.num_perks
	local perk_t = MM_PERKS[i]
	
	MenuLib.addMenu({
		stringId = "Shop_Popup_"..(perk_t.name),
		
		x = 181,
		y = 29,
		
		width = 114,
		height = 156,
		color = 27,
		
		title = perk_t.name,
		ps_flags = PS_NOXBUTTON|PS_NOFADE|PS_DRAWTITLE|PS_NOSLIDEIN|PS_IRRELEVANT,
		
		drawer = function(v, ML, menu, props)
			local x,y = props.corner_x, props.corner_y
			local p = consoleplayer
			
			MMHUD.menus.drawPerkItem(v,
				x + 38,
				y + 20,
				i,
				true
			)
			
			MenuLib.interpolate(v, false)
			
			if MMHUD.menus.tryingEquip
				return
			end
			
			local this_itemid = perkit_to_itemid[i]
			if not (consoleplayer.mm_save.purchased[this_itemid])
				v.drawString(x + 54,
					y + 65, "Buy?", V_ALLOWLOWERCASE, "thin-center"
				)
				
				MenuLib.addButton(v, {
					x = (x + 54) - (27 + 16),
					y = y + 75,
					
					width = 32,
					height = 20,
					
					name = "Purchase",
					color = 103,
					outline = 111,
					
					pressFunc = function()
						if MMHUD.menus.tryingEquip then return end
						MMHUD.menus.tryPerkEquip(i, "primary", "pri_perk")
					end
					
				})
				
				MenuLib.addButton(v, {
					x = (x + 54) + (27) - 16,
					y = y + 75,
					
					width = 32,
					height = 20,
					
					name = "Cancel",
					color = 7,
					outline = 15,
					
					pressFunc = function()
						MenuLib.initPopup(-1)
					end
					
				})
				return
			end
			
			v.drawString(x + 54,
				y + 65, "Equip?", V_ALLOWLOWERCASE, "thin-center"
			)
			
			MenuLib.addButton(v, {
				x = (x + 54) - 20,
				y = y + 100,
				
				width = 40,
				height = 20,
				
				name = "Cancel",
				color = 7,
				outline = 15,
				
				pressFunc = function()
					MenuLib.initPopup(-1)
				end
			})
			
			MenuLib.addButton(v, {
				x = (x + 54) - (27 + 16),
				y = y + 75,
				
				width = 32,
				height = 20,
				
				name = (p.mm_save and p.mm_save.pri_perk == i) and "Unequip" or "Primary",
				color = (p.mm_save and p.mm_save.pri_perk == i) and 39 or 7,
				outline = (p.mm_save and p.mm_save.pri_perk == i) and 47 or 15,
				
				pressFunc = function()
					if MMHUD.menus.tryingEquip then return end
					MMHUD.menus.tryPerkEquip(i, "primary", "pri_perk")
				end
				
			})
			
			MenuLib.addButton(v, {
				x = (x + 54) + (27) - 16,
				y = y + 75,
				
				width = 32,
				height = 20,
				
				name = (p.mm_save and p.mm_save.sec_perk == i) and "Unequip" or "Secondary",
				color = (p.mm_save and p.mm_save.sec_perk == i) and 39 or 7,
				outline = (p.mm_save and p.mm_save.sec_perk == i) and 47 or 15,
				
				pressFunc = function()
					if MMHUD.menus.tryingEquip then return end
					MMHUD.menus.tryPerkEquip(i, "secondary", "sec_perk")
				end
				
			})
			
			--auto-close
			/*
			if MMHUD.menus.equippop.last == MMHUD.menus.equippop.timer
			and MMHUD.menus.equippop.timer
				MenuLib.initPopup(-1)
				
				--yeah....
				MMHUD.menus.equippop.timer = 0
				MMHUD.menus.equippop.last = 0
			end
			*/
		end
	})
end

MenuLib.addMenu({
	stringId = "ShopPage",
	title = "Shop",
	
	width = 270,
	
	drawer = function(v, ML, menu, props)
		MenuLib.interpolate(v, false)
		local x,y = props.corner_x, props.corner_y
		
		MMHUD.menus.drawRings(v,
			(BASEVIDWIDTH/2) - 15,
			y + 1
		)
		
		do
			x = $ + 6
			y = $ + 17
			
			local cate = MM_PERKS.category_ptr
			
			for i = 1, #cate.items
				local item = MM.Shop.items[cate.items[i]]
				
				MMHUD.menus.drawPerkItem(v, x,y, item.perk_id)
				
				x = $ + 37
				
				if (i == 4)
					x = props.corner_x + 6
					y = $ + 46
				end
			end
			
		end
		
		v.drawFill(180, props.corner_y + 14,
			1, 156, 0
		)
		
		if MenuLib.client.hovering ~= -1
			local perk_t = MM_PERKS[MenuLib.client.hovering]
			
			local workx = (BASEVIDWIDTH/2) + 23
			local worky = 40
			
			v.drawString(workx, worky - 10,
				perk_t.name,
				V_ALLOWLOWERCASE|V_YELLOWMAP,
				"left"
			)
			
			if (perk_t and perk_t.description ~= nil)
				for k,str in ipairs(perk_t.description)
					v.drawString(workx, worky,
						str,
						V_ALLOWLOWERCASE,
						"small-thin"
					)
					worky = $ + 4
				end
				
			end
			
			if (perk_t and perk_t.cost ~= nil)
				local cost = "???"
				if type(perk_t.cost) == "number"
					if perk_t.cost == 0
						cost = "Free!"
					else
						cost = "$" .. format_int(perk_t.cost)
					end
				elseif type(perk_t.cost) == "string"
					cost = perk_t.cost
				end
				
				v.drawString(workx, worky + 6,
					"Cost: \x83"..cost,
					V_ALLOWLOWERCASE,
					"thin"
				)
			end
			
		--draw our equipped perks
		else
			local center_x = ((BASEVIDWIDTH/2) + menu.width/4) - 5
			y = props.corner_y + 27
			
			v.drawString(center_x - 34,
				y - 10,
				"Primary",
				V_ALLOWLOWERCASE|V_YELLOWMAP,
				"thin"
			)
			MMHUD.menus.drawPerkItem(v,
				center_x - 34,
				y,
				consoleplayer.mm_save.pri_perk,
				true
			)
			
			v.drawString(center_x + (34*2),
				y + 43,
				"Secondary",
				V_ALLOWLOWERCASE|V_YELLOWMAP,
				"thin-right"
			)
			MMHUD.menus.drawPerkItem(v,
				center_x + 34,
				y,
				consoleplayer.mm_save.sec_perk,
				true
			)
		
		end
	end
})

addHook("ThinkFrame", do
	if not MMHUD.menus then return end
	
	if MMHUD.menus.tryEquippingThis
		COM_BufInsertText(consoleplayer, MMHUD.menus.tryEquippingThis)
		MMHUD.menus.tryEquippingThis = nil
	end
	
	if MMHUD.menus.tryingEquip
		MMHUD.menus.last_tryingEquip = MMHUD.menus.tryingEquip
		MMHUD.menus.tryingEquip = $ - 1
		
		if consoleplayer.mm_save[MMHUD.menus.tryEquippingSlot] == MMHUD.menus.iWantThisSlot
			MMHUD.menus.tryingEquip = 0
		end
	elseif MMHUD.menus.last_tryingEquip
		MMHUD.menus.last_tryingEquip = max($-1, 0)
	end
end)