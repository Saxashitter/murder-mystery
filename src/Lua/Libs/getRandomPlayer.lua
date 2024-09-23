local function conditionsPassed(p, conditions)
	if conditions == nil then
		return true
	end

	if conditions(p) then
		return true
	end

	return false
end

return function(conditions)
	local p
	while not p do
		p = players[P_RandomKey(#players)]

		if (p and p.valid and conditionsPassed(p, conditions)) then
			return p
		end

		p = nil
	end
end