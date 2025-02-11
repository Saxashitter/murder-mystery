return function(v, ML)
	v.drawScaled(
		ML.client.mouse_x,
		ML.client.mouse_y,
		FU*2,
		v.cachePatch("CROSHAI2"),
		0
	)
end, nil, true