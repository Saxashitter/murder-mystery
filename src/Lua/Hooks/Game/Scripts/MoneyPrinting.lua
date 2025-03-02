local TR = TICRATE
local SPAWN_RATE = TR --*3/2

return function()
	if (leveltime % SPAWN_RATE) then return end
	if not P_RandomChance(FU*4/5) then return end
	
	MM.printMoney()
end