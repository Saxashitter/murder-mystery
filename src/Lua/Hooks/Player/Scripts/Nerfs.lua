local speedCap = MM.require "Libs/speedCap"

return function(p)
	p.charability = CA_NONE
	p.charability2 = CA2_NONE
	p.jumpfactor = FU

	speedCap(p.mo, MM_N.speed_cap)
	p.normalspeed = MM_N.speed_cap

	p.thrustfactor = 5
	p.accelstart = 250
	p.acceleration = 50

	p.runspeed = 9999*FU

	p.powers[pw_shield] = 0
end