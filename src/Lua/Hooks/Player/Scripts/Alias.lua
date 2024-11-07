return function(p)
	if not p.mm.alias then return end

	p.mm.alias.skin = p.mo.skin
	p.mm.alias.color = p.mo.color
	p.mm.alias.skincolor = p.skincolor
end