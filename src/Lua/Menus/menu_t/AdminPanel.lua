local buttonwidth = 65
local buttonpad = buttonwidth + 5

MenuLib.addMenu({
	stringId = "AdminPanel",
	title = "Admin Panel",
	
	width = 180,
	height = 120,
	
	drawer = function(v, ML, menu, props)
		MenuLib.interpolate(v, false)
		local x,y = props.corner_x, props.corner_y
		x = $ + 5
		y = $ + 20
		
		do
			MenuLib.addButton(v, {
				x = x,
				y = y,
				
				width = buttonwidth,
				height = 25,
				
				name = "",
				color = 155,
				outline = 159,
				
				pressFunc = function()
					MenuLib.client.commandbuffer = "add mm_afkmode 1"
				end,
				
			})
			
			v.drawString(x + (buttonwidth/2),
				y + 2,
				"Anti-AFK",
				V_ALLOWLOWERCASE|V_YELLOWMAP,
				"thin-center"
			)
			v.drawString(x + (buttonwidth/2),
				y + 15,
				CV_MM.afkkickmode.string,
				V_ALLOWLOWERCASE,
				"thin-center"
			)
			
		end
		
		MenuLib.addButton(v, {
			x = (props.corner_x + menu.width) - 5 - buttonwidth,
			y = y,
			
			width = buttonwidth,
			height = 25,
			
			name = "Debug",
			color = 13,
			outline = 19,
			
			pressFunc = function()
				MenuLib.initMenu(MenuLib.findMenu("AdminPanel_Sub1"))
			end,
			
		})
		
	end
})

MenuLib.addMenu({
	stringId = "AdminPanel_Sub1",
	title = "Admin Panel",
	
	width = (buttonpad*4) + 7,
	height = 120,
	
	drawer = function(v, ML, menu, props)
		MenuLib.interpolate(v, false)
		local x,y = props.corner_x, props.corner_y
		x = $ + 5
		y = $ + 20
		
		do
			MenuLib.addButton(v, {
				x = x,
				y = y,
				
				width = buttonwidth,
				height = 25,
				
				name = "",
				color = 155,
				outline = 159,
				
				pressFunc = function()
					MenuLib.client.commandbuffer = "toggle mm_debug"
				end,
				
			})
			
			v.drawString(x + (buttonwidth/2),
				y + 2,
				"Debug",
				V_ALLOWLOWERCASE|V_YELLOWMAP,
				"thin-center"
			)
			v.drawString(x + (buttonwidth/2),
				y + 15,
				CV_MM.debug.string,
				V_ALLOWLOWERCASE,
				"thin-center"
			)
			
		end
		
		MenuLib.addButton(v, {
			x = x + buttonpad,
			y = y,
			
			width = buttonwidth,
			height = 25,
			
			name = "End Round",
			color = 13,
			outline = 19,
			
			pressFunc = function()
				MenuLib.client.commandbuffer = "mm_endgame"
			end,
			
		})
		
		MenuLib.addButton(v, {
			x = x + buttonpad*2,
			y = y,
			
			width = buttonwidth,
			height = 25,
			
			name = "Showdown",
			color = 13,
			outline = 19,
			
			pressFunc = function()
				MenuLib.client.commandbuffer = "mm_startshowdown"
			end,
			
		})
		
		MenuLib.addButton(v, {
			x = x + buttonpad*3,
			y = y,
			
			width = buttonwidth,
			height = 25,
			
			name = "Overtime",
			color = 13,
			outline = 19,
			
			pressFunc = function()
				MenuLib.client.commandbuffer = "mm_timeto0"
			end,
			
		})
	end
})
