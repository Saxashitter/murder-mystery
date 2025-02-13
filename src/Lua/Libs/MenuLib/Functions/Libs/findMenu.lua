local ML = MenuLib

return function(stringId)
	for k, menu_t in ipairs(ML.menus)
		if menu_t.stringId == stringId
			return k, menu_t
		end
	end
	return -1
end