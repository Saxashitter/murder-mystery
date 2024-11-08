return function()
	MM_N.showdown = true
	MM_N.showdown_song = "SHWDW"..tostring(P_RandomRange(1,3))
	MMHUD:PushToTop(5*TICRATE,"SHOWDOWN", "There's 1 person left, the murderer can see where he is!")
	S_StartSound(nil,sfx_kc4b)
end