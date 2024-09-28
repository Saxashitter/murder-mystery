-- Simple lua to run events for the mod.
-- Adds easy modding support and more!

local events = {}

local function can_override_variable(old, new, prioritize)
	if prioritize == "number" then
		if old == nil or (old ~= nil and old > new) then
			return new
		end
		return old
	end

	if not old
	and new then
		return new
	end

	return old
end

MM.addEvent = function(name, func)
	if not events[name] then
		-- TODO: make list of valid events and print as an error if its not valid
		events[name] = {}
	end

	table.insert(events[name], func)
end

MM.runEvent = function(name, prioritize, ...)
	if not events[name] then return end

	local return_value

	for _,call in pairs(events[name]) do
		return_value = can_override_variable(return_value, call(...), prioritize)
	end

	return return_value
end