local ML = MenuLib

--this functions just the same as initMenu(), this just allows
--another menu to draw as if it was a popup
return function(id)
	if (isdedicatedserver) then return end
	
	--close this popup
	if (id == -1)
		ML.client.menuLayer = $ - 1
		table.remove(ML.client.popups)
		return
	end
	
	input.ignoregameinputs = true
	
	table.insert(ML.client.popups, {
		id = id,
		order = #ML.client.popups,
		lifespan = 0,
		
		y_off = 700,
	})
	
	ML.client.menuLayer = $ + 1
end