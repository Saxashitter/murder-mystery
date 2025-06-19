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

	-- controller/mobileAdd commentMore actions
	local angle = R_PointToAngle2(0, 0, ML.client.sidemove*FU, -ML.client.forwardmove*FU)
	local analog = max(abs(ML.client.forwardmove), abs(ML.client.sidemove))*FU/50

	ML.client.mouse_x = $ + FixedMul(cos(angle), analog*4)
	ML.client.mouse_y = $ + FixedMul(sin(angle), analog*4)

	ML.client.mouse_x = ML.clamp(0, $, BASEVIDWIDTH*FU)
	ML.client.mouse_y = ML.clamp(0, $, BASEVIDHEIGHT*FU)
	
	if ML.client.commandbuffer ~= nil
		COM_BufInsertText(consoleplayer,ML.client.commandbuffer)
		ML.client.commandbuffer = nil
	end
end)

addHook("KeyDown", function(key)
	if isdedicatedserver then return end
	
	if key.name == "lctrl"
	or key.name == "rctrl"
		ML.client.text_ctrldown = true
	end
	
	if key.name == "lshift"
	or key.name == "rshift"
		ML.client.text_shiftdown = true
	end
	
	if ML.client.textbuffer ~= nil
		local keydown = false
		ML.client.textbuffer,keydown = ML.keyHandler(key, ML.client.textbuffer)
		if keydown then return true; end
	end
end)
addHook("KeyUp", function(key)
	if isdedicatedserver then return end
	
	if key.name == "lctrl"
	or key.name == "rctrl"
		ML.client.text_ctrldown = false
	end
	
	if key.name == "lshift"
	or key.name == "rshift"
		ML.client.text_shiftdown = false
	end
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
	and (ML.client.textbuffer_id == nil)
		ML.client.doMousePress = true
	elseif key.name == "escape"
	and not chatactive
		if (ML.client.textbuffer_id == nil)
			if #ML.client.popups
				if ML.menus[ML.client.popups[#ML.client.popups].id].ps_flags & PS_NOESCAPE --holy SHIT
					--do nothing
				else
					ML.initPopup(-1)
				end
			else
				ML.initMenu(-1)
			end
		else
			if ML.client.textbuffer_funcs.close ~= nil
				if ML.client.textbuffer_funcs.close()
					return true
				end
			end
			ML.stopTextInput()
		end
		return true
	elseif key.name == "enter"
	and not chatactive
	and (ML.client.textbuffer_id ~= nil)
		if ML.client.textbuffer_funcs.enter ~= nil
			ML.client.textbuffer_funcs.enter()
		end
		S_StartSound(nil,sfx_menu1,consoleplayer)
		ML.stopTextInput()
	end
end)

addHook("PlayerCmd", function(p, cmd)
	if not ML.client.overrideinputs then return end

	ML.client.lastbuttons = ML.client.buttons
	ML.client.buttons = cmd.buttons
	ML.client.forwardmove = cmd.forwardmove
	ML.client.sidemove = cmd.sidemove

	if ML.client.buttons & BT_JUMP
	and ML.client.lastbuttons & BT_JUMP == 0 then
		ML.client.doMousePress = true
	end

	cmd.buttons = 0
	cmd.sidemove = 0
	cmd.forwardmove = 0

	cmd.angleturn = p.cmd.angleturn
	cmd.aiming = p.cmd.aiming
end)