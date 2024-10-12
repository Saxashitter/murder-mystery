return function(table, var)
	for k,v in pairs(table) do
		if v == var then
			return true, k
		end
	end

	return false
end