return function()
	local protips = MenuLib.findMenu("Protips")
	MenuLib.menus[protips].fromkeydown = true
	MenuLib.initMenu(protips)
end