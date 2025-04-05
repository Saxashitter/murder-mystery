return function()
	--if the storm was active, fade it out
	if MM_N.showdown 
	or MM_N.overtime
	or CV_MM.debug.value then
		MM:handleStorm()
	end
end, "gameover"