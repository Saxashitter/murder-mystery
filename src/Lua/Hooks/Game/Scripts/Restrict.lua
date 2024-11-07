return function()
	--Funny
	if leveltime == 10*TICRATE and isserver then
		CV_Set(CV_FindVar("restrictskinchange"),1)
	end
end