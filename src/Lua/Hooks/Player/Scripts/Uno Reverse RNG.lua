local roles = MM.require "Variables/Data/Roles"

return function(p) -- Role handler
	if leveltime == MM_N.pregame_time then
		if p.mm.role == MMROLE_MURDERER then
			if P_RandomChance(FRACUNIT/2) then
				MM:GiveItem(p, "uno_reverse")
			end
		end
	end
end