local TR = TICRATE
local spawn_wait = 0

local SPAWN_MIN = TR/5
local SPAWN_MAX = TR

addHook("NetVars", function(n) spawn_wait = n($); end)

return function()
	if spawn_wait
		spawn_wait = $ - 1
		return
	end
	
	do --if P_RandomChance(FU*4/5)
		MM.printMoney()
	end
	
	spawn_wait = TR -- P_RandomRange(SPAWN_MIN,SPAWN_MAX)
end, "waiting"