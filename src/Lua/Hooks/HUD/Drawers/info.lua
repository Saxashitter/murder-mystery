local TR = TICRATE

local function HUD_InfoDrawer(v)
	local p = displayplayer
	local slidein = MMHUD.xoffset
	
	--Timer
	do
		local flash = false
		local timetic = MM_N.time
		timetic = not (MM_N.overtime and not MM_N.showdown) and min(max($,0), MM_N.maxtime)+TICRATE or 0
		timetic = min($,MM_N.maxtime)
		
		local minutes = G_TicsToMinutes(timetic, true)
		local seconds = G_TicsToSeconds(timetic)
		
		if minutes < 10 then minutes = "0"..$ end
		if seconds < 10 then seconds = "0"..$ end
		
		flash = timetic <= 31*TICRATE or MM_N.showdown
		flash = (flash and ((leveltime%(2*TICRATE)) < 30*TICRATE) and (leveltime/5 & 1))
		
		local finalstring = minutes..":"..seconds
		if (MM_N.showdown)
			finalstring = "SHOWDOWN !!" -- ("..$..")"
		end
		
		v.drawScaled(5*FU - slidein,
			10*FU,
			FU,
			v.cachePatch("NGRTIMER"),
			V_SNAPTOLEFT|V_SNAPTOTOP
		)
		v.drawString(20*FU - slidein,
			10*FU,
			finalstring, --.."."..tictrn,
			V_SNAPTOLEFT|V_SNAPTOTOP|(flash and V_REDMAP or 0),
			"fixed"
		)
	end
	
	--rings
	do
		local yoff = 0
		local rings = MM:GetPlayerRings(p)
		if (MMHUD.info_slideout)
			local ticker = MMHUD.info_ticker
			
			yoff = -12*FU
			if ticker <= 16
				yoff = ease.outback((FU/16)*ticker, 0, $)
			end
			
			slidein = 0
			if ticker >= 5*TR
				slidein = ease.inquad((FU/TR)*(ticker - 5*TR), $, 60*FU)
			end
			
			rings = ($ - p.mm.ringspaid) + MMHUD.info_count
			
			v.drawString(20*FU - slidein + (v.stringWidth(tostring(rings),0,"normal")*FU),
				32*FU + yoff,
				"+"..(p.mm.ringspaid - MMHUD.info_count),
				V_SNAPTOLEFT|V_SNAPTOTOP|V_GREENMAP,
				"fixed-right"
			)	
		end
		
		v.drawScaled(6*FU - slidein,
			21*FU + yoff,
			FU*3/4,
			v.cachePatch("NRNG1"),
			V_SNAPTOLEFT|V_SNAPTOTOP
		)
		v.drawString(20*FU - slidein,
			22*FU + yoff,
			rings,
			V_SNAPTOLEFT|V_SNAPTOTOP,
			"fixed"
		)	
	end

end

return HUD_InfoDrawer,"gameandscores"