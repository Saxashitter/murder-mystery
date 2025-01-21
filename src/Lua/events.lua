-- Simple lua to run hooks for the mod.
-- Adds easy modding support and more!

local events = {}

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

MM.addHook = function(name, func)
	if not events[name] then
		-- TODO: make list of valid events and print as an error if its not valid
		events[name] = {}
	end

	table.insert(events[name], func)
end

MM.runHook = function(name, ...)
	if not events[name] then return end

	local return_value

	for _,call in pairs(events[name]) do
		return_value = call(...) or $
	end

	return return_value
end