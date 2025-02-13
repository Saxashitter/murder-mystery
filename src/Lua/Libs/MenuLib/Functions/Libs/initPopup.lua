local ML = MenuLib

--this functions just the same as initMenu(), this just allows
--another menu to draw as if it was a popup
return function(id)
	if (isdedicatedserver) then return end
	
	--close this popup
	if (id == -1)
		if ML.menus[#ML.client.popups].ps_flags & PS_NOSLIDEIN
			table.remove(ML.client.popups)
		else
			local popupitem_t = ML.client.popups[#ML.client.popups]
			popupitem_t.goingdown = true
			popupitem_t.lifespan = min($, 7)
		end
		return
	end
	
	input.ignoregameinputs = true
	
	table.insert(ML.client.popups, {
		id = id,
		order = #ML.client.popups,
		lifespan = 0,
		
		--animation
		goingdown = false,
		y_off = 700,
	})
	
end