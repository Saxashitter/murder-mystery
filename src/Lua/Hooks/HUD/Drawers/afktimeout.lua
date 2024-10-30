local TR = TICRATE
local AFK_TIMEOUT = 60*TR

local function HUD_AFKDrawer(v,p,c)
	if not MM:isMM() then return end
	if not (p.mm) then return end
	
	if p.mm.afktimer < AFK_TIMEOUT - (10*TR)+1 then return end
	--if p.mm.afkhelpers.timeuntilreset ~= 2*TR then return end
	
	local flash = ((leveltime%(2*TR)) < 30*TR) and (leveltime/5 & 1) and V_REDMAP or 0
	local y = 120
	if p.mm.outofbounds then y = $ + 30 end
	
	v.drawString(160,y,
		"! YOU WILL BE KICKED !",
		flash|V_SNAPTOBOTTOM,
		"center"
	)
	v.drawString(160,y+8,
		"FOR BEING AFK",
		flash|V_SNAPTOBOTTOM,
		"thin-center"
	)
	v.drawScaled(160*FU - (v.cachePatch("STTNUM0").width*FU/2),
		(y + 18)*FU,
		FU,
		v.cachePatch("STTNUM"..(AFK_TIMEOUT - p.mm.afktimer)/TR),
		V_SNAPTOBOTTOM,
		flash and v.getColormap(TC_RAINBOW,SKINCOLOR_RED) or nil
	)	
	
end

return HUD_AFKDrawer