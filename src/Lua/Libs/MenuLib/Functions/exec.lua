local path = MenuLib.root .. "Functions/Libs/"

local tree = {
	"clamp",
	"interpolate",
	
	"keyHandler",
	"newBufferID",
	"startTextInput",
	"stopTextInput",
	
	"addMenu",
	"initMenu",
	"findMenu",
	"initPopup",
}

for k, name in ipairs(tree)
	MenuLib[name] = dofile(path .. name)
end