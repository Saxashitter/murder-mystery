MMHUD.menus = {}

MMHUD.menus.drawRings = function(v, x,y)
	x = $*FU
	y = $*FU
	local rings = MM:GetPlayerRings(consoleplayer)
	
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
	
	MMHUD.menus.tryingEquip = TICRATE
end

--TODO: put these in the perk's definitions?
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
		
		drawer = function(v, ML, menu, props)
			local x,y = props.corner_x, props.corner_y
			local p = consoleplayer
			
			v.drawString(x + 2, y + 2, perk_t.name, V_ALLOWLOWERCASE, "thin")
			
			MMHUD.menus.drawPerkItem(v,
				x + 38,
				y + 20,
				i,
				true
			)
			
			MenuLib.interpolate(v, false)
			
			--no buying yet...
			v.drawString(x + 54,
				y + 65, "Equip?", V_ALLOWLOWERCASE, "thin-center"
			)
			
			if MMHUD.menus.tryingEquip
				MenuLib.addButton(v, {
					x = (x + 54) - 20,
					y = y + 75,
					
					width = 40,
					height = 20,
					
					name = "Wait...",
					color = 7,
					outline = 15,
					
				})
				
				return
			end
			
			MenuLib.addButton(v, {
				x = (x + 54) - (27 + 16),
				y = y + 75,
				
				width = 32,
				height = 20,
				
				name = (p.mm_save and p.mm_save.pri_perk == i) and "Unequip" or "Primary",
				color = 7,
				outline = 15,
				
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
				color = 7,
				outline = 15,
				
				pressFunc = function()
					if MMHUD.menus.tryingEquip then return end
					MMHUD.menus.tryPerkEquip(i, "secondary", "sec_perk")
				end
				
			})
			
			--auto-close
			if MMHUD.menus.last_tryingEquip
			and not MMHUD.menus.tryingEquip
				MenuLib.initPopup(-1)
			end
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
			
			for i = 1, MM_PERKS.num_perks
				MMHUD.menus.drawPerkItem(v, x,y, i)
				
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
					cost = "$"..(perk_t.cost)
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
	elseif MMHUD.menus.last_tryingEquip
		MMHUD.menus.last_tryingEquip = max($-1, 0)
	end
end)