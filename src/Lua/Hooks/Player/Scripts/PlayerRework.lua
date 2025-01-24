local speedCap = MM.require "Libs/speedCap"

return function(p)
	if CV_MM.debug.value then return end
	
	local sonic = skins["sonic"]
	local speedcap = MM_N.speed_cap
	local basespeedmulti = FU
	
	p.charflags = $ &~(SF_DASHMODE|SF_RUNONWATER|SF_CANBUSTWALLS|SF_MACHINE)
	p.charability = CA_NONE
	p.charability2 = CA2_NONE
	p.jumpfactor = sonic.jumpfactor
	
	local effects = p.mm.effects
	
	for i,v in pairs(effects) do
		if v.fuse then
			v.fuse = $ - 1
			
			if MM.player_effects[i] then
				if MM.player_effects[i].thinker then
					MM.player_effects[i].thinker(p)
				end
			end
			
			if v.modifiers then
				local modifiers = v.modifiers
				
				if modifiers.normalspeed_multi then
					basespeedmulti = FixedMul($, modifiers.normalspeed_multi)
				end
			end
			
			if v.fuse <= 0 then
				if MM.player_effects[i].on_end then
					MM.player_effects[i].on_end(p)
				end
				
				effects[i] = nil
			end
		end
	end
	
	speedcap = FixedMul($, basespeedmulti)
	
	if p.powers[pw_carry] ~= CR_ZOOMTUBE
		speedCap(p.mo, FixedMul(speedcap,p.mo.scale))
	end
	
	p.normalspeed = speedcap
	
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