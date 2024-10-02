local function getRandomPos(approx)
	return FixedMul(P_RandomRange(-128, 128)*FU, approx)
end

return function(self, time, approx)
	if approx == nil then approx = FU end
	local ping_positions = {}

	S_StartSound(nil, sfx_menu1)

	for p in players.iterate do
		if not (p
		and p.mo
		and p.mo.health
		and p.mm
		and not p.mm.spectator
		and p.mm.role == MMROLE_MURDERER) then
			continue
		end

		table.insert(ping_positions, {
			x = p.mo.x+getRandomPos(approx),
			y = p.mo.y+getRandomPos(approx),
			z = p.mo.z+getRandomPos(approx),
			maxtime = time,
			time = time
		})
	end

	MM_N.ping_positions = ping_positions
end