local hudwasmm = false
local modname = "SAXAMM"

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
	local x = (320*FU)-(patch.width*FU)
	local y = 0
	v.drawScaled(x, y, FU, patch, V_SNAPTOTOP|V_SNAPTORIGHT|V_50TRANS)

	if p.spectator 
	or not (p.mo and p.mo.valid)
	or p.mo.health == 0
		v.drawString(320,0,
			"Dead",
			V_GRAYMAP|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_50TRANS,
			"right"
		)
		v.drawString(320,8,
			"Killed by: TODO: player name",
			V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"thin-right"
		)
		return
	end
	
	if types[p.mm.role] == nil then return end
	
	v.drawString(320,0,
		types[p.mm.role][1],
		types[p.mm.role][2]|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_10TRANS,
		"right"
	)
	for i = 3,7
		if types[p.mm.role][i] ~= nil
			v.drawString(320,8*(i - 2),
				types[p.mm.role][i],
				V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_10TRANS,
				"thin-right"
			)
		end
	end
end

local function HUD_WeaponDrawer(v,p)
	
	local trans = 0
	local yoffset = 0

	local patch = v.cachePatch("MMWEAPON")
	local x = 45*FU
	local y = 155*FU

	v.drawScaled(x, y, FU, patch, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_50TRANS)

	if p.mm.weapon and p.mm.weapon.valid
		local wpn_t = MM:getWpnData(p)	
		--Name
		v.drawString(47,
			155,
			wpn_t.name or "Weapon",
			V_YELLOWMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"left"
		)
		
		--Tooltips
		v.drawString(47,
			171,
			(p.mm.weapon.hidden and "Hidden..." or "Showing!"),
			V_YELLOWMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|(p.mm.weapon.hidden and V_30TRANS or 0),
			"thin"
		)
		v.drawString(47,
			179,
			"[C1] - "..(p.mm.weapon.hidden and "Show" or "Hide").." weapon",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin"
		)
		if not p.mm.weapon.hidden
			v.drawString(47,
				187,
				"[FIRE] - Use weapon",
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
				"thin"
			)
		end
		
		--Icon
		v.drawScaled(9*FU,
			159*FU,
			FU,
			v.cachePatch(wpn_t.icon or "MISSING"), --v.cachePatch("MISSING"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|trans
		)
		
		yoffset = -(p.mm.weapon.cooldown*FU)/2
		--yoffset = ease.outquad(FU/3,$,0)
	else
		v.drawString(47,
			155,
			"No Weapon...",
			V_30TRANS|V_GRAYMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin"
		)	
	end
	
	v.drawScaled(5*FU,
		155*FU + yoffset,
		FU*2,
		v.cachePatch("CURWEAP"),
		V_SNAPTOLEFT|V_SNAPTOBOTTOM|trans
	)
end

local function HUD_TimeForWeapon(v,p)
	if not MM:isMM() then return end
	if not (p.mo and p.mo.health and p.mm) then return end
	if p.mm.role == 1 then return end
	if leveltime >= 10*TICRATE then return end

	local time = (10*TICRATE)-leveltime

	v.drawString(160, 40, "You'll get your weapon in... ", V_SNAPTOTOP|V_ALLOWLOWERCASE, "center")
	v.drawNum(160, 50, time/TICRATE, V_SNAPTOTOP)
end

local function HUD_IntermissionText(v)
	local type = MM_N.endType or MM.endTypes[1]

	v.drawString(160, 60, type.name, V_SNAPTOTOP|type.color, "center")
	v.drawString(160, 200-24, "This mode is in alpha!", V_SNAPTOBOTTOM, "center")
end

addHook("HUD",function(v,p)
	if (gametype == GT_SAXAMM)
		if not hudwasmm
			customhud.SetupItem("rings",		     modname)
			customhud.SetupItem("time",			     modname)
			customhud.SetupItem("score",		     modname)
			customhud.SetupItem("lives",		     modname)
			customhud.SetupItem("intermissiontally", modname, HUD_IntermissionText)
			
			customhud.SetupItem("saxamm_role",	     modname, HUD_RoleDrawer,    "game")
			customhud.SetupItem("saxamm_weapon",     modname, HUD_WeaponDrawer,  "game")
			customhud.SetupItem("saxamm_weapontime", modname, HUD_TimeForWeapon, "game")
		end
		
		hudwasmm = true
	else
		if hudwasmm
			customhud.SetupItem("rings",				"vanilla")
			customhud.SetupItem("time",					"vanilla")
			customhud.SetupItem("score",				"vanilla")
			customhud.SetupItem("lives",				"vanilla")
			customhud.SetupItem("intermissiontally",	"vanilla")
		end
		
		hudwasmm = false
	end
end,"game")