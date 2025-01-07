local roles = MM.require "Variables/Data/Roles"
local doBrakes = MM.require "Libs/speedCap.lua"

local weapon = {}

local MAX_COOLDOWN = TICRATE
local MAX_ANIM = MAX_COOLDOWN
local MAX_HIT = MAX_COOLDOWN/5

weapon.id = "sword"
weapon.category = "Weapon"
weapon.display_name = "Sword"
weapon.display_icon = "MM_ROBLOX_SWORD"
weapon.state = dofile "Items/Weapons/Sword/freeslot"
weapon.timeleft = -1
weapon.hit_time = 2
weapon.animation_time = TICRATE
weapon.cooldown_time = TICRATE + TICRATE/2
weapon.range = FU*5
--you should be able to jump over and juke the murderer
weapon.zrange = FU
weapon.position = {
	x = FU,
	y = 0,
	z = 0
}
weapon.animation_position = {
	x = 0,
	y = FU,
	z = 0
}
weapon.stick = true
weapon.animation = true
weapon.damage = true
weapon.weaponize = true
weapon.droppable = true
weapon.shootable = false
weapon.shootmobj = MT_THOK
weapon.equipsfx = sfx_sequip
weapon.hitsfx = sfx_kffire
weapon.onlyhitone = true
weapon.droppable = true

local function LungeThink(item,p)
	local me = p.mo
	if not (me and me.health) then return end
	
	if item.lungetime
		me.flags = $|MF_NOGRAVITY
		
		me.momz = -P_GetMobjGravity(me)*3
		me.state = S_PLAY_WALK
		doBrakes(me,15*me.scale)
		
		p.drawangle = me.angle
		
		item.lungetime = $ - 1
		
		if item.lungetime == 0
			me.flags = $ &~MF_NOGRAVITY
		end
	end
	

end
weapon.thinker = function(item, p)
	if not (p and p.valid) then return end
	
	LungeThink(item,p)
	
	--so FUCKING good
	local mo = item.mobj
	
	if item.frameanimation
		mo.frame = (item.frameanimation >= TICRATE and B or C)
		if (item.frameanimation >= TICRATE - 5)
			P_SpawnGhostMobj(mo).frame = $|FF_ADD|FF_SEMIBRIGHT
		end
		
		item.frameanimation = $-1
		if item.frameanimation == 0
			mo.frame = A
		end
	end


	for p2 in players.iterate do
		if not (p2 ~= p
		and p2
		and p2.mo
		and p2.mo.health
		and p2.mm
		and not p2.mm.spectator) then continue end

		local dist = R_PointToDist2(p.mo.x, p.mo.y, p2.mo.x, p2.mo.y)
		local maxdist = FixedMul(p.mo.radius+p2.mo.radius, item.range)

		if dist > maxdist
		or abs((p.mo.z + p.mo.height/2) - (p2.mo.z + p2.mo.height/2)) > FixedMul(max(p.mo.height, p2.mo.height), item.zrange or item.range)
		or not P_CheckSight(p.mo, p2.mo) then
			continue
		end

		if roles[p.mm.role].team == roles[p2.mm.role].team
		and not roles[p.mm.role].friendlyfire then
			continue
		end
		
		local adiff = FixedAngle(
			AngleFixed(R_PointToAngle2(p.mo.x, p.mo.y, p2.mo.x, p2.mo.y)) - AngleFixed(p.cmd.angleturn << 16)
		)
		if AngleFixed(adiff) > 180*FU
			adiff = InvAngle($)
		end
		if (AngleFixed(adiff) > 115*FU)
			continue
		end
		
		P_SpawnLockOn(p, p2.mo, S_LOCKON1)
		break
	end
end

weapon.attack = function(item,p)
	--so goood.
	item.frameanimation = TICRATE
	item.mobj.frame = B
	
	local lunge = P_RandomChance(FU/2)
	S_StartSound(p.mo, lunge and sfx_slunge or sfx_sslash)
	
	if lunge
		item.lungetime = TICRATE/2
	end
	
	do
		local me = p.mo
		
		if not (me and me.valid) then return end
		
		local angle = p.cmd.angleturn << 16
		local dist = 16*FU
		local whiff = P_SpawnMobjFromMobj(me,
			P_ReturnThrustX(nil,angle, dist),
			P_ReturnThrustY(nil,angle, dist),
			FixedDiv(me.height,me.scale)/2,
			MT_THOK
		)
		whiff.state = S_MM_KNIFE_WHIFF
		whiff.fuse = -1 --whiff.tics
		whiff.angle = angle
		whiff.renderflags = $|RF_NOSPLATBILLBOARD
		whiff.frame = $|FF_TRANS50
		whiff.scale = $*5/2
		whiff.height = 0
		
		local aiming = AngleFixed(p.aiming + ANGLE_90)
		--clamp so it doesnt distort so much
		aiming = max(50*FU,min(130*FU,$))
		aiming = FixedAngle($) - ANGLE_90
		
		P_CreateFloorSpriteSlope(whiff)
		local slope = whiff.floorspriteslope
		slope.o = {
			x = whiff.x, y = whiff.y, z = whiff.z
		}
		slope.zangle = aiming
		slope.xydirection = angle
		
		me.whiff_fx = whiff
	end
end

weapon.unequip = function(item,p)
	item.frameanimation = nil
	item.mobj.frame = A

	if item.lungetime
		p.mo.flags = $ &~MF_NOGRAVITY
		item.lungetime = nil
	end
end
weapon.drop = function(item,p)
	if item.lungetime
		p.mo.flags = $ &~MF_NOGRAVITY
		item.lungetime = nil
	end
end

return weapon