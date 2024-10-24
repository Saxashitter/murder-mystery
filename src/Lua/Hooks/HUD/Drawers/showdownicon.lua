local sglib = MM.require "Libs/sglib"
local int_ease = MM.require "Libs/int_ease"

return function(v,p,c)
	if not MM_N.showdown then
		return
	end
	
	/*
	v.drawString(6*FU - MMHUD.xoffset,
		35*FU,
		"SHOWDOWN!",
		V_SNAPTOTOP|V_SNAPTOLEFT|V_REDMAP,
		"thin-fixed"
	)
	*/
	
	if not (p and p.mm and p.mm.role) then return end

	if p.mm.role == MMROLE_MURDERER then
		for player in players.iterate do
			if not (player and player.mo and player.mo.health and player.mm and player.mm.role ~= MMROLE_MURDERER) then continue end

			local icon = v.getSprite2Patch(player.skin, SPR2_LIFE, false, A, 0)
			local to_screen = sglib.ObjectTracking(v,p,c,player.mo)

			if not to_screen.onScreen then continue end

			local dist = R_PointToDist2(c.x, c.y, player.mo.x, player.mo.y)
			local t = max(0, min(FixedDiv(dist, 1500*FU), FU))
			local trans = int_ease(t, 10, 0)

			if trans == 10 << V_ALPHASHIFT then continue end
			v.drawScaled(to_screen.x, to_screen.y, (FU/2)*3/2, icon, (trans*V_10TRANS), v.getColormap(player.skin, player.mo.color))
		end
		return
	end

	// TODO: make marker towards shotgun if dropped
	/* local icon = v.getSprite2Patch(player.skin, SPR2_LIFE, false, A, 0)
	local to_screen = sglib.ObjectTracking(v,p,c,player.mo)

	if not to_screen.onScreen then continue end

	local dist = R_PointToDist2(c.x, c.y, player.mo.x, player.mo.y)
	local t = max(0, min(FixedDiv(dist, 1500*FU), FU))
	local trans = int_ease(t, 10, 0) */
end