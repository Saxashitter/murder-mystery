local ghost_min_alpha = FU/2
freeslot("sfx_cloak1")
sfxinfo[sfx_cloak1] = {
	flags = SF_X2AWAYSOUND,
	caption = "\x86".."Murderer cloaks\x80"
}
freeslot("sfx_cloak2")
sfxinfo[sfx_cloak2] = {
	flags = SF_X2AWAYSOUND,
	caption = "\x86".."Murderer uncloaks\x80"
}

local hud_tween_start = -55*FU
local hud_tween = hud_tween_start
local icon_name = "MM_PI_GHOST"
local TR = TICRATE

MM_PERKS[MMPERK_GHOST] = {
	primary = function(p)
		p.mm.perk_ghost_time = $ or 0
		p.mm.perk_ghost_cooldown = $ or 0
		
		local me = p.mo
		
		local last_ghosting = p.mm.perk_ghost_time

		if (p.cmd.buttons & BT_TOSSFLAG)
		and not (p.lastbuttons & BT_TOSSFLAG)
			if (p.mm.perk_ghost_cooldown == 0)
				p.mm.perk_ghost_time = 8*TICRATE
				p.mm.perk_ghost_cooldown = 30*TICRATE
				
				S_StartSound(me, sfx_cloak1)
			elseif p.mm.perk_ghost_time
				p.mm.perk_ghost_time = 0
			end
		end
		
		if p.mm.perk_ghost_cooldown
			p.mm.perk_ghost_cooldown = max($-1,0)
		end
		
		if MM_N.gameover
			p.mm.perk_ghost_time = 0
		end
		
		if p.mm.perk_ghost_time
			me.alpha = FixedFloor(ease.linear(FU/2, $, 0) * 100)/100
			p.mm.perk_ghost_time = max($-1,0)
			
			if not (me.mm_overlay and me.mm_overlay.valid)
				local over = P_SpawnMobjFromMobj(me,
					0,0,0,
					MT_OVERLAY
				)
				over.sprite = me.sprite
				over.state = S_PLAY_WAIT
				over.skin = me.skin
				over.tics,over.fuse = -1,-1
				over.target = me
				over.drawonlyforplayer = p
				over.dontdrawforviewmobj = me
				over.shadowscale = me.shadowscale
				me.mm_overlay = over
			end
			me.mm_overlay.sprite = me.sprite
			me.mm_overlay.sprite2 = me.sprite2
			me.mm_overlay.anim_duration = me.anim_duration
			me.mm_overlay.frame = me.frame
			me.mm_overlay.color = me.color
			me.mm_overlay.alpha = max(me.alpha, ghost_min_alpha)
		else
			me.alpha = FixedCeil(ease.linear(FU/3, $, FU) * 100)/100
			
			if (me.mm_overlay and me.mm_overlay.valid)
				me.mm_overlay.sprite = me.sprite
				me.mm_overlay.sprite2 = me.sprite2
				me.mm_overlay.frame = me.frame
				me.mm_overlay.color = me.color
				me.mm_overlay.anim_duration = me.anim_duration
				me.mm_overlay.alpha = max($, me.alpha)
				
				if me.alpha >= FU
					P_RemoveMobj(me.mm_overlay)
					me.mm_overlay = nil
				end
			end
		end
		
		if last_ghosting > 0
		and p.mm.perk_ghost_time == 0
			S_StartSound(me, sfx_cloak2)
		end
	end,
	
	secondary = function(p)
		local me = p.mo
		local item = p.mm.inventory.items[p.mm.inventory.cur_sel]
		if not (item and item.id == "knife")
			me.alpha = FixedCeil(ease.linear(FU/2, $, FU) * 100)/100
			return
		end
		
		if (p.mm.inventory.hidden)
			me.alpha = FixedCeil(ease.linear(FU/2, $, FU) * 100)/100
		else
			me.alpha = FixedFloor(ease.linear(FU/2, $, FU/2) * 100)/100
		end
	end,

	drawer = function(v,p,c, order)
		local x = 5*FU
		local y = 100*FU
		local scale = FU/2
		local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM
		local timer = 0
		if order == "sec" then y = $ + 18*FU end
		if p.mm.perk_ghost_time == nil then return end

		if p.mm.perk_ghost_time == 0
		and p.mm.perk_ghost_cooldown == 0
		and FixedFloor(hud_tween) == hud_tween_start
			return
		end

		if (p.mm.perk_ghost_time > 0)
			hud_tween = ease.inquad(FU/2, $, 0)
			timer = p.mm.perk_ghost_time/TR
		else
			if p.mm.perk_ghost_cooldown == 0
				hud_tween = ease.inquad(FU/4, $, hud_tween_start)
			end
			timer = p.mm.perk_ghost_cooldown/TR
			flags = $|V_50TRANS
		end
		x = $ + hud_tween

		v.drawScaled(x,
			y,
			scale,
			v.cachePatch(icon_name),
			flags
		)
		v.drawString(x,
			y + (31*scale) - 8*FU,
			timer,
			flags,
			"thin-fixed"
		)
	end,
	
	icon = icon_name,
	icon_scale = FU/2,
	name = "Ghost"
}