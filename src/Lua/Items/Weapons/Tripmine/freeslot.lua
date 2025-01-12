local TR = TICRATE
local function SafeFreeslot(...)
	for _, item in ipairs({...})
		if rawget(_G, item) == nil
			return freeslot(item)
		end
	end
end

SafeFreeslot("SPR_SBSM")
sfxinfo[SafeFreeslot("sfx_subsma")].caption = "Mine activate"
sfxinfo[SafeFreeslot("sfx_subsme")] = {
	caption = "Explosion",
	flags = SF_X8AWAYSOUND
}
sfxinfo[SafeFreeslot("sfx_subsmt")].caption = "/"

states[SafeFreeslot("S_MM_TRIPMINE_HELD")] = {
	sprite = SPR_NULL,
	frame = A,
	tics = -1
}

states[SafeFreeslot("S_MM_TRIPMINE")] = {
	sprite = SPR_SBSM,
	frame = A,
	action = function(mine)
		mine.activatein = 2
		mine.activatewait = 0
		mine.primed = false
		mine.fade = 0
	end,
	tics = -1
}
mobjinfo[SafeFreeslot("MT_MM_TRIPMINE")] = {
	doomednum = -1,
	spawnstate = S_MM_TRIPMINE,
	deathsound = sfx_subsme,
	activesound = sfx_subsma,
	seesound = sfx_subsmt,
	spawnhealth = 1,
	height = 32*FRACUNIT,
	radius = 16*FRACUNIT,
	flags = MF_SOLID|MF_RUNSPAWNFUNC
}

local function GetActorZ(actor,targ,type)
	if type == nil then type = 1 end
	if not (actor and actor.valid) then return 0 end
	if not (targ and targ.valid) then return 0 end
	
	local flip = P_MobjFlip(actor)
	
	--get z
	if type == 1
		if flip == 1
			return actor.z
		else
			return actor.z+actor.height-targ.height
		end
	--get top z
	elseif type == 2
		if flip == 1
			return actor.z+actor.height
		else
			return actor.z-targ.height
		end
		
	--RELATIVE
	--get z
	--since theres a good chance we're using these with P_SpawnMobjFromMobj,
	--make the distances absolute (FU, not mo.scale) since ^ already
	--does that
	elseif type == 3
		if flip == 1
			--ez
			return 0
		else
			return FixedDiv(actor.height-targ.height,actor.scale)
		end
	--get top z
	elseif type == 4
		if flip == 1
			return FixedDiv(actor.height,actor.scale)
		else
			return -FixedDiv(targ.height,actor.scale)
		end
	end
	
	return 0
end

local function delete3d(door)
	if not door.made3d
		return
	end
	
	if door.sides
		for k,v in pairs(door.sides)
			if v and v.valid
				P_RemoveMobj(v)
			end
		end
	end
	
	door.made3d = false
end

local numtotrans = {
	[10] = FF_TRANS90,
	[9] = FF_TRANS90,
	[8] = FF_TRANS80,
	[7] = FF_TRANS70,
	[6] = FF_TRANS60,
	[5] = FF_TRANS50,
	[4] = FF_TRANS40,
	[3] = FF_TRANS30,
	[2] = FF_TRANS20,
	[1] = FF_TRANS10,
	[0] = 0,
}
local TAKIS_3D_FLAGS = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP|MF_SCENERY

local function ThreeDThinker(door)
	local trans = numtotrans[door.fade]
	if door.fade == 10
		delete3d(door)
		return
	end
	
	if not door.made3d
		local list
		local flip = P_MobjFlip(door)
		door.flags2 = $|MF2_DONTDRAW
		
		door.sides = {}
		list = door.sides
		
		for i = 1,4
			local angle = door.angle+(FixedAngle(90*FU*(i-1)))
			list[0+i] = P_SpawnMobjFromMobj(door,
				P_ReturnThrustX(nil,angle,16*FU),
				P_ReturnThrustY(nil,angle,16*FU),
				0,MT_RAY
			)
			list[0+i].frame = A|FF_FULLBRIGHT
			list[0+i].sprite = SPR_SBSM
			list[0+i].tics,list[0+i].fuse = -1,-1
			list[0+i].flags = TAKIS_3D_FLAGS
			list[0+i].renderflags = $|RF_PAPERSPRITE|RF_NOSPLATBILLBOARD
			list[0+i].angle = angle+ANGLE_90
			list[0+i].height = 32*FU
			list[0+i].radius = 0
			list[0+i].destscale = door.scale
			list[0+i].scalespeed = list[0+i].destscale + 1
			P_SetOrigin(list[0+i],
				list[0+i].x,
				list[0+i].y,
				GetActorZ(door,list[0+i],1)
			)
		end
		list[7] = P_SpawnMobjFromMobj(door,0,0,0,MT_RAY)
		list[7].frame = C|FF_FULLBRIGHT
		list[7].sprite = SPR_SBSM
		list[7].tics,list[7].fuse = -1,-1
		list[7].flags = TAKIS_3D_FLAGS
		list[7].angle = door.angle
		list[7].height = door.height
		list[7].scale = door.scale
		list[7].destscale = door.destscale
		list[7].scalespeed = door.scalespeed
		P_SetOrigin(list[7],list[7].x,list[7].y,GetActorZ(door,list[7],1))
		
		door.made3d = true
	
	--update positions
	else
		local list = door.sides
		
		for i = 1,4
			local angle = door.angle+(FixedAngle(90*FU*(i-1)))
			list[0+i].angle = angle+ANGLE_90
			list[0+i].height = 32*FU
			list[0+i].radius = 0
			list[0+i].destscale = door.scale
			list[0+i].scalespeed = list[0+i].destscale + 1
			list[0+i].frame = ($ &~FF_TRANSMASK)|trans
			P_MoveOrigin(list[0+i],
				door.x+P_ReturnThrustX(nil,angle,16*door.scale) + door.momx,
				door.y+P_ReturnThrustY(nil,angle,16*door.scale) + door.momy,
				GetActorZ(door,list[0+i],1) + door.momz
			)
			
			if door.fade == 10
				list[0+i].flags2 = $|MF2_DONTDRAW
			end
		end
		
		list[7].angle = door.angle
		list[7].scale = door.scale
		list[7].frame = ($ &~FF_TRANSMASK)|trans
		P_MoveOrigin(list[7],
			door.x + door.momx,
			door.y + door.momy,
			GetActorZ(door,list[7],1) + door.momz
		)
		if door.fade == 10
			list[7].flags2 = $|MF2_DONTDRAW
		end
		
	end
	
end

addHook("MobjThinker",function(mine)
	if not (mine and mine.valid) then return end
	
	ThreeDThinker(mine)
	P_ButteredSlope(mine)
	
	if R_PointToDist2(0,0,mine.momx,mine.momy) <= 3*mine.scale
		if mine.activatein
			if not mine.activatewait
				S_StartSound(mine,mine.info.activesound)
				mine.activatewait = TR*3/2
				mine.activatein = $-1
				
				if mine.activatein == 0
					S_StartSound(mine,mine.info.seesound)
				end
			else
				mine.activatewait = $-1
			end
			
		end
		
	end
	
	if not mine.activatein
		if not mine.primed
			mine.flags = $|MF_SPECIAL
			mine.aura_ticker = 0
		end
		mine.primed = true
		
		if mine.fade < 10
		and (leveltime & 1)
			mine.fade = $+1
		end
	end
	
	if mine.fade == 10
		mine.aura_ticker = $+1
		
		local size = FU*3/2
		local maxtime = 45*TR
		if mine.aura_ticker > maxtime
			if (mine.aura and mine.aura.valid)
				P_RemoveFloorSpriteSlope(mine.aura)
				P_RemoveMobj(mine.aura)
				mine.aura = nil
			end
			return
		else
			size = ease.linear((FU/maxtime)*mine.aura_ticker, $, 1)
		end
		
		if not (mine.aura and mine.aura.valid)
			local aura = P_SpawnMobjFromMobj(mine,0,0,0,MT_THOK)
			aura.tics = -1
			aura.fuse = -1
			aura.renderflags = $|RF_FLOORSPRITE|RF_NOCOLORMAPS|RF_SLOPESPLAT|RF_OBJECTSLOPESPLAT
			aura.sprite = SPR_BGLS
			aura.frame = B|FF_FULLBRIGHT|FF_ADD|FF_TRANS60
			aura.scale = $
			aura.color = SKINCOLOR_GALAXY
			
			mine.aura = aura
		else
			local aura = mine.aura
			local mysin = sin(FixedAngle(mine.aura_ticker*5*FU))
			
			aura.spritexscale = size + mysin/5
			aura.spriteyscale = aura.spritexscale
			aura.color = SKINCOLOR_GALAXY
			aura.dispoffset = -5
			P_MoveOrigin(aura,
				mine.x,
				mine.y,
				mine.z + (FU/20)
			)
			
			if (mine.standingslope)
				if not aura.floorspriteslope
					P_CreateFloorSpriteSlope(aura)
				end
				local slope = aura.floorspriteslope
				local stand = mine.standingslope
				
				slope.o = {stand.o.x, stand.o.y, stand.o.z}
				slope.zangle = stand.zangle
				slope.xydirection = stand.xydirection
				
			elseif aura.floorspriteslope
				P_RemoveFloorSpriteSlope(aura)
			end
			
		end
	end
	
end,MT_MM_TRIPMINE)

local function SpawnSparks(mo)
	for i = 10,P_RandomRange(15,20)
		local spark = P_SpawnMobjFromMobj(mo,
			P_RandomRange(-32,32)*FU,
			P_RandomRange(-32,32)*FU,
			FixedDiv(mo.height/2,mo.scale) + P_RandomRange(-16,16)*FU,
			MT_THOK
		)
		spark.state = S_SPRK1
		spark.fuse = 16
		spark.colorized = true
		spark.blendmode = AST_ADD
		spark.color = SKINCOLOR_MAJESTY
		
		P_Thrust(spark,
			R_PointToAngle2(spark.x,spark.y, mo.x,mo.y),
			-3*spark.scale
		)
		P_SetObjectMomZ(spark,P_RandomRange(-3,3)*FU)
	end
end

local function SetPurplePlanes(mo)
	local fakerange = 256*mo.scale
	searchBlockmap("lines", function(ref, line)
		if line.frontside
			line.frontside.toptexture = R_TextureNumForName("VIOWALL")
			line.frontside.bottomtexture = line.frontside.toptexture
		end
		if line.backside
			line.backside.toptexture = R_TextureNumForName("VIOWALL")
			line.backside.bottomtexture = line.backside.toptexture
		--there is void behind this line
		else
			line.frontside.midtexture = R_TextureNumForName("VIOWALL")
		end
		
		if line.frontsector
			P_SpawnLightningFlash(line.frontsector)
			
			if line.frontsector.floorpic ~= "F_SKY1"
				line.frontsector.floorpic = "VIOWALL"
			end
			if line.frontsector.ceilingpic ~= "F_SKY1"
				line.frontsector.ceilingpic = "VIOWALL"
			end
			
			for fof in line.frontsector.ffloors()
				if fof.sector.floorpic ~= "F_SKY1"
					fof.sector.floorpic = "VIOWALL"
				end
				if fof.sector.ceilingpic ~= "F_SKY1"
					fof.sector.ceilingpic = "VIOWALL"
				end
				
				if fof.master.frontside
					fof.master.frontside.toptexture = R_TextureNumForName("VIOWALL")
					fof.master.frontside.bottomtexture = fof.master.frontside.toptexture
				end
				if fof.master.backside
					fof.master.backside.toptexture = R_TextureNumForName("VIOWALL")
					fof.master.backside.bottomtexture = fof.master.backside.toptexture
				--there is void behind this line
				else
					fof.master.frontside.midtexture = R_TextureNumForName("VIOWALL")
				end
			end
			
		end
		if line.backsector
			P_SpawnLightningFlash(line.backsector)
			
			if line.backsector.floorpic ~= "F_SKY1"
				line.backsector.floorpic = "VIOWALL"
			end
			if line.backsector.ceilingpic ~= "F_SKY1"
				line.backsector.ceilingpic = "VIOWALL"
			end
			
			for fof in line.backsector.ffloors()
				if fof.sector.floorpic ~= "F_SKY1"
					fof.sector.floorpic = "VIOWALL"
				end
				if fof.sector.ceilingpic ~= "F_SKY1"
					fof.sector.ceilingpic = "VIOWALL"
				end
				
				if fof.master.frontside
					fof.master.frontside.toptexture = R_TextureNumForName("VIOWALL")
					fof.master.frontside.bottomtexture = fof.master.frontside.toptexture
				end
				if fof.master.backside
					fof.master.backside.toptexture = R_TextureNumForName("VIOWALL")
					fof.master.backside.bottomtexture = fof.master.backside.toptexture
				--there is void behind this line
				else
					fof.master.frontside.midtexture = R_TextureNumForName("VIOWALL")
				end
			end
		end
	end, 
	mo,
	mo.x-fakerange, mo.x+fakerange,
	mo.y-fakerange, mo.y+fakerange)
	
end

addHook("TouchSpecial",function(mine,me)
	if not (mine and mine.valid) then return end
	if not (me and me.valid) then return end
	if not (me.health) then return end
	
	local p = me.player
	
	local sfx = P_SpawnGhostMobj(mine)
	sfx.flags2 = $|MF2_DONTDRAW
	sfx.fuse = 12*TR
	
	S_StartSound(sfx,mine.info.deathsound)
	S_StartSound(sfx,mine.info.deathsound)
	S_StartSound(sfx,mine.info.deathsound)
	
	if mine.aura and mine.aura.valid
		P_RemoveMobj(mine.aura)
	end
	
	P_KillMobj(me,mine,mine.tracer,DMG_INSTAKILL)
	me.color = SKINCOLOR_MAJESTY
	me.colorized = true
	S_StartSound(me,mine.info.deathsound)
	
	SpawnSparks(mine)
	SpawnSparks(me)
	SetPurplePlanes(mine)
	
	delete3d(mine)
end,MT_MM_TRIPMINE)

addHook("MobjRemoved",delete3d,MT_MM_TRIPMINE)

return S_MM_TRIPMINE_HELD