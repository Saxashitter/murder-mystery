return function(v, ML)
	v.drawScaled(
		ML.client.mouse_x,
		ML.client.mouse_y,
		FU/4,
		v.cachePatch(ML.client.canPressSomething and "ML_RBLX_POINT" or "ML_RBLX_CURS"),
		0
	)
end, nil, true