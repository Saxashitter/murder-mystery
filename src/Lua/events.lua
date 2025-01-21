-- Simple lua to run hooks for the mod.
-- Adds easy modding support and more!

/*
	HOOK LIST:

	--[Game]--
		* "PostMapLoad", function()
			Executes once MM has given out clues, set the number of murderers, and after the map has loaded.

		* "Init", function()
			Executes once MM has set the number of murderers, but before the map has loaded and before
			clues have been given out.
		
	--[Player]--
		* "PlayerInit", function(player_t, boolean midgame?)
			Executes when a player spawns in and all MM variables are initialized.
			If "midgame?" true, then the player joined midgame as a spectator 

		* "PlayerThink", function(player_t player)
			Executes when an alive player thinks during a round

		* "DeadPlayerThink", function(player_t player)
			Executes when a dead player/spectator thinks during a round

		* "CorpseSpawn", function(mobj_t target, mobj_t corpse)
			Executes when a player mobj "target" dies and spawns mobj "corpse"
		
		* "CorpseThink", function(mobj_t corpse)
			Executes when a corpse thinks. "Even dead enemies think"
		
		* "CorpseFound", function(mobj_t corpse, mobj_t finder)
			Executes when player mobj "finder" finds "corpse"

		* "GiveStartWeapon", function(player_t, string/boolean given_weapon)
			TODO: implement fully before documenting
		
	--[Items]--
		* "InventorySwitch", function(player_t player, int cur_slot, int new_slot)
			Executes when a player decides to switch inventory slots, but before
			the switching executes.
			- Return value: Boolean (override default behavior?)
		
		* "ItemDrop", function(player_t player)
			Executes when a player drops an item by choice. This will not trigger
			during pregame or when forcibly dropped, like when a murderer picks up the
			revolver, for example.
			- Return value: Boolean (override default behavior?)
		
		* "ItemUse", function(player_t player)
			Executes when a player uses a weapon that fires bullets.
			- Return value: Boolean (override default behavior?)

		* "AttackPlayer", function(player_t inflictor, player_t target)
			Executes when player "inflictor" uses a melee weapon and hits player "target."
			- Return value: Boolean (don't hit target?, nil = use default behavior)

		* "CreateAlias", function(player_t player, table alias)
			Executes when the Uno Reverse creates an alias of "player" when swapped with someone.

		* "ApplyAlias", function(player_t player, table alias)
			Executes when the Uno Reverse applies an alias for "player" when swapping with someone.

*/

-- Simple lua to run hooks for the mod.
-- Adds easy modding support and more!
local events = {}
events["PostMapLoad"] = {}
events["Init"] = {}
events["PlayerInit"] = {}
events["PlayerThink"] = {}
events["DeadPlayerThink"] = {}
events["CorpseSpawn"] = {}
events["CorpseThink"] = {}
events["CorpseFound"] = {}
events["GiveStartWeapon"] = {}
events["InventorySwitch"] = {}
events["ItemDrop"] = {}
events["ItemUse"] = {}
events["AttackPlayer"] = {}
events["CreateAlias"] = {}
events["ApplyAlias"] = {}

local handler_snaptrue = {
	func = function(current, result)
		return result or current
	end,
	initial = false
}

local handler_snapany = {
	func = function(current, result)
		if result ~= nil then
			return result
		else
			return current
		end
	end,
	initial = nil
}
local handler_default = handler_snaptrue

MM.addHook = function(hooktype, func)
	if events[hooktype] then
		table.insert(events[hooktype], {
			func = func,
			errored = false
		})
	else
		error("Invalid HookType")
	end
end

MM.runHook = function(hooktype, ...)
	if not events[hooktype] then
		error("Invalid HookType")
	end

	local handler = events[hooktype].handler or handler_default
	local override = handler.initial

    for i,v in ipairs(events[hooktype]) do
		local status, result = pcall(v.func, ...)
		if status then
			override = handler.func(override, result)
		elseif not v.errored then
			v.errored = true
			print("WARNING: Error in Murder Mystery " .. hooktype .. " hook handler #" .. i .. ":")
			print(result)
		end
    end

    return override
end