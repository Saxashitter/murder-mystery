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
