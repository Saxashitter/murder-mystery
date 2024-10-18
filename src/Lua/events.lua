-- Simple lua to run hooks for the mod.
-- Adds easy modding support and more!

local events = {}

MM.addHook = function(name, func)
	if not events[name] then
		-- TODO: make list of valid events and print as an error if its not valid
		events[name] = {}
	end

	table.insert(events[name], func)
end

MM.runHook = function(name, ...)
	if not events[name] then return end

	local return_value

	for _,call in pairs(events[name]) do
		return_value = call(...) or $
	end

	return return_value
end