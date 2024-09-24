addHook("ViewpointSwitch", function(p, p2, f)
	if not (MM:isMM() and p.mm and not p.mm.spectator) then return end
	return p2 == p
end)