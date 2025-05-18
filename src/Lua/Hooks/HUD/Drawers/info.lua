local TR = TICRATE

-- https://stackoverflow.com/questions/10989788/format-integer-in-lua
local function format_int(number)

  local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')

  -- reverse the int-string and append a comma to all blocks of 3 digits
  int = int:reverse():gsub("(%d%d%d)", "%1,")

  -- reverse the int-string back remove an optional comma and put the 
  -- optional minus and fractional part back
  return minus .. int:reverse():gsub("^,", "") .. fraction
end

local function HUD_InfoDrawer(v, stplyr)
	local p = displayplayer
	
	local slidein = MMHUD.xoffset
	
	--Timer
	do
		local x = 5*FU - slidein
		local y = 10*FU
		local flags = V_SNAPTOLEFT|V_SNAPTOTOP
		
		local flash = false
		local timetic = MM_N.time
		timetic = not (MM_N.overtime and not MM_N.showdown) and min(max($,0), MM_N.maxtime)+TICRATE or 0
		timetic = min($,MM_N.maxtime)
		
		local minutes = G_TicsToMinutes(timetic, true)
		local seconds = G_TicsToSeconds(timetic)
		local centi = G_TicsToCentiseconds(timetic)
		
		if minutes < 10 then minutes = "0"..$ end
		if seconds < 10 then seconds = "0"..$ end
		if centi < 10 then centi = "0"..$ end
		
		flash = timetic <= 31*TICRATE or MM_N.showdown
		flash = (flash and ((leveltime%(2*TICRATE)) < 30*TICRATE) and (leveltime/5 & 1))
		
		local finalstring = minutes..":"..seconds .. (CV_MM.debug.value and ("."..centi) or "")
		if (MM_N.showdown)
			finalstring = "SHOWDOWN !!" -- ("..$..")"
		end
		
		if splitscreen and (stplyr and stplyr.valid)
			x = 160*FU - ((v.stringWidth(finalstring,0,"normal") + 15)/2)*FU
			y = 100*FU
			flags = MMHUD.hudtrans
		end
		
		if flags ~= V_100TRANS
			v.drawScaled(x + FU, y + FU,
				FU,
				v.cachePatch("MM_CLOCK2"),
				flags,
				v.getColormap(nil,nil,"MM_HudShadow")
			)
			v.drawScaled(x,y,
				FU,
				v.cachePatch("MM_CLOCK2"),
				flags
			)
			
			v.drawString(x + 15*FU, y,
				finalstring,
				flags|(flash and V_REDMAP or 0),
				"fixed"
			)
		end
	end
	
	--rings
	do
		local x = 6*FU - FU/2
		local y = (splitscreen and 10 or 23)*FU
		local yoff = 0
		local rings = MM:GetPlayerRings(secondarydisplayplayer or p)
		if (MMHUD.info_slideout)
			local ticker = MMHUD.info_ticker
			ticker = min($, 7*TR)
			
			yoff = -12*FU
			if ticker <= 16
				yoff = ease.outback((FU/16)*ticker, 0, $)
			end
			
			slidein = 0
			if ticker >= 5*TR
				slidein = ease.inquad((FU/TR)*(ticker - 5*TR), $, 60*FU)
			end
			
			rings = ($ - p.mm.ringspaid) + MMHUD.info_count
			
			v.drawString(
				x + 14*FU + (v.stringWidth(tostring(rings),0,"normal")*FU) - slidein,
				y + 11*FU + yoff,
				"+"..(p.mm.ringspaid - MMHUD.info_count),
				V_SNAPTOLEFT|V_SNAPTOTOP|V_GREENMAP|V_PERPLAYER,
				"fixed-right"
			)	
		end
		
		local origin_size = FixedDiv(16*FU, v.cachePatch("MMRING").width*FU) -- Scale to 16 pixels
		local origin_scale = FU*3/4
		
		v.drawScaled(x - slidein + FU,
			y + yoff + FU,
			FixedMul(origin_size, origin_scale),
			v.cachePatch("MMRING"),
			V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
			v.getColormap(nil,nil,"MM_HudShadow")
		)
		v.drawScaled(x - slidein,
			y + yoff,
			FixedMul(origin_size, origin_scale),
			v.cachePatch("MMRING"),
			V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER
		)
		
		v.drawString(x + 14*FU - slidein,
			y + FU + yoff,
			format_int(tostring(rings)),
			V_SNAPTOLEFT|V_SNAPTOTOP|V_PERPLAYER,
			"fixed"
		)	
	end

end

return HUD_InfoDrawer,"gameandscores"
