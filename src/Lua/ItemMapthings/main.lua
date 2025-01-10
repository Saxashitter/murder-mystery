freeslot "MT_MM_ITEMSPAWN"

mobjinfo[MT_MM_ITEMSPAWN] = {
	--$Name Item Spawner
	--$Sprite UNKNB0
	--$Category SaxaMM
	--$NotAngled
	--$StringArg0 Item ID
	--$StringArg0ToolTip The item's ID to spawn.
	flags = MF_NOGRAVITY|MF_NOBLOCKMAP,
	radius = 16*FRACUNIT,
	height = 32*FRACUNIT,
	doomednum = 3003,
	spawnstate = S_NULL
}

addHook("MapThingSpawn",function(mo,mt)
	local item_id = mt.stringargs[0]
	
	if MM.Items[item_id] then
		if item_id then
			if mo and mo.valid then
				MM:SpawnItemDrop(item_id, mo.x, mo.y, mo.z, mo.angle, 0)
			end
		end
	end
end, MT_MM_ITEMSPAWN)