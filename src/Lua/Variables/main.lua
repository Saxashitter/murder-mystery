addHook("MapChange", function()
	MM:init()
end)

addHook("NetVars", function(n)
	MM_N = n($)
end)