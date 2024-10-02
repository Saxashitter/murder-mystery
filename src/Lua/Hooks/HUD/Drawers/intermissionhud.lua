local int_ease = MM.require "Libs/int_ease"

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
	if not MM_N.voting then return end
	if MM_N.end_ticker == nil then return end

	// DEFINITION

	local tics = MM_N.end_ticker
	local tics_after = max(0, MM_N.end_ticker-MAX_FADE)

	// PARALLAX

	local patch = v.cachePatch("SRB2BACK")
	local scale = FU/2

	local scroll = tics*scale

	local t = FixedDiv(min(tics, MAX_FADE), MAX_FADE)
	local trans = ease.linear(t, 10, 0) << V_ALPHASHIFT

	if not (tics) then return end
	if trans == 10 << V_ALPHASHIFT then return end

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

	//// ICONS

	local icon_width = 20

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

		local scale = FU*5/4

		local total_width = (icon_width*(#icons-1))
		local x = ( 160*FU ) - ( total_width*scale/2 )
		local y = ( (200-32)*FU )

		for k,icon in pairs(icons) do
			v.drawScaled(x, y, scale, icon.patch, trans|V_SNAPTOBOTTOM, icon.color)
			x = $+(icon_width*scale)
		end
	end

	// MAPS

	for k,map in ipairs(MM_N.mapVote) do
		local scale = FU/4

		local p = displayplayer

		local maxMaps = #MM_N.mapVote
		local mapIcon = v.cachePatch(G_BuildMapName(map.map).."P")
		local iconWidth = mapIcon.width*scale
		local offset = 60*FU
		local width = iconWidth*maxMaps
		width = $+(offset*(maxMaps-1))

		local x = 160*FU
		x = $ - (width/2)
		x = $ + (offset*(k-1))
		x = $ + (iconWidth*(k-1))

		local y = 100*FU
		y = $ - (mapIcon.height*scale/2)

		local color = 0
		if (p and p.mm and p.mm.cur_map == k) then
			if not (p.mm.selected_map) then
				color = V_YELLOWMAP
			else
				color = V_GREENMAP
			end
		end

		v.drawScaled(x, y, scale, mapIcon, trans)
		v.drawString(x+(iconWidth/2),
			y+(mapIcon.height*scale),
			G_BuildMapTitle(map.map),
			V_ALLOWLOWERCASE|color|trans,
			"thin-fixed-center")
		v.drawString(x+(iconWidth/2),
			y+(mapIcon.height*scale)+(8*FU),
			tostring(map.votes),
			V_ALLOWLOWERCASE|color|trans,
			"thin-fixed-center")
	end

	// START IN

	local time = (15*TICRATE-MM_N.end_ticker)/TICRATE

	v.drawString(160, 200-20, "JOIN US AT https://discord.gg/PxT4XKhZxd", V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_REDMAP|trans, "center")
	v.drawString(160, 200-10, "START IN "..tostring(time).." SECONDS", V_SNAPTOBOTTOM|V_YELLOWMAP|trans, "center")
end,"gameandscores"