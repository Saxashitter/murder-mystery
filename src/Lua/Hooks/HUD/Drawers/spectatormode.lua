return function(v,p)
	if not (p.mm_save) then return end
	if not (p.mm_save.afkmode) then return end
	if not (p.spectator) then return end
	
	local snap = V_SNAPTOLEFT|V_SNAPTOBOTTOM
	local y = 200 - (8*4)
	v.drawString(0, y,
		"spectator mode",
		snap|V_YELLOWMAP,
		"thin"
	)
	y = $ + 8
	
	v.drawString(0, y,
		"You'll spawn as a spectator",
		snap|V_ALLOWLOWERCASE,
		"thin"
	)
	y = $ + 8
	
	v.drawString(0, y,
		"every round now.",
		snap|V_ALLOWLOWERCASE,
		"thin"
	)
	y = $ + 8

	v.drawString(0, y,
		"\x82[WEAPON 5]\x80 - Open Menu",
		snap|V_ALLOWLOWERCASE,
		"thin"
	)
	y = $ + 8
	
end