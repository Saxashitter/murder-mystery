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
local HUD_BEGINNINGXOFF = 380*FU
--leveltime at which V_HUDTRANS starts fading in
local HUD_STARTFADEIN = (50 / 2) + 10

local slidein_time = 25
local slidein_frac = FixedDiv(FU, slidein_time*FU)
/*
local game_slidein_time = 20
local game_slidein_frac = FixedDiv(FU, game_slidein_time*FU)
*/

--dont draw if MMHUD.hudtrans == V_100TRANS
rawset(_G, "V_100TRANS", 10 << V_ALPHASHIFT)
local htranstable = {
	[0] = 10,
	[1] = 9,
	[2] = 9,
	[3] = 8,
	[4] = 8,
	[5] = 7,
	[6] = 7,
	[7] = 6,
	[8] = 6,
	[9] = 5,
	[10] = 5,
}

--DO NOT SYNCH!!!!!!!!
local MMHUD = {
	ticker = 0,
	slidefrac = FU,
	wslidefrac = FU,
	
	xoffset = HUD_BEGINNINGXOFF,
	weaponslidein = HUD_BEGINNINGXOFF,
	dontslidein = false,

	hudtrans = V_100TRANS,
	hudtranshalf = V_100TRANS,
}
rawset(_G, "MMHUD", MMHUD)

local hudwasmm = false
local modname = "SAXAMM"
MMHUD.modname = modname

MMHUD.interpolate = function(v,set)
	if v.interpolate ~= nil then v.interpolate(set) end
end

local function addHud(name)
	local func,hudtype,layer = dofile("Hooks/HUD/Drawers/"..name)

	table.insert(huds, {name, func or "None", hudtype or "game", layer})
end

addHook("MapLoad",do
	MMHUD.ticker = 0
	MMHUD.xoffset = HUD_BEGINNINGXOFF
	MMHUD.weaponslidein = HUD_BEGINNINGXOFF
	
	MMHUD.slidefrac = FU
	MMHUD.wslidefrac = FU
	
	MMHUD.hudtrans = V_100TRANS
end)

local function Playing()
	return not MM:pregame() and not MM_N.waiting_for_players and not MM_N.gameover
end

--itd be nice to have hacked in drawfuncs that handled this
local function DoRegularSlide(v, out)
	local offset = HUD_BEGINNINGXOFF
	MMHUD.xoffset = FixedMul(offset, MMHUD.slidefrac)
	
	local my_frac = slidein_frac
	if not out
		MMHUD.slidefrac = min($, my_frac * 5)
		MMHUD.slidefrac = max($ - my_frac, 0)
	else
		MMHUD.slidefrac = min($ + my_frac, FU)
	end
end

--ugh
local function DoWeaponSlide(v, out)
	local offset = HUD_BEGINNINGXOFF
	MMHUD.weaponslidein = FixedMul(offset, MMHUD.wslidefrac)
	
	local my_frac = slidein_frac
	if not out
		MMHUD.wslidefrac = min($, my_frac * 5)
		MMHUD.wslidefrac = $ - my_frac
		MMHUD.wslidefrac = max($, 0)
	else
		MMHUD.wslidefrac = $ + my_frac
		MMHUD.wslidefrac = min($, FU)
	end
end
MMHUD.DoRegularSlide = DoRegularSlide
MMHUD.DoWeaponSlide = DoWeaponSlide

addHook("HUD", function(v,p,c)
	if MM:isMM() then
		if not hudwasmm then
			for i, data in ipairs(huds) do
				local drawFunc = data[2]
				
				if drawFunc == "None" then drawFunc = nil end
				
				if (is_hud_modded(data[1])
				and not customhud.ItemExists(data[1]))
				or not is_hud_modded(data[1]) then
					customhud.SetupItem(data[1], modname, drawFunc, data[3], data[4] or i)
					continue
				end
				
				customhud.enable(data[1])
			end
		end
		
		MMHUD.ticker = $+1
		if abs(leveltime - MMHUD.ticker) >= 4
			MMHUD.ticker = leveltime
		end
		
		if not MMHUD.dontslidein
			if not MM.gameover
				
				--"Round starts in..."
				if MMHUD.ticker >= HUD_STARTFADEIN
				and not Playing()
					DoWeaponSlide(v)
					
					if MM_N.waiting_for_players
						DoRegularSlide(v)
					end
				end
				
				--slide in regular hud
				if Playing()
					DoRegularSlide(v)
					DoWeaponSlide(v,true)
				end
				
				--fade in stuff if we've tweened for at least 2 tics
				if MMHUD.xoffset <= FixedMul(HUD_BEGINNINGXOFF, FixedSqrt(FU*7/10))
					if MMHUD.hudtrans >> V_ALPHASHIFT ~= 0
						MMHUD.hudtrans = (($ >> V_ALPHASHIFT) - 1) << V_ALPHASHIFT
					end
				end
				
			--everything slides out
			else
				DoRegularSlide(v,true)
				DoWeaponSlide(v,true)
				
				if MMHUD.hudtrans >> V_ALPHASHIFT ~= 10
					MMHUD.hudtrans = (($ >> V_ALPHASHIFT) + 1) << V_ALPHASHIFT
				end
			end
		else
			if MMHUD.hudtrans >> V_ALPHASHIFT ~= 10
				MMHUD.hudtrans = (($ >> V_ALPHASHIFT) + 1) << V_ALPHASHIFT
			end
			
			MMHUD.dontslidein = false
		end
		MMHUD.hudtranshalf = htranstable[10 - (MMHUD.hudtrans >> V_ALPHASHIFT)] << V_ALPHASHIFT
		
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

addHud "deathflash"
addHud "outofbounds"
addHud "afktimeout"
addHud "interacthud"
addHud "endgamepointer"
addHud "murdererping"
addHud "stormgohere"
addHud "attraction"
addHud "showdownicon"
addHud "role"
--good coding practices
addHud "gamerole"
addHud "goals"
--addHud "heldweapon"
addHud "availableitems"
addHud "weapontime"
addHud "pregamehud"
addHud "payment"
addHud "info"
addHud "toptext"
addHud "seenplayer"
addHud "results"
addHud "intermissiontally"
addHud "rankings"
addHud "real_rankings"
addHud "perkicons"
addHud "perkhud"
addHud "intermissionhud"
addHud "interhud_scores"
addHud "showdownanim"
addHud "foundplayer"
addHud "debug"
addHud "textspectator"
addHud "spectatormode"
addHud "menulib"
