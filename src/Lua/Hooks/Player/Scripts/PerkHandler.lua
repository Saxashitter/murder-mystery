return function(p)
	if p.mm.role ~= MMROLE_MURDERER then return end
	if (p.mm_save.perk == 0) then return end
	
	if MM_PERKS[p.mm_save.perk] ~= nil
		MM_PERKS[p.mm_save.perk](p)
	end
end