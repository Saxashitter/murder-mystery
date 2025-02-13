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
			
			v.drawString(x + 2, y + 2, perk_t.name, V_ALLOWLOWERCASE, "thin")
			
			MMHUD.menus.drawPerkItem(v,
				x + 38,
				y + 20,
				i,
				true
			)
			
			v.drawString(x + 54,
				y + 65, "Buy?", V_ALLOWLOWERCASE, "thin-center"
			)
			
			MenuLib.addButton(v, {
				x = (x + 54) - (27 + 16),
				y = y + 75,
				
				width = 32,
				height = 20,
				
				name = "Yes",
				color = 99,
				outline = 105,
				
				--pressFunc = pressfunc
				
			})
			
			MenuLib.addButton(v, {
				x = (x + 54) + (27) - 16,
				y = y + 75,
				
				width = 32,
				height = 20,
				
				name = "No",
				color = 35,
				outline = 41,
				
				--pressFunc = pressfunc
				
			})
		end
	})
end

MenuLib.addMenu({
	stringId = "ShopPage",
	title = "Shop",
	
	width = 270,
	
	drawer = function(v, ML, menu, props)
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
			
		end
	end
})