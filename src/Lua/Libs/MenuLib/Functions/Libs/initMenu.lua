local ML = MenuLib

return function(id)
	if (isdedicatedserver) then return end
	
	input.ignoregameinputs = true
	if id ~= -1
		if (ML.client.currentMenu.prevId == id)
			ML.client.currentMenu.prevId = -1
		else
			ML.client.currentMenu.prevId = ML.client.currentMenu.id
		end
	--closed
	else
		ML.client.currentMenu.prevId = -1
		input.ignoregameinputs = false
		
		ML.client.mouse_x = (BASEVIDWIDTH*FU) / 2
		ML.client.mouse_y = (BASEVIDHEIGHT*FU) / 2
	end
	
	ML.client.currentMenu.id = id
end