local ML = MenuLib

local function drawIt(v, ML, y_off)
	if ML.client.popup_id == -1 then return end
	
	local menu = ML.menus[ML.client.popup_id]
	
	local corner_x = menu.x
	local corner_y = menu.y + y_off
	
	if (menu.outline ~= nil)
		v.drawFill(
			corner_x - 1, corner_y - 1,
			menu.width + 2, menu.height + 2,
			menu.outline
		)
	end
	
	do
		ML.addButton(v, {
			x = corner_x + (menu.width) - 10,
			y = corner_y,
			width = 10,
			height = 13,
			
			name = "x",
			color = -1,
			
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
		menu.drawer(v, ML, {
			corner_x = corner_x,
			corner_y = corner_y,
		})
	end
end

ML.HUD.popup_offset = 700
ML.HUD.popup_time = 0

return function(v, ML)
	local target_offset = 700
	
	if ML.client.popup_id ~= -1
		target_offset = 0
		ML.HUD.popup_time = $ + 2
	else
		ML.HUD.popup_time = 0
	end
	
	ML.HUD.popup_offset = (ease.linear(FU/2, $*FU, target_offset*FU)) / FU
	
	v.fadeScreen(0xFF00, min(25, ML.HUD.popup_time))
	drawIt(v, ML, ML.HUD.popup_offset)
	
end, nil, true