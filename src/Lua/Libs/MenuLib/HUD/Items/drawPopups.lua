local ML = MenuLib

local function drawIt(v, ML)	
	ML.client.menuLayer = $ + #ML.client.popups
	
	for key, popupitem_t in ipairs(ML.client.popups)
		ML.interpolate(v, key)
		local menu = ML.menus[popupitem_t.id]
		
		--set the stage_id to the topmost pop-up
		if key == #ML.client.popups
			ML.HUD.stage_id = $ + #ML.client.popups
		end
		
		popupitem_t.y_off = (ease.linear(FU/2, $*FU, 0)) / FU
		local y_off = popupitem_t.y_off
		
		popupitem_t.lifespan = $ + 1
		v.drawFill(0,0,
			(v.width()/v.dupx())+1,
			(v.height()/v.dupy())+1,
			31|(max(3, 10 - popupitem_t.lifespan)<<V_ALPHASHIFT)|V_SNAPTOLEFT|V_SNAPTOTOP
		)
		
		local corner_x = menu.x
		local corner_y = menu.y + y_off
		
		if (menu.outline ~= nil)
			v.drawFill(
				corner_x - 1, corner_y - 1,
				menu.width + 2, menu.height + 2,
				menu.outline
			)
		end
		if (menu.color ~= -1)
			v.drawFill(
				corner_x, corner_y,
				menu.width, menu.height,
				menu.color
			)
		end
		
		do
			ML.addButton(v, {
				x = corner_x + (menu.width) - 10,
				y = corner_y,
				width = 10,
				height = 13,
				
				name = "x",
				color = menu.color,
				
				pressFunc = function()
					ML.initPopup(-1)
				end
			})
		end
		
		v.drawFill(corner_x, corner_y + 13,
			menu.width, 1,
			0
		)
		
		if (menu.drawer ~= nil)
			menu.drawer(v, ML, menu, {
				corner_x = corner_x,
				corner_y = corner_y,
			})
		end
		
		ML.interpolate(v, false)
	end
end

return function(v, ML)
	drawIt(v, ML)	
end, nil, false