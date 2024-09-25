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
	if MM.gameover then return end
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