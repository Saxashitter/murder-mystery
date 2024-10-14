local version = dofile("version")
if #version > 7 then
	version = $:sub(1,7)
end

local roles = MM.require "Variables/Data/Roles"

--cant think of a good way to draw & get the length using just 1 loop
local function HUD_RoleDrawer(v,p)
	local patch = v.cachePatch("MMROLE")
	local off = MMHUD.xoffset
	
	local longest_width = 0
	local killername = "your own stupidity."
	local killerstring = "Killed by "
	if p.spectator then
		local src = p.mm.whokilledme
		
		if src ~= nil
			if type(src) == "string"
			and src ~= ''
				killerstring = src
			elseif type(src) == "userdata" and userdataType(src) == "mobj_t"
			and ((src and src.valid) and (src.player and src.player.valid)) then
				killername = "\x85"..src.player.name
				killerstring = $..killername
			else
				killerstring = $..killername
			end
		else
			killerstring = "Joined midgame."
		end
	end

	do
		if p.spectator 
		or not (p.mo and p.mo.valid)
		or p.mo.health == 0 then
			longest_width = v.stringWidth("  Dead",V_ALLOWLOWERCASE,"normal")
		else
			longest_width = v.stringWidth("  "..roles[p.mm.role].name,V_ALLOWLOWERCASE,"normal")
		end
	end
	
	do
		local y = 10*FU
		if not p.spectator
			for k,va in ipairs(roles[p.mm.role].desc) do
				longest_width = max($,
					v.stringWidth("  "..va,V_ALLOWLOWERCASE,"thin")
				)
				y = $+8*FU
			end
		else
			longest_width = max($,
				v.stringWidth("  "..killerstring,V_ALLOWLOWERCASE,"thin")
			)
			y = $+8*FU

			longest_width = max($,
				v.stringWidth("  You cannot interact with alive people.",V_ALLOWLOWERCASE,"thin")
			)
			y = $+8*FU
		end
		
		local x = (320*FU) - longest_width*FU
		v.drawScaled(x + off, y, FU, patch, V_SNAPTOTOP|V_SNAPTORIGHT|V_50TRANS)
		v.drawString(x + off, y + (2*FU), version, V_SNAPTOTOP|V_SNAPTORIGHT|V_80TRANS, "thin-fixed")
	end
	
	if p.spectator 
	or not (p.mo and p.mo.valid)
	or p.mo.health == 0 then
		v.drawString(320*FU + off,
			0,
			"Dead",
			V_GRAYMAP|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"fixed-right"
		)
		if p.spectator
			
			v.drawString(320*FU + off,
				8*FU,
				killerstring,
				V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
				"thin-fixed-right"
			)
			v.drawString(320*FU + off,
				16*FU,
				"You cannot interact with alive people.",
				V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
				"thin-fixed-right"
			)
		end
		return
	end
	
	if not (p.mm and roles[p.mm.role]) then return end
	
	v.drawString(320*FU + off,
		0,
		roles[p.mm.role].name,
		roles[p.mm.role].color|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
		"fixed-right"
	)
	for k,va in ipairs(roles[p.mm.role].desc)
		v.drawString(320*FU + off,
			(8*k)*FU,
			va,
			V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"thin-fixed-right"
		)
	end
end

return HUD_RoleDrawer