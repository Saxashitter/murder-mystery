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

-- maybe add skin changes here too?
