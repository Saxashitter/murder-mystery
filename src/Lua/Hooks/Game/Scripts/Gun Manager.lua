local getCount = MM.require "Libs/getCount"
local randomPlayer = MM.require "Libs/getRandomPlayer"
local roles = MM.require "Variables/Data/Roles"
local lostgun = roles[MMROLE_SHERIFF].weapon or "revolver"

local function _eligibleGunPlayer(p)
	local hasfreeslot = false
	local inv = p.mm.inventory
	for i = 1, inv.count
		if inv.items[i] == nil
			hasfreeslot = true
			break
		end
	end
	
	return p
	and p.mo
	and p.mo.valid
	and p.mo.health
	and p.mm
	and not p.mm.spectator
	and p.mm.role ~= MMROLE_MURDERER
	and not (p.mm.weapon and p.mm.weapon.valid)
	and hasfreeslot
end

--refill and empty murd/sheriff slots left by players who left
local function refillSlots()
	if MM_N.dueling then return end
	if not MM:pregame() then return end
	
	local count = MM.countPlayers()
	local maxrole = MM_N.special_count
	
	if count.murderers < maxrole
	or count.sheriffs < maxrole
		MM:assignRoles(maxrole - min(count.murderers, count.sheriffs),
			true,
			count.murderers < count.sheriffs
		)
		if CV_MM.debug.value
			print("\x83MM:\x80 Special roles too low! Reassigning roles...")
		end
	end
end

return function()
	if (MM_N.dueling) then return end
	refillSlots()
	if (CV_MM.debug.value) then return end
	
	local _,innocents = getCount()

	-- gun management
	if not (not MM:pregame()
	and not MM:playerWithGun()
	and innocents >= 1) then
		return
	end
	
	--shitty
	if (MM_N.gavegun)
		MM_N.gavegun = nil
		return
	end
	
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
					MM:GiveItem(p, lostgun)
					
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
				MM_N.gavegun = true
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