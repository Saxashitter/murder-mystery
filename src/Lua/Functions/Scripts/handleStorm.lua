freeslot("SPR_BGLS")

local numtotrans = {
	[9] = FF_TRANS90,
	[8] = FF_TRANS80,
	[7] = FF_TRANS70,
	[6] = FF_TRANS60,
	[5] = FF_TRANS50,
	[4] = FF_TRANS40,
	[3] = FF_TRANS30,
	[2] = FF_TRANS20,
	[1] = FF_TRANS10,
	[0] = 0,
}

local function onPoint(point1,point2)
	/*
	print(string.format(
		"onPoint(): x1 = %f y1 = %f, x2 = %f y2 = %f",
		FixedFloor(point1.x),FixedFloor(point1.y),
		FixedFloor(point2.x),FixedFloor(point2.y)
		)
	)
	*/
	local x1,y1 = FixedFloor(point1.x),FixedFloor(point1.y)
	local x2,y2 = FixedFloor(point2.x),FixedFloor(point2.y)
	return (x1 >= x2 - FU and x1 <= x2 + FU) and (y1 >= y2 - FU and y1 <= y2 + FU)
end

return function(self)
	local point = MM_N.storm_point
	
	if CV_MM.debug.value
	and MM_N.storm_startingdist ~= nil
		local dist = MM_N.storm_startingdist
		local pi = (22*FU/7)
		local circ = FixedMul(2*pi, dist/6)
		local maxiter = FixedDiv(circ, 80*FU + 20*FU)
		
		if not (point.debug_lasers)
			point.debug_lasers = {}
			for i = 0,maxiter/FU - 1
				local angle = FixedAngle(leveltime*FU) + FixedAngle(FixedDiv(360*FU,maxiter)*i)
				point.debug_lasers[i] = P_SpawnMobjFromMobj(point,
					P_ReturnThrustX(nil,angle,dist),
					P_ReturnThrustY(nil,angle,dist),
					0,
					MT_THOK
				)
				local laser = point.debug_lasers[i]
				laser.myindex = i
				laser.tics = -1
				laser.fuse = -1
				laser.renderflags = $|RF_PAPERSPRITE|RF_NOCOLORMAPS
				laser.blendmode = AST_ADD
				laser.sprite = SPR_BGLS
				laser.frame = A|FF_FULLBRIGHT
				laser.scale = $*2
			end
		end
		for i = 0, maxiter/FU - 1 --laser in ipairs(point.debug_lasers)
			local laser = point.debug_lasers[i]
			if not (laser and laser.valid)
				table.remove(point.debug_lasers,i)
				continue
			end
			
			local angle = FixedAngle(leveltime*FU) + FixedAngle(FixedDiv(360*FU,maxiter)*i)
			local xthrust = point.x + P_ReturnThrustX(nil,angle,dist)
			local ythrust = point.y + P_ReturnThrustY(nil,angle,dist)
			P_MoveOrigin(laser,
				xthrust,
				ythrust,
				point.z
			)
			laser.z = P_FloorzAtPos(
				xthrust,
				ythrust,
				laser.floorz, 20*FU
			) + FU
			laser.angle = angle + ANGLE_90
			do
				local cz = laser.subsector.sector and laser.subsector.sector.ceilingheight or P_CeilingzAtPos(laser.x,laser.y,laser.ceilingz, 20*FU)
				local fz = laser.z --P_FloorzAtPos(laser.x,laser.y,20*FU)
				laser.spriteyscale = FixedDiv(cz - fz, 10*laser.scale)
			end
			
		end
		
		if not (not MM_N.time
		or MM_N.showdown)
			return
		end
	end
	
	if (leveltime < 10*TICRATE) then return end
	
	if not (point and point.valid)
		MM_N.storm_ticker = 0
		return
	end
	MM_N.storm_ticker = $+1
	if not (MM_N.time)
	and not MM_N.showdown
		MM_N.storm_ticker = $+2
	end
	
	local dist = MM_N.storm_startingdist - (MM_N.storm_ticker*FU*2)
	dist = max($,
		MM_N.storm_usedpoints and MM_N.storm_startingdist/8 or 1028*FU
	)
	
	local pi = (22*FU/7)
	local circ = FixedMul(2*pi, dist/6)
	local maxiter = FixedDiv(circ, 80*FU + 20*FU)
	
	if not (point.lasers)
		point.lasers = {}
		for i = 0,maxiter/FU - 1
			local angle = FixedAngle(leveltime*FU) + FixedAngle(FixedDiv(360*FU,maxiter)*i)
			point.lasers[i] = P_SpawnMobjFromMobj(point,
				P_ReturnThrustX(nil,angle,dist),
				P_ReturnThrustY(nil,angle,dist),
				0,
				MT_THOK
			)
			local laser = point.lasers[i]
			laser.myindex = i
			laser.tics = -1
			laser.fuse = -1
			laser.renderflags = $|RF_PAPERSPRITE|RF_NOCOLORMAPS
			laser.blendmode = AST_ADD
			laser.sprite = SPR_BGLS
			laser.frame = A|FF_FULLBRIGHT
			laser.scale = $*2
		end
		
		point.laser_eye = P_SpawnMobjFromMobj(point,0,0,0,MT_THOK)
		local laser = point.laser_eye
		laser.tics = -1
		laser.fuse = -1
		laser.renderflags = $|RF_NOCOLORMAPS
		laser.sprite = SPR_BGLS
		laser.frame = A|FF_FULLBRIGHT
		laser.scale = $
		
		point.laser_splat = P_SpawnMobjFromMobj(point,0,0,0,MT_THOK)
		local laser = point.laser_splat
		laser.tics = -1
		laser.fuse = -1
		laser.renderflags = $|RF_FLOORSPRITE|RF_NOCOLORMAPS
		laser.sprite = SPR_BGLS
		laser.frame = B|FF_FULLBRIGHT
		laser.scale = $
		
	end
	
	/*
	print(string.format(
		"dist: %f	radi: %f	circ: %f	i: %f	ii: %d	ticker: %d",
		dist,
		dist/4,
		circ,
		maxiter,
		maxiter/FU,
		MM_N.overtime_ticker
	))
	print(#point.lasers)
	*/
	
	local color = P_RandomRange(SKINCOLOR_GALAXY,SKINCOLOR_NOBLE)
	for i,laser in ipairs(point.lasers)
		if not (laser and laser.valid)
			table.remove(point.lasers,i)
			continue
		end
		
		if laser.myindex > maxiter/FU
			laser.destscale = 0
			laser.scalespeed = FixedDiv(laser.scale,TICRATE*FU)
			laser.fuse = TICRATE
			table.remove(point.lasers,laser.myindex)
			--P_RemoveMobj(laser)
			continue
		end
		
		local angle = FixedAngle(leveltime*FU) + FixedAngle(FixedDiv(360*FU,maxiter)*i)
		local xthrust = point.x + P_ReturnThrustX(nil,angle,dist)
		local ythrust = point.y + P_ReturnThrustY(nil,angle,dist)
		P_MoveOrigin(laser,
			xthrust,
			ythrust,
			point.z
		)
		laser.z = P_FloorzAtPos(
			xthrust,
			ythrust,
			laser.floorz, 20*FU
		) + FU
		laser.angle = angle + ANGLE_90
		laser.color = color
		do
			local cz = laser.subsector.sector and laser.subsector.sector.ceilingheight or P_CeilingzAtPos(laser.x,laser.y,laser.ceilingz, 20*FU)
			local fz = laser.z --P_FloorzAtPos(laser.x,laser.y,20*FU)
			laser.spriteyscale = FixedDiv(cz - fz, 10*laser.scale)
		end
		
	end
	
	--people like to hide behind these so dont let em do that
	local mysin = sin(FixedAngle(MM_N.storm_ticker*5*FU))
	local fade = numtotrans[mysin*6 / FU] or 0
	do
		local laser = point.laser_eye
		do
			local cz = laser.subsector.sector and laser.subsector.sector.ceilingheight or P_CeilingzAtPos(laser.x,laser.y,laser.ceilingz, 20*FU)
			local fz = laser.z --P_FloorzAtPos(laser.x,laser.y,20*FU)
			laser.spriteyscale = FixedDiv(cz - fz, 10*laser.scale)
		end
		laser.spritexscale = FU + mysin/5
		laser.color = SKINCOLOR_GALAXY
		laser.dispoffset = -4
		laser.frame = ($ &~FF_TRANSMASK)|fade
		P_MoveOrigin(laser,
			point.x,
			point.y,
			point.z
		)
	end
	do
		local laser = point.laser_splat
		laser.spritexscale = FU + mysin/5
		laser.spriteyscale = laser.spritexscale
		laser.color = SKINCOLOR_GALAXY
		laser.dispoffset = -5
		laser.frame = ($ &~FF_TRANSMASK)|fade
		P_MoveOrigin(laser,
			point.x,
			point.y,
			point.z
		)
	end
	if (point.garg and point.garg.valid)
		point.garg.spriteyoffset = ease.inoutquad(FU/4,$, 32*FU + (mysin/3)*20)
		P_MoveOrigin(point.garg,
			point.x,
			point.y,
			point.z
		)
		point.garg.angle = point.angle
	else
		local garg = P_SpawnMobjFromMobj(
			point,
			0,0,0,
			MT_GARGOYLE
		)
		garg.flags = MF_NOCLIPTHING
		garg.colorized = true
		garg.color = SKINCOLOR_GALAXY
		garg.scale = $*2
		garg.angle = point.angle
		point.garg = garg
	end
	
	/*
	for i = 0,maxiter/FU - 1
		local laser = P_SpawnMobjFromMobj(point,
			P_ReturnThrustX(nil,angle,dist),
			P_ReturnThrustY(nil,angle,dist),
			0,
			MT_THOK
		)
		laser.z = P_FloorzAtPos(laser.x,laser.y,laser.floorz, 20*FU) + FU
		do
			laser.tics = 1
			laser.fuse = -1
			laser.angle = angle + ANGLE_90
			laser.renderflags = $|RF_PAPERSPRITE|RF_NOCOLORMAPS
			laser.blendmode = AST_ADD
			laser.sprite = SPR_BGLS
			laser.frame = A|FF_FULLBRIGHT
			laser.scale = $*2
			laser.color = color
			P_SetOrigin(laser,laser.x,laser.y,laser.z)
		end
		do
			local cz = laser.subsector.sector and laser.subsector.sector.ceilingheight or P_CeilingzAtPos(laser.x,laser.y,laser.ceilingz, 20*FU)
			local fz = laser.z --P_FloorzAtPos(laser.x,laser.y,20*FU)
			laser.spriteyscale = FixedDiv(cz - fz, 20*FU)
		end
	end
	*/
	
	
	for p in players.iterate
		if not p.mm then continue end
		
		p.mm.outofbounds = false
		p.mm.oob_dist = 0
		
		if p.spectator
		or (p.playerstate ~= PST_LIVE)
			continue
		end
		
		if not (p.mo and p.mo.valid)
			continue
		end
		
		local me = p.mo
		
		local pDist = R_PointToDist2(me.x,me.y, point.x,point.y)
		p.mm.oob_dist = pDist
		
		if pDist <= dist
			continue
		end
		
		--Move this here because otherwise we would never be considered
		--in bounds during the endcam, eventually killing us
		if MM_N.gameover then continue end
		
		p.mm.outofbounds = true
		
	end

	if dist > 1028*FU then return end
	
	if not (point.destpoint)
		point.eased = 0
		point.destpoint = point.otherpoints[P_RandomRange(1,#point.otherpoints)]
		point.startpoint = {
			x = point.x,
			y = point.y,
			z = point.z,
			a = point.angle
		}
	end
	if onPoint(point,point.destpoint)
		repeat
			point.destpoint = point.otherpoints[P_RandomRange(1,#point.otherpoints)]
		until not onPoint(point,point.destpoint)
		point.eased = 0
		point.startpoint = {
			x = point.x,
			y = point.y,
			z = point.z,
			a = point.angle
		}
	end
	
	local nextpoint = point.destpoint
	local easetics = 60*TICRATE
	local frac = (FU/easetics)*point.eased
	local x = ease.inoutquad(frac, point.startpoint.x, nextpoint.x)
	local y = ease.inoutquad(frac, point.startpoint.y, nextpoint.y)
	local z = ease.inoutquad(frac, point.startpoint.z, nextpoint.z)
	P_MoveOrigin(point,
		x,y,z
	)
	point.angle = FixedAngle(
		ease.inoutquad(frac,
			AngleFixed(point.startpoint.a),
			AngleFixed(nextpoint.a)
		)
	)
	point.eased = $+1
		
end