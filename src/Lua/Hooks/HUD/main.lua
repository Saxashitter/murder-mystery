local huds = {
	["rings"] = {"None", "game"},
	["time"] = {"None", "game"},
	["score"] = {"None", "game"},
	["lives"] = {"None", "game"}
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
local HUD_BEGINNINGXOFF = 300*FU

--DO NOT SYNCH!!!!!!!!
local MMHUD = {
	ticker = 0,
	xoffset = HUD_BEGINNINGXOFF,
}
rawset(_G, "MMHUD", MMHUD)


local hudwasmm = false
local modname = "SAXAMM"

local function addHud(name)
	local func,hudtype = dofile("Hooks/HUD/Drawers/"..name)

	huds[name] = {func or "None", hudtype or "game"}
end

addHook("MapLoad",do
	MMHUD.ticker = 0
	MMHUD.xoffset = HUD_BEGINNINGXOFF
end)

addHook("HUD", function(v,p,c)
	if MM:isMM() then
		if not hudwasmm then
			for name, data in pairs(huds) do
				local drawFunc = data[1]

				if drawFunc == "None" then drawFunc = nil end
	
				if (is_hud_modded(name)
				and not customhud.ItemExists(name))
				or not is_hud_modded(name) then
					customhud.SetupItem(name, modname, drawFunc, data[2])
					continue
				end

				customhud.enable(name)
			end
		end

		MMHUD.ticker = $+1
		if abs(leveltime - MMHUD.ticker) >= 4
			MMHUD.ticker = leveltime
		end
		
		if not MM.gameover
			if MM_N.waiting_for_players
			and MMHUD.ticker >= TR*5
				MMHUD.xoffset = ease.inquad(FU*3/10,$,HUD_BEGINNINGXOFF)
			elseif MMHUD.ticker >= TR*3/2
				MMHUD.xoffset = ease.inquart(FU*9/10,$,0)
			end
		else
			MMHUD.xoffset = ease.inquart(FU*9/10,$,HUD_BEGINNINGXOFF)
		end
		
		hudwasmm = true
		return
	end

	MMHUD.ticker = 0
	MMHUD.xoffset = HUD_BEGINNINGXOFF
	
	if hudwasmm
		for name,data in pairs(huds) do

			if not is_hud_modded(name) then
				customhud.SetupItem(name, "vanilla")
				continue
			end

			customhud.disable(name)
		end
	end
	
	hudwasmm = false
end)

addHud "murdererping"
addHud "showdownicon"
addHud "role"
addHud "heldweapon"
addHud "weapontime"
addHud "info"
addHud "showdownanim"
addHud "intermissiontally"
addHud "rankings"
addHud "intermission"