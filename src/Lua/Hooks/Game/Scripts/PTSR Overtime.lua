return function()
	if MM_N.ptsr_mode
	and MM_N.time
	and MM_N.time <= 20*TICRATE
	and mapmusname ~= "OTMUSA" then
		S_ChangeMusic("OTMUSA", false)
		mapmusname = "OTMUSA"
	end

	if MM_N.time == 0
	and MM_N.ptsr_mode then
		if MM_N.ptsr_overtime_ticker == 0 then
			S_StartSound(nil, P_RandomRange(41,43)) -- lightning
		end

		if mapmusname ~= "OTMUSB" then
			S_ChangeMusic("OTMUSB", true)
			mapmusname = "OTMUSB"
		end

		P_SetupLevelSky(34)
		P_SetSkyboxMobj(nil)

		MM_N.ptsr_overtime_ticker = $+1
	end
end