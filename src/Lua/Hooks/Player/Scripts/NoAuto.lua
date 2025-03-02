return function(p)
	if p.pflags & PF_ANALOGMODE
		p.pflags = $|PF_FORCESTRAFE &~(PF_ANALOGMODE|PF_DIRECTIONCHAR)
	else
		p.pflags = $ &~PF_FORCESTRAFE
	end
end