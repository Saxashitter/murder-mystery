addHook("MapChange", function()
	MM:init()
end)

--Shitty
addHook("MapLoad", function()
	MM:init(true)
end)

addHook("NetVars", function(n)
	MM_N = n($)
end)

local oldrsc = CV_FindVar("restrictskinchange").value

addHook("GameQuit",do
	CV_Set(CV_FindVar("restrictskinchange"),oldrsc)
end)