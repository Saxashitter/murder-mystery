local theme = {}

local background

theme.start_transparent = true
theme.transition = false
theme.transition_time = 0
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

function theme.draw(v, tics)
	if not background then
		background = v.cachePatch "SRB2BACK"
	end

	local scale = FU/2
	local scroll = tics*scale

	draw_parallax(v, scroll, scroll, scale, background, V_SNAPTOTOP|V_SNAPTOLEFT)
end

return theme