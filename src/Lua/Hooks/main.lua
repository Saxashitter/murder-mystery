dofile "Hooks/Player/main"

customhud.SetupFont("STCFG")

dofile "Hooks/Game/Load"
dofile "Hooks/Game/Manager"
dofile "Hooks/HUD/main"

local oldrsc = CV_FindVar("restrictskinchange").value

addHook("GameQuit",do
	CV_Set(CV_FindVar("restrictskinchange"),oldrsc)
end)