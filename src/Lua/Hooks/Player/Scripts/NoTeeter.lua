--srb2 makes players teeter on steep no-physics slopes for some reason
return function(p)
	local me = p.mo
	
	if P_IsObjectOnGround(me)
	and (me.standingslope)
		local slope = me.standingslope
		if not (slope.flags & SL_NOPHYSICS) then return end
		if not (slope.zdelta >= FU/2) then return end
		
		if me.state == S_PLAY_EDGE
			me.state = S_PLAY_STND
		end
		
	end
end