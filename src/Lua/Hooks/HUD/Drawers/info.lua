local function HUD_InfoDrawer(v,p)
	
	local slidein = MMHUD.xoffset
	
	--TODO: Replace with timelimit stuff once thats added
	local timetic = MM_N.time
	timetic = min(max($,0), MM_N.maxtime)
	
	local minutes = G_TicsToMinutes(timetic, true)
	local seconds = G_TicsToSeconds(timetic)
	--local tictrn  = G_TicsToCentiseconds(timetic)
	
	if minutes < 10 then minutes = "0"..$ end
	if seconds < 10 then seconds = "0"..$ end
	--if tictrn < 10 then tictrn = "0"..$ end
	
	v.drawScaled(5*FU - slidein,
		10*FU,
		FU,
		v.cachePatch("NGRTIMER"),
		V_SNAPTOLEFT|V_SNAPTOTOP
	)
	v.drawString(20*FU - slidein,
		10*FU,
		minutes..":"..seconds, --.."."..tictrn,
		V_SNAPTOLEFT|V_SNAPTOTOP,
		"fixed"
	)
end

return HUD_InfoDrawer