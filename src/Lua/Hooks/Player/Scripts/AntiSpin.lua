addHook("PlayerCanEnterSpinGaps",function(p)
	if not (MM:isMM()) then return end
	return false
end)

return function(p)
	p.pflags = $ &~(PF_STARTDASH|PF_SPINNING)
end