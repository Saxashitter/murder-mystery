return function(v, ML)
	ML.addButton(v, {
		x = 10,
		y = 10,
		
		width = 40,
		height = 10,
		
		name = "Button",
		color = 66,
		outline = 71,
	})

	ML.addButton(v, {
		x = 180,
		y = 100,
		
		width = 100,
		height = 10,
		
		name = "otherButt",
		color = 0,
		
		selected = {
			color = 191,
			nameStyles = {
				align = "center",
				flags = V_ALLOWLOWERCASE|V_INVERTMAP
			},
		}
	})

	ML.addButton(v, {
		x = 0,
		y = 170,
		
		width = 30,
		height = 30,
		
		name = "boob",
		nameStyles = {
			align = "center",
			flags = V_ALLOWLOWERCASE|V_YELLOWMAP
		},
		color = 252,
	})
end