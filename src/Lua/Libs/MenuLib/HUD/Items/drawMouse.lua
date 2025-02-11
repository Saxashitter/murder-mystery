return function(v, ML)
	v.drawScaled(
		ML.client.mouse_x,
		ML.client.mouse_y,
		FU/4,
		v.cachePatch("MM_RBLX_CURS"),
		0
	)
end, nil, true