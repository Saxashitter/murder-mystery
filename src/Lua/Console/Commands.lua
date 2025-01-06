COM_AddCommand("MM_GiveItem", function(p, name)
	if not MM:isMM() then return end

	MM:GiveItem(p, name)
end, COM_ADMIN)

COM_AddCommand("MM_EndGame", function(p)
	if not MM:isMM() then return end

	MM:endGame(1)
	MM_N.killing_end = false
	MM_N.disconnect_end = true
	MM_N.end_ticker = 3*TICRATE - 1
	S_StartSound(nil,sfx_s253)
end, COM_ADMIN)

COM_AddCommand("MM_StartShowdown", function(p)
	if not MM:isMM() then return end
	if MM_N.showdown then return end
	
	MM:startShowdown()
end, COM_ADMIN)

COM_AddCommand("MM_TimeTo0", function(p)
	if not MM:isMM() then return end
	
	MM_N.time = 0
end, COM_ADMIN)

COM_AddCommand("suicide", function(p)
	if MM:isMM() and not CV_MM.debug.value
		CONS_Printf(p,"You can't use this in Murder Mystery.")
	else
		if not (p.mo and p.mo.valid)
		or (p.spectator)
		or not (p.mo.health)
			CONS_Printf(p,"You can't use this right now.")
			return
		end
		
		--vanilla
		if gamestate ~= GS_LEVEL or gamestate == GS_INTERMISSION
			CONS_Printf(p,"You must be in a level to use this.")
			return
		end
		
		if not G_PlatformGametype()
			CONS_Printf(p,"You may only use this in co-op, race, and competition!")
			return
		end
		
		if not (netgame or multiplayer)
			CONS_Printf(p,"You can't use this in Single Player! Use \"retry\" instead.")
			return
		end
		
		P_KillMobj(p.mo,0,0,DMG_INSTAKILL)
	end
end)

COM_AddCommand("MM_toptextsay", function(p,time,header,...)
	if not MM:isMM() then return end
	
	if not tostring(time)
		CONS_Printf(p,"mm_toptextsay <time> <header> <...>")
		return
	end
	
	local args = {...}
	MMHUD:PushToTop(abs(tonumber(time) or 5)*TICRATE,
		header,
		unpack(args)
	)
end, COM_ADMIN)

local tofixed = tofixed
if tofixed == nil
	--L_DecimalFixed
	tofixed = function(str)
		if str == nil return nil end
		local dec_offset = string.find(str,'%.')
		if dec_offset == nil
			return (tonumber(str) or 0)*FRACUNIT
		end
		local whole = tonumber(string.sub(str ,0,dec_offset-1)) or 0
		local decimal = tonumber(string.sub(str,dec_offset+1)) or 0
		whole = $ * FRACUNIT
		local dec_len = string.len(decimal)
		decimal = $ * FRACUNIT / (10^dec_len)
		return whole + decimal
	end
end

COM_AddCommand("MM_stormradius", function(p,dest,time)
	if not MM:isMM() then return end
	if not tofixed then return end
	
	if dest == nil then return end
	if (time == nil) then return end
	local point = MM_N.storm_point
	
	if not (point and point.valid) then return end
	
	dest = abs(tofixed($))
	time = abs(tonumber($))
	
	point.storm_destradius = dest
	point.storm_incre = point.storm_radius - ease.linear(FU/(time or 1),
		point.storm_radius,
		dest
	)
end, COM_ADMIN)

COM_AddCommand("MM_MakeMeA", function(p, newrole)
	if not MM:isMM() then return end
	if not (p.mm) then return end
	if (p.mm.spectator) then return end
	if newrole == nil then return end
	
	do
		local todo = string.upper(newrole)
		local realnum = _G["MMROLE_"..todo]
		if realnum ~= nil
			p.mm.got_weapon = false
			p.mm.role = realnum
			
			for play in players.iterate()
				if not (play.mm) then continue
				play.mm.teammates = nil
			end
		else
			CONS_Printf(p,todo.." is not a role.")
		end
	end
	
end, COM_ADMIN)

