return function()
	MM_N.overtime = true
	S_StartSound(nil,sfx_kc4b)
	MMHUD:PushToTop(5*TICRATE,"OVERTIME", "The murderer will be revealed slowly!")
end