local sglib = MM.require "Libs/sglib"
local roles = MM.require "Variables/Data/Roles"

local function HUD_EndGameDrawer(v,p,c)
	if not MM_N.gameover then return end

	if MM_N.sniped_end then
		local patch = v.cachePatch("MM_SNIPER_APPROVED")
		local tic = MM_N.end_ticker - (TICRATE*3 + MM.sniper_theme_offset) + 6
		if tic > 0 then
			local slide = ease.inquad(min(FU-1, tic*FU/6), FU, 0)
			v.drawScaled(
				140*FU,
				140*FU,
				FU/2 + slide*2,
				patch,
				V_SNAPTOBOTTOM|V_SNAPTORIGHT
			)
		end
	end
	if MM_N.voting then return end
	
	if MM_N.end_killed and MM_N.end_killed.valid
	and (MM_N.end_killed.player and MM_N.end_killed.player.valid)
		local w2s = sglib.ObjectTracking(v,p,c,MM_N.end_killed,false,true)

		if w2s.onScreen
			local isme = ''
			if MM_N.end_killed == consoleplayer.realmo
				isme = "\x80 (you!)"
			end
			
			v.drawString(w2s.x,
				w2s.y - 32*w2s.scale,
				roles[MM_N.end_killed.player.mm.role].name..isme,
				roles[MM_N.end_killed.player.mm.role].color,
				"thin-fixed-center"
			)
		end
		
	end

	if MM_N.end_killer and MM_N.end_killer.valid and MM_N.end_killer.health and MM_N.end_killer.player
		local w2s = sglib.ObjectTracking(v,p,c,MM_N.end_killer,false,true)

		if w2s.onScreen
			local isme = ''
			if MM_N.end_killer == consoleplayer.realmo
				isme = "\x80 (you!)"
			end
			
			if MM_N.end_killed
			and MM_N.end_killed.valid
			and MM_N.end_killed.player.mm.role == MMROLE_MURDERER
				v.drawString(w2s.x,
					w2s.y - 64*w2s.scale,
					"HERO"..isme,
					V_YELLOWMAP,
					"thin-fixed-center"
				)
				v.drawString(w2s.x,
					w2s.y - 64*w2s.scale - 8*FU,
					MM_N.end_killer.player.name,
					V_YELLOWMAP|V_ALLOWLOWERCASE,
					"thin-fixed-center"
				)
			--TODO: this block will execute now after a while, FIX!
			--Innocents kill each other
			else
				v.drawString(w2s.x,
					w2s.y - 64*w2s.scale,
					roles[MM_N.end_killer.player.mm.role].name..isme,
					roles[MM_N.end_killer.player.mm.role].color,
					"thin-fixed-center"
				)
			end
		end
		
	end
	
end

return HUD_EndGameDrawer