local function draw_parallax(v, x, y, scale, patch, flags)
	local width = patch.width
	local height = patch.height

	local screen_width = v.width()/v.dupx()
	local screen_height = v.height()/v.dupy()

	x = $ % (width*scale)
	y = $ % (height*scale)

	x = $-(width*scale)
	y = $-(height*scale)

	local ox = x
	local oy = y

	while y < screen_height*FU do
		while x < screen_width*FU do
			v.drawScaled(x, y, scale, patch, flags)
			x = $+(width*scale)
		end
		x = ox
		y = $+(height*scale)
	end
end

local MAX_FADE = 20

return function(v)
	if not MM.gameover then return end
	if MM.end_ticker == nil then return end

	// DEFINITION

	local tics = MM.end_ticker
	local tics_after = max(0, MM.end_ticker-MAX_FADE)

	// PARALLAX

	local patch = v.cachePatch("SRB2BACK")
	local scale = FU/2

	local scroll = tics*scale

	local t = FixedDiv(min(tics, MAX_FADE), MAX_FADE)
	local trans = V_10TRANS*ease.linear(t, 10, 0)

	if trans == 10 then return end

	draw_parallax(v, scroll, scroll, scale, patch, V_SNAPTOTOP|V_SNAPTOLEFT|trans)

	// RESULTS

	local results = v.cachePatch("RESULT")

	local t = FixedDiv(min(tics_after, TICRATE), TICRATE)
	local x = (160*FU)-(results.width*(FU/2))
	local y = ease.outquad(t, -results.height*FU, 4*FU)

	v.drawScaled(x, y, FU, results, V_SNAPTOTOP)

	// WINNING PLAYERS
	//// TEXT

	local endtype = MM.endType or MM.endTypes[1]

	local y = ease.outcubic(t, -10*(FU*2), 18*FU)

	v.drawString(160*FU, y, endtype.name, V_SNAPTOTOP|endtype.color, "fixed-center")

	local murd_text = "\x85Murderers: \x80"
	for k,p in pairs(MM_N.murderers) do
		if not (p and p.valid) then continue end

		murd_text = $..p.name
		if k ~= #MM_N.murderers then
			murd_text = $..", "
		end
	end

	v.drawString(160*FU, y+(10*FU), murd_text, V_SNAPTOTOP, "thin-fixed-center")

	local icon_width = 48

	if MM_N[endtype.results] then
		local icons = {}
		for _,p in pairs(MM_N[endtype.results]) do
			if not (p and p.valid) then continue end
			local patch = v.getSprite2Patch(p.skin, SPR2_LIFE, false, A, 0)

			table.insert(icons, {
				patch = patch,
				color = v.getColormap(p.skin, p.skincolor),
				name = p.name,
				rings = p.rings
			})
		end

		table.sort(icons, function(one, two)
			return one.rings < two.rings
		end)

		local scale = FU*3/2

		local total_width = (icon_width*(#icons-1))
		local x = ( 160*FU ) - ( total_width*scale/2 )
		local y = ( 100*FU )

		for k,icon in pairs(icons) do
			if k > 3 then break end
			v.drawScaled(x, y, scale, icon.patch, trans, icon.color)

			customhud.CustomFontString(v,
				x, y+(4*scale),
				icon.name,
				"STCFN",
				0,
				"center",
				FU/2)
			customhud.CustomFontString(v,
				x, y+(8*scale),
				tostring(icon.rings).." Rings",
				"STCFN",
				0,
				"center",
				FU/2)

			x = $+(icon_width*scale)
		end
	end
end,"gameandscores"