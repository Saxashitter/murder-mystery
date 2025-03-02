local path = "Menus/menu_t/"

local tree = {
	"Main",
	"Shop",
	"Protips",
	"AdminPanel",
}

for k, name in ipairs(tree)
	dofile(path .. name)
end