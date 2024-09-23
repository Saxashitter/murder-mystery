return function(p) -- Murderer handler.
	if p.mm.role ~= 2 then return end

	local murd = p.mm.murderer

	if leveltime >= 10*TICRATE
	and not (p.mm.weapon
	and p.mm.weapon.valid
	and p.mm.weapon.__type == "Knife"
	and not p.mm.got_weapon) then
		MM:giveWeapon(p, "Knife")
		p.mm.got_weapon = true
	end
end