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
	if p.charability == CA_FLOAT then
		p.charability = CA_NONE
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

addHook("PostThinkFrame", do
	if not MM:isMM() then return end

	for p in players.iterate do
		if p.mo and p.mo.valid and not (p.mo.health) then
			p.mo.flags2 = $|MF2_DONTDRAW
			return
		end
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

local dist_values = {}

dist_values["CLOSE"] = 3000/15
dist_values["NEAR"] = 3000/5
dist_values["FAR"] = 3000/2

local function skinColorToChatColor(color)
	local chatcolor = skincolors[color].chatcolor;

	-- this elseif table is by srb2, not me
	if (not chatcolor or chatcolor>V_INVERTMAP)
		return "\x80"
	elseif (chatcolor == V_MAGENTAMAP)
		return "\x81"
	elseif (chatcolor == V_YELLOWMAP)
		return "\x82";
	elseif (chatcolor == V_GREENMAP)
		return "\x83";
	elseif (chatcolor == V_BLUEMAP)
		return "\x84";
	elseif (chatcolor == V_REDMAP)
		return "\x85";
	elseif (chatcolor == V_GRAYMAP)
		return "\x86";
	elseif (chatcolor == V_ORANGEMAP)
		return "\x87";
	elseif (chatcolor == V_SKYMAP)
		return "\x88";
	elseif (chatcolor == V_PURPLEMAP)
		return "\x89";
	elseif (chatcolor == V_AQUAMAP)
		return "\x8a";
	elseif (chatcolor == V_PERIDOTMAP)
		return "\x8b";
	elseif (chatcolor == V_AZUREMAP)
		return "\x8c";
	elseif (chatcolor == V_BROWNMAP)
		return "\x8d";
	elseif (chatcolor == V_ROSYMAP)
		return "\x8e";
	elseif (chatcolor == V_INVERTMAP)
		return "\x8f"
	end
end

addHook("PlayerMsg", function(src, t, trgt, msg)
	if not MM:isMM() then return end
	if gamestate ~= GS_LEVEL then return end
	if t == 3 then return end

	if not (consoleplayer
		and consoleplayer.mo
		and consoleplayer.mo.health
		and consoleplayer.mm
		and not consoleplayer.mm.spectator) then
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

	if not P_CheckSight(displayplayer.mo, src.mo) then
		if dist > (3000*FU)/4 then return true end

		chatprint("\x86You can hear faint talking through the walls...", true)

		return true
	end

	if dist > 3000*FU then
		return true
	end

	local color = skinColorToChatColor(src.mo and src.mo.color or src.skincolor)
	local name = color.."<"..src.name..">".."\x80"

	if IsPlayerAdmin(src) then
		name = color.."<\x82@"..color..src.name..">".."\x80"
	end
	if src == server then
		name = color.."<\x82~"..color..src.name..">".."\x80"
	end

	local disttext = "[NEAR]"
	if src ~= consoleplayer then
		local distcheck
		for name,_dist in pairs(dist_values) do
			if dist <= _dist*FU
			and (not distcheck or distcheck > _dist*FU) then
				disttext = "["..name.."]"
				distcheck = _dist*FU
				continue
			end
		end

		name = "\x86"..disttext.."\x80".." "..$
	end

	chatprint(name.."\x80 "..msg, true)

	return true
end)

doAndInsert("Murderer")
doAndInsert("Sheriff")