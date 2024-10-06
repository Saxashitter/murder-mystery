freeslot("SPR_BGLS")

return function(self)
	local point = MM_N.overtime_point
	
	if not (point and point.valid)
		MM_N.overtime_ticker = 0
		return
	end
	MM_N.overtime_ticker = $+1
	
	local dist = MM_N.overtime_startingdist - (MM_N.overtime_ticker*FU*2)
	dist = max($,1028*FU)
	
	local pi = (22*FU/7)
	local circ = FixedMul(2*pi, dist/6)
	local maxiter = FixedDiv(circ, 80*FU + 20*FU)
	
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
	*/
	
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
			local cz = laser.subsector.sector and laser.subsector.sector.ceilingheight or P_CeilingzAtPos(laser.x,laser.y,laser.ceilingz, 20*FU)
			local fz = laser.z --P_FloorzAtPos(laser.x,laser.y,20*FU)
			laser.spriteyscale = FixedDiv(cz - fz, 20*FU)
		end
	end
	
	if MM_N.gameover then return end
	
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
		
		p.mm.outofbounds = true
		
	end
	
end