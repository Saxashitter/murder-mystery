return function(p)
	if ((p.cmd.buttons & BT_WEAPONMASK ~= p.lastbuttons & BT_WEAPONMASK)
	and (p.cmd.buttons & BT_WEAPONMASK) == 5)
		MenuLib.initMenu(MenuLib.findMenu("ShopPage"))
	end
end