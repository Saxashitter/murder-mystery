local getCount = MM.require "Libs/getCount"
local randomPlayer = MM.require "Libs/getRandomPlayer"
local roles = MM.require "Variables/Data/Roles"

local function _eligibleGunPlayer(p)
	return p
	and p.mo
	and p.mo.valid
	and p.mo.health
	and p.mm
	and not p.mm.spectator
	and p.mm.role ~= MMROLE_MURDERER
	and not (p.mm.weapon and p.mm.weapon.valid)
end

return function()
	if (MM_N.dueling) then return end
	
	local _,innocents = getCount()

	-- gun management
	if not (not MM:pregame()
	and not MM:playerWithGun()
	and innocents >= 1) then
		return
	end
	
	local lostgun = roles[MMROLE_SHERIFF].weapon or "revolver"
	local wpns = MM:GetCertainDroppedItems(lostgun)

	if #wpns then
		for _,wpn in pairs(wpns) do
			if wpn.timealive == nil then
				wpn.timealive = 0
			end

			wpn.timealive = $+1

			if wpn.timealive > 20*TICRATE then
				-- give player gun
				local p = randomPlayer(_eligibleGunPlayer)
				if p then
					MM:GiveItem(p, lostgunn)
					for play in players.iterate do
						if play == p then
							chatprintf(play,"\x82*You have been given the gun!",true)
						else
							chatprintf(play,"\x82*A random player has received the gun due to inactivity!")
						end
					end
					MM:discordMessage("***A random player has received the gun due to inactivity!***\n")
					P_RemoveMobj(wpn)
				end
			end
		end

		return
	end

	local p = randomPlayer(_eligibleGunPlayer)
	if p and not MM:canGameEnd() then
		MM:GiveItem(p, lostgun)
		for play in players.iterate
			if play == p
				chatprintf(play,"\x82*You have been given the gun!",true)
			else
				chatprintf(play,"\x82*A random player has received the gun due to the gun despawning!")
			end
		end
		MM:discordMessage("***A random player has received the gun due to the gun despawning!***\n")
	end
end