local ML = MenuLib
ML.menus = {}

return function(props)
	table.insert(ML.menus, {
		title = props.title or "Menu",
		
		width = props.width or 300,
		height = props.height or 170,
		color = props.color or 27,
		outline = props.outline,
		
		drawer = props.drawer,
		thinker = props.thinker,
		
		stringId = props.stringId,
		
		--the rest are popup only
		x = props.x or BASEVIDWIDTH/2,
		y = props.y or BASEVIDHEIGHT/2,
	})
	
	--every menu item NEEDS a stringId for indentification
	if props.stringId == nil
		error("MenuItem missing props.stringId", 2)
	end
	
	return #ML.menus
end