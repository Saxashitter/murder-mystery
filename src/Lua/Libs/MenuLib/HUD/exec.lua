local ML = MenuLib
ML.HUD = {
	items = {}
}

--load functions
do
	local path = ML.root .. "HUD/Libs/"
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
	local path = ML.root .. "HUD/Items/"
	local tree = {
		--"drawButton",
		"drawMenus",
		"drawPopups",
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

local textinput_time = 0
local textinput_tween = TICRATE/5
local textinput_tweenfrac = FU / textinput_tween
addHook("HUD",function(v)
	ML.client.hovering = -1
	ML.client.canPressSomething = false
	ML.HUD.stage_item = nil
	ML.HUD.stage_id = -1
	
	if ML.client.currentMenu.id == -1
		ML.HUD.menu_fake_width = 1
		ML.HUD.menu_fake_height = 1
		return
	end
	ML.client.menuLayer = 0
	ML.HUD.stage_id = 0
	
	for key, item in ipairs(ML.HUD.items)
		if item.interpolate
			ML.interpolate(v, true)
		end
		
		ML.HUD.stage_item = item
		item.func(v, ML)
		
		ML.interpolate(v, false)
	end
	
	--text input
	ML.interpolate(v, true)
	if (ML.client.textbuffer ~= nil)
		local boxwidth = (8*(32 + 1)) + 7
		local x = (BASEVIDWIDTH - boxwidth)/2
		local y = 80 + ease.outquad(
			min(textinput_tweenfrac * textinput_time, FU),
			320*FU, 0
		) / FU
		
		local typestr = "Use your keyboard to type."
		v.drawFill(x + 5,
			y - 5,
			v.stringWidth(typestr,0,"thin") + 6,
			8+5, 159
		)
		v.drawString(x + 8,
			y - 2,
			typestr,
			V_ALLOWLOWERCASE,
			"thin"
		)
		
		--text box
		v.drawFill(x + 5,
			y + 4 + 5,
			boxwidth - 8,
			8+6, 159
		)
		local blinking = (((4*leveltime)/TICRATE) & 1) and "_" or ""
		if ML.client.textbuffer:len() == 32 then blinking = ""; end
		v.drawString(x + 8,
			y + 12 + 1,
			ML.client.textbuffer .. blinking,
			V_ALLOWLOWERCASE|V_6WIDTHSPACE,
			"left"
		)
		
		if ML.client.textbuffer_tooltip ~= nil
			local tip = ML.client.textbuffer_tooltip
			
			v.drawFill(x + 5,
				y + 10 + (8+6),
				v.stringWidth(tip,0,"thin") + 6,
				8+5, 159
			)
			v.drawString(x + 8,
				y + 27,
				tip,
				V_ALLOWLOWERCASE,
				"thin"
			)
			
		end
		
		textinput_time = min($ + 1, textinput_tween + 1)
	else
		textinput_time = 0
	end
	ML.interpolate(v, false)
end)

