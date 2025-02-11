return function(v, set)
	if (v.interpolate == nil) then return end
	
	v.interpolate(set)
end