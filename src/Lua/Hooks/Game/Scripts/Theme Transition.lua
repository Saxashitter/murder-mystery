return function(self)
	if not MM_N.transition then return end

	MM_N.transition_time = max(0, $-1)

	if not (MM_N.transition_time) then
		MM:startVote()
		MM_N.transition = false
	end
end, "gameover"