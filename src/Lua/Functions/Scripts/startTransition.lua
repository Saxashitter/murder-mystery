return function(self)
	local theme = MM.themes[MM_N.theme or "srb2"]

	if not theme.transition then
		MM:startVote()
		print("The theme doesn't have a transition, continue.")
		return
	end

	MM_N.transition = true
	MM_N.transition_time = theme.transition_time
end