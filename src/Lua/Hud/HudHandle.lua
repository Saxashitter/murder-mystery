local hudwasmm = false
local modname = "SAXAMM"

local TR = TICRATE
local HUD_BEGINNINGXOFF = 300*FU

local MMHUD = {
	ticker = 0,
	xoffset = HUD_BEGINNINGXOFF,
	lastmap = nil,
}


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
		v.drawString(320*FU + off,
			8*FU,
			"Killed by: TODO: player name",
			V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"thin-fixed-right"
		)
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

local function HUD_WeaponDrawer(v,p)
	if (p.spectator) then return end
	
	local slidein = MMHUD.xoffset
	
	local trans = 0
	local yoffset = 0

	local patch = v.cachePatch("MMWEAPON")
	local x = 45*FU
	local y = 155*FU

	v.drawScaled(x - slidein, y, FU, patch, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_50TRANS)

	if p.mm and p.mm.weapon and p.mm.weapon.valid
		local wpn_t = MM:getWpnData(p)
		
		--Name
		v.drawString(47*FU - slidein,
			156*FU,
			wpn_t.name or "Weapon",
			V_YELLOWMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"fixed"
		)
		
		--Tooltips
		v.drawString(47*FU - slidein,
			162*FU,
			(p.mm.weapon.hidden and "Hidden..." or "Showing!"),
			V_YELLOWMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|(p.mm.weapon.hidden and V_30TRANS or 0),
			"thin-fixed"
		)
		v.drawString(47*FU - slidein,
			170*FU,
			"[C1] - "..(p.mm.weapon.hidden and "Show" or "Hide").." weapon",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin-fixed"
		)
		local y = 178
		if wpn_t.droppable then
			v.drawString(47*FU - slidein,
				y*FU,
				"[C2] - Drop weapon",
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
				"thin-fixed"
			)
			y = $+8
		end
		if not p.mm.weapon.hidden
			v.drawString(47*FU - slidein,
				y*FU,
				"[FIRE] - Use weapon",
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
				"thin-fixed"
			)
		end
		
		--Icon
		v.drawScaled(9*FU - slidein,
			159*FU,
			FU,
			v.cachePatch(wpn_t.icon or "MISSING"), --v.cachePatch("MISSING"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|trans
		)
		
		yoffset = -(p.mm.weapon.cooldown*FU)/2
		--yoffset = ease.outquad(FU/3,$,0)
	else
		v.drawString(47*FU - slidein,
			156*FU,
			"No Weapon",
			V_GRAYMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin-fixed"
		)	
	end
	
	v.drawScaled(5*FU - slidein,
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
		
		MMHUD.ticker = $+1
		if abs(leveltime - MMHUD.ticker) >= 4
			MMHUD.ticker = leveltime
		end
		
		if MMHUD.ticker >= TR*3/2
			MMHUD.xoffset = ease.inquart(FU*9/10,$,0)
		end
		
		hudwasmm = true
	else
		MMHUD.ticker = 0
		MMHUD.xoffset = HUD_BEGINNINGXOFF
		
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

addHook("MapLoad",do
	MMHUD.ticker = 0
	MMHUD.xoffset = HUD_BEGINNINGXOFF
end)