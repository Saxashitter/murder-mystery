states[freeslot "S_PLAY_BODY"] = {
	sprite = SPR_PLAY,
	frame = freeslot "SPR2_OOF_"|A,
	tics = -1
}

addHook("MobjDeath", function(target, inflictor, source)
	if not MM:isMM() then return end
	if not (target and target.valid and target.player and target.player.mm) then return end

	target.player.mm.spectator = true

	if target.player.mm.weapon and target.player.mm.weapon.valid then
		MM:spawnDroppedWeapon(target.x, target.y, target.z, target.player.mm.weapon.__type)

		if target.player.mm.role == 3 then
			-- oh, thats the sheriff
			-- notify everyone that the sheriff is dead
			chatprint("!!! - The sheriff has died! Find his gun!", true)
		end

		P_RemoveMobj(target.player.mm.weapon)
		target.player.mm.weapon = nil
	end

	if (source
	and source.player
	and source.player.mm
	and source.player.mm.role ~= 2
	and target.player.mm.role ~= 2) then
		chatprintf(source.player, "!!! - That was not the murderer. You were killed for friendly fire!", true)
		P_DamageMobj(source, nil, nil, 999, DMG_INSTAKILL)
	end
	
	target.player.mm.whokilledme = source
	
	/*
	local headcount = 0
	for p in players.iterate
		if p.spectator
		or not (p.mo and p.mo.valid and p.mo.health)
		or (p.mm and p.mm.spectator)
			continue
		end
		headcount = $+1
	end

	local innocents = 0
	local murderers = 0
	for p in players.iterate do
		if not (p
		and p.mo
		and p.mo.health
		and not p.mm.spectator) then
			continue
		end

		if p.mm.role == 2 then
			murderers = $+1
			continue
		end

		innocents = $+1
	end
	*/
	
	local angle = (inflictor and inflictor.valid) and R_PointToAngle2(target.x, target.y, inflictor.x, inflictor.y) or target.angle
	target.deathangle = angle
	
	if MM:canGameEnd() then
		S_StartSound(nil,sfx_buzz3)
		S_StartSound(nil,sfx_s253)
		MM:startEndCamera(target,
			target.player.drawangle + ANGLE_180,
			200*FU,
			6*TICRATE,
			FU/16
		)
		target.state = (target.player.mm.end_deathstate and S_PLAY_DEAD or S_PLAY_PAIN)
		target.flags2 = $ &~MF2_DONTDRAW
		target.angle = angle
		MM_N.killing_end = true
		return
	end
	

	local corpse = P_SpawnMobjFromMobj(target, 0,0,0, MT_THOK)

	target.flags2 = $|MF2_DONTDRAW

	corpse.skin = target.skin
	corpse.color = target.color
	corpse.state = S_PLAY_BODY

	corpse.angle = angle
	corpse.flags = 0
	corpse.flags2 = 0
	corpse.tics = -1
	corpse.fuse = -1

	P_InstaThrust(corpse, angle, -8*FU)
	P_SetObjectMomZ(corpse,6*FU)
end, MT_PLAYER)

addHook("ThinkFrame", function()
	if not MM:isMM() then return end

	for p in players.iterate() do
		if p.mo and not (p.mo.health) then
		
			if MM_N.gameover
				if MM_N.end_ticker < 3*TICRATE
				and not MM_N.voting
					p.deadtimer = min($,3)
					p.mo.momx,p.mo.momy,p.mo.momz = 0,0,0
					p.mo.flags2 = $ &~MF2_DONTDRAW
					p.mo.state = (p.mm.end_deathstate and S_PLAY_DEAD or S_PLAY_PAIN)
					continue
					
				elseif MM_N.end_ticker == 3*TICRATE
				and not MM_N.voting
					local corpse = P_SpawnMobjFromMobj(p.mo, 0,0,0, MT_THOK)
					
					corpse.skin = p.mo.skin
					corpse.color = p.mo.color
					corpse.state = S_PLAY_BODY
					
					corpse.angle = p.mo.deathangle
					corpse.flags = 0
					corpse.flags2 = 0
					corpse.tics = -1
					corpse.fuse = -1

					P_InstaThrust(corpse, p.mo.deathangle, -8*FU)
					P_SetObjectMomZ(corpse,6*FU)
				end
			end
			
			p.mo.flags2 = $|MF2_DONTDRAW
			continue
		end
	end
end)