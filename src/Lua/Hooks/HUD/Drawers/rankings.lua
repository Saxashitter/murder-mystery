local function HUD_TabScoresDrawer(v)

	local summadat = v.cachePatch("SUMMADAT")

	local w,h = FixedDiv(v.width()/v.dupx(), summadat.width),
		FixedDiv(v.height()/v.dupy(), summadat.height)

	v.drawStretched(0, 0,
		w, h,
		summadat,
		V_SNAPTOTOP|V_SNAPTOLEFT)
end

return HUD_TabScoresDrawer