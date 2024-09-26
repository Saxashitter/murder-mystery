local sglib = MM.require "Libs/sglib"

return function(v,p,c)
	if not (p and p.mo) then return end

	for k,pos in pairs(MM_N.ping_positions) do
		local thok_sprite = v.getSpritePatch(SPR_THOK, A, 0)
		local to_screen = sglib.ObjectTracking(v, p, c, pos)

		if not to_screen.onScreen then continue end

		local trans = V_10TRANS*ease.linear(FixedDiv(pos.time, pos.maxtime), 9, 4)

		v.drawScaled(to_screen.x, to_screen.y, to_screen.scale, thok_sprite, trans, v.getColormap(nil, SKINCOLOR_RED))
	end
end