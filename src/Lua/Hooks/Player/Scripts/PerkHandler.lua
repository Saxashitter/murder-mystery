return function(p)
	--if p.mm.role ~= MMROLE_MURDERER then return end
	
	if p.mm_save.pri_perk ~= 0
		if MM_PERKS[p.mm_save.pri_perk] ~= nil
		and MM_PERKS[p.mm_save.pri_perk].primary ~= nil
			MM_PERKS[p.mm_save.pri_perk].primary(p)
		end
	end

	if p.mm_save.sec_perk ~= 0
		if MM_PERKS[p.mm_save.sec_perk] ~= nil
		and MM_PERKS[p.mm_save.sec_perk].secondary ~= nil
			MM_PERKS[p.mm_save.sec_perk].secondary(p)
		end
	end
	
end