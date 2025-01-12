local MOVE_DEADZONE = 10

return function(p)
	if not MM_N.voting then return end
	if (p.mm_save.afkmode) then return end
	
	if (p and p.mo) then
		p.mo.momx = 0
		p.mo.momy = 0
		p.mo.momz = 0
	end

	if MM_N.mapVote.state != "voting" then return end

	if not p.mm.selected_map then
		local moveIndex = 0
		local lastSelected = p.mm.cur_map

		if (abs(p.mm.sidemove) + abs(p.mm.forwardmove)) >= MOVE_DEADZONE
		-- ...and we're moving in what is arguably one direction (not diagonal)
		and abs(abs(p.mm.sidemove) - abs(p.mm.forwardmove)) > MOVE_DEADZONE
		then
			-- there's probably a better way to do these
			if abs(p.mm.sidemove) > abs(p.mm.forwardmove) then
				if p.mm.sidemove > 0 then
					p.mm.cur_map = 1
				else
					p.mm.cur_map = 3
				end
			else
				if p.mm.forwardmove > 0 then
					p.mm.cur_map = 2
				else
					p.mm.cur_map = 4
				end
			end
		end
		if p.mm.cur_map ~= lastSelected then
			S_StartSound(nil, sfx_menu1, p)
		end

		if p.mm.buttons & (BT_JUMP|BT_SPIN) == BT_JUMP then
			p.mm.selected_map = true
			MM_N.mapVote.maps[p.mm.cur_map].votes = $+1
			S_StartSound(nil, sfx_addfil, p)
		end
	else
		if p.mm.buttons & (BT_JUMP|BT_SPIN) == BT_SPIN then
			p.mm.selected_map = false
			MM_N.mapVote.maps[p.mm.cur_map].votes = $-1
			S_StartSound(nil, sfx_notadd, p)
		end
	end
end