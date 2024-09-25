-- SAXAS MURDER MYSTERY

rawset(_G, "MM_N", {})
rawset(_G, "MM", {})

G_AddGametype({
    name = "Murder Mystery",
    identifier = "SAXAMM",
    typeoflevel = TOL_COOP|TOL_MATCH,
    rules = GTR_FRIENDLYFIRE|GTR_SPAWNINVUL,
    intermissiontype = int_match,
    headerleftcolor = 222,
    headerrightcolor = 84,
	description = "wip"
})

MM.require = dofile "Libs/require"
dofile "Libs/CustomHud.lua"

dofile "Variables/main"
dofile "Functions/main"
dofile "Console/main"
dofile "Hooks/main"
dofile "Weapons/main"

setmetatable(MM, {
	__index = function(self, key)
		if rawget(self, key) ~= nil then
			return rawget(self, key)
		end

		if MM_N[key] then
			print "net has it, return the thing from net"
			return MM_N[key]
		end
	end,
	__newindex = function(self, key, value)
		if MM_N[key] ~= nil then
			print "whoop we assigning shit to net now"
			MM_N[key] = value
			return
		end

		rawset(self, key, value)
	end
})