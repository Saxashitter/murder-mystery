local scripts = {}
local global_scripts = {}

local function doAndInsert(file, global)
	local func = dofile("Hooks/Player/Scripts/"..file)

	if global then
		global_scripts[#global_scripts+1] = func
		return
	end
	scripts[#scripts+1] = func
end

addHook("PlayerThink", function(p)
	if not MM:isMM() then return end

	if not p.mm then
		MM:playerInit(p)
	end

	for _,script in ipairs(global_scripts) do
		script(p)
	end

	if not (p.mo and p.mo.valid and p.mo.health) then
		return
	end

	p.spectator = p.mm.spectator
	if p.mm.spectator then
		return
	end
	
	if p.deadtimer >= 3*TICRATE
	and p.playerstate == PST_DEAD
		G_DoReborn(#p)
		p.deadtimer = 0
	end
	
	for _,script in ipairs(scripts) do
		script(p)
	end
end)

doAndInsert("Murderer")
doAndInsert("Sheriff")
doAndInsert("Nerfs")
doAndInsert("Map Vote", true)