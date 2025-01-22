local function R_GetScreenCoords(v, p, c, mx, my, mz)
	
	local camx, camy, camz, camangle, camaiming
	if p.awayviewtics then
		camx = p.awayviewmobj.x
		camy = p.awayviewmobj.y
		camz = p.awayviewmobj.z
		camangle = p.awayviewmobj.angle
		camaiming = p.awayviewaiming
	elseif c.chase then
		camx = c.x
		camy = c.y
		camz = c.z
		camangle = c.angle
		camaiming = c.aiming
	else
		camx = p.mo.x
		camy = p.mo.y
		camz = p.viewz-20*FRACUNIT
		camangle = p.mo.angle
		camaiming = p.aiming
	end

	-- Lat: I'm actually very lazy so mx can also be a mobj!
	if type(mx) == "userdata" and mx.valid
		my = mx.y
		mz = mx.z
		mx = mx.x	-- life is easier
	end

	local x = camangle-R_PointToAngle2(camx, camy, mx, my)

	local distfact = cos(x)
	if not distfact then
		distfact = 1
	end -- MonsterIestyn, your bloody table fixing...

	if x > ANGLE_90 or x < ANGLE_270 then
		return -320, -100, 0, true	--pass on extra "dontdraw" parameter
	else
		x = FixedMul(tan(x, true), 160<<FRACBITS)+160<<FRACBITS
	end
	
	local pointtodist = R_PointToDist2(camx, camy, mx, my)
	if not pointtodist then
		pointtodist = 1
	end
	
	
	local y = camz-mz
	if y == 0
	or pointtodist == 0
	or distfact == 0
	or (FixedMul(distfact, pointtodist) == 0)
		return -320, -100, 0, true
	end
	
	--print(y/FRACUNIT)
	y = FixedDiv(y, FixedMul(distfact, pointtodist))
	y = (y*160)+(100<<FRACBITS)
	y = y+tan(camaiming, true)*160
 
	local scale = FixedDiv(160*FRACUNIT, FixedMul(distfact, pointtodist))
	--print(scale)

	return x, y, scale
end

local function interpolate(v,set)
	if v.interpolate ~= nil then v.interpolate(set) end
end
local cv_fov = CV_FindVar("fov")

addHook("HUD", function(v,p,cam)
	if not (MM:isMM()) then return end
	if not (p.mm) then return end
	if not (p.mm_save) then return end
	if (p.spectator) then return end
	if (MM_N.gameover) then return end
	
	if (p.mm.role ~= MMROLE_MURDERER) then return end
	
	if (p.mm_save.pri_perk ~= MMPERK_XRAY
	and p.mm_save.sec_perk ~= MMPERK_XRAY)
		return
	end
	
	local me = p.mo
	local maxdist = 10240*me.scale
	if p.mm_save.sec_perk == MMPERK_XRAY
		maxdist = $/3
	end
	
	local cutoff = function(y) return false end
	if splitscreen
		if p == secondarydisplayplayer
			cutoff = function(y,patch,scale) return y < (patch.height*scale >> 1) end
		else
			cutoff = function(y,patch,scale) return y > 200*FRACUNIT + (patch.height*scale >> 1) end
		end
	end
	
	for play in players.iterate()
		if not (play.mm) then continue end
		if not (play.mm_save) then continue end
		if (play.spectator) then continue end
		if not (play.mo and play.mo.valid) then continue end
		if not (play.mo.health) then continue end
		if (play.mm.role == MMROLE_MURDERER) then continue end
		
		if (P_CheckSight(me, play.mo)) then continue end
		if (R_PointToDist(play.mo.x,play.mo.y) > maxdist) then continue end
		
		do
			local adiff = FixedAngle(
				AngleFixed(R_PointToAngle(play.mo.x, play.mo.y) - cam.angle)
			)
			if AngleFixed(adiff) > 180*FU
				adiff = InvAngle($)
			end
			if (AngleFixed(adiff) > cv_fov.value)
				continue
			end
		end
		
		local x, y, scale, nodraw
		local flip = 1
		
		do --if cam.chase and not (p.awayviewtics)
			x, y, scale, nodraw = R_GetScreenCoords(v, p, cam, play.mo)
			if nodraw then continue end
			
			scale = $*2
			if me.eflags & MFE_VERTICALFLIP
			and p.pflags & PF_FLIPCAM
				y = 200*FRACUNIT - $
			else
				flip = P_MobjFlip(me)
			end
			scale = FixedMul($,me.scale)
		end
		scale = FixedDiv($,2*FU)
		scale = abs($)
		
		local facingang = R_PointToAngle(play.mo.x, play.mo.y) - play.drawangle
		local patch,flip = v.getSprite2Patch(play.skin,
			play.mo.sprite2,
			false,
			play.mo.frame,
			((facingang + ANGLE_202h)>>29) + 1,
			play.mo.rollangle
		)
		
		if cutoff(y,patch,scale) then continue end
		
		interpolate(v,#play)
		v.drawScaled(x,y,scale,
			patch,
			(flip and V_FLIP or 0),
			v.getColormap(TC_BLINK,play.skincolor)
		)
		interpolate(v,false)
		
	end
	interpolate(v,false)
	
end,"game")