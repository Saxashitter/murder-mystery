local buttonwidth = 65
local buttonpad = buttonwidth + 5

local cv = {
	muteradio = nil,
}

local textbuf = ""
local textbufid = MenuLib.newBufferID()

MenuLib.addMenu({
	stringId = "UserSettings",
	title = "User Settings",
	
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
					MenuLib.client.commandbuffer = "mm_spectatormode"
				end,
				
			})
			
			v.drawString(
				x + buttonwidth/2,
				y + 2,
				"Spectator Mode",
				V_ALLOWLOWERCASE|V_YELLOWMAP,
				"thin-center"
			)
			v.drawString(
				x + buttonwidth/2,
				y + 15,
				consoleplayer.mm_save.afkmode and "On" or "Off",
				V_ALLOWLOWERCASE,
				"thin-center"
			)
		end
		
		do
			if not cv.muteradio
				cv.muteradio = CV_FindVar("mm_muteradio")
				
			end
			
			MenuLib.addButton(v, {
				x = (props.corner_x + menu.width) - 5 - buttonwidth,
				y = y,
				
				width = buttonwidth,
				height = 25,
				
				name = "",
				color = 155,
				outline = 159,
				
				pressFunc = function()
					MenuLib.client.commandbuffer = "toggle mm_muteradio"
				end,
				
			})
			
			v.drawString(
				(props.corner_x + menu.width) - 5 - buttonwidth/2,
				y + 2,
				"Mute Radios",
				V_ALLOWLOWERCASE|V_YELLOWMAP,
				"thin-center"
			)
			v.drawString(
				(props.corner_x + menu.width) - 5 - buttonwidth/2,
				y + 15,
				cv.muteradio.string,
				V_ALLOWLOWERCASE,
				"thin-center"
			)
		end
		
		--layer 2
		do
			local ypos = y + (menu.height - 5 - 25) - 25
			MenuLib.addButton(v, {
				x = x,
				y = ypos,
				
				width = buttonwidth,
				height = 25,
				
				name = "",
				color = 13,
				outline = 19,
				
				pressFunc = function()
					ML.startTextInput(textbuf,textbufid,{
                        onenter = function()
                            MenuLib.client.commandbuffer = "MM_RadioSong "..ML.client.textbuffer
                            textbuf = ""
                        end,
                        tooltip = {
                            "Sets your radio's song when dropped. \x82Valid songs:",
                            "tacos, macca, overtime, fellas, sonicr, elevator, portal"
                        },
                        typesound = sfx_oldrad
                    })				
				end,
				
			})
			
			v.drawString(
				x + buttonwidth/2,
				ypos + 2,
				"Radio Song...",
				V_ALLOWLOWERCASE|V_YELLOWMAP,
				"thin-center"
			)
			v.drawString(
				x + buttonwidth/2,
				ypos + 15,
				consoleplayer.mmradio_song and consoleplayer.mmradio_song.realname or "macca",
				0,
				"thin-center"
			)
		end
		
		do
			local ypos = y + (menu.height - 5 - 25) - 25
			MenuLib.addButton(v, {
				x = (props.corner_x + menu.width) - 5 - buttonwidth,
				y = ypos,
				
				width = buttonwidth,
				height = 25,
				
				name = "\x82".."Discord",
				color = 13,
				outline = 19,
				
				id = 1000,
				pressFunc = function() end,
				
			})
			
			if MenuLib.client.hovering == 1000
				menu.sexdick = 14
			end
			
		end
		
		if menu.sexdick == nil
			menu.sexdick = 0
		elseif menu.sexdick
			menu.sexdick = $ - 2
			
			local trans = 0
			if (menu.sexdick < 10)
				trans = (10 - menu.sexdick) << V_ALPHASHIFT
			end
			
			if menu.sexdick
				MenuLib.interpolate(v,true)
				local x,y = MenuLib.client.mouse_x + 3*FU,MenuLib.client.mouse_y + 3*FU
				--drawfillfixed wheeeeen
				local width,height = 113,16
				v.drawFill(x/FU, y/FU, width,height, 19|trans)
				v.drawFill((x/FU) + 1, (y/FU) + 1, width-2,height-2, menu.color|trans) 
				
				v.drawString(x + 2*FU,y + 2*FU,
					"Join us in our Discord server!\x82\n"..
					"discord.gg/XVcvm97Mqx",
					V_ALLOWLOWERCASE|trans,
					"small-fixed"
				)
				MenuLib.interpolate(v,false)
			end
		end
		
	end
})
