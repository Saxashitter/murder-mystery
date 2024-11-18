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

local Squiggle = MM.require "HUDObjs/squiggletext"
local int_ease = MM.require "Libs/int_ease"

local last_innocent_data
local murderer_data
local showdown_text
local showdown_str = "SHOWDOWN!!"
local init = false

local swspr = {}

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

return function(v, p)
	if (not MM_N.showdown or MM_N.gameover) then
		last_innocent_data = nil
		murderer_data = nil
		init = false
		showdown_text = nil
		return
	end

	if not (MM_N.showdown_ticker) then return end

	if not init then
		showdown_text = Squiggle(160*FU,
			200*FU,
			FU*3,
			string.sub(showdown_str, 1, 1),
			"center",
			SKINCOLOR_RED,
			{
				shake = true,
				wiggle = false
			},
			V_SNAPTOBOTTOM)
		init = true
	end

	local start_t = max(0, min(FixedDiv(MM_N.showdown_ticker, TICRATE), FU))
	local end_t = max(0, min(FixedDiv((3*TICRATE)-MM_N.showdown_ticker, TICRATE), FU))

	local t = MM_N.showdown_ticker < TICRATE and start_t or end_t

	-- insert showdown animation here, not ready yet
	if MM_N.showdown_ticker < 3*TICRATE then
		local twn = int_ease(t, 0, 16)
		v.fadeScreen(0xFF00, twn)

		local right_length = #MM_N.showdown_right
		local right_key = right_length-1 // wrapper
		local right_scale = FU
		local right_height = 128*FU
		local right_yoff = 0

		if right_key then
			for i = 1,right_key do // poor code ik but im having a brain aneursym
				right_scale = max(FU/6, $*3/4)
			end
			right_yoff = (128*right_scale)/5
			right_height = (128*right_scale)
		end

		local right_totalheight = (right_height*right_length)-(right_yoff*right_key)

		local x = ease.outcubic(t, -128*right_scale, -128*(right_scale/3))
		local y = (100*FU)-(right_totalheight/2)
		for k,data in ipairs(MM_N.showdown_right) do
			draw_sw_spr(v,
				(320*FU)-x+v.RandomRange(-2*FU, 2*FU),
				y+v.RandomRange(-2*FU, 2*FU),
				right_scale, data.skin,
				V_SNAPTORIGHT|V_FLIP,
				data.color)
			y = $+right_height-right_yoff
		end

		local left_length = #MM_N.showdown_left
		local left_key = left_length-1 // wrapper
		local left_scale = FU
		local left_height = 128*FU
		local left_yoff = 0

		if left_key then
			for i = 1,left_key do // poor code ik but im having a brain aneursym
				left_scale = max(FU/6, $*3/4)
			end
			left_yoff = (128*left_scale)/5
			left_height = (128*left_scale)
		end

		local left_totalheight = (left_height*left_length)-(left_yoff*left_key)

		local x = ease.outcubic(t, -128*left_scale, -128*(left_scale/3))
		local y = (100*FU)-(left_totalheight/2)
		for k,data in ipairs(MM_N.showdown_left) do
			draw_sw_spr(v,
				x+v.RandomRange(-2*FU, 2*FU),
				y+v.RandomRange(-2*FU, 2*FU),
				left_scale, data.skin,
				V_SNAPTOLEFT,
				data.color)
			y = $+left_height-left_yoff
		end

		local width = v.nameTagWidth "SHOWDOWN!"
		local x = (160*FU)-(width*(FU/2))
		local y = ease.outcubic(t, 200*FU, 162*FU)

		/*x = $+v.RandomRange(-2*FU, 2*FU)
		y = $+v.RandomRange(-2*FU, 2*FU)

		v.drawScaledNameTag(x, y, "SHOWDOWN", V_SNAPTOBOTTOM, FU, SKINCOLOR_RED, SKINCOLOR_WHITE)*/

		local text_twn = ease.linear(FixedDiv(MM_N.showdown_ticker, 16), 1, #showdown_str)

		showdown_text.text = string.sub(showdown_str, 1, text_twn)
		showdown_text.y = y
		showdown_text:draw(v)
	end
end