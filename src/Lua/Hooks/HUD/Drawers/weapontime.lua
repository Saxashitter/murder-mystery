local function HUD_TimeForWeapon(v,p)
	if not MM:isMM() then return end
	if not (p.mo and p.mo.health and p.mm) then return end
	if MM_N.waiting_for_players then
		v.drawString(160*FU,
			40*FU - MMHUD.xoffset,
			"Waiting for players",
			V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"fixed-center"
		)
		return
	end
	if leveltime >= 10*TICRATE then return end

	local time = (10*TICRATE)-leveltime

	v.drawString(160*FU,
		40*FU - MMHUD.xoffset,
		(p.mm.role == 1) and "Round starts in"
		or "You'll get your weapon in",
		V_SNAPTOTOP|V_ALLOWLOWERCASE,
		(p.mm.role == 1) and "fixed-center" or "thin-fixed-center"
	)
	v.drawScaled(160*FU - (v.cachePatch("STTNUM0").width*FU/2),
		50*FU - MMHUD.xoffset,
		FU,
		v.cachePatch("STTNUM"..(time/TICRATE)),
		V_SNAPTOTOP
	)	
end

return HUD_TimeForWeapon