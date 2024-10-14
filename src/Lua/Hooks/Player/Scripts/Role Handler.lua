local roles = MM.require "Variables/Data/Roles"

/* return function(p) -- Role handler
	if not (roles[p.mm.role].weapon) then return end

	if leveltime >= 10*TICRATE
	and not p.mm.got_weapon
	and not (p.mm.weapon
	and p.mm.weapon.valid
	and p.mm.weapon.__type == roles[p.mm.role].weapon) then
		MM:giveWeapon(p, roles[p.mm.role].weapon)
		p.mm.got_weapon = true
	end
end*/