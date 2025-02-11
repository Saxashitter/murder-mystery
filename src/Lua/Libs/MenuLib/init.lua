--MenuLib v0.0.2 written by luigi budd

if rawget(_G,"MenuLib")
	print("\x85MenuLib already loaded, aborting...")
	return
end

rawset(_G, "MenuLib", {})

rawset(_G, "BASEVIDWIDTH", BASEVIDWIDTH or 320)
rawset(_G, "BASEVIDHEIGHT", BASEVIDHEIGHT or 200)

MenuLib.VERSION = 000
MenuLib.SUBVERSION = 2
MenuLib.root = "Libs/MenuLib/"

MenuLib.client = {
	
	--Self explanatory
	menuactive = false,
	menuTime = 0,
	
	mouse_x = (BASEVIDWIDTH*FU) / 2,
	mouse_y = (BASEVIDHEIGHT*FU) / 2,
	
	--the button ID that we're hovering over
	hovering = -1,
	
	--menu ID
	currentMenu = {
		id = -1,
		layers = {}
	},
	popup_id = -1,
	
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