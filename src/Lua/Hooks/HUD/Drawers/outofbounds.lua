local TR = TICRATE
local sglib = MM.require "Libs/sglib"

local function HUD_OOBDrawer(v,p,c)
	if not MM:isMM() then return end
	if not (p.mm) then return end
	
	if MM_N.overtime_point and MM_N.overtime_point.valid
		local point = MM_N.overtime_point
		
		local to_screen = sglib.ObjectTracking(v,p,c,point)
		if to_screen.onScreen
		and p.mm.oob_dist > 2056*FU
		and not P_CheckSight(p.realmo, MM_N.overtime_point)
			--local dist = R_PointToDist2(c.x, c.y, player.mo.x, player.mo.y)
			
			/*
			v.drawScaled(
				to_screen.x,
				to_screen.y - 16*to_screen.scale,
				FU/2,
				v.cachePatch("CHARICO"),
				0
			)
			*/
			
			v.drawString(
				to_screen.x,
				to_screen.y - 24*to_screen.scale,
				"GO HERE",
				V_YELLOWMAP,
				"thin-fixed-center"
			)
		end
		
	end
	
	if not p.mm.outofbounds then return end
	
	v.fadeScreen(
		160 + ( FixedMul(9*FU,FixedDiv(p.mm.oob_ticker,3*TR)) / FU),
		( FixedMul(9*FU,FixedDiv(p.mm.oob_ticker,3*TR)) / FU)
	)
	
	local flash = ((leveltime%(2*TR)) < 30*TR) and (leveltime/5 & 1) and V_REDMAP or 0
	v.drawString(160,160,
		"! OUT OF BOUNDS !",
		flash|V_SNAPTOBOTTOM,
		"center"
	)
	v.drawString(160,168,
		"Return to play area",
		flash|V_SNAPTOBOTTOM,
		"thin-center"
	)
	v.drawScaled(160*FU - (v.cachePatch("STTNUM0").width*FU/2),
		178*FU,
		FU,
		v.cachePatch("STTNUM"..(3*TR - p.mm.oob_ticker)/TR),
		V_SNAPTOBOTTOM
	)	
	
end

return HUD_OOBDrawer