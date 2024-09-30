local sglib = MM.require "Libs/sglib"

local function HUD_EndGameDrawer(v,p,c)
	if not MM_N.gameover then return end
	if MM_N.voting then return end
	
	if MM_N.end_killed and MM_N.end_killed.valid
		local w2s = sglib.ObjectTracking(v,p,c,MM_N.end_killed)

		if w2s.onScreen
			local isme = ''
			if MM_N.end_killed == consoleplayer.realmo
				isme = "\x80 (you!)"
			end
			
			v.drawString(w2s.x,
				w2s.y - 32*w2s.scale,
				"MURDERER"..isme,
				V_REDMAP,
				"thin-fixed-center"
			)
		end
		
	end

	if MM_N.end_killer and MM_N.end_killer.valid and MM_N.end_killer.health
		local w2s = sglib.ObjectTracking(v,p,c,MM_N.end_killer)

		if w2s.onScreen
			local isme = ''
			if MM_N.end_killer == consoleplayer.realmo
				isme = "\x80 (you!)"
			end
			
			v.drawString(w2s.x,
				w2s.y - 64*w2s.scale,
				"HERO"..isme,
				V_YELLOWMAP,
				"thin-fixed-center"
			)
		end
		
	end
	
end

return HUD_EndGameDrawer