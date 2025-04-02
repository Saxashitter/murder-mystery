--player tip: you needa kill yourself

MenuLib.addMenu({
	stringId = "Protips",
	title = "Guide",
	
	width = 250,
	height = 130,
	
	drawer = function(v, ML, menu, props)
		MenuLib.interpolate(v, false)
		local x,y = props.corner_x, props.corner_y
		x = $ + 5
		y = $ + 20
		
		v.drawString(160,86,"Please refer to the",V_ALLOWLOWERCASE,"center")
		v.drawString(160,94," Message Board page.",V_ALLOWLOWERCASE,"center")
		
		
		v.drawString(160,105,"<<link>>",V_YELLOWMAP|V_ALLOWLOWERCASE,"center")
	end
})