local patches = {}

local function patch(v, str)
	if not (patches[str]) then
		patches[str] = v.cachePatch(str)
	end

	return patches[str]
end

local function tween(t, first, second, third)
	if t < FU/2 then
		return ease.outcubic(t*2, first, second)
	end

	return ease.incubic((t*2)-FU, second, third)
end

return function(v)
	if not MM_N.ptsr_mode then return end
	if MM_N.time ~= 0 then return end

	local tics = MM_N.ptsr_overtime_ticker

	local left_tween 
	local right_tween 
	
	local text_its = v.cachePatch("OT_ITS")
	local text_overtime = v.cachePatch("OT_OVERTIME")
	
	local anim_len = 7*TICRATE/4 -- 1.75 secs
	local anim_delay = 2*TICRATE
	local anim_lastframe = (anim_len*2)+(anim_delay)
	local left_end = 0 -- end pos of left
	local right_end = 110 -- end pos of right

	local shake_dist = 2
	local shakex_1 = v.RandomRange(-shake_dist, shake_dist)
	local shakey_1 = v.RandomRange(-shake_dist, shake_dist)
	local shakex_2 = v.RandomRange(-shake_dist, shake_dist)
	local shakey_2 = v.RandomRange(-shake_dist, shake_dist)
	
	local div = min(FixedDiv(tics, anim_len), FU)
	local div_end = min(FixedDiv(tics - anim_delay - anim_len, anim_len), FU)

	if tics <= anim_len + anim_delay then -- come in
		left_tween = ease.outquint(div, left_end-400, left_end)
		right_tween = ease.outquint(div, right_end+400, right_end)
	else -- come out
		left_tween = ease.inquint(div_end, left_end, left_end-400)
		right_tween = ease.inquint(div_end, right_end, right_end+400)
	end

	if tics <= anim_lastframe then -- draw
		v.drawScaled(
			(left_tween+shakex_1)*FU,
			(80+shakey_1)*FU,
			FU/2,
			text_its
		)
		
		v.drawScaled(
			(right_tween+shakex_2)*FU,
			(80+shakey_2)*FU,
			FU/2,
			text_overtime
		)
		
		/* Beta Text (Broken positions)
			v.drawLevelTitle(left_tween+shakex_1, 100+shakey_1, "It's ", V_REDMAP)
			v.drawLevelTitle(right_tween+shakex_2, 100+shakey_2, "Overtime!", V_REDMAP)
		*/
	end

	local t = min(FixedDiv(tics, TICRATE*2), FU)
	v.fadeScreen(SKINCOLOR_CRIMSON, ease.linear(t, 10, 0))
end