return function(v)
	if MenuLib and (MenuLib.client.currentMenu.id ~= -1)
		MMHUD.DoRegularSlide(v,true)
		MMHUD.DoWeaponSlide(v,true)
		MMHUD.dontslidein = true
	end
end