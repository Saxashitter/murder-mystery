local ML = MenuLib
ML.HUD = {
	items = {}
}

--load functions
do
	local path = "Libs/MenuLib/HUD/Libs/"
	local tree = {
		"addButton",
		"buttonHovering",
	}

	for k, name in ipairs(tree)
		ML[name] = dofile(path .. name)
	end
end

--load hud items
do
	local path = "Libs/MenuLib/HUD/Items/"
	local tree = {
		--"drawButton",
		"drawMenus",
		"drawMouse",
	}

	for k, name in ipairs(tree)
		local func, id, interp = dofile(path .. name)
		id = $ or k
		
		table.insert(ML.HUD.items, id, {
			id = id,
			func = func,
			interpolate = interp,
			
			name = name
		})
	end
end

--Sort hud items based on priority
table.sort(ML.HUD.items, function(a,b)
	return (a.id < b.id)
end)

addHook("HUD",function(v)
	ML.client.hovering = -1
	
	if ML.client.currentMenu.id == -1 then return end
	
	for key, item in ipairs(ML.HUD.items)
		if item.interpolate
			ML.interpolate(v, true)
		end
		
		item.func(v, ML)
		
		ML.interpolate(v, false)
	end
end)

