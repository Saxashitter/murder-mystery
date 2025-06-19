return function(v,p)
	if not MM:isMM() then return end
	if MM_N.waiting_for_players then return end
	if leveltime >= MM_N.pregame_time + 20 then return end
	
	local x = 5*FU - MMHUD.weaponslidein
	local y = 100*FU
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_PERPLAYER|V_YELLOWMAP
	
	v.drawString(
		x,y,
		"[WEAPON 5] - Open Menu",
		flags,
		"thin-fixed"
	)
	y = $+8*FU
end