addHook("MapChange", do
	MM:init()
end)

addHook("NetVars", function(n)
	MM_N = n($)
end)