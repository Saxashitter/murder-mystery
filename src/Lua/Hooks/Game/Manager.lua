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

addHook("PreThinkFrame", function()
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
		p.powers[pw_underwater] = underwatertics*2
		p.powers[pw_spacetime] = spacetimetics*2
	end
end)

local function is_showdown(innocents, count)
	if count > 2 then
		return innocents == 1
	end

	return false
end

addHook("ThinkFrame", function()
	if not MM:isMM() then return end

	if MM_N.gameover then
		if MM_N.voting
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
		else
			MM_N.end_ticker = $+1
			
			if (MM_N.end_camera and MM_N.end_camera.valid)
				MM:startEndCamera()
			end
			
			if MM_N.end_ticker == 3*TICRATE
				for mo in mobjs.iterate()
					if not (mo and mo.valid) then continue end
					
					if mo.notthinking
						continue
					end
					
					mo.flags = $ &~MF_NOTHINK
				end
			end
			
			if MM_N.end_ticker >= 5*TICRATE
				MM_N.end_ticker = 1
				MM:startVote()
			end
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
			MM_N.waiting_for_players = false
		end
		return
	end

	local count = 0
	local innocents = 0
	local murderers = 0

	for p in players.iterate do
		if not (p and p.mo and p.mm) then continue end
		if p.mm.joinedmidgame then continue end

		count = $+1

		if p.mm.spectator then continue end
		if p.mm.role == 2 then
			murderers = $+1
			continue
		end

		innocents = $+1
	end

	local canEnd, endType = MM:canGameEnd()

	if canEnd then
		MM:endGame(endType or 1)
		if not MM_N.killing_end
			MM_N.disconnect_end = true
			MM_N.end_ticker = 3*TICRATE - 1
			S_StartSound(nil,sfx_s253)
		end
	end

	-- 1 innocent? start showdown
	if is_showdown(innocents, count)
	and not MM_N.showdown then
		MM_N.showdown = true
	end

	if MM_N.showdown then
		if mapmusname ~= "MADEDE" then
			mapmusname = "MADEDE"
			S_ChangeMusic("MADEDE", true)
		end

		MM_N.showdown_ticker = $+1
	end


	-- time management
	MM_N.time = max(0, $-1)
	if not (MM_N.time)
	and not MM_N.showdown then 
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
	
	--Funny
	if leveltime == 10*TICRATE
		CV_Set(CV_FindVar("restrictskinchange"),1)
	end
	
	-- gun management
	if leveltime > 10*TICRATE
	and not MM:playerWithGun()
	and not MM_N.gameover
	and innocents > 1 then
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
			if p and not MM:canGameEnd() then
				MM:giveWeapon(p, "Gun")
				chatprint("!!! - A random player has gotten the gun due to the gun despawning!")
			end
		end
	end
end)