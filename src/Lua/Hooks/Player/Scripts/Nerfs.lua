return function(p)
	if p.charability == CA_GLIDEANDCLIMB then
		if p.climbing then
			p.climbing = 0
			p.mo.state = S_PLAY_JUMP
		end
	end
	if p.charability == CA_FLY then
		p.powers[pw_tailsfly] = min(TICRATE/2, $)
	end
	if p.charability == CA_FLOAT
	or p.charability == CA_THOK
	or p.charability == CA_BOUNCE then
		p.charability = CA_NONE
	end
	if p.charability2 == CA2_GUNSLINGER then
		p.charability2 = CA2_NONE
	end

	if p.mo.skin == "knuckles" then
		p.jumpfactor = skins[p.mo.skin].jumpfactor*3/2
	end
end