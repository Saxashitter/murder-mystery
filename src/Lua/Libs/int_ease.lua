return function(t, start, finish)
	-- t ranges from 0 to FU
	-- this is meant for integer values due to ease.linear sometimes decreasing further in time
	-- which results in an unsmooth tween

	-- if anyone knows a better way to do this, pull request or something

	t = max(0, min(t, FU))

	local diff = finish - start

	return start + ( (diff * (t*100/FU))/100 )
end