local theme = {}

local background

theme.start_transparent = false
theme.transition = true
theme.transition_time = 2*TICRATE
theme.music = "_INTER"
theme.stretch = false

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

local summa_scale = 0
local summa_vscale = 0
local summa

function theme.init()
	summa_scale = 0
	summa_vscale = 0
end

local function lerp(a, b, t)
	return FixedMul(a, FU-t) + FixedMul(b, t)
end

function theme.transitiondraw(v, tics)
	if not summa then
		summa = v.cachePatch"SUMMADAT"
	end

	local end_hscale = FixedDiv(v.width()/v.dupx(), summa.width)*2
	local end_vscale = FixedDiv(v.height()/v.dupy(), summa.height)*2

	if tics then
		summa_scale = lerp($, end_hscale, FU/6)
		summa_vscale = lerp($, end_vscale, FU/6)
	else
		summa_scale = lerp($, 0, FU/6)
		summa_vscale = lerp($, 0, FU/6)
	end

	local x = 160*FU
	local y = 100*FU

	if summa_scale
	and summa_vscale then
		v.drawStretched(
			x-(summa.width*summa_scale/2),
			y-(summa.height*summa_vscale/2),
			summa_scale,
			summa_vscale,
			summa)
	end
end

function theme.draw(v, tics)
	if not background then
		background = v.cachePatch"SRB2BACK"
	end

	local scale = FU/2
	local scroll = tics*scale

	draw_parallax(v, scroll, scroll, scale, background, V_SNAPTOTOP|V_SNAPTOLEFT)
end

return theme