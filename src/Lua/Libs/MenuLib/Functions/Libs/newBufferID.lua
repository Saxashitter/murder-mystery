local currentIds = 0

return function()
	currentIds = $ + 1
	return currentIds
end