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

return function(self)
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