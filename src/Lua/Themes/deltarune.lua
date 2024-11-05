local theme = {}

theme.start_transparent = true
theme.transition = false
theme.transition_time = 0
theme.music = "RUDBST"

local KRIS_X = 90*FU
local RALSEI_X = 53*FU
local SUSIE_X = 70*FU
local KRIS_Y = 170*FU
local PLAYER_X = (320*FU)-KRIS_X

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

local function return_player(v, data)
	return v.getSprite2Patch(data.skin, data.spr2, false, data.frame, data.rot)
end

local function draw_player(v, x, y, scale, data, flags)
	flags = flags or 0

	local player = return_player(v, data)

	x = $+(player.leftoffset*scale)
	y = $+(player.topoffset*scale)

	if data.rot > 5 then
		if flags & V_FLIP then
			flags = $ & ~V_FLIP
			x = $-(player.width*scale)
		else
			flags = $|V_FLIP
			x = $+(player.width*scale)
		end
	end

	local color = v.getColormap(data.skin, data.color)

	v.drawScaled(x, y, scale, player, flags, color)

	return player
end

function theme.transitiondraw(v, tics)

end

local background
local strips
local kris
local susie
local ralsei
function theme.draw(v, tics)
	if not background then
		background = v.cachePatch"DELTABG_1"
	end
	if not strips then
		strips = v.cachePatch"DELTABG_2"
	end
	if not kris then
		kris = {}
		for i = 0,5 do
			kris[i] = v.cachePatch("KRIS"..tostring(i))
		end
	end
	if not ralsei then
		ralsei = {}
		for i = 0,4 do
			ralsei[i] = v.cachePatch("RALSEI"..tostring(i))
		end
	end
	if not susie then
		susie = {}
		for i = 0,7 do
			susie[i] = v.cachePatch("SUSIE"..tostring(i))
		end
	end

	local x_speed = FU/4
	local y_speed = FU/7

	local x = tics*x_speed
	local y = tics*y_speed

	local sw = v.width()/v.dupx()
	local sh = v.height()/v.dupy()

	v.drawStretched(0, 0, FixedDiv(sw, 320), FixedDiv(sh, 190), background, V_SNAPTOLEFT|V_SNAPTOTOP)

	draw_parallax(v, x,y, FU, strips, V_SNAPTOTOP|V_SNAPTOLEFT|V_80TRANS)
	draw_parallax(v, -x,-y, FU, strips, V_SNAPTOTOP|V_SNAPTOLEFT|V_80TRANS)

	local krisf = tics/3 % 6
	local ralseif = tics/3 % 5
	local susief = tics/3 % 8

	v.drawScaled(SUSIE_X, KRIS_Y, FU, susie[susief], V_SNAPTOLEFT)
	v.drawScaled(RALSEI_X, KRIS_Y, FU, ralsei[ralseif], V_SNAPTOLEFT)
	v.drawScaled(KRIS_X, KRIS_Y, FU, kris[krisf], V_SNAPTOLEFT)

	if not (consoleplayer and consoleplayer.valid) then return end

	local scale = FU/2
	local data = {
		skin = consoleplayer.skin,
		spr2 = SPR2_STND,
		color = consoleplayer.skincolor,
		frame = A,
		rot = 3
	}

	local player = return_player(v, data)
	local PLAYER_X = PLAYER_X-(player.width*scale/4)
	local PLAYER_Y = KRIS_Y-(player.height*scale)

	draw_player(v, PLAYER_X, PLAYER_Y, scale, data, V_SNAPTORIGHT)
end

return theme