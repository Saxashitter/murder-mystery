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
		
		if p.mm.perk_ghost_time
			me.alpha = ease.linear(FU/2, $, 0)
			
			p.mm.perk_ghost_time = max($-1,0)
		else
			me.alpha = ease.linear(FU/3, $, FU)
		end
		
	end,
}