local function shallowCopy(toCopy)
	if type(toCopy) != "table" then
		return toCopy
	end

	local copy = {}

	for k,v in pairs(toCopy) do
		copy[k] = shallowCopy(v)
	end

	return copy
end

return shallowCopy