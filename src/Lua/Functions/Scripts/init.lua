local matchVars = MM.require "Variables/Data/Match"
local shallowCopy = MM.require "Libs/shallowCopy"
local randomPlayer = MM.require "Libs/getRandomPlayer"

local function canBeRole(p, count)
	if count < 2 then
		return true
	end
	
	return true
end

freeslot("MT_MM_STORMDIST")
mobjinfo[MT_MM_STORMDIST] = {
	--$Name Storm Radius Point
	--$Sprite BGLSC0
	--$Category SaxaMM
	flags = MF_NOSECTOR|MF_NOTHINK|MF_SCENERY,
	radius = 28*FRACUNIT,
	height = 1,
	doomednum = 3002,
	spawnstate = S_NULL
}

local function set_overtime_point()
	local possiblePoints = {}
	local radiuspoints = {}
	for mt in mapthings.iterate do
		if mt.type == mobjinfo[MT_MM_STORMDIST].doomednum
			if #radiuspoints < 2
				table.insert(radiuspoints,{x = mt.x*FU, y = mt.y*FU})
			else
				print("\x82WARNING:\x80 This map has more than 2 Storm Radius Points! Only place 2 on each edge of your desired range.")
			end
		end
		
		if mt.type <= 35 then
			local z = P_FloorzAtPos(mt.x*FU,mt.y*FU,mt.z*FU,
				mobjinfo[MT_PLAYER].height
			)
			
			table.insert(possiblePoints,{x = mt.x*FU, y = mt.y*FU, z = z, a = mt.angle*ANG1, type = mt.type})
		end
	end
	
	MM_N.storm_ticker = 0
	
	local chosenKey = P_RandomRange(1,#possiblePoints)
	local chosenPoint = possiblePoints[chosenKey]
	if chosenPoint == nil then return end
	
	if #radiuspoints < 2
		--Find the farthest possible point
		local olddist = 4096*FU
		for k,v in ipairs(possiblePoints) do
			if v == chosenPoint then continue end

			--add 256 as a small buffer to let people get to the middle
			local distTo = R_PointToDist2(v.x,v.y, chosenPoint.x,chosenPoint.y) + 256*FU
			if distTo < olddist then continue end
			olddist = distTo
		end
		MM_N.storm_startingdist = olddist
	else
		local rp = radiuspoints
		MM_N.storm_startingdist = R_PointToDist2(
			rp[1].x, rp[1].y,
			rp[2].x, rp[2].y
		)
		MM_N.storm_usedpoints = true
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
	MM_N.storm_point.flags = MF_NOCLIPTHING
	
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
	MM_N.storm_garg = garg
	
	--table.remove(possiblePoints,chosenKey)
	MM_N.storm_point.otherpoints = possiblePoints
end

return function(self, maploaded)
	if maploaded then
		if not MM:isMM() then return end
		
		MM_N.clues_weaponsleft = max(MM:countPlayers().innocents/3,1)
		local clue_amm = 5
		if (mapheaderinfo[gamemap].mm_clueamount ~= nil)
		and tonumber(mapheaderinfo[gamemap].mm_clueamount)
			clue_amm = abs(tonumber(mapheaderinfo[gamemap].mm_clueamount))
		end
		
		set_overtime_point()
		if clue_amm ~= 0
			MM:giveOutClues(clue_amm)
		end
		
		MM_N.lastmap = gamemap
		MM.runHook("PostMapLoad")
		return
	end
	
	MM_N = shallowCopy(matchVars)
	if (MM_N.end_camera and MM_N.end_camera.valid) then
		P_RemoveMobj(MM_N.end_camera)
		MM_N.end_camera = nil
	end

	local count = 0
	for p in players.iterate do
		self:playerInit(p, true)
		count = $+1
	end

	MM_N.waiting_for_players = count < 2

	if not (self:isMM() and count >= 2) then return end

	local special_count = P_RandomRange(1, max(1, min(count/6, 3)))
	MM_N.special_count = special_count

	MM:assignRoles(special_count)
	
	local innocents = 0
	for p in players.iterate do
		if (p.mm and p.mm.role ~= MMROLE_MURDERER)
			innocents = $+1
		end
		
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
	MM_N.minimum_killed = max(1,innocents/5)
	
	if isserver then
		CV_Set(CV_FindVar("restrictskinchange"),0)
	end
	
	MM.runHook("Init")
end
