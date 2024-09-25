local randomPlayer = MM.require "Libs/getRandomPlayer"

local function _eligibleGunPlayer(p)
	return p
	and p.mo
	and p.mo.valid
	and p.mo.health
	and p.mm
	and not p.mm.spectator
	and p.mm.role ~= 2
	and not (p.mm.weapon and p.mm.weapon.valid)
end

addHook("ThinkFrame", do
	if not MM:isMM() then return end

	if MM_N.waiting_for_players then
		local playersIn = 0
		for p in players.iterate do
			playersIn = $+1
		end

		if playersIn >= 2 then
			COM_BufInsertText(server, "map "..G_BuildMapName(gamemap).." -f")
		end
		return
	end

	// is time up?

	local innocents = 0
	local murderers = 0

	for p in players.iterate do
		if not (p and p.mo and p.mm and not p.mm.spectator) then continue end

		if p.mm.role == 2 then
			murderers = $+1
			continue
		end

		innocents = $+1
	end

	if not (murderers) then
		MM:endGame(1)
		return
	end
	if not (innocents) then
		MM:endGame(2)
		return
	end

	-- time management
	MM_N.time = $-1

	-- gun management
	if leveltime > 10*TICRATE
	and not MM:playerWithGun() then
		local wpns = MM:isWeaponOnMap("Gun")

		if wpns then
			for _,wpn in pairs(wpns) do
				if not (wpn and wpn.valid and wpn.timealive) then
					continue
				end

				if wpn.timealive > TICRATE then
					-- give player gun
					local p = randomPlayer(_eligibleGunPlayer)
					if p then
						MM:giveWeapon(p, "Gun")
						chatprint(" !!! - A random player has gotten the gun due to inactivity!")
						P_RemoveMobj(wpn)
					end
					break
				end
			end
		else
			local p = randomPlayer(_eligibleGunPlayer)
			if p then
				MM:giveWeapon(p, "Gun")
				chatprint(" !!! - A random player has gotten the gun due to the gun despawning!")
			end
		end
	end
end)