local constvalues = {}

-- ACCESSED BY CALLING MMTYPE_NAME
local function MC(type, name)
	type = $:upper()
	name = $:upper()
	if constvalues[type] == nil then
		constvalues[type] = -1
	end
	constvalues[type] = $+1
	rawset(_G, "MM"..type.."_"..name, constvalues[type])

	print("MM // Made constant: MM"..type.."_"..name)
end

-- roles
MC("role", "innocent")
MC("role", "sheriff")
MC("role", "murderer")