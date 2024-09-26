local sglib = MM.require "Libs/sglib"

return function(v,p,c)
	if not MM_N.showdown then return end

	v.drawString(6, 30, "SHOWDOWN!", V_SNAPTOTOP|V_SNAPTOLEFT|V_REDMAP, "thin")

	if not (p and p.mo and p.mm and p.mm.role == 2) then return end

	for player in players.iterate do
		if not (player and player.mo and player.mo.health and player.mm and player.mm.role ~= 2) then continue end

		local icon = v.getSprite2Patch(player.skin, SPR2_LIFE, false, A, 0)
		local to_screen = sglib.ObjectTracking(v,p,c,player.mo)

		if not to_screen.onScreen then return end

		v.drawScaled(to_screen.x, to_screen.y, FU, icon, nil, v.getColormap(player.skin, player.mo.color))
	end
end