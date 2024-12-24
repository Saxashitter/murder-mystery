states[freeslot "S_PLAY_BODY"] = {
	sprite = SPR_PLAY,
	frame = freeslot "SPR2_OOF_"|A,
	tics = -1
}
spr2defaults[SPR2_OOF_] = SPR2_DEAD

local roles = MM.require "Variables/Data/Roles"

addHook("MobjDeath", function(target, inflictor, source, dmgt)
	if not MM:isMM() then return end
	
	--most likely map damage
	/*
	if not (inflictor and inflictor.valid and source and source.valid)
	and dmgt ~= DMG_DEATHPIT
		P_DoPlayerPain(target.player,target,target)
		P_PlayRinglossSound(target,target.player)
		return true
	end
	*/
	
	if not (target and target.valid and target.player and target.player.mm) then return end

	if not (MM_N.waiting_for_players or CV_MM.debug.value) then
		target.player.mm.spectator = true
	end

	for k,v in pairs(target.player.mm.inventory.items) do
		MM:DropItem(target.player, k, true, true)
	end
	
	if target.player.mm.role ~= MMROLE_MURDERER
		--people like to shoot each other and fall into pits,
		--so we wouldnt be able to get those kills
		--actually i changed my mind
		if (source and source.valid)
		and (source.player)
		and (source.player.mm.role == MMROLE_MURDERER)
			MM_N.peoplekilled = $+1
		end
	end
	
	if (source
	and source.player
	and source.player.mm
	and target
	and target.player
	and target.player.mm
	and roles[source.player.mm.role].team == roles[target.player.mm.role].team
	and not roles[source.player.mm.role].cankillmates) then
		chatprintf(source.player, "\x82*That was not the murderer. You were killed for friendly fire!", true)
		P_DamageMobj(source, nil, nil, 999, DMG_INSTAKILL)
		target.player.mm.whokilledme = "Killed by someone else's stupidity."
	end

	if not MM:canGameEnd()
	and MM_N.special_count >= 2 then
		if target.player.mm.role ~= MMROLE_INNOCENT
			if target.player.mm.role == MMROLE_MURDERER
				local text = "\x82*"..target.player.name.." was a murderer!"
				
				/*
				if source
				and source.player then
					text = $.." // Died to "..source.player.name
				elseif source
					--died to an mobj
					text = $.." // Died to an mobj."
				else
					text = $.." // Died to a hazard."
				end
				*/
				
				chatprint(text)
			end
			
			local color = roles[target.player.mm.role].colorcode
			for p in players.iterate()
				if not (p.mm) then continue end
				if (p.mm.spectator) then continue end
				
				if (p.mm.role == target.player.mm.role)
				and (p == consoleplayer)
					MMHUD:PushToTop(5*TICRATE,
						"TEAMMATE DEAD",
						"Your teammate, "..color..target.player.name.."\x80 died!"
					)
				end
			end
		end
	end

	--numbers for hacky hud stuff
	target.player.mm.whokilledme = source or 123123
	
	local angle = (inflictor and inflictor.valid) and R_PointToAngle2(target.x, target.y, inflictor.x, inflictor.y) or target.angle
	target.deathangle = angle
	
	if MM:canGameEnd() and not MM_N.gameover 
	and not (CV_MM.debug.value) then
		-- funny sniper sound
		if target.player.mm.role == MMROLE_SHERIFF and source and source.valid then
			local dist = R_PointToDist2(
				R_PointToDist2(target.x, target.y, source.x, source.y), target.z,
				0, source.z
			)
			local required_dist = FU*4500
			local required_speed = FU*20
			if not P_IsObjectOnGround(target) then
				required_dist = FU*2500
				required_speed = FU*12
			end
			if dist > required_dist and target.player.speed > required_speed then
				MM_N.sniped_end = true
				S_ChangeMusic("mmtf2o", false, nil)
			end
			-- print("dist " .. dist/FU)
			-- print("speed " .. target.player.speed/FU)
		end

		S_StartSound(nil,sfx_buzz3)
		S_StartSound(nil,sfx_s253)
		local facingangle = target.player.drawangle + ANGLE_180
		if (source and source.valid)
			facingangle = R_PointToAngle2(target.x,target.y, source.x,source.y)
		end
		MM:startEndCamera(target,
			facingangle,
			200*FU,
			6*TICRATE,
			FU/16
		)
		target.state = (target.player.mm.end_deathstate and S_PLAY_DEAD or S_PLAY_PAIN)
		target.flags2 = $ &~MF2_DONTDRAW
		target.angle = angle
		MM_N.killing_end = true
		
		if source and source.valid
			source.momx,source.momy = 0,0
		end
		
		if target.player.mm.role == 2
			MM_N.end_killed = target
			MM_N.end_killer = source
		else
			MM_N.end_killed = source
			MM_N.end_killer = target
		end
		MM:discordMessage("***The round has ended!***\n")
		
		do
			local sherrifs = {}
			local murderers = {}
			for p in players.iterate
				if not (p.mm) then continue end
				
				local status = (p.mm.spectator) and " (Dead)" or ''
				if (p.mm.role == MMROLE_SHERIFF)
					table.insert(sherrifs,p.name..status)
				elseif (p.mm.role == MMROLE_MURDERER)
					table.insert(murderers,p.name..status)
				end
			end
			
			if #murderers > 0
				local str = ''
				for k,name in ipairs(murderers)
					str = $ .. "*"..name.."*, "
				end
				MM:discordMessage("***Murderers:*** "..str.."\n")
			end
			if #sherrifs > 0
				local str = ''
				for k,name in ipairs(sherrifs)
					str = $ .. "*"..name.."*, "
				end
				MM:discordMessage("***Sheriffs:*** "..str.."\n")
			end
			
		end
		
		return
	end

	local corpse = P_SpawnMobjFromMobj(target, 0,0,0, MT_THOK)

	target.flags2 = $|MF2_DONTDRAW

	corpse.skin = target.skin
	corpse.color = target.color
	corpse.state = S_PLAY_BODY
	corpse.colorized = target.colorized

	corpse.angle = angle
	corpse.flags = 0
	corpse.flags2 = 0
	corpse.tics = -1
	corpse.fuse = -1
	corpse.shadowscale = target.shadowscale
	corpse.radius = target.radius
	
	P_InstaThrust(corpse, angle, -8*FU)
	P_SetObjectMomZ(corpse,6*FU)

	MM_N.corpses[#MM_N.corpses+1] = corpse
	corpse.playerid = #target.player
	corpse.playername = target.player.name

	MM.runHook("CorpseSpawn", target, corpse)
end, MT_PLAYER)

--TODO: player mobjs arent hidden anymore
addHook("ThinkFrame", function()
	if not MM:isMM() then return end

	if MM_N.gameover
	and not MM_N.voting
		for p in players.iterate() do
			if p.mo and not (p.mo.health) then
				
				if p.mo.stormkilledme
					p.mo.color = SKINCOLOR_GALAXY
					p.mo.colorized = true
				end
				
				--Endcam cutscene
				local releaseTic = 3*TICRATE
				if MM_N.sniped_end then
					-- for music timing
					releaseTic = 3*TICRATE + MM.sniper_theme_offset
				end
				if MM_N.end_ticker < releaseTic
					p.deadtimer = min($,3)
					p.mo.momx,p.mo.momy,p.mo.momz = 0,0,0
					p.mo.flags2 = $ &~MF2_DONTDRAW
					p.mo.flags = $ | MF_NOGRAVITY
					p.mo.state = (p.mm.end_deathstate and S_PLAY_DEAD or S_PLAY_PAIN)
					continue
					
				elseif MM_N.end_ticker == releaseTic
					local corpse = P_SpawnMobjFromMobj(p.mo, 0,0,0, MT_THOK)
					
					corpse.skin = p.mo.skin
					corpse.color = p.mo.color
					corpse.state = S_PLAY_BODY
					corpse.colorized = p.mo.colorized
					corpse.shadowscale = p.mo.shadowscale
					
					corpse.angle = p.mo.deathangle
					corpse.flags = 0
					corpse.flags2 = 0
					corpse.tics = -1
					corpse.fuse = -1

					P_InstaThrust(corpse, p.mo.deathangle, -8*FU)
					P_SetObjectMomZ(corpse,6*FU)
				end
				
				p.mo.flags2 = $|MF2_DONTDRAW
				continue
			end
		end
	end
	
	for _,corpse in pairs(MM_N.corpses) do
		if not (corpse and corpse.valid) then
			table.remove(MM_N.corpses, _)
			continue
		end
		
		if corpse.playerid -- idk why the MF2_DONTDRAW above is only when the game ends :P, maybe y'all should see that?
		and (players[corpse.playerid] and players[corpse.playerid].valid)
		and (players[corpse.playerid].mo and players[corpse.playerid].mo.valid)
			if not players[corpse.playerid].mo.health
			and not (players[corpse.playerid].mo.flags2 & MF2_DONTDRAW) then
				players[corpse.playerid].mo.flags2 = $1|MF2_DONTDRAW
			end
		end
		
		MM.runHook("CorpseThink", corpse)

		for p in players.iterate do
			if not (p and p.mo and p.mo.health and p.mm and p.mm.role ~= MMROLE_MURDERER and not p.mm.spectator) then
				continue
			end

			if P_CheckSight(corpse, p.mo)
			and R_PointToDist(corpse.x, corpse.y, p.mo.x, p.mo.y) < 2000*FU
			and not (MM_N.knownDeadPlayers[corpse.playerid]) then
				chatprint("\x82*The corpse of "..corpse.playername.." has been found!")
				MM_N.knownDeadPlayers[corpse.playerid] = true
				MM.runHook("CorpseFound", corpse, p.mo)
			end
		end
	end
end)