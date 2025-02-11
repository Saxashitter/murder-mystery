local path = "Menus/menu_t/"

local tree = {
	"Shop"
}

for k, name in ipairs(tree)
	dofile(path .. name)
end