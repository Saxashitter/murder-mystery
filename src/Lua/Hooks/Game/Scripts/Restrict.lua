return function()
	--Funny
	if leveltime == MM_N.pregame_time and isserver then
		CV_Set(CV_FindVar("restrictskinchange"),1)
	end
end