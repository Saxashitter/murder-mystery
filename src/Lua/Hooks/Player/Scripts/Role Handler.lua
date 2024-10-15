local roles = MM.require "Variables/Data/Roles"

return function(p) -- Role handler
	if not (roles[p.mm.role].weapon) then return end

	if leveltime >= 10*TICRATE
	and not p.mm.got_weapon
		MM:GiveItem(p, roles[p.mm.role].weapon, true)
		p.mm.got_weapon = true
	end
end