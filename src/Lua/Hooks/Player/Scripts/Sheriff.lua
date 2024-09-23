return function(p) -- Murderer handler.
	if p.mm.role ~= 3 then return end

	if leveltime >= 10*TICRATE
	and not p.mm.got_weapon
	and not (p.mm.weapon
	and p.mm.weapon.valid
	and p.mm.weapon.__type == "Gun") then
		MM:giveWeapon(p, "Gun")
		p.mm.got_weapon = true
	end
end