return function(notext)
	MM_N.overtime = true
	S_StartSound(nil,sfx_kc4b)
	
	if not notext then
		MMHUD:PushToTop(5*TICRATE,"OVERTIME", "The murderer will be revealed slowly!")
	end
end