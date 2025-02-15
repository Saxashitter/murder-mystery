local ML = MenuLib
local function noPopUpInteract()
	local nointer = false
	if (#ML.client.popups > 0)
		nointer = true
	end
	
	if (#ML.client.popups == 1)
	and (ML.menus[ML.client.popups[1].id].ps_flags & PS_IRRELEVANT)
		nointer = false
	end
	return nointer
end

return function(v, props)
	if ML.client.menuTime < 3 then return false; end
	if (ML.client.currentMenu.id == -1) then return false; end
	if (ML.client.menuLayer ~= ML.HUD.stage_id) then return false; end
	
	--shitty ik
	if ML.HUD.stage_item.name == "drawMenus"
	and noPopUpInteract()
		return false
	end
	
	local m_x = ML.client.mouse_x / FU
	local m_y = ML.client.mouse_y / FU
	
	if ((m_x >= props.x) and (m_x <= props.x + props.width))
	and ((m_y >= props.y) and (m_y <= props.y + props.height))
		return true
	end
	return false
end