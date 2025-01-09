local function HUD_HPDrawer(v,p)
	local x = 5*FU - MMHUD.xoffset
	local y = 170*FU
	
	if (p.spectator) then return end
	
	v.drawString(x,y,"HP: "..p.mm.hp.."/"..MM_PLAYER_HPMAX,
		V_SNAPTOLEFT|V_SNAPTOBOTTOM,
		"thin-fixed"
	)
end

return HUD_HPDrawer