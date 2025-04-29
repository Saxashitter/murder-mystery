addHook("ViewpointSwitch", function(p, p2, f)
	if (CV_MM.debug.value) then return end
	if not (MM:isMM() and p.mm) then return end
	if (p.mm.spectator) then return end
	
	return p2 == p
end)