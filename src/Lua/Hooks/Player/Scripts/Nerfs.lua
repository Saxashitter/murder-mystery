local speedCap = MM.require "Libs/speedCap"

return function(p)
	if CV_MM.debug.value then return end
	
	local sonic = skins["sonic"]
	
	p.charflags = $ &~(SF_DASHMODE|SF_RUNONWATER|SF_CANBUSTWALLS)
	p.charability = CA_NONE
	p.charability2 = CA2_NONE
	p.jumpfactor = sonic.jumpfactor

	speedCap(p.mo, FixedMul(MM_N.speed_cap,p.mo.scale))
	p.normalspeed = MM_N.speed_cap
	
	p.thrustfactor = sonic.thrustfactor
	p.accelstart = sonic.accelstart
	p.acceleration = sonic.acceleration
	
	p.runspeed = 9999*FU

	p.powers[pw_shield] = 0
end