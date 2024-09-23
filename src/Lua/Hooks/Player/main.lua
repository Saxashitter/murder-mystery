local scripts = {}

states[freeslot "S_PLAY_BODY"] = {
	sprite = SPR_PLAY,
	frame = freeslot "SPR2_OOF_"|A,
	tics = -1
}

local function doAndInsert(file)
	local func = dofile("Hooks/Player/Scripts/"..file)

	scripts[#scripts+1] = func
end

addHook("PlayerThink", function(p)
	if not MM:isMM() then return end

	if not p.mm then
		MM:playerInit(p)
	end

	if not (p.mo and p.mo.valid and p.mo.health) then
		if (p.mo and not p.mo.health) then
			p.mo.flags2 = $|MF2_DONTDRAW
		end
		return
	end

	if p.charability == CA_GLIDEANDCLIMB then
		if p.climbing then
			p.climbing = 0
			p.mo.state = S_PLAY_JUMP
		end
	end
	if p.charability == CA_FLY then
		p.powers[pw_tailsfly] = min(TICRATE, $)
	end
	if p.charability2 == CA2_GUNSLINGER then
		p.charability2 = CA2_NONE
	end

	p.spectator = p.mm.spectator
	if p.mm.spectator then
		return
	end

	for _,script in ipairs(scripts) do
		script(p)
	end
end)

addHook("MobjDeath", function(target, inflictor, source)
	if not MM:isMM() then return end
	if not (target and target.valid and target.player and target.player.mm) then return end

	target.player.mm.spectator = true

	if target.player.mm.weapon and target.player.mm.weapon.valid then
		MM:spawnDroppedWeapon(target.x, target.y, target.z, target.player.mm.weapon.__type)

		if target.player.mm.role == 3 then
			-- oh, thats the sheriff
			-- notify everyone that the sheriff is dead
			chatprint(" !!! - The sheriff has died! Find his gun!", true)
		end

		P_RemoveMobj(target.player.mm.weapon)
		target.player.mm.weapon = nil
	end

	if (source
	and source.player
	and source.player.mm
	and source.player.mm.role ~= 2
	and target.player.mm.role ~= 2) then
		chatprintf(source.player, " !!! - That was not the murderer. You were killed for friendly fire!", true)
		P_DamageMobj(source, nil, nil, 999, DMG_INSTAKILL)
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

addHook("ViewpointSwitch", function(p, p2, f)
	if not (MM:isMM() and p.mm and not p.mm.spectator) then return end
	return p2 == p
end)

addHook("PlayerMsg", function(src, t, trgt, msg)
	if not MM:isMM() then return end
	if gamestate ~= GS_LEVEL then return end
	if t == 4 then return end

	if not (displayplayer
		and displayplayer.mo
		and displayplayer.mo.health
		and displayplayer.mm
		and not displayplayer.mm.spectator) then
			return
	end
	if not (src
		and src.mo
		and src.mo.health
		and src.mm
		and not src.mm.spectator) then
			return true
	end

	local dist = R_PointToDist2(displayplayer.mo.x, displayplayer.mo.y,
		src.mo.x,
		src.mo.y)

	if dist > 1500*FU then
		return true
	end
end)

doAndInsert("Murderer")
doAndInsert("Sheriff")