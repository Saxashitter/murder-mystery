-- SAXAS MURDER MYSTERY

rawset(_G, "MM_N", {})
rawset(_G, "MM", {})

G_AddGametype({
    name = "Murder Mystery",
    identifier = "SAXAMM",
    typeoflevel = TOL_RACE,
    rules = GTR_FRIENDLYFIRE|GTR_SPAWNINVUL,
    intermissiontype = int_match,
    headerleftcolor = 222,
    headerrightcolor = 84,
	description = "wip"
})

MM.require = dofile "Libs/require"

dofile "Variables/main"
dofile "Functions/main"
dofile "Hooks/main"
dofile "Weapons/main"

dofile "Libs/CustomHud.lua"
dofile "Hud/HudHandle.lua"