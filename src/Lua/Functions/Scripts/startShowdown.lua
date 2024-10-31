return function()
	MM_N.showdown = true
	MM_N.showdown_song = "SHWDW"..tostring(P_RandomRange(1,3))
	S_StartSound(nil,sfx_kc4b)
end