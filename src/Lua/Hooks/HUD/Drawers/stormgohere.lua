--i swear we had this before...
local sglib = MM.require "Libs/sglib"

local function HUD_DrawGoHere(v,p,c)
	if not (p.mo and p.mo.valid) then return end
	if (p.spectator) then return end
	if (MM_N.gameover) then return end
	if not (MM_N.overtime or MM_N.showdown) then return end
	
	do
		local dest = MM_N.storm_point
		
		--!!!
		if not (dest and dest.valid) then return end
		if P_CheckSight(p.mo,dest) then return end
		
		local icon = v.cachePatch("MM_SHOWDOWNMARK") --v.getSprite2Patch(player.skin, SPR2_LIFE, false, A, 0)
		local to_screen = sglib.ObjectTracking(v,p,c,dest)

		if not to_screen.onScreen then return end
		
		v.drawScaled(to_screen.x,
			to_screen.y,
			(FU/4), icon,
			0,
			v.getColormap(nil, SKINCOLOR_GALAXY)
		)
		v.drawScaled(to_screen.x,
			to_screen.y - 6*FU,
			(FU/8),
			v.cachePatch("GARGB1"),
			0,
			v.getColormap(TC_RAINBOW, SKINCOLOR_GALAXY)
		)
	end
	
end

return function(v,p,c)
	MMHUD.interpolate(v,true)
	HUD_DrawGoHere(v,p,c)
	MMHUD.interpolate(v,false)
end