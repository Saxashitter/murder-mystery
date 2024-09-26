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

addHook("PreThinkFrame", do
	if not MM:isMM() then return end
	if not MM.gameover then return end

	for p in players.iterate do
		if (p and p.mm) then
			p.mm.lastside = p.mm.sidemove or 0
			p.mm.lastforward = p.mm.forwardmove or 0
	
			p.mm.forwardmove = p.cmd.forwardmove
			p.mm.sidemove = p.cmd.sidemove
	
			p.mm.buttons = p.cmd.buttons
		end
		p.cmd.forwardmove = 0
		p.cmd.sidemove = 0
		p.cmd.buttons = 0
	end
end)

addHook("ThinkFrame", do
	if not MM:isMM() then return end

	if MM_N.gameover then
		MM_N.end_ticker = $+1
		if MM_N.end_ticker > 15*TICRATE then
			local selected_map = 1
			local most_votes = 0
			for _,map in ipairs(MM_N.mapVote) do
				if map.votes < most_votes then continue end

				selected_map = map.map
				most_votes = map.votes
			end
			G_SetCustomExitVars(selected_map, 2)
			G_ExitLevel()
		end
		return
	end

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
	MM_N.time = max(0, $-1)
	if not (MM_N.time) then
		if not MM_N.ping_time then
			MM_N.pings_done = $+1

			if MM_N.pings_done >= 2 then
				MM_N.pings_done = 0
				MM_N.max_ping_time = max(6, $/2)
			end

			MM_N.ping_time = MM_N.max_ping_time
			MM_N.ping_approx = FixedDiv(MM_N.ping_time, 30*TICRATE)

			MM:pingMurderers(min(MM_N.max_ping_time, 5*TICRATE), MM_N.ping_approx)
		end
		MM_N.ping_time = max(0, $-1)

		for k,pos in pairs(MM_N.ping_positions) do
			pos.time = max($-1, 0)
			if not (pos.time) then
				table.remove(MM_N.ping_positions, k)
			end
		end
	end

	-- gun management
	if leveltime > 10*TICRATE
	and not MM:playerWithGun() then
		local wpns = MM:isWeaponOnMap("Gun")

		if wpns then
			for _,wpn in pairs(wpns) do
				if not (wpn and wpn.valid and wpn.timealive) then
					continue
				end

				if wpn.timealive > 60*TICRATE then
					-- give player gun
					local p = randomPlayer(_eligibleGunPlayer)
					if p then
						MM:giveWeapon(p, "Gun")
						chatprint("!!! - A random player has gotten the gun due to inactivity!")
						P_RemoveMobj(wpn)
					end
				end
			end
		else
			local p = randomPlayer(_eligibleGunPlayer)
			if p then
				MM:giveWeapon(p, "Gun")
				chatprint("!!! - A random player has gotten the gun due to the gun despawning!")
			end
		end
	end
end)