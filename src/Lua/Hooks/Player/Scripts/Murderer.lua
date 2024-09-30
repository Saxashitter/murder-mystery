return function(p) -- Murderer handler.
	if p.mm.role ~= MMROLE_MURDERER then return end

	local murd = p.mm.murderer

	if leveltime >= 10*TICRATE
	and not p.mm.got_weapon
	and not (p.mm.weapon
	and p.mm.weapon.valid
	and p.mm.weapon.__type == "Knife") then
		MM:giveWeapon(p, "Knife")
		p.mm.got_weapon = true
	end
end