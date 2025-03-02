local command_buf

MenuLib.addMenu({
	stringId = "MainMenu",
	title = "Main Menu",
	
	width = 180,
	height = 120,
	
	drawer = function(v, ML, menu, props)
		MenuLib.interpolate(v, false)
		local x,y = props.corner_x, props.corner_y
		x = $ + 5
		y = $ + 20
		
		local buttonwidth = 65
		
		MenuLib.addButton(v, {
			x = x,
			y = y,
			
			width = buttonwidth,
			height = 25,
			
			name = "Shop",
			color = 13,
			outline = 19,
			
			pressFunc = function()
				MenuLib.initMenu(MenuLib.findMenu("ShopPage"))
			end,
			
		})
		
		MenuLib.addButton(v, {
			x = (props.corner_x + menu.width) - 5 - buttonwidth,
			y = y,
			
			width = buttonwidth,
			height = 25,
			
			name = "Guide book",
			color = 13,
			outline = 19,
			
			pressFunc = function()
				MenuLib.initMenu(MenuLib.findMenu("Protips"))
			end,
			
		})
		
		--line 2
		MenuLib.addButton(v, {
			x = x,
			y = y + (menu.height - 40 - 25),
			
			width = buttonwidth,
			height = 25,
			
			name = "Admin Panel",
			color = 13,
			outline = 19,
			
			pressFunc = function()
				MenuLib.initMenu(MenuLib.findMenu("AdminPanel"))
			end,
			
		})
		
		do
			MenuLib.addButton(v, {
				x = (props.corner_x + menu.width) - 5 - buttonwidth,
				y = y + (menu.height - 40 - 25),
				
				width = buttonwidth,
				height = 25,
				
				name = "",
				color = 13,
				outline = 19,
				
				pressFunc = function()
					command_buf = "mm_spectatormode"
				end,
				
			})
			
			v.drawString(
				(props.corner_x + menu.width) - 5 - buttonwidth/2,
				y + (menu.height - 40 - 25) + 2,
				"Spectator Mode",
				V_ALLOWLOWERCASE|V_YELLOWMAP,
				"thin-center"
			)
			v.drawString(
				(props.corner_x + menu.width) - 5 - buttonwidth/2,
				y + (menu.height - 40 - 25) + 15,
				consoleplayer.mm_save.afkmode and "On" or "Off",
				V_ALLOWLOWERCASE,
				"thin-center"
			)
		end
	end
})

addHook("ThinkFrame",do
	if command_buf
		COM_BufInsertText(consoleplayer, command_buf)
		command_buf = nil
	end
end)