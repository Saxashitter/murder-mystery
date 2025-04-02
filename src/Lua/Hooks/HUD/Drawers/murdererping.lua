local sglib = MM.require "Libs/sglib"
local int_ease = MM.require "Libs/int_ease"

return function(v,p,c)
	if not (p and p.mo) then return end

	for k,pos in pairs(MM_N.ping_positions) do
		local thok_sprite = v.getSpritePatch(SPR_THOK, A, 0)
		local to_screen = sglib.ObjectTracking(v, p, c, pos)

		if not to_screen.onScreen then continue end

		local trans = V_10TRANS*int_ease(FixedDiv(pos.time, pos.maxtime), 10, 4)
		if trans == 10 then return end

        MMHUD.interpolate(v,k)
		v.drawScaled(to_screen.x, to_screen.y, to_screen.scale, thok_sprite, trans, v.getColormap(nil, SKINCOLOR_RED))
        MMHUD.interpolate(v,false)
    end
    MMHUD.interpolate(v,false)
end