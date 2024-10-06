return function(self)
	local storm = MM_N.overtime_storm
	
	if not (storm and storm.valid) then
		if not (MM_N.overtime_point) then
			return
		end
		MM_N.overtime_storm = P_SpawnMobj(
			MM_N.overtime_point.x,
			MM_N.overtime_point.y,
			MM_N.overtime_point.z,
			MT_MM_STORMVISUAL)
		storm = MM_N.overtime_storm
	end
	MM_N.overtime_ticker = $+1
	
	local dist = 6000*FU - (MM_N.overtime_ticker*FU*2)
	dist = max($,1028*FU)
	storm.dist = dist

	/*
	print(string.format(
		"radi: %f	circ: %f	i: %f	ii: %d",
		dist/4,
		circ,
		maxiter,
		maxiter/FU
	))
	
	
	local color = P_RandomRange(SKINCOLOR_GALAXY,SKINCOLOR_NOBLE)
	for i = 0,maxiter/FU - 1
		local angle = FixedAngle(leveltime*FU) + FixedAngle(FixedDiv(360*FU,maxiter)*i)
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
			local cz = P_CeilingzAtPos(laser.x,laser.y,laser.ceilingz, 20*FU)
			local fz = laser.z --P_FloorzAtPos(laser.x,laser.y,20*FU)
			laser.spriteyscale = FixedDiv(cz - fz, 20*FU)
		end
	end*/
	
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
		
		local pDist = R_PointToDist2(me.x,me.y, storm.x,storm.y)
		p.mm.oob_dist = pDist
		
		if pDist <= dist
			continue
		end
		
		p.mm.outofbounds = true
		
	end
	
end