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
					ML.startTextInput(textbuf,textbufid,nil,function()
						MenuLib.client.commandbuffer = "MM_RadioSong "..ML.client.textbuffer
						textbuf = ""
					end, "Sets your radio's song when dropped.")				
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
	end
})
