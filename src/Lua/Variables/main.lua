local constvalues = {}

-- ACCESSED BY CALLING MMTYPE_NAME
local function MC(type, name, val_add)
	val_add = $ or 0
	
	type = $:upper()
	name = $:upper()
	if constvalues[type] == nil then
		constvalues[type] = -1
	end
	constvalues[type] = $+1 + val_add
	rawset(_G, "MM"..type.."_"..name, constvalues[type])

	print("MM // Made constant: MM"..type.."_"..name)
end

-- roles
MC("role", "innocent")
MC("role", "sheriff")
MC("role", "murderer")

-- perks
MC("perk", "footsteps", 1)
MC("perk", "ninja", 1)
MC("perk", "haste", 1)
MC("perk", "ghost", 1)
MC("perk", "swap", 1)
MC("perk", "fakegun", 1)
MC("perk", "trap", 1)

MM.sniper_theme_offset = 13
MM.themes = {} -- intermission themes

local function addTheme(name)
	MM.themes[name] = dofile("Themes/"..name)
end

addTheme "srb2"

rawset(_G,"MM_PLAYER_STORMMAX",5*TICRATE)