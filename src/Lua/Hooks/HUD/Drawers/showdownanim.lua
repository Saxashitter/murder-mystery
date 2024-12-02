MM.showdownSprites = {
	["sonic"] = "MMSD_SONIC";
	["tails"] = "MMSD_TAILS";
	["knuckles"] = "MMSD_KNUCKLES";
	["amy"] = "MMSD_AMY";
	["fang"] = "MMSD_FANG";
	["metalsonic"] = "MMSD_METAL";
	-- you may be asking why im doing this instead of directly getting the XTRAB0 spr2
	-- i wanna plan to add custom sprites for this sometime soon
}

--this is super extra and blocks a lot of vision
local SW_STR = "SHOWDOWN!!"
local SW_SUBSTR = "IT'S A SHOWDOWN! "

local fade = 0
local side_x = -128*(FU*3/2)
local versus_y = -46*(FU*3/4)
local str_y = 200*FU
local substr_y = 200*FU
local letters = {}
local letter_cooldown = 0
local init = false
local swspr = {}

local function init_vars()
	fade = 0
	side_x = -128*(FU*3/2)
	versus_y = -46*(FU*3/4)
	str_y = 200*FU
	substr_y = 200*FU
	letters = {}
	letter_cooldown = 0
	init = false
end

local function return_sw_spr(v, sn)
	if not (MM.showdownSprites[sn]) then
		sn = "sonic"
	end

	if not (swspr[sn]) then
		swspr[sn] = v.cachePatch(MM.showdownSprites[sn])
	end

	return swspr[sn]
end

local function draw_sw_spr(v, x, y, scale, sn, flags, c)
	local patch = return_sw_spr(v, sn)

	flags = flags or 0

	/*if flip then
		x = $-(patch.width*scale)

		if not (flags & V_FLIP) then
			flags = $|V_FLIP
		else
			flags = $ & ~V_FLIP
		end
	end*/

	local color = v.getColormap(sn, c)

	v.drawScaled(x, y, scale, patch, flags, color)

	return patch
end

local FONT = "STCFN"
local function manage_letters(v)
	if #letters >= #SW_STR then return end

	local stri = #letters+1
	local str = string.sub(SW_STR, stri, stri)

	local byte = str:byte()

	letters[stri] = v.cachePatch(string.format("STCFN%03d", byte))
	S_StopSoundByID(nil, sfx_wepchg)
	S_StartSoundAtVolume(nil, sfx_wepchg, 225)
end

local function draw_substr(v)
	local str_width = v.stringWidth(SW_SUBSTR)

	local sw = (v.width()/v.dupx())

	local x = ((leveltime % str_width) - str_width)*FU
	local y = substr_y
	local ox = x
	local scroll = true

	while y < 200*FU do
		if scroll then
			while x < (sw*FU) do
				v.drawString(x, y, SW_SUBSTR, V_SNAPTOBOTTOM|V_50TRANS|V_REDMAP, "fixed")
				x = $+(str_width*FU)
			end
		else
			x = sw*FU - $
			while x >= -(str_width*FU) do
				v.drawString(x, y, SW_SUBSTR, V_SNAPTOBOTTOM|V_50TRANS|V_REDMAP, "fixed")
				x = $-(str_width*FU)
			end
		end

		y = $+9*FU
		x = (ox-(str_width*FU/3)) % (str_width*FU)
		ox = x
		scroll = not scroll
	end
end

local function draw_side(v, x, data, right)
	if not (data and #data) then return end

	local right_length = #data
	local right_key = right_length-1 // wrapper
	local right_scale = FU
	local right_height = 128*FU
	local right_yoff = 0
	local flags = V_SNAPTOLEFT

	if right_key then
		for i = 1,right_key do // poor code ik but im having a brain aneursym
			right_scale = max(FU/6, $*3/4)
		end
		right_yoff = (128*right_scale)/5
		right_height = (128*right_scale)
	end

	local right_totalheight = (right_height*right_length)-(right_yoff*right_key)

	local y = (100*FU)-(right_totalheight/2)

	if right then
		x = (320*FU)-$
		flags = V_SNAPTORIGHT|V_FLIP
	end

	for k,data in ipairs(data) do
		draw_sw_spr(v,
			x+v.RandomRange(-2*FU, 2*FU),
			y+v.RandomRange(-2*FU, 2*FU),
			right_scale, data.skin,
			flags,
			data.color
		)
		y = $+right_height-right_yoff
	end
end

return function(v, p)
	if (not MM_N.showdown or MM_N.gameover) then
		init_vars()
		return
	end

	if not (MM_N.showdown) then return end

	if not init then
		init = true
	end
	
	local state = 1

	-- insert showdown animation here, not ready yet
	if MM_N.showdown_ticker >= 3*TICRATE then
		state = 2
	end

	local screen_height = (v.height()/v.dupy())*FU

	local draw_sides = true
	local versus = v.cachePatch("MM_VERSUS")

	if state == 1 then
		side_x = ease.linear(FU/5, $, 0*FU)
		str_y = ease.linear(FU/3, $, 170*FU)
		substr_y = ease.linear(FU/3, $, 120*FU)
		versus_y = ease.linear(FU/5, $, (screen_height/2)-(versus.height*(FU*3/4)/2))

		fade = min($+1, 13)
	elseif state == 2 then
		side_x = ease.linear(FU/5, $, -128*FU)
		str_y = ease.linear(FU/3, $, 200*FU)
		substr_y = ease.linear(FU/3, $, 200*FU)
		versus_y = ease.linear(FU/5, $, -versus.height*FU)
		fade = max(0, $-1)
		draw_sides = fade > 0
	end

	manage_letters(v)
	v.fadeScreen(0xFF00, fade)

	local str_scale = FU*3/2
	local width = 8*(#letters*str_scale)

	local str_x = (160*FU)-(width/2)

	if draw_sides then
		draw_substr(v)

		local str = "The murderer can see you, RUN!"
		local max_width = v.stringWidth(str, 0, "thin")
		max_width = (max($, 8*#letters)*FU)+(4*FU)

		local max_height = (8*str_scale)+(8*FU)+(4*FU)

		v.drawStretched(160*FU - (max_width/2),
			str_y - 2*FU,
			max_width,
			max_height,
			v.cachePatch("1PIXEL"),
			V_SNAPTOBOTTOM|V_40TRANS
		)

		for k,patch in ipairs(letters) do
			v.drawScaled(
				str_x+v.RandomRange(-FU, FU),
				str_y+v.RandomRange(-FU, FU),
				str_scale,
				patch,
				V_SNAPTOBOTTOM,
				v.getColormap(TC_RAINBOW, SKINCOLOR_RED)
			)
			str_x = $+(8*str_scale)
		end
		if (p and p.mm and p.mm.role == MMROLE_MURDERER) then
			str = "GET THAT INNOCENT!"
		end

		v.drawString(160*FU, str_y+(8*str_scale), str, V_SNAPTOBOTTOM, "thin-fixed-center")

		draw_side(v, side_x, MM_N.showdown_right, true)
		draw_side(v, side_x, MM_N.showdown_left, false)

		v.drawScaled(160*FU-(versus.width*(FU*3/4)/2), versus_y, FU*3/4, versus, V_SNAPTOTOP)
	end
end