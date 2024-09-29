local function HUD_InfoDrawer(v)
	
	local p = displayplayer
	local slidein = MMHUD.xoffset
	
	--Timer
	do
		local timetic = MM_N.time
		timetic = min(max($,0), MM_N.maxtime)
		
		local minutes = G_TicsToMinutes(timetic, true)
		local seconds = G_TicsToSeconds(timetic)
		
		if minutes < 10 then minutes = "0"..$ end
		if seconds < 10 then seconds = "0"..$ end
		
		v.drawScaled(5*FU - slidein,
			10*FU,
			FU,
			v.cachePatch("NGRTIMER"),
			V_SNAPTOLEFT|V_SNAPTOTOP
		)
		v.drawString(20*FU - slidein,
			10*FU,
			minutes..":"..seconds, --.."."..tictrn,
			V_SNAPTOLEFT|V_SNAPTOTOP,
			"fixed"
		)
	end
	
	--rings?
	do
		v.drawScaled(6*FU - slidein,
			20*FU,
			FU*3/4,
			v.cachePatch("NRNG1"),
			V_SNAPTOLEFT|V_SNAPTOTOP
		)
		v.drawString(20*FU - slidein,
			20*FU,
			p.rings,
			V_SNAPTOLEFT|V_SNAPTOTOP,
			"fixed"
		)	
	end
end

return HUD_InfoDrawer,"gameandscores"