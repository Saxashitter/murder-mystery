local SLIDE_TIME = TICRATE
local SLIDE_DELAY = TICRATE/2
local SLIDEUP_TIME = TICRATE
local SLIDEUP_DELAY = TICRATE/2
local RINGS_TALLY = TICRATE/2
local ALIVE_TALLY = TICRATE/2
local SCORE_TALLY = TICRATE/2

local TOTAL_TIME = SLIDE_TIME+SLIDEUP_TIME+RINGS_TALLY+ALIVE_TALLY+SCORE_TALLY

local function div(tics, time)
	return max(0, min(FixedDiv(tics, time), FU))
end

local function moving(t)
	return (t == 0 or t == FU)
end

return function(v, p)
	if not (MM_N.results_ticker) then return end

	local display_results = true

	local tics = MM_N.results_ticker

	local sw = v.width()/v.dupx()
	local sh = v.height()/v.dupy()

	local _tics = tics

	local slide = div(_tics, SLIDE_TIME)
	_tics = $-SLIDE_TIME

	local slideup = div(_tics-SLIDE_DELAY, SLIDEUP_TIME)
	_tics = $-SLIDE_DELAY-SLIDEUP_TIME

	local rings_tally = div(_tics-SLIDEUP_DELAY, RINGS_TALLY)
	_tics = $-SLIDEUP_DELAY-RINGS_TALLY

	local alive_tally = div(_tics, ALIVE_TALLY)
	_tics = $-ALIVE_TALLY

	local score_tally = div(_tics, SCORE_TALLY)
	_tics = $-SCORE_TALLY

	local ft = "You survived!"
	if not (p and p.mm and not p.mm.spectator) then
		ft = "You died..."
		display_results = false
	end
	if (p and p.mm and p.mm.joinedmidgame) then
		ft = "You joined during a game!"
		display_results = false
	end

	local ft_w = v.levelTitleWidth(ft)
	local ft_x = ease.outback(slide, -ft_w, (sw/2)-(ft_w/2), FU*3/2)
	local ft_y = display_results and ease.outcubic(slideup, sh/2, 24) or sh/2
	v.drawLevelTitle(ft_x, ft_y, ft, V_SNAPTOLEFT|V_SNAPTOTOP)

	if not display_results then return end

	local base_y = (sh*FU/2)-(4*FU)
	local add_y = 10*FU
	local number_x = 200*FU

	base_y = ease.outcubic(slideup, $+(sh*FU), $)

	local rings = ease.linear(rings_tally, 0, p.rings)
	local rings_x = 80*FU
	local rings_y = base_y

	local time = ease.linear(alive_tally, 0, max(0, MM_N.maxtime-MM_N.time))
	local time_x = rings_x
	local time_y = base_y+add_y

	v.drawString(rings_x, rings_y, "RINGS:", V_SNAPTOTOP, "fixed")
	v.drawString(number_x, rings_y, tostring(rings), V_SNAPTOTOP, "fixed")

	v.drawString(time_x, time_y, "TIME ALIVE:", V_SNAPTOTOP, "fixed")
	v.drawString(number_x, time_y, tostring(time), V_SNAPTOTOP, "fixed")

	if moving(rings_tally)
	or moving(alive_tally) then
		S_StartSound(nil, sfx_ptally)
	end
end