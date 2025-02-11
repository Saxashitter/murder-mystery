local ML = MenuLib

--this functions just the same as initMenu(), this just allows
--another menu to draw as if it was a popup
return function(id)
	if (isdedicatedserver) then return end
	if (ML.client.popup_id ~= -1 and id ~= -1) then return end
	
	input.ignoregameinputs = true
	
	ML.client.popup_id = id
end