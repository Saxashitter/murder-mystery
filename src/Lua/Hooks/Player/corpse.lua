states[freeslot "S_PLAY_BODY"] = {
	sprite = SPR_PLAY,
	frame = freeslot "SPR2_OOF_"|A,
	tics = -1
}
spr2defaults[SPR2_OOF_] = SPR2_DEAD

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

	if MM_N.waiting_for_players then
		target.player.mm.spectator = true
	end

	if target.player.mm.weapon and target.player.mm.weapon.valid then
		MM:spawnDroppedWeapon(target.x, target.y, target.z, target.player.mm.weapon.__type)

		if (target.player.mm.weapon and target.player.mm.weapon.valid) then
			-- oh, thats the gun haver
			-- notify everyone that they died
			local type = "gun holder"
			if target.player.mm.role == MMROLE_SHERIFF then
				type = "sheriff"
			end
			chatprint("!!! - The "..type.." has died! Find his gun!", true)
		end

		P_RemoveMobj(target.player.mm.weapon)
		target.player.mm.weapon = nil
	end

	if (source
	and source.player
	and source.player.mm
	and source.player.mm.role ~= MMROLE_MURDERER
	and target.player.mm.role ~= MMROLE_MURDERER) then
		chatprintf(source.player, "!!! - That was not the murderer. You were killed for friendly fire!", true)
		P_DamageMobj(source, nil, nil, 999, DMG_INSTAKILL)
	end
	
	target.player.mm.whokilledme = source
	
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