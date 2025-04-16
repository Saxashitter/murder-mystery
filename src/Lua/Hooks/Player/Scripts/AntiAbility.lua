addHook("PlayerCanEnterSpinGaps",function(p)
	if not (MM:isMM()) then return end
	if (CV_MM.debug.value) then return end
	return false
end)

--prevent weird exploits from letting people fire corks
addHook("MobjSpawn",function(cork)
	if not (MM:isMM()) then return end
	if (CV_MM.debug.value) then return end
	
	cork.flags = $|MF_NOCLIPTHING|MF_NOCLIP
	P_RemoveMobj(cork)
end,MT_CORK)

return function(p)
	if (CV_MM.debug.value) then return end
	p.pflags = $ &~(PF_STARTDASH|PF_SPINNING)
end