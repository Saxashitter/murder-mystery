local speedCap = MM.require "Libs/speedCap"

return function(p)
	if p.charability == CA_FLOAT
	or p.charability == CA_THOK
	or p.charability == CA_BOUNCE
	or p.charability == CA_FLY
	or p.charability == CA_GLIDEANDCLIMB then
		p.charability = CA_NONE
	end
	if p.charability2 == CA2_GUNSLINGER then
		p.charability2 = CA2_NONE
	end

	if p.jumpfactor ~= FU then
		p.jumpfactor = FU
	end

	speedCap(p.mo, 28*FU)
	p.runspeed = 9999*FU
end