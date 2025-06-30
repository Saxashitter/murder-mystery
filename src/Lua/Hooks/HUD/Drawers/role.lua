--TODO: we dont really need this

local version = dofile("version")
if #version > 7 then
	version = $:sub(1,7)
end

local roles = MM.require "Variables/Data/Roles"

--cant think of a good way to draw & get the length using just 1 loop
local function HUD_RoleDrawer(v,p)
	if not (p and p.valid) then p = consoleplayer end
	
	if not (p.mm and roles[p.mm.role]) then return end
	
	local patch = v.cachePatch("MMROLE")
	
	local longest_width = 0
	----Calc "Killed by" string
	local killername = "your own stupidity."
	local killerstring = "Killed by "
	if p.spectator then
		local src = p.mm.whokilledme
		
		if src ~= nil
			if type(src) == "string"
			and src ~= ''
				killerstring = src
			--TODO: if the sheriff dies, this will get replaced
			--		by the default text instead
			elseif type(src) == "userdata" and userdataType(src) == "mobj_t"
			and ((src and src.valid) and (src.player and src.player.valid)) then
				killername = roles[src.player.mm.role].colorcode .. src.player.name
				killerstring = $..killername
			else
				killerstring = $..killername
			end
		else
			if (p.mm_save.afkmode)
				killerstring = "You're in spectator mode."
			else
				killerstring = "Joined midgame."
			end
		end
	end
	----
	
	----Role name
	do
		if p.spectator 
		or not (p.mo and p.mo.valid)
		or p.mo.health == 0 then
			longest_width = v.stringWidth("  Dead",V_ALLOWLOWERCASE,"normal")
		else
			longest_width = v.stringWidth("  "..roles[p.mm.role].name,V_ALLOWLOWERCASE,"normal")
		end
	end
	----
	
	----Calculate widest string
	do
		local y = 10*FU
		if not p.spectator
			for k,va in ipairs(roles[p.mm.role].desc) do
				longest_width = max($,
					v.stringWidth("  "..va,V_ALLOWLOWERCASE,"small")
				)
				y = $+4*FU
			end
		else
			longest_width = max($,
				v.stringWidth("  "..killerstring,V_ALLOWLOWERCASE,"small")
			)
			y = $+4*FU

			longest_width = max($,
				v.stringWidth("  You cannot interact with alive people.",V_ALLOWLOWERCASE,"small")
			)
			y = $+4*FU
		end
		
		local x = (320*FU) - longest_width*FU
		v.slideDrawScaled(x, y, FU, patch, V_SNAPTOTOP|V_SNAPTORIGHT|V_50TRANS)
		v.slideDrawString(x, y + (2*FU), version, V_SNAPTOTOP|V_SNAPTORIGHT|V_80TRANS, "thin-fixed")
	end
	----
	
	----Draw "Killed by"
	if p.spectator 
	or not (p.mo and p.mo.valid)
	or p.mo.health == 0 then
		v.slideDrawString(320*FU,
			0,
			"Dead",
			V_GRAYMAP|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"fixed-right"
		)
		if p.spectator
			
			v.slideDrawString(320*FU,
				8*FU,
				killerstring,
				V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
				"small-fixed-right"
			)
			v.slideDrawString(320*FU,
				12*FU,
				"You cannot interact with alive people.",
				V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
				"small-fixed-right"
			)
		end
		return
	end
	----
	
	v.slideDrawString(320*FU,
		0,
		roles[p.mm.role].name,
		roles[p.mm.role].color|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
		"fixed-right"
	)
	for k,va in ipairs(roles[p.mm.role].desc)
		v.slideDrawString(320*FU,
			(8+(4*(k-1)))*FU,
			va,
			V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"small-fixed-right"
		)
	end
end

MMHUD.HUD_RoleDrawer = HUD_RoleDrawer
return HUD_RoleDrawer,"scores"