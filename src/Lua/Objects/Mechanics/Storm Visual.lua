// object freeslotting

states[freeslot "S_MM_STORMSPR"] = {
	sprite = freeslot "SPR_STRM",
	frame = A,
	tics = -1
}

mobjinfo[freeslot "MT_MM_STORMVISUAL"] = {
	radius = 1,
	height = 1,
	spawnstate = S_THOK,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT,
	flags2 = MF2_DONTDRAW
}

COM_AddCommand("spawnstorm", function(p)
	P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, MT_MM_STORMVISUAL)
end)

addHook("MobjSpawn", function(mo)
	mo.subobjects = {}
	mo.dist = 1024*FU
	mo.tics = -1
	mo.fuse = -1

	-- spawn objects
	for i = 1,16 do
		local submo = P_SpawnMobjFromMobj(mo,
			0,0,0,
			MT_THOK)
		submo.tics = -1
		submo.fuse = -1
		submo.state = S_MM_STORMSPR
		submo.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOTHINK|MF_NOBLOCKMAP
		submo.flags2 = 0
		table.insert(mo.subobjects, submo)
	end
end, MT_MM_STORMVISUAL)

addHook("MobjThinker", function(mo)
	if not (mo and mo.valid) then return end

	local color = P_RandomRange(SKINCOLOR_GALAXY,SKINCOLOR_NOBLE)

	local pi = (22*FU/7)
	local circ = FixedMul(2*pi, mo.dist/6)
	local amount = (circ/100)/FU

	local iter = 1
	while iter < amount do
		if not (mo.subobjects[iter] and mo.subobjects[iter].valid) then
			local submo = P_SpawnMobjFromMobj(mo,
				0,0,0,
				MT_THOK)
			submo.tics = -1
			submo.fuse = -1
			submo.state = S_MM_STORMSPR
			submo.flags = MF_NOCLIP|MF_NOCLIPHEIGHT|MF_NOGRAVITY|MF_NOTHINK|MF_NOBLOCKMAP
			submo.flags2 = 0
			table.insert(mo.subobjects, submo)
		end
		iter = $+1
	end

	for k,submo in pairs(mo.subobjects) do
		if k > amount then
			if submo and submo.valid then
				P_RemoveMobj(submo)
			end
			mo.subobjects[k] = nil
			continue
		end

		local angle = (360*FU)/amount
		angle = $*k
		angle = FixedAngle($) + FixedAngle(leveltime*FU)

		submo.color = color
		submo.colorized = true

		submo.scale = FU*2
		submo.spriteyscale = FixedDiv(2048*FU, 20*FU)

		submo.renderflags = $|RF_PAPERSPRITE|RF_NOCOLORMAPS
		submo.blendmode = AST_ADD
		submo.frame = $|FF_FULLBRIGHT

		P_MoveOrigin(submo,
			mo.x+FixedMul(mo.dist, cos(angle)),
			mo.y+FixedMul(mo.dist, sin(angle)),
			mo.floorz)
		submo.angle = angle+ANGLE_90
	end
end, MT_MM_STORMVISUAL)