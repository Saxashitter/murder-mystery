local strings = {
	"storm.starting_dist",
	"storm.usedpoints",
	"storm.ticker",
	"storm.curdist",
	"storm.realdist",
	"interact.interacted",
}

return function(v,p)
	if not CV_MM.debug.value then return end
	
	local x = 5
	local y = 40
	local work = 0
	local flags = V_SNAPTOLEFT|V_SNAPTOTOP|V_ALLOWLOWERCASE
	
	v.drawString(x,y - 4,
		"Debug",
		flags|V_YELLOWMAP,
		"small"
	)
	
	local dist = MM_N.storm_startingdist - (MM_N.storm_ticker*FU*2)
	local rdist = max(dist,
		MM_N.storm_usedpoints and MM_N.storm_startingdist/8 or 1028*FU
	)
	local values = {
		[1] = string.format("%f",MM_N.storm_startingdist),
		[2] = MM_N.storm_usedpoints,
		[3] = MM_N.storm_ticker,
		[4] = string.format("%f",dist),
		[5] = string.format("%f",rdist),
		[6] = p.mm.interact.interacted,
	}
	
	for k,str in ipairs(strings)
		v.drawString(x,y + work,
			str.." = "..tostring(values[k]),
			flags,
			"small"
		)
		
		work = $+4
	end
	
end