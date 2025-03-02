local TR = TICRATE
local spawn_wait = 0

local SPAWN_MIN = TR/2
local SPAWN_MAX = TR*3/2

return function()
	if spawn_wait
		spawn_wait = $ - 1
		return
	end
	
	if P_RandomChance(FU*4/5)
		MM.printMoney()
	end
	
	spawn_wait = P_RandomRange(SPAWN_MIN,SPAWN_MAX)
end

addHook("NetVars",function(n) spawn_wait = n($) end)