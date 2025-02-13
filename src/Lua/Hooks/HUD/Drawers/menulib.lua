return function(v)
	if MenuLib and (MenuLib.client.currentMenu.id ~= -1)
		MMHUD.xoffset = ease.inexpo(FU*6/10,$,1000*FU)
		MMHUD.weaponslidein = MMHUD.xoffset
		MMHUD.dontslidein = true
	end
end