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
	
	local chosenPoint = possiblePoints[P_RandomRange(1,#possiblePoints)]
	
	MM_N.overtime_ticker = 0
	
	if chosenPoint == nil then return end
	
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
	
	MM_N.overtime_point = P_SpawnMobj(
		chosenPoint.x,
		chosenPoint.y,
		chosenPoint.z,
		MT_THOK
	)
	MM_N.overtime_point.state = S_THOK
	MM_N.overtime_point.tics = -1
	MM_N.overtime_point.fuse = -1
	MM_N.overtime_point.flags2 = $|MF2_DONTDRAW
	
	local garg = P_SpawnMobjFromMobj(
		MM_N.overtime_point,
		0,0,0,
		MT_GARGOYLE
	)
	garg.flags = MF_NOCLIPTHING|MF_SOLID
	garg.colorized = true
	garg.color = SKINCOLOR_GALAXY
	garg.scale = $*2
	garg.angle = chosenPoint.a
end

return function(self, maploaded)
	if maploaded then
		set_overtime_point()
		--MM:giveOutClues(5)
		
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
	
	local murdererP
	local sheriffP
	
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
	
	murdererP = murderer_chance_table[P_RandomRange(1,#murderer_chance_table)]
	
	-- Insert sheriff chances in sheriff_chance_table.
	for p in players.iterate do
		if not (p and p.valid and p.mm and p.mm_save)
		and not canBeRole(p, count) then continue end
		
		if (p == murdererP) then continue end
		
		for i=1,p.mm_save.sheriff_chance_multi do
			table.insert(sheriff_chance_table, p)
		end
	end
	
	sheriffP = sheriff_chance_table[P_RandomRange(1,#sheriff_chance_table)]

	murdererP.mm.role = MMROLE_MURDERER -- murderer
	murdererP.mm_save.murderer_chance_multi = 1

	sheriffP.mm.role = MMROLE_SHERIFF -- sheriff
	sheriffP.mm_save.sheriff_chance_multi = 1
	
	if murdererP and murdererP.valid
	and sheriffP and sheriffP.valid then
		for p in players.iterate do
			if not (p and p.valid and p.mm and p.mm_save) then continue end
			
			if (p ~= murdererP) then 
				p.mm_save.murderer_chance_multi = $ + 1
			end 

			if (p ~= sheriffP) then 
				p.mm_save.sheriff_chance_multi = $ + 1
			end
		end
		
		for p in players.iterate do
			if not (p and p.valid and p.mm and p.mm_save) then continue end
			
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
			
			
			CONS_Printf(p, string.format("\x85Murderer Chance: (%.2f percent)\n\x84Sheriff Chance: (%.2f percent)", result_m, result_s))
		end
	end
	
	if isserver then
		CV_Set(CV_FindVar("restrictskinchange"),0)
	end

	MM_N.ptsr_mode = P_RandomRange(1, 10) >= 7
	-- HEADS UP! this might be an external mod in the future when we clean up the code
	-- the reason behind this is cause we dislike bloat
	-- and i only did this cause i made a promise
	-- - saxashitter

	MM.runHook("Init")
end