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
		
		v.drawString(160,100,"git gud",V_ALLOWLOWERCASE,"center")
	end
})