local types = {
	{"Innocent",
		V_GREENMAP,
		"Stay alive."
	},
	{"Murderer",
		V_REDMAP,
		"Kill everyone."
	},
	{"Sheriff",
		V_BLUEMAP,
		"Shoot the murderer!"
	}
}

local function HUD_RoleDrawer(v,p)
	local patch = v.cachePatch("MMROLE")
	local off = MMHUD.xoffset
	local x = (320*FU)-(patch.width*FU)
	local y = 0
	v.drawScaled(x + off, y, FU, patch, V_SNAPTOTOP|V_SNAPTORIGHT|V_50TRANS)

	if p.spectator 
	or not (p.mo and p.mo.valid)
	or p.mo.health == 0
		v.drawString(320*FU + off,
			0,
			"Dead",
			V_GRAYMAP|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"fixed-right"
		)
		if p.spectator
			local src = p.mm.whokilledme
			local name = "your own stupidity"
			
			if ((src and src.valid) and (src.player and src.player.valid))
				name = "\x85"..src.player.name
			end
			
			v.drawString(320*FU + off,
				8*FU,
				"Killed by "..name,
				V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
				"thin-fixed-right"
			)
		end
		return
	end
	
	if not (p.mm and types[p.mm.role]) then return end
	
	v.drawString(320*FU + off,
		0,
		types[p.mm.role][1],
		types[p.mm.role][2]|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
		"fixed-right"
	)
	for i = 3,7
		if types[p.mm.role][i] ~= nil
			v.drawString(320*FU + off,
				(8*(i - 2))*FU,
				types[p.mm.role][i],
				V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
				"thin-fixed-right"
			)
		end
	end
end

return HUD_RoleDrawer