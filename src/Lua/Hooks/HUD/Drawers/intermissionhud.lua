local int_ease = MM.require "Libs/int_ease"
local MAX_FADE = 20

local VWarp = MM.require "Libs/vwarp"

local function return_settings(v, theme, transition)
	local settings = {}

	if theme.start_transparent
	and not transition then
		local tics = MM_N.end_ticker
		local t = FixedDiv(min(tics, MAX_FADE), MAX_FADE)
		local trans = ease.linear(t, 10, 0)

		if not (tics) then return false end
		if trans == 10 << V_ALPHASHIFT then return false end

		settings.transp = trans
	end

	if theme.stretch then
		local sw = v.width()/v.dupx()
		local sh = v.height()/v.dupy()
		settings.xscale = FixedDiv(sw, 320)
		settings.yscale = FixedDiv(sh, 200)
		settings.xorigin = -(sw-320)*FU/2
	end

	return settings
end

local function draw_hud(v)
	// DEFINITION

	if MM_N.end_ticker == nil then return end

	local tics = MM_N.end_ticker
	local tics_after = max(0, MM_N.end_ticker-MAX_FADE)

	// DRAW THEME

	local theme = MM.themes[MM_N.theme or "srb2"]

	local t = FixedDiv(min(tics, MAX_FADE), MAX_FADE)
	local trans = ease.linear(t, 10, 0)

	local settings = return_settings(v, theme)
	if settings == false then return end

	theme.draw(VWarp(v, settings), tics)

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
				skin = p.skin,
				rings = p.rings
			})
		end

		local scale = FU*5/4

		local total_width = (icon_width*(#icons-1))
		local x = ( 160*FU ) - ( total_width*scale/2 )
		local y = ( (200-24)*FU )

		for k,icon in pairs(icons) do
			local myscale = FixedMul(scale,skins[icon.skin].highresscale or FU)
			v.drawScaled(x, y, myscale, icon.patch, trans|V_SNAPTOBOTTOM, icon.color)
			x = $+(icon_width*scale)
		end
	end

	// MAPS
	if MM_N.mapVote.state == "voting" then
		local p = consoleplayer
		if p and p.mm and p.mm.cur_map
		and not (p.mm_save.afkmode) then
			local arrow = ("\x1d\x1a\x1c\x1b"):sub(p.mm.cur_map, p.mm.cur_map)
			local color = V_YELLOWMAP
			if p.mm.selected_map then
				color = V_GREENMAP
			end
			v.drawString(
				160, 90, arrow, color|trans, "center"
			)
		end

		local scale = FU/4
		for k,map in ipairs(MM_N.mapVote.maps) do

			local mapIcon = v.cachePatch(G_BuildMapName(map.map).."P")
			local iconWidth = 160*scale
			-- width = $+(offset*(maxMaps-1))

			local ang = k*ANGLE_90

			local x = 160*FU
			x = $ - (iconWidth/2)
			x = $ + FixedMul(320*sin(ang), scale)
			-- x = $ + (offset*(k-1))
			-- x = $ + (iconWidth*(k-1))

			local y = 92*FU
			y = $ + FixedMul(160*cos(ang), scale)
			y = $ - (100*scale/2)

			v.drawScaled(x, y, scale, mapIcon, trans)
			
			local color = 0
			local outline = "INACTIVE"
			if (p and p.mm and p.mm.cur_map == k) then
				outline = "ACTIVE"
				if not (p.mm.selected_map) then
					color = V_YELLOWMAP
				else
					color = V_GREENMAP
					outline = "VOTED"
					v.drawScaled(x, y, scale,
						mapIcon, trans|V_ADD,
						v.getColormap(TC_RAINBOW,SKINCOLOR_GREEN)
					)
				end
			end

			v.drawScaled(x, y, scale*2, v.cachePatch("MM_MAPVOTE_OUTLINE_" .. outline), trans)
			v.drawString(x+(iconWidth/2),
				y+((mapIcon.height+4)*scale),
				G_BuildMapTitle(map.map),
				V_ALLOWLOWERCASE|color|trans,
				"thin-fixed-center")
			
			
			-- v.drawString(x+(iconWidth/2),
			-- 	y+(mapIcon.height*scale)+(8*FU),
			-- 	tostring(map.votes),
			-- 	V_ALLOWLOWERCASE|color|trans,
			-- 	"thin-fixed-center")
		end
	elseif MM_N.mapVote.state == "rolling" then
		local scale = FU/4
		local iconWidth = 160*scale
		local tickerWidth = 170*scale
		local min_ind = MM_N.mapVote.rollx/FU - 8
		local max_ind = MM_N.mapVote.rollx/FU + 8
		for k=min_ind,max_ind do
			local map = MM_N.mapVote.pool[((k-1+#MM_N.mapVote.pool*5) % #MM_N.mapVote.pool)+1]
			local mapIcon = v.cachePatch(G_BuildMapName(map).."P")

			local x = 160*FU
			x = $ - (iconWidth/2)
			x = $ + tickerWidth*(k-1)
			x = $ - FixedMul(MM_N.mapVote.rollx, tickerWidth)
			-- x = $ + (iconWidth*(k-1))

			local y = 92*FU
			y = $ - (100*scale/2)

			local outline = "INACTIVE"
			if (FixedFloor(MM_N.mapVote.rollx+FU/2)/FU+1 == k) then
				outline = "ACTIVE"
			end

			v.drawScaled(x, y, scale, mapIcon, trans)
			v.drawScaled(x, y, scale*2, v.cachePatch("MM_MAPVOTE_OUTLINE_" .. outline), trans)
		end
	elseif MM_N.mapVote.state == "done" then
		local scale = FU/2
		local map = MM_N.mapVote.selected_map
		local x = 160*FU
		x = $ - (80/2)*FU

		local y = 100*FU
		y = $ - (100*scale/2)
		v.drawScaled(x, y, scale, v.cachePatch(G_BuildMapName(map).."P"), trans)
		local wintext = "WINNER"
		if MM_N.mapVote.unanimous then
			wintext = "UNANIMOUS WINNER"
		end
		v.drawString(x+(FU*80/2),
			y-(18*scale),
			wintext,
			V_ALLOWLOWERCASE|trans,
			"fixed-center")
		v.drawString(x+(FU*80/2),
			y+(104*scale),
			G_BuildMapTitle(map),
			V_ALLOWLOWERCASE|trans,
			"fixed-center")
	end

	// START IN
	v.drawString(160, 200-20, "JOIN US AT https://discord.gg/PxT4XKhZxd", V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_REDMAP|trans, "center")
	if MM_N.mapVote then
		local time = (MM_N.mapVote.ticker-1)/TICRATE+1
		local prefix = ""
		if MM_N.mapVote.state == "voting" then
			prefix = "VOTING ENDS IN "
		elseif MM_N.mapVote.state == "done" then
			prefix = "STARTING IN "
		end
		
		if #prefix then
			v.drawString(160, 200-10, prefix..tostring(time).." SECONDS", V_SNAPTOBOTTOM|V_YELLOWMAP|trans, "center")
		end
	end
end

return function(v)
	if not MM_N.voting
	and not MM_N.transition then return end

	local theme = MM.themes[MM_N.theme or "srb2"]

	if MM_N.voting then
		draw_hud(v)
	end

	local settings = return_settings(v, theme, true)
	if settings == false then return end

	if theme.transitiondraw then
		// DRAW TRANSITION OVER EVERYTHING
		theme.transitiondraw(VWarp(v, settings), MM_N.transition_time)
	end
end,"gameandscores"