freeslot "MT_MM_ITEMSPAWN"

mobjinfo[MT_MM_ITEMSPAWN] = {
	--$Name Item Spawner
	--$Sprite RVOLA2A8
	--$Category EPIC!MM
	--$NotAngled
	--$StringArg0 Item ID
	--$StringArg0ToolTip The item's ID to spawn.
	--$Arg0 Price
	--$Arg0Default 0
	--$Arg0Type 0
	--$Arg0Tooltip How many coins does this item cost to pick up?\nIf the player doesn't have enough coins, the item stays in place. 
	--$Arg1 Interact Duration
	--$Arg1Default 5
	--$Arg1Type 0
	--$Arg1Tooltip How long a player needs to interact (in tics) in order to activate.
	flags = MF_NOGRAVITY|MF_NOBLOCKMAP,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	doomednum = 8003,
	spawnstate = S_NULL
}

addHook("MapThingSpawn",function(mo,mt)
	local item_id = mt.stringargs[0]
	local item_cost = mt.args[0]
	local item_pickuptime = mt.args[1]
	
	if MM.Items[item_id] then
		if item_id then
			if mo and mo.valid then
				MM:SpawnItemDrop(item_id, mo.x, mo.y, mo.z, mo.angle, 0, {
					price = item_cost;
					pickuptime = item_pickuptime;
				})
			end
		end
	end
end, MT_MM_ITEMSPAWN)