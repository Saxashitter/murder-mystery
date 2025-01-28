local dist_values = {}

dist_values["CLOSE"] = 3000/15
dist_values["NEAR"] = 3000/5
dist_values["FAR"] = 3000/2

local function skinColorToChatColor(color)
	local chatcolor = skincolors[color].chatcolor;

	-- this elseif table is by srb2, not me
	if (chatcolor == V_MAGENTAMAP)
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

	return "\x80"
end

addHook("PlayerMsg", function(src, t, trgt, msg)
	if not MM:isMM() then return end
	if gamestate ~= GS_LEVEL then return end
	if MM.gameover then return end
	if t == 3 then return end
	
	--allow dedicated server chats?
	if (src == server and not players[0]) then return end

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
	
	if MM.runHook("OnRawChat", src, t, trgt, msg) then
		return true
	end
	
	--talk from cameras
	if (src.mmcam and src.mmcam.cam and src.mmcam.cam.valid)
		MMCAM.CameraSay(src,src.mmcam.cam,msg)
	--talk to cameras
	elseif #MMCAM.TOTALCAMS ~= nil
		local me = src.mo
		for k,cam in ipairs(MMCAM.TOTALCAMS)
			
			if not (me and me.valid) then break end
			if not (cam.health) then continue end
			if not P_CheckSight(me,cam) then continue end
			
			local dist = R_PointToDist2(me.x,me.y, cam.x,cam.y)
			if dist > MMCAM.far_dist*cam.scale then continue end
			
			--send our message to the cameramen (skibidi)
			for i = 0,#players - 1
				local p = cam.args.players[i]
				
				if not (p and p.valid) then continue end
				if not (p.mm) then continue end
				if (p.spectator or p.mm.spectator) then continue end
				
				chatprintf(p,"\x86[CAM]<"..src.name..">\x80 "..msg,true)
			end
		end
	end

	local plrname = src.name
	local alias = src.mm.alias
	
	local perm_level = MM:getpermlevel(src)

	if alias then
		if alias.perm_level ~= nil then
			perm_level = alias.perm_level
		end
		
		if alias.name then
			plrname = alias.name
		end
	end
	
	local dist = R_PointToDist2(consoleplayer.mo.x, consoleplayer.mo.y,
		src.mo.x,
		src.mo.y)

	if not P_CheckSight(consoleplayer.mo, src.mo)
	and dist >= 192*FU then
		if dist > (3000*FU)/4 then return true end

		chatprint("\x86You can hear faint talking through the walls...", true)
		return true
	end

	if dist > 3000*FU then
		return true
	end

	local color = skinColorToChatColor(src.mo and src.mo.color or src.skincolor)
	
	if alias
	and alias.skincolor then
		color = skinColorToChatColor(alias.skincolor)
	end
	
	local name = color.."<"..plrname..">".."\x80" -- default

	if perm_level == 1 then -- is Admin
		name = color.."<\x82@"..color..plrname..">".."\x80"
	elseif perm_level == 2 then -- is Server
		name = color.."<\x82~"..color..plrname..">".."\x80"
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