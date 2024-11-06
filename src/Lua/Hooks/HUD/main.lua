local huds = {
	{"rings", "None", "game"};
	{"score", "None", "game"};
	{"time", "None", "game"};
	{"lives", "None", "game"}
}

customhud.SetupFont("STCFN")

-- Should match hud_disable_options in lua_hudlib.c
-- taken from customhud
local defaultitems = {
	{"stagetitle", "titlecard"},
	{"textspectator", "game"},
	{"crosshair", "game"},

	{"score", "game"},
	{"time", "game"},
	{"rings", "game"},
	{"lives", "game"},

	{"weaponrings", "game"},
	{"powerstones", "game"},
	{"teamscores", "gameandscores"},

	{"nightslink", "game"},
	{"nightsdrill", "game"},
	{"nightsrings", "game"},
	{"nightsscore", "game"},
	{"nightstime", "game"},
	{"nightsrecords", "game"},

	{"rankings", "scores"},
	{"coopemeralds", "scores"},
	{"tokens", "scores"},
	{"tabemblems", "scores"},

	{"intermissiontally", "intermission"},
	{"intermissiontitletext", "intermission"},
	{"intermissionmessages", "intermission"},
	{"intermissionemeralds", "intermission"},
}

local function is_hud_modded(name)
	for k,v in ipairs(defaultitems) do
		if name == v[1] then
			return false
		end
	end

	return true
end

local TR = TICRATE
local HUD_BEGINNINGXOFF = 350*FU

--DO NOT SYNCH!!!!!!!!
local MMHUD = {
	ticker = 0,
	xoffset = HUD_BEGINNINGXOFF,
	weaponslidein = HUD_BEGINNINGXOFF,
}
rawset(_G, "MMHUD", MMHUD)


local hudwasmm = false
local modname = "SAXAMM"

local function addHud(name)
	local func,hudtype = dofile("Hooks/HUD/Drawers/"..name)

	table.insert(huds, {name, func or "None", hudtype or "game"})
end

addHook("MapLoad",do
	MMHUD.ticker = 0
	MMHUD.xoffset = HUD_BEGINNINGXOFF
	MMHUD.weaponslidein = HUD_BEGINNINGXOFF
end)

addHook("HUD", function(v,p,c)
	if MM:isMM() then
		if not hudwasmm then
			for i, data in ipairs(huds) do
				local drawFunc = data[2]

				if drawFunc == "None" then drawFunc = nil end
	
				if (is_hud_modded(data[1])
				and not customhud.ItemExists(data[1]))
				or not is_hud_modded(data[1]) then
					customhud.SetupItem(data[1], modname, drawFunc, data[3], i)
					continue
				end

				customhud.enable(data[1])
			end
		end

		MMHUD.ticker = $+1
		if abs(leveltime - MMHUD.ticker) >= 4
			MMHUD.ticker = leveltime
		end
		
		if not MM.gameover
			if MMHUD.ticker >= TR*3/2
				MMHUD.weaponslidein = ease.inquart(FU*9/10,$,0)
				if MM_N.waiting_for_players
					MMHUD.xoffset = ease.inquart(FU*9/10,$,0)
				end
			end
			if MMHUD.ticker >= 10*TR
			and not MM_N.waiting_for_players
				MMHUD.xoffset = ease.inquart(FU*9/10,$,0)
				MMHUD.weaponslidein = ease.inexpo(FU*7/10,$,HUD_BEGINNINGXOFF)
			end
		else
			MMHUD.xoffset = ease.inexpo(FU*7/10,$,HUD_BEGINNINGXOFF)
			MMHUD.weaponslidein = ease.inexpo(FU*7/10,$,HUD_BEGINNINGXOFF)
		end
		
		hudwasmm = true
		return
	end

	MMHUD.ticker = 0
	MMHUD.xoffset = HUD_BEGINNINGXOFF
	
	if hudwasmm
		for i,data in ipairs(huds) do
			if not is_hud_modded(data[1]) then
				customhud.SetupItem(data[1], "vanilla")
				continue
			end

			customhud.disable(data[1])
		end
	end
	
	hudwasmm = false
end)

addHud "outofbounds"
addHud "afktimeout"
addHud "endgamepointer"
addHud "murdererping"
addHud "showdownicon"
addHud "role"
addHud "heldweapon"
addHud "availableitems"
addHud "weapontime"
addHud "info"
addHud "toptext"
addHud "seenplayer"
addHud "results"
addHud "intermissiontally"
addHud "rankings"
addHud "intermissionhud"
addHud "showdownanim"
