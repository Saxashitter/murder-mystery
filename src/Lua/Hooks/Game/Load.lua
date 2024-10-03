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