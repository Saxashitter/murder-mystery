--bullshit
addHook("LinedefExecute",function(line,mo,sec)
	if G_BuildMapTitle(gamemap) ~= "Mil Base" then return end
	S_StartSound(sec,sfx_mmcam0)
end,"MM_MAPI1")