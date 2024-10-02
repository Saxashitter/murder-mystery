local roles = MM.require "Variables/Data/Roles"

local function HUD_TimeForWeapon(v,p)
	if not MM:isMM() then return end
	if not (p.mo and p.mo.health and p.mm) then return end
	if MM_N.waiting_for_players then
		local xoffset = MMHUD.xoffset
		if leveltime >= 5*TICRATE
			xoffset = 0
		end
		
		v.drawString(160*FU,
			40*FU - xoffset,
			"Waiting for players...",
			V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"fixed-center"
		)
		return
	end
	if leveltime >= 10*TICRATE then return end

	local time = (10*TICRATE)-leveltime

	v.drawString(160*FU,
		40*FU - MMHUD.xoffset,
		roles[p.mm.role].weapon and "You'll get your weapon in" or
		"Round starts in",
		V_SNAPTOTOP|V_ALLOWLOWERCASE,
		roles[p.mm.role].weapon and "thin-fixed-center" or "fixed-center"
	)
	v.drawScaled(160*FU - (v.cachePatch("STTNUM0").width*FU/2),
		50*FU - MMHUD.xoffset,
		FU,
		v.cachePatch("STTNUM"..(time/TICRATE)),
		V_SNAPTOTOP
	)	
end

return HUD_TimeForWeapon