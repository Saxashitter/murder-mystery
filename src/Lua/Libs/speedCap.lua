local function L_DoBrakes(mo,factor)
	mo.momx = FixedMul($,factor)
	mo.momy = FixedMul($,factor)
	// mo.momz = FixedMul($,factor)
end

return function(mo,limit,factor)
	local spd = FixedHypot(mo.momx, mo.momy)
	local ang = R_PointToAngle2(0,0,mo.momx,mo.momy)

	if spd > limit
		if factor == nil
			factor = FixedDiv(limit,spd)
		end
		L_DoBrakes(mo,factor)
		return factor
	end
end