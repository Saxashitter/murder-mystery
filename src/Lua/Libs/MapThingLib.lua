local function SectorCeilingZ(sector, x, y)
	if not sector then
		sector = R_PointInSubsector(x, y).sector
	end

	local z = sector.ceilingheight

	if sector.c_slope and sector.c_slope.valid then
		z = P_GetZAt(sector.c_slope, x, y, $)
	end

	return z
end

local function SectorFloorZ(sector, x, y)
	if not sector then
		sector = R_PointInSubsector(x, y).sector
	end

	local z = sector.floorheight

	if sector.f_slope and sector.f_slope.valid then
		z = P_GetZAt(sector.f_slope, x, y, $)
	end

	return z
end

local function P_GetMobjSpawnHeight(mobjtype, x, y, dz, flip, scale, absolutez)
	local sector = R_PointInSubsector(x, y).sector
	local mobjdata = mobjinfo[mobjtype]

	if absolutez then
		return dz
	end

	if flip then
		return (SectorCeilingZ(sector, x, y) - dz) - FixedMul(mobjdata.height, scale)
	end

	return SectorFloorZ(sector, x, y) + dz
end

local function P_GetMapThingSpawnHeight(mobjtype, mthing, x, y)
	local dz = mthing.z*FU
	local flip = mobjinfo[mobjtype].flags & MF_SPAWNCEILING or mthing.options & MTF_OBJECTFLIP
	local absolutez = mthing.options & MTF_ABSOLUTEZ

	return P_GetMobjSpawnHeight(mobjtype, x, y, dz, flip, mthing.scale, absolutez);
end

return P_GetMobjSpawnHeight, P_GetMapThingSpawnHeight