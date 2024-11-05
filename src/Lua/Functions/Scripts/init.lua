local matchVars = MM.require "Variables/Data/Match"
local shallowCopy = MM.require "Libs/shallowCopy"
local randomPlayer = MM.require "Libs/getRandomPlayer"

local function canBeRole(p, count)
	if count < 2 then
		return true
	end
	
	return true
end

local function set_overtime_point()
	local possiblePoints = {}
	for mt in mapthings.iterate do
		if mt.type <= 35 then
			local z = P_FloorzAtPos(mt.x*FU,mt.y*FU,mt.z*FU,
				mobjinfo[MT_PLAYER].height
			)
			
			table.insert(possiblePoints,{x = mt.x*FU, y = mt.y*FU, z = z, a = mt.angle*ANG1, type = mt.type})
		end
	end
	
	local chosenKey = P_RandomRange(1,#possiblePoints)
	local chosenPoint = possiblePoints[chosenKey]
	if chosenPoint == nil then return end
	
	MM_N.storm_ticker = 0
	
	
	--Find the farthest possible point
	local olddist = 4096*FU
	for k,v in ipairs(possiblePoints) do
		if v == chosenPoint then continue end
		
		--add 256 as a small buffer to let people get to the middle
		local distTo = R_PointToDist2(v.x,v.y, chosenPoint.x,chosenPoint.y) + 256*FU
		if distTo < olddist then continue end
		
		MM_N.overtime_startingdist = distTo
		olddist = distTo
	end
	
	MM_N.storm_point = P_SpawnMobj(
		chosenPoint.x,
		chosenPoint.y,
		chosenPoint.z,
		MT_THOK
	)
	MM_N.storm_point.state = S_THOK
	MM_N.storm_point.tics = -1
	MM_N.storm_point.fuse = -1
	MM_N.storm_point.flags2 = $|MF2_DONTDRAW
	
	local garg = P_SpawnMobjFromMobj(
		MM_N.storm_point,
		0,0,0,
		MT_GARGOYLE
	)
	garg.flags = MF_NOCLIPTHING
	garg.colorized = true
	garg.color = SKINCOLOR_GALAXY
	garg.scale = $*2
	garg.angle = chosenPoint.a
	MM_N.storm_point.garg = garg
	
	table.remove(possiblePoints,chosenKey)
	MM_N.storm_point.otherpoints = possiblePoints
end

return function(self, maploaded)
	if maploaded then
		if not MM:isMM() then return end

		set_overtime_point()
		MM:giveOutClues(5)
		
		MM.runHook("PostMapLoad")
		return
	end
	
	MM_N = shallowCopy(matchVars)
	if (MM_N.end_camera and MM_N.end_camera.valid) then
		P_RemoveMobj(MM_N.end_camera)
		MM_N.end_camera = nil
	end
	
	local lastMurderers = {}
	local lastSheriffs = {}

	for p in players.iterate do
		self:playerInit(p, true)
	end
	
	local count = 0
	for p in players.iterate do
		count = $+1
	end

	MM_N.waiting_for_players = count < 2

	if not (self:isMM() and count >= 2) then return end

	// local special_count = P_RandomRange(1, max(1, min(count/3, 3)))
	local special_count = 1

	local murdererP = {}
	local sheriffP = {}

	local murderer_refs = {}
	local sheriff_refs = {}

	local murderer_chance_table = {} 
	local sheriff_chance_table = {}
	
	-- Insert murderer chances in murderer_chance_table.
	for p in players.iterate do
		if not (p and p.valid and p.mm and p.mm_save) 
		and not canBeRole(p, count) then continue end
		
		for i=1,p.mm_save.murderer_chance_multi do
			table.insert(murderer_chance_table, p)
		end
	end
	
	for i = 1,special_count do
		local p
		while not (p and p.valid) do
			local _p = murderer_chance_table[P_RandomRange(1,#murderer_chance_table)]
			if not murderer_refs[_p] then
				p = _p
				murderer_refs[_p] = true
			end
		end
		print "got murderer"
		murdererP[i] = p
	end
	
	-- Insert sheriff chances in sheriff_chance_table.
	for p in players.iterate do
		if not (p and p.valid and p.mm and p.mm_save)
		and not canBeRole(p, count) then continue end
		
		if (p == murdererP) then continue end
		
		for i=1,p.mm_save.sheriff_chance_multi do
			table.insert(sheriff_chance_table, p)
		end
	end

	for i = 1,special_count do
		local p
		while not (p and p.valid) do
			local _p = sheriff_chance_table[P_RandomRange(1,#sheriff_chance_table)]
	
			if not sheriff_refs[_p] then
				p = _p
				sheriff_refs[_p] = true
			end
		end
		print "got sheriff"
		sheriffP[i] = p
	end

	for _,p in pairs(murdererP) do
		print "assigned murderer"
		p.mm.role = MMROLE_MURDERER -- murderer
		p.mm_save.murderer_chance_multi = 1
	end

	for _,p in pairs(sheriffP) do
		print "assigned sheriff"
		p.mm.role = MMROLE_SHERIFF -- sheriff
		p.mm_save.sheriff_chance_multi = 1
	end

	for p in players.iterate do
		if not (p and p.valid and p.mm and p.mm_save) then continue end
		
		if (p.mm.role ~= MMROLE_MURDERER) then 
			p.mm_save.murderer_chance_multi = $ + 1
		end 

		if (p.mm.role ~= MMROLE_SHERIFF) then 
			p.mm_save.sheriff_chance_multi = $ + 1
		end
		
		local m_chancecount = 0
		local s_chancecount = 0
		
		local m_percent = "???%"
		local s_percent = "???%"
		
		for _p in players.iterate do
			if not (_p and _p.valid and _p.mm and _p.mm_save) then continue end
			
			for i=1,_p.mm_save.murderer_chance_multi do
				m_chancecount = $ + 1
			end
			
			for i=1,_p.mm_save.sheriff_chance_multi do
				s_chancecount = $ + 1
			end
		end
		
		local result_m = FixedMul( 
							FixedDiv(
								p.mm_save.murderer_chance_multi*FU,
								m_chancecount*FU
							),
							100*FU
						)
						
		local result_s = FixedMul( 
							FixedDiv(
								p.mm_save.sheriff_chance_multi*FU,
								s_chancecount*FU
							),
							100*FU
						)
		
		p.mm_save.cons_murderer_chance = result_m
		p.mm_save.cons_sheriff_chance = result_s
		
		CONS_Printf(p, string.format("\x85Murderer Chance: (%.2f percent)\n\x84Sheriff Chance: (%.2f percent)", result_m, result_s))
	end
	
	if isserver then
		CV_Set(CV_FindVar("restrictskinchange"),0)
	end
	
	MM.runHook("Init")
end