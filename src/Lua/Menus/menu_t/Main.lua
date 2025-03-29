local command_buf

--buttons that handle cvars should be colored 155 with outline 159
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
				if not (consoleplayer == server
				or IsPlayerAdmin(consoleplayer))
					S_StartSound(nil,sfx_lose, consoleplayer)
					return
				end
				
				MenuLib.initMenu(MenuLib.findMenu("AdminPanel"))
			end,
			
		})
		
		MenuLib.addButton(v, {
			x = (props.corner_x + menu.width) - 5 - buttonwidth,
			y = y + (menu.height - 40 - 25),
			
			width = buttonwidth,
			height = 25,
			
			name = "User Settings",
			color = 13,
			outline = 19,
			
			pressFunc = function()
				MenuLib.initMenu(MenuLib.findMenu("UserSettings"))
			end,
			
		})
		
	end
})
