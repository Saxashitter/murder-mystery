local ML = MenuLib

return function(v,ML)
	if ML.client.currentMenu.id == -1 then return end
	
	local menu = ML.menus[ML.client.currentMenu.id]
	
	local corner_x = (BASEVIDWIDTH/2) - (menu.width/2)
	local corner_y = (BASEVIDHEIGHT/2) - (menu.height/2)
	
	v.drawFill(
		corner_x, corner_y,
		menu.width, menu.height,
		27
	)
	
	v.drawString(corner_x + 2,
		corner_y + 2,
		menu.title,
		V_ALLOWLOWERCASE,
		"left"
	)
	
	do --if (ML.client.currentMenu.prevId ~= -1)
		ML.addButton(v, {
			x = (BASEVIDWIDTH/2) + (menu.width/2) - 25,
			y = corner_y,
			width = 25,
			height = 13,
			
			name = ML.client.currentMenu.prevId ~= -1 and "Back" or "Exit",
			color = 27,
			
			pressFunc = function()
				ML.initMenu(ML.client.currentMenu.prevId)
			end
		})
	end
	
	v.drawFill(corner_x, corner_y + 13,
		menu.width, 1,
		0
	)
	
	if (menu.drawer ~= nil)
		menu.drawer(v, ML, {
			corner_x = corner_x,
			corner_y = corner_y,
		})
	end
end