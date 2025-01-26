--from clairebun
--https://wiki.srb2.org/wiki/User:Clairebun/Sandbox/Common_Lua_Functions#L_Choose
return function(...)
	local args = {...}
	local choice = P_RandomRange(1,#args)
	return args[choice]
end