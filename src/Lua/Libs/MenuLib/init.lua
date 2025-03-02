--MenuLib v0.0.3 written by luigi budd

if rawget(_G,"MenuLib")
	print("\x85MenuLib already loaded, aborting...")
	return
end

rawset(_G, "MenuLib", {})

rawset(_G, "BASEVIDWIDTH", BASEVIDWIDTH or 320)
rawset(_G, "BASEVIDHEIGHT", BASEVIDHEIGHT or 200)

local function enumflags(prefix, ...)
	local work = {...}
	
	for k,enum in ipairs(work)
		local val = 1<<(k-1)
		assert(val ~= -1,"\x85Ran out of bits for "..prefix.."! (k="..k..")\x80")
		
		rawset(_G,prefix..enum,val)
		print("Enummed "..prefix..""..enum.." ("..val..")")
	end
end

--Popup-Style flags
enumflags("PS_",
	--this popup will automatically draw the title and separating line
	"DRAWTITLE",
	
	--this popup wont have an "X" button, youd better have it close itself!
	"NOXBUTTON",
	
	--this popup wont fade the other menus behind it
	"NOFADE",
	
	--this popup is purely visual, and will not be interactable
	"IRRELEVANT",
	
	--this popup will not slide in from the bottom
	"NOSLIDEIN",
	
	--HOLY SHIT
	--this popup cannot be closed with the escape key
	"NOESCAPE"
)

MenuLib.VERSION = 000
MenuLib.SUBVERSION = 3
--dont forget the ending "/"
MenuLib.root = "Libs/MenuLib/"

MenuLib.client = {
	
	--Self explanatory
	menuactive = false,
	menuTime = 0,
	
	mouse_x = (BASEVIDWIDTH*FU) / 2,
	mouse_y = (BASEVIDHEIGHT*FU) / 2,
	
	--the button ID that we're hovering over
	hovering = -1,
	canPressSomething = false,
	
	--menu ID
	currentMenu = {
		id = -1,
		layers = {}
	},
	popups = {},
	menuLayer = 0,
	
	--use this when detecting mouse presses
	doMousePress = false,
	mouseTime = -1,
}


local tree = {
	"main",
	
	"Functions/exec",
	"HUD/exec",
}

for k,file in ipairs(tree)
	dofile(MenuLib.root .. file)
end