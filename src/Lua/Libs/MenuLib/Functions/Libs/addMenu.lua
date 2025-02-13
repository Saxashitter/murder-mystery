local ML = MenuLib
ML.menus = {}

local function getAttrib(props, attrib, default)
	if (props[attrib] == nil)
		return default
	end
	return props[attrib]
end

return function(props)
	table.insert(ML.menus, {
		title = props.title or "Menu",
		
		width = getAttrib(props, "width", 300),
		height = getAttrib(props, "height", 170),
		color = getAttrib(props, "color", 27),
		outline = props.outline,
		
		drawer = props.drawer,
		thinker = props.thinker,
		
		stringId = props.stringId,
		
		--the rest are popup only
		x = getAttrib(props, "x", BASEVIDWIDTH/2),
		y = getAttrib(props, "y", BASEVIDHEIGHT/2),
		ps_flags = getAttrib(props, "ps_flags", 0),
	})
	
	--every menu item NEEDS a stringId for indentification
	if props.stringId == nil
		error("MenuItem missing properties.stringId", 2)
	end
	
	return #ML.menus
end