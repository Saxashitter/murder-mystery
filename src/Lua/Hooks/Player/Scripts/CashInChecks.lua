local wrapadd = MM.require("Libs/wrappedadd")

return function(p)
	if not p.mm_save then return end
	
	if (p.mm_save.ringstopay)
	and (leveltime % 3 == 0)
		p.rings = 0
		p.mm_save.rings = wrapadd($, 1)
		p.mm.rings = wrapadd($, 1)
		S_StartSound(nil, mobjinfo[MT_RING].deathsound, p)
		
		p.mm_save.ringstopay = $ - 1
	end
end