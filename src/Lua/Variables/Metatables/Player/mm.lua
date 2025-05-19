local funcs_path = "Variables/Metatables/Player/Functions"

local mt_giveitem = MM.require(funcs_path + "/give_item")
local mt_clearslot = MM.require(funcs_path + "/clear_slot")

local funcs = {
	["give_item"] = mt_giveitem;
	["clear_slot"] = mt_clearslot;
}

MM.player_metatable = {
	__index = function(a, key)
		if funcs[key] then
			return funcs[key]
		end
	end
}

registerMetatable(MM.player_metatable)
