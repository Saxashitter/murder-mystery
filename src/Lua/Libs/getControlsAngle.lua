return function(p, forwardmove, sidemove)
	local camera_angle = (p.cmd.angleturn<<16)
	local controls_angle = R_PointToAngle2(0,0, forwardmove*FU, -sidemove*FU)

	return camera_angle+controls_angle
end