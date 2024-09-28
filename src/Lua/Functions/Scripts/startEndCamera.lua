local function intervalhelper(t, d)
	return (min(t,d)*FU) / (max(d,1))
end

local function interval(t, s, d)
	return intervalhelper(max(t,s) - s, d)
end

local function follow(mobj, mul)
	P_MoveOrigin(mobj,
		mobj.origin[1] + P_ReturnThrustX(nil,mobj.angle,-mobj.lerpradius),
		mobj.origin[2] + P_ReturnThrustY(nil,mobj.angle,-mobj.lerpradius),
		mobj.z
	)
end

return function(self, origin, focusang, finalradius, panduration, panspeed)
	if not (MM_N.end_camera and MM_N.end_camera.valid)
		local angle = AngleFixed(focusang)
		
		MM_N.end_camera = P_SpawnMobjFromMobj(origin,
			P_ReturnThrustX(nil,focusang,-1200*FU),
			P_ReturnThrustY(nil,focusang,-1200*FU),
			origin.height,
			MT_THOK
		)
		MM_N.end_camera.tics = -1
		MM_N.end_camera.fuse = -1
		MM_N.end_camera.flags2 = $|MF2_DONTDRAW
		
		MM_N.end_camera.origin = {origin.x,origin.y,origin.z + origin.height}
		MM_N.end_camera.startradius = {1200*FU,800*FU}
		MM_N.end_camera.endradius = {finalradius, finalradius/2}
		MM_N.end_camera.lerpradius = MM_N.end_camera.startradius[1]
		
		MM_N.end_camera.swirldur = 3*TICRATE
		MM_N.end_camera.startangle = angle + 90*FU
		MM_N.end_camera.endangle = angle + 990*FU --720*FU
		
		MM_N.end_camera.target = origin
		
		MM_N.end_camera.panduration = panduration
		MM_N.end_camera.panspeed = panspeed
		
		MM_N.end_camera.ticker = 0
		MM_N.end_camera.angle = R_PointToAngle2(MM_N.end_camera.x,MM_N.end_camera.y, origin.x,origin.y)
	--Move
	else
		local time = MM_N.end_camera.ticker
		local pan = ease.outquint(
			interval(time, MM_N.end_camera.swirldur, MM_N.end_camera.panduration),
			FU, 0
		)
		
		if time <= MM_N.end_camera.swirldur
			local swirl = intervalhelper(time, MM_N.end_camera.swirldur)
			
			local ang = FixedAngle(swirl < FU/2 and
				ease.inoutquint(swirl, MM_N.end_camera.startangle, MM_N.end_camera.endangle) or
				ease.inoutquad(swirl, MM_N.end_camera.startangle, MM_N.end_camera.endangle)
			)
			local hdist = ease.outquad(swirl, MM_N.end_camera.startradius[1], MM_N.end_camera.endradius[1])
			
			/*
			local p = {
				x = MM_N.end_camera.origin[1] - FixedMul(cos(ang), hdist),
				y = MM_N.end_camera.origin[2] - FixedMul(sin(ang), hdist),
				z = MM_N.end_camera.origin[3] + ease.outquad(swirl, MM_N.end_camera.startradius[2], MM_N.end_camera.endradius[2])
			}
			*/
			
			MM_N.end_camera.lerpradius = hdist
			
			MM_N.end_camera.angle = ang - ANGLE_90
			MM_N.end_camera.ticker = $+1
		end
		follow(MM_N.end_camera, FixedMul(pan, MM_N.end_camera.panspeed))
		
	end
	
	for p in players.iterate
		p.awayviewmobj = MM_N.end_camera
		p.awayviewtics = 10*TICRATE
	end
end