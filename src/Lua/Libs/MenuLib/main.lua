local ML = MenuLib

addHook("PreThinkFrame", do
	if ML.client.doMousePress
		if ML.client.mouseTime == -1
			ML.client.mouseTime = 0
		else
			ML.client.doMousePress = false
			ML.client.mouseTime = -1
		end
	end
	
	ML.client.menuactive = false
	if ML.client.currentMenu.id == -1
		ML.client.currentMenu.layers = {}
		ML.client.menuTime = 0
		return
	end
	ML.client.menuactive = true
	ML.client.menuTime = $ + 1
	
	ML.client.mouse_x = $ + mouse.dx * 3700
	ML.client.mouse_y = $ + mouse.dy * 3700
	
	ML.client.mouse_x = ML.clamp(0, $, BASEVIDWIDTH*FU)
	ML.client.mouse_y = ML.clamp(0, $, BASEVIDHEIGHT*FU)
	
end)

addHook("KeyDown", function(key)
	if isdedicatedserver then return end
	if key.repeated then return end
	if (ML.client.menuTime < 2)
		ML.client.doMousePress = false
		ML.client.mouseTime = -1
		return
	end
	
	if key.name == "mouse1"
		ML.client.doMousePress = true
	elseif key.name == "escape"
		if #ML.client.popups
			if ML.menus[ML.client.popups[#ML.client.popups].id].ps_flags & PS_NOESCAPE --holy SHIT
				--do nothing
			else
				ML.initPopup(-1)
			end
		else
			ML.initMenu(-1)
		end
		return true
	end
end)