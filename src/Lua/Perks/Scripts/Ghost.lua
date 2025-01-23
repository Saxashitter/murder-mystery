MM_PERKS[MMPERK_GHOST] = {
	primary = function(p)
		p.mm.perk_ghost_time = $ or 0
		p.mm.perk_ghost_cooldown = $ or 0
		
		local me = p.mo
		
		if (p.cmd.buttons & BT_TOSSFLAG)
		and not (p.lastbuttons & BT_TOSSFLAG)
		and (p.mm.perk_ghost_cooldown == 0)
			p.mm.perk_ghost_time = 10*TICRATE
			p.mm.perk_ghost_cooldown = 60*TICRATE
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
			me.mm_overlay.alpha = max(me.alpha, FU/5)
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
	end
}