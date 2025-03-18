return function(v,p,c)
	if not (p.mm) then return end
	if (MM_N.gameover) then return end
	if (p.mm.role ~= MMROLE_MURDERER) then return end
	if (p.spectator) then return end
	
	MM_PERKS.drawPerkIcon(v,p,c, 1,p.mm_save.pri_perk)
	MM_PERKS.drawPerkIcon(v,p,c, 2,p.mm_save.sec_perk)
	
	/*
	if (p.mm_save.pri_perk ~= 0)
		if MM_PERKS[p.mm_save.pri_perk] ~= nil
		and MM_PERKS[p.mm_save.pri_perk].drawer ~= nil
			MM_PERKS[p.mm_save.pri_perk].drawer(v,p,c, "pri")
		end
	end

	if (p.mm_save.sec_perk ~= 0)
		if MM_PERKS[p.mm_save.sec_perk] ~= nil
		and MM_PERKS[p.mm_save.sec_perk].drawer ~= nil
			MM_PERKS[p.mm_save.sec_perk].drawer(v,p,c, "sec")
		end
	end
	*/
	
end