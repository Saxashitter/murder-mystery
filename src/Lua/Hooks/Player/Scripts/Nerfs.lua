local speedCap = MM.require "Libs/speedCap"

return function(p)
	if CV_MM.debug.value then return end
	
	local sonic = skins["sonic"]
	
	p.charflags = $ &~(SF_DASHMODE|SF_RUNONWATER|SF_CANBUSTWALLS)
	p.charability = CA_NONE
	p.charability2 = CA2_NONE
	p.jumpfactor = sonic.jumpfactor
	
	if p.powers[pw_carry] ~= CR_ZOOMTUBE
		speedCap(p.mo, FixedMul(MM_N.speed_cap,p.mo.scale))
	end
	p.normalspeed = MM_N.speed_cap
	
	p.thrustfactor = sonic.thrustfactor
	p.accelstart = (sonic.accelstart*3)/2 -- Buff start acceleration
	p.acceleration = sonic.acceleration
	
	p.runspeed = 9999*FU
	
	p.rings = 0

	p.powers[pw_shield] = 0
	p.powers[pw_underwater] = 0
	p.powers[pw_spacetime] = 0
	
	if (p.mo.eflags & (MFE_UNDERWATER|MFE_GOOWATER))
		p.accelstart = 3*$/2
		p.acceleration = 3*$/2
		p.normalspeed = $*2
	end
end