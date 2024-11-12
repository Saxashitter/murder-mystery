local strings = {
	"storm.starting_dist",
	"storm.usedpoints",
	"storm.ticker",
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
	
	local values = {
		[1] = string.format("%f",MM_N.storm_startingdist),
		[2] = MM_N.storm_usedpoints,
		[3] = MM_N.storm_ticker,
	}
	
	for k,str in ipairs(strings)
		v.drawString(x,y + work,
			str..": "..tostring(values[k]),
			flags,
			"small"
		)
		
		work = $+4
	end
	
end