local flashtime = 0
local whiteflash = 5

local function HUD_DeathFlash(v, p)
	if splitscreen then return end -- TODO: support later, right now it covers the whole screen

	if (p.playerstate ~= PST_DEAD)
	or (MM_N.gameover)
		flashtime = 0
		return
	end
	
	flashtime = $ + 1
	
	if flashtime < whiteflash
		v.drawFill(nil,nil,nil,nil,0)
	elseif flashtime < 2*TICRATE + whiteflash
		v.fadeScreen(0xFF00,
			32 - FixedMul(32*FU, FixedDiv((flashtime - whiteflash)*FU, 2*TICRATE*FU))/FU
		)
	end
	
end

return HUD_DeathFlash
