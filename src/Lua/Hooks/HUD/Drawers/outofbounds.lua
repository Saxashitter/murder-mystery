local TR = TICRATE
local sglib = MM.require "Libs/sglib"

local function HUD_OOBDrawer(v,p,c)
	if not MM:isMM() then return end
	if not (p.mm) then return end
	
	if not p.mm.outofbounds then return end
	
	v.fadeScreen(
		160 + ( FixedMul(9*FU,FixedDiv(p.mm.oob_ticker,MM_PLAYER_STORMMAX)) / FU),
		( FixedMul(9*FU,FixedDiv(p.mm.oob_ticker,MM_PLAYER_STORMMAX)) / FU)
	)
	
	local flash = ((leveltime%(2*TR)) < 30*TR) and (leveltime/5 & 1) and V_REDMAP or 0
	local y = 120
	v.drawString(160,y,
		"! OUT OF BOUNDS !",
		flash|V_SNAPTOBOTTOM,
		"center"
	)
	v.drawString(160,y+8,
		"Return to play area",
		flash|V_SNAPTOBOTTOM,
		"thin-center"
	)
	v.drawScaled(160*FU - (v.cachePatch("STTNUM0").width*FU/2),
		(y + 18)*FU,
		FU,
		v.cachePatch("STTNUM"..(MM_PLAYER_STORMMAX - p.mm.oob_ticker)/TR),
		V_SNAPTOBOTTOM,
		flash and v.getColormap(TC_RAINBOW,SKINCOLOR_RED) or nil
	)	
	
end

return HUD_OOBDrawer