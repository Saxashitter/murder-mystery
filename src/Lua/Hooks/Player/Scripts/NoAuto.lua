return function(p)
	if (p.pflags & (PF_ANALOGMODE|PF_DIRECTIONCHAR)) == (PF_ANALOGMODE|PF_DIRECTIONCHAR)
		p.pflags = $ &~PF_ANALOGMODE
		if (p == consoleplayer)
			MMHUD:PushToTop(5*TICRATE,
				"Header",
				"test",
				"test",
				"test",
				"test"
			)
		end
	end
end