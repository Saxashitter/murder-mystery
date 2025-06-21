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
	local passed = {}
	for p in players.iterate
		if (p and p.valid and conditionsPassed(p, conditions)) then
			table.insert(passed, p)
			print(p.name.." passed")
		end
	end
	return passed[P_RandomRange(1, #passed)]
end