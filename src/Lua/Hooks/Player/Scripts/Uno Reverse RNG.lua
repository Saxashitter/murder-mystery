local roles = MM.require "Variables/Data/Roles"

return function(p) -- Role handler
	if leveltime == 10*TICRATE then
		if p.mm.role == MMROLE_MURDERER then
			if P_RandomChance(FRACUNIT/4) then
				MM:GiveItem(p, "uno_reverse")
			end
		end
	end
end