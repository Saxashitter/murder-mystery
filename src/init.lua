-- SAXAS MURDER MYSTERY

rawset(_G, "MM_N", {})
rawset(_G, "MM", {})

G_AddGametype({
    name = "Murder Mystery",
    identifier = "SAXAMM",
    typeoflevel = TOL_COOP|TOL_MATCH,
    rules = GTR_FRIENDLYFIRE|GTR_SPAWNINVUL,
    intermissiontype = int_match,
    headerleftcolor = 222,
    headerrightcolor = 84,
	description = "wip"
})

MM.require = dofile "Libs/require"
dofile "Libs/CustomHud.lua"

dofile "Variables/main"
dofile "Functions/main"
dofile "Console/main"
dofile "Hooks/main"
dofile "Weapons/main"

