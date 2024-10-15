local MOVE_DEADZONE = 10

return function(p)
	if not MM_N.voting then return end

	if (p and p.mo) then
		p.mo.momx = 0
		p.mo.momy = 0
		p.mo.momz = 0
	end

	if not p.mm.selected_map then
		local moveIndex = 0
		local lastSelected = p.mm.cur_map

		if p.mm.sidemove <= -MOVE_DEADZONE
		and p.mm.lastside > -MOVE_DEADZONE then
			moveIndex = -1
		end

		if p.mm.sidemove >= MOVE_DEADZONE
		and p.mm.lastside < MOVE_DEADZONE then
			moveIndex = 1
		end

		p.mm.cur_map = min(max(1, $+moveIndex), #MM_N.mapVote)
		if p.mm.cur_map ~= lastSelected then
			S_StartSound(nil, sfx_menu1, p)
		end

		if p.mm.buttons & (BT_JUMP|BT_SPIN) == BT_JUMP then
			p.mm.selected_map = true
			MM_N.mapVote[p.mm.cur_map].votes = $+1
			S_StartSound(nil, sfx_addfil, p)
		end
	else
		if p.mm.buttons & (BT_JUMP|BT_SPIN) == BT_SPIN then
			p.mm.selected_map = false
			MM_N.mapVote[p.mm.cur_map].votes = $-1
			S_StartSound(nil, sfx_notadd, p)
		end
	end
end