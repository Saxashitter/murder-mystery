local function HUD_Tooltips(v)
	local x = 5*FU
	local y = 162*FU
	v.drawString(
		x,y,
		"Controls",
		V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_YELLOWMAP,
		"thin-fixed"
	)
	y = $+8*FU

	v.drawString(
		x,y,
		"[C1] - Equip/Unequip Items",
		V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
		"thin-fixed"
	)
	y = $+8*FU
	
	v.drawString(x,y,
		"[C2] - Drop weapon",
		V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
		"thin-fixed"
	)
	y = $+8*FU
	
	v.drawString(x,y,
		"[FIRE] - Use weapon",
		V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
		"thin-fixed"
	)
end

return HUD_Tooltips, "scores"