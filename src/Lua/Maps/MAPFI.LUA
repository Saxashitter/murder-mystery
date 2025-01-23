--Code by Luigi Budd

local FI_MAPSCALE = FU*4/5

local scaledown = {
	[MT_PLAYER] = true,
	[MT_RING] = true
}

addHook("MobjSpawn",function(mo)
    if (not MM:isMM()) or (gamemap != 298) then return end
	if not scaledown[mo.type] then return end
	
	mo.scale = FixedMul($,FI_MAPSCALE)
	mo.destscale = mo.scale
end)