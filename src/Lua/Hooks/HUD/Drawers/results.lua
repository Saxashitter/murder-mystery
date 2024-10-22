local function returnDiv(tics, time)
	return max(0, min(FixedDiv(tics, time), FU))
end

return function(v, p)
	if not (MM_N.results_ticker) then return end

	local tics = MM_N.results_ticker
	local sw = v.width()/v.dupx()

	local ft = "You survived!"
	if not (p and p.mm and not p.mm.spectator) then
		ft = "You died..."
	end
	if (p and p.mm and p.mm.joinedmidgame) then
		ft = "You joined during a game!"
	end

	local ft_w = v.levelTitleWidth(ft)

	local ft_t = returnDiv(tics, TICRATE)
	local ft_x = ease.outback(ft_t, -ft_w, (sw/2)-(ft_w/2), sw)
	local ft_y = 100

	v.drawLevelTitle(ft_x, ft_y, ft, V_SNAPTOLEFT)
	v.drawString(160, 100+v.levelTitleHeight(ft), "W.I.P, Stats soon", V_SNAPTOBOTTOM, "center")
end