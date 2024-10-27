local activebuttons = BT_JUMP|BT_WEAPONNEXT|BT_WEAPONPREV|BT_ATTACK|BT_CUSTOM1|BT_CUSTOM2|BT_CUSTOM3
local AFK_TIMEOUT = 60*TICRATE

local function handleTimeout(p)
	if p == server
	or IsPlayerAdmin(p)
		P_KillMobj(p.mo,nil,nil,DMG_SPECTATOR)
		chatprintf(p,"\x82*You have been made a spectator for being AFK.")
		p.mm.afkhelpers.timedout = false
	else
		COM_BufAddText(server,"kick "..#p.." AFK")
	end
	
end

return function(p)
	local cmd = p.cmd
	local afk = p.mm.afkhelpers
	
	if afk.timedout
	or (MM_N.waiting_for_players)
		return
	end
	
	if not (cmd.forwardmove or cmd.sidemove
	or cmd.buttons & activebuttons)
	or (afk.lastangle ~= cmd.angleturn << 16)
	or (afk.lastaiming ~= cmd.aiming)
		if afk.timeuntilreset < 2*TICRATE
			afk.timeuntilreset = $+1
		else
			p.mm.afktimer = $ + 1
			
			if p.mm.afktimer == AFK_TIMEOUT
				p.mm.afktimer = 0
				afk.timedout = true
				
				handleTimeout(p)
			end
		end
	else
		if afk.timeuntilreset
			afk.timeuntilreset = $-1
		else
			p.mm.afktimer = $*3/4
		end
	end
	
	afk.lastangle = cmd.angleturn << 16
	afk.lastaiming = cmd.aiming	
end