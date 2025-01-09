addHook("PlayerCanEnterSpinGaps",function(p)
	if not (MM:isMM()) then return end
	if (CV_MM.debug.value) then return end
	return false
end)

return function(p)
	if (CV_MM.debug.value) then return end
	p.pflags = $ &~(PF_STARTDASH|PF_SPINNING)
end