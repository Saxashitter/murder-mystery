local scripts = {}

local function doAndInsert(file)
	local func = dofile("Hooks/Player/Scripts/"..file)

	scripts[#scripts+1] = func
end

addHook("PlayerThink", function(p)
	if not MM:isMM() then return end

	if not p.mm then
		MM:playerInit(p)
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