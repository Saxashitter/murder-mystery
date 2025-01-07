local constvalues = {}

-- ACCESSED BY CALLING MMTYPE_NAME
local function MC(type, name)
	type = $:upper()
	name = $:upper()
	if constvalues[type] == nil then
		constvalues[type] = -1
	end
	constvalues[type] = $+1
	rawset(_G, "MM"..type.."_"..name, constvalues[type])

	print("MM // Made constant: MM"..type.."_"..name)
end

-- roles
MC("role", "innocent")
MC("role", "sheriff")
MC("role", "murderer")

MM.sniper_theme_offset = 13
MM.themes = {} -- intermission themes

local function addTheme(name)
	MM.themes[name] = dofile("Themes/"..name)
end

addTheme "srb2"

rawset(_G,"MM_PLAYER_STORMMAX",5*TICRATE)