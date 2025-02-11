local ML = MenuLib

addHook("PreThinkFrame", do
	if ML.client.currentMenu.id == -1
		return
	end
	
	ML.client.mouse_x = $ + mouse.dx * 3000
	ML.client.mouse_y = $ + mouse.dy * 3000
	
	ML.client.mouse_x = ML.clamp(0, $, BASEVIDWIDTH*FU)
	ML.client.mouse_y = ML.clamp(0, $, BASEVIDHEIGHT*FU)
	
	if ML.client.doMousePress
		if ML.client.mouseTime == -1
			ML.client.mouseTime = 0
		else
			ML.client.doMousePress = false
			ML.client.mouseTime = -1
		end
	end
end)

addHook("KeyDown", function(key)
	if isdedicatedserver then return end
	if key.repeated then return end
	
	if key.name == "mouse1"
		ML.client.doMousePress = true
	end
end)