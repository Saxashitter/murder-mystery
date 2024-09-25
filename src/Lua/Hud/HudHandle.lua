local hudwasmm = false
local modname = "SAXAMM"

addHook("HUD",function(v,p)
	if (gametype == GT_SAXAMM)
		if not hudwasmm
			customhud.SetupItem("rings",		     modname)
			customhud.SetupItem("time",			     modname)
			customhud.SetupItem("score",		     modname)
			customhud.SetupItem("lives",		     modname)
			customhud.SetupItem("intermissiontally", modname, HUD_IntermissionText)
			customhud.SetupItem("rankings",			 modname, HUD_TabScoresDrawer)
			
			customhud.SetupItem("saxamm_role",	     modname, HUD_RoleDrawer,    "game")
			customhud.SetupItem("saxamm_weapon",     modname, HUD_WeaponDrawer,  "game")
			customhud.SetupItem("saxamm_weapontime", modname, HUD_TimeForWeapon, "game")
			customhud.SetupItem("saxamm_info",		 modname, HUD_InfoDrawer,	 "game")
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
			customhud.SetupItem("rankings",				"vanilla")
		end
		
		hudwasmm = false
	end
end,"game")