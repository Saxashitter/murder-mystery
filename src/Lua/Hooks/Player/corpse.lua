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
	
	--TODO: make this better and determine if this kill is a winning kill
	local headcount = 0
	for p in players.iterate
		if p.spectator
		or not (p.mo and p.mo.valid and p.mo.health)
		or (p.mm and p.mm.spectator)
			continue
		end
		headcount = $+1
	end
	
	if headcount == 2
		S_StartSound(target,sfx_buzz3)
		S_StartSound(nil,sfx_s253)
		MM:startEndCamera(target,
			target.player.drawangle + ANGLE_180,
			200*FU,
			6*TICRATE,
			FU/16
		)
	end
	

	local corpse = P_SpawnMobjFromMobj(target, 0,0,0, MT_THOK)

	target.flags2 = $|MF2_DONTDRAW

	corpse.skin = target.skin
	corpse.color = target.color
	corpse.state = S_PLAY_BODY

	local angle = (inflictor and inflictor.valid) and R_PointToAngle2(target.x, target.y, inflictor.x, inflictor.y) or target.angle

	corpse.angle = angle
	corpse.flags = 0
	corpse.flags2 = 0
	corpse.tics = -1
	corpse.fuse = -1

	P_InstaThrust(corpse, angle, -8*FU)
	corpse.momz = 6*(FU*P_MobjFlip(corpse))
end, MT_PLAYER)

addHook("ThinkFrame", function()
	if not MM:isMM() then return end

	for p in players.iterate() do
		if p.mo and not (p.mo.health) then
			p.mo.flags2 = $|MF2_DONTDRAW
			continue
		end
	end
end)