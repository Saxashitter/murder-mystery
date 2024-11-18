return function()
	MM_N.showdown = true
	MM_N.showdown_song = "SHWDW"..tostring(P_RandomRange(1,3))

	for p in players.iterate do
		if not (p and p.mo and p.mo.health and p.mm and not p.mm.spectator) then continue end

		if p.mm.role ~= MMROLE_MURDERER then
			table.insert(MM_N.showdown_right, {
				skin = p.mo.skin,
				color = p.mo.color
			})
			print "added to right side"
			continue
		end

		table.insert(MM_N.showdown_left, {
			skin = p.mo.skin,
			color = p.mo.color
		})
		print "added to left side"
	end

	MMHUD:PushToTop(5*TICRATE,"SHOWDOWN", "There's 1 person left, the murderer can see where he is!")
	S_StartSound(nil,sfx_kc4b)
end