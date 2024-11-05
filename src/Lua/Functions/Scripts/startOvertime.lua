return function()
	MM_N.overtime = true
	S_StartSound(nil,sfx_kc4b)
	MMHUD:PushToTop("OVERTIME", "The murderer will be revealed slowly!", 5*TICRATE)
end