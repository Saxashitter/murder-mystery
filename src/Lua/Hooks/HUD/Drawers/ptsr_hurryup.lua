local START_TIME = 20*TICRATE
local END_TIME = 3*TICRATE

return function(v)
	if not MM_N.ptsr_mode then return end
	if not (MM_N.time ~= nil and MM_N.time <= START_TIME) then return end

	local sw = v.width()*FU/v.dupx()

	local tics = START_TIME-MM_N.time
	if tics >= END_TIME then return end

	local t = FixedDiv(tics, END_TIME)

	local secs = G_TicsToSeconds(MM_N.time)
	local mins = G_TicsToMinutes(MM_N.time)

	local str = string.format("%02d:%02d", mins, secs)
	local width = v.stringWidth(str)*FU

	local x = (sw/2)-(width/2)
	local y = (100-4)*FU

	if t < FU/2 then
		x = ease.outcubic(t*2, sw, x)
	else
		x = ease.incubic((t*2)-FU, x, -width)
	end

	x = $+v.RandomRange(-2*FU, 2*FU)
	y = $+v.RandomRange(-2*FU, 2*FU)

	v.drawString(x, y, str, V_SNAPTOLEFT, "fixed")
end