local roles = MM.require "Variables/Data/Roles"

local weapon = {}

local MAX_COOLDOWN = TICRATE
local MAX_ANIM = MAX_COOLDOWN
local MAX_HIT = MAX_COOLDOWN/5

weapon.id = "tripmine"
weapon.category = "Weapon"
weapon.display_name = "\x89Subspace Tripmine"
weapon.display_icon = "MM_TRIPMINE"
weapon.state = dofile "Items/Weapons/Tripmine/freeslot"
weapon.timeleft = -1
weapon.hit_time = 2
weapon.animation_time = TICRATE
weapon.cooldown_time = TICRATE
weapon.position = {
	x = FU*3/2,
	y = 0,
	z = 0
}
weapon.animation_position = {
	x = 0,
	y = 2*FU,
	z = 0
}
weapon.stick = true
weapon.animation = true
weapon.weaponize = true
weapon.droppable = false
weapon.shootable = false
weapon.shootmobj = MT_THOK
weapon.minemobj = MT_MM_TRIPMINE
weapon.allowdropmobj = false
weapon.maxshots = 5

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
		door.flags2 = $ &~MF2_DONTDRAW
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
	door.flags2 = $ &~MF2_DONTDRAW
end

local function DropTripmine(p)
	local me = p.mo
	local mine = P_SpawnMobjFromMobj(me,
		P_ReturnThrustX(nil,me.angle,64*FU),
		P_ReturnThrustY(nil,me.angle,64*FU),
		FixedDiv(me.height,me.scale)/2,
		weapon.minemobj
	)
	mine.angle = me.angle
	mine.scale = me.scale
	mine.tracer = me
end

local TAKIS_3D_FLAGS = MF_NOGRAVITY|MF_NOCLIPHEIGHT|MF_NOCLIP|MF_SCENERY
local function ThreeDThinker(door, me)
	local trans = 0

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
				door.x+P_ReturnThrustX(nil,angle,16*door.scale) + me.momx,
				door.y+P_ReturnThrustY(nil,angle,16*door.scale) + me.momy,
				GetActorZ(door,list[0+i],1) + me.momz
			)
			
		end
		
		list[7].angle = door.angle
		list[7].scale = door.scale
		list[7].frame = ($ &~FF_TRANSMASK)|trans
		P_MoveOrigin(list[7],
			door.x + me.momx,
			door.y + me.momy,
			(P_MobjFlip(door) == 1 and door.z or door.z + door.height) + me.momz
		)
		
	end
	
end

weapon.hiddenthinker = function(item,p)
	item.ammoleft = $ or weapon.maxshots
	item.mobj.height = 32 * p.mo.scale
	
	if (p.mm.inventory.hidden)
	or (item.cooldown)
		delete3d(item.mobj)
		return
	end
	
	ThreeDThinker(item.mobj, p.mo)
end
weapon.thinker = weapon.hiddenthinker

weapon.attack = function(item,p)
	if item.ammoleft == nil or item.ammoleft == 0 then return end
	
	DropTripmine(p)
	delete3d(item.mobj)
	
	item.ammoleft = $ - 1
	
	if item.ammoleft == 0
		MM:DropItem(p,nil,false,true,true)
	end
end

weapon.drawer = function(v, p,item, x,y,scale,flags, selected, active)
	if item.ammoleft == nil then return end
	if not selected
		v.drawString(x, (y + 32*scale) - 8*FU,
			item.ammoleft.."/"..weapon.maxshots,
			(flags &~V_ALPHAMASK)|V_ALLOWLOWERCASE,
			"thin-fixed"
		)
		
		return
	end
	
	v.drawString(160*FU,y - 20*FU,
		"Ammo: "..item.ammoleft.." / "..weapon.maxshots,
		(flags &~V_ALPHAMASK)|V_ALLOWLOWERCASE,
		"thin-fixed-center"
	)
end

weapon.unequip = function(item,p)
	delete3d(item.mobj)
end
weapon.drop = function(item,p)
	delete3d(item.mobj)
end

return weapon