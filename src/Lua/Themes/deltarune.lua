local theme = {}

theme.start_transparent = true
theme.transition = false
theme.transition_time = 0
theme.music = "RUDBST"

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

function theme.transitiondraw(v, tics)

end

local background
local strips
function theme.draw(v, tics)
	if not background then
		background = v.cachePatch"DELTABG_1"
	end
	if not strips then
		strips = v.cachePatch"DELTABG_2"
	end

	local x_speed = FU/4
	local y_speed = FU/8

	local x = tics*x_speed
	local y = tics*y_speed

	local sw = v.width()/v.dupx()
	local sh = v.height()/v.dupy()

	v.drawStretched(0, 0, FixedDiv(sw, 320), FixedDiv(sh, 190), background, V_SNAPTOLEFT|V_SNAPTOTOP)

	draw_parallax(v, x,y, FU, strips, V_SNAPTOTOP|V_SNAPTOLEFT|V_40TRANS)
	draw_parallax(v, -x,-y, FU, strips, V_SNAPTOTOP|V_SNAPTOLEFT|V_40TRANS)
end

return theme