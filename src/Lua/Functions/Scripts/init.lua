local matchVars = MM.require "Variables/Data/Match"
local shallowCopy = MM.require "Libs/shallowCopy"
local randomPlayer = MM.require "Libs/getRandomPlayer"

local function canBeRole(p, lastRoles, count)
	// TODO: unaware if this causes freezes, test and fix if so
	if count < 2 then
		return true
	end

	if lastRoles[p] then
		return false
	end

	return true
end

return function(self, setovertimepoint)
	if setovertimepoint
		local possiblePoints = {}
		for mt in mapthings.iterate do
			if mt.type <= 35 then
				local z = P_FloorzAtPos(mt.x*FU,mt.y*FU,mt.z*FU,
					mobjinfo[MT_PLAYER].height
				)
				
				table.insert(possiblePoints,{x = mt.x*FU, y = mt.y*FU, z = z, type = mt.type})
			end
		end
		
		local chosenPoint = possiblePoints[P_RandomRange(1,#possiblePoints)]
		
		if chosenPoint == nil then return end
		
		MM_N.overtime_point = P_SpawnMobj(
			chosenPoint.x,
			chosenPoint.y,
			chosenPoint.z,
			MT_THOK
		)
		MM_N.overtime_point.state = S_THOK
		MM_N.overtime_point.tics = -1
		MM_N.overtime_point.fuse = -1
		P_SetOrigin(consoleplayer.mo,
			chosenPoint.x,
			chosenPoint.y,
			chosenPoint.z
		)
		return
	end
	
	MM_N = shallowCopy(matchVars)
	if (MM_N.end_camera and MM_N.end_camera.valid)
		P_RemoveMobj(MM_N.end_camera)
		MM_N.end_camera = nil
	end
	
	local lastMurderers = {}
	local lastSheriffs = {}

	for p in players.iterate do
		local lastRole = p.mm and p.mm.role or MMROLE_INNOCENT

		self:playerInit(p, true)
		p.mm_save.lastRole = lastRole

		if lastRole == MMROLE_SHERIFF then
			lastSheriffs[p] = true
		end
		if lastRole == MMROLE_MURDERER then
			lastMurderers[p] = true
		end
	end

	local count = 0
	for p in players.iterate do
		count = $+1
	end

	MM_N.waiting_for_players = count < 2

	if not (self:isMM() and count >= 2) then return end

	local murdererP = randomPlayer(function(p)
		return p.mm
		and canBeRole(p, lastMurderers, count)
	end)
	local sherriffP = randomPlayer(function(p)
		return p.mm
		and p ~= murdererP
		and canBeRole(p, lastSheriffs, count)
	end)

	murdererP.mm.role = MMROLE_MURDERER -- murderer
	sherriffP.mm.role = MMROLE_SHERIFF -- sherriff
	
	CV_Set(CV_FindVar("restrictskinchange"),0)
end