local roles = MM.require "Variables/Data/Roles"

local weapon = {}

local MAX_COOLDOWN = TICRATE
local MAX_ANIM = MAX_COOLDOWN
local MAX_HIT = MAX_COOLDOWN/5

weapon.id = "knife"
weapon.category = "Weapon"
weapon.display_name = "Knife"
weapon.display_icon = "MM_KNIFE"
weapon.state = dofile "Items/Weapons/Knife/freeslot"
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
weapon.droppable = false
weapon.shootable = false
weapon.shootmobj = MT_THOK
weapon.equipsfx = sfx_kequip
weapon.hitsfx = sfx_kffire
weapon.misssfx = sfx_kwhiff
weapon.allowdropmobj = false

local function distchecks(item, p, target)
	local dist = R_PointToDist2(p.mo.x, p.mo.y, target.x, target.y)
	local maxdist = FixedMul(p.mo.radius + target.radius, item.range)

	if dist > maxdist
	or abs((p.mo.z + p.mo.height/2) - (target.z + target.height/2)) > FixedMul(max(p.mo.height, target.height), item.zrange or item.range)
	or not P_CheckSight(p.mo, target) then
		return false
	end

	local adiff = FixedAngle(
		AngleFixed(R_PointToAngle2(p.mo.x, p.mo.y, target.x, target.y)) - AngleFixed(p.cmd.angleturn << 16)
	)
	if AngleFixed(adiff) > 180*FU
		adiff = InvAngle($)
	end
	if (AngleFixed(adiff) > 115*FU)
		return false
	end
	
	return true
end

weapon.thinker = function(item, p)
	if not (p and p.valid) then return end
	
	for p2 in players.iterate do
		if not (p2 ~= p
		and p2
		and p2.mo
		and p2.mo.health
		and p2.mm
		and not p2.mm.spectator) then continue end

		local dist = R_PointToDist2(p.mo.x, p.mo.y, p2.mo.x, p2.mo.y)
		local maxdist = FixedMul(p.mo.radius+p2.mo.radius, item.range)

		if roles[p.mm.role].team == roles[p2.mm.role].team
		and not roles[p.mm.role].friendlyfire then
			continue
		end
		
		if not distchecks(item,p,p2.mo) then continue end
		
		P_SpawnLockOn(p, p2.mo, S_LOCKON1)
	end
	
	if MMCAM
	and MMCAM.TOTALCAMS
		for k,cam in pairs(MMCAM.TOTALCAMS)
			if not (cam and cam.valid) then continue end
			if not (cam.health) then continue end
			if not (cam.args) then continue end
			if (cam.args.viewpoint) then continue end
			if not (cam.args.melee and cam.args.melee.valid) then continue end
			
			if not distchecks(item,p, cam.args.melee) then continue end
			
			P_SpawnLockOn(p, cam, S_LOCKON1)
		end
	end
	
end

--Whiff so people know youre bad at the game
weapon.onmiss = function(item,p)
	if not item.misssfx then return end
	S_StartSound(p.mo,item.misssfx)
end

weapon.attack = function(item,p)
	local me = p.mo
	
	if not (me and me.valid) then return end
	
	local angle = p.cmd.angleturn << 16
	local dist = 16*FU
	local whiff = P_SpawnMobjFromMobj(me,
		P_ReturnThrustX(nil,angle, dist) + me.momx,
		P_ReturnThrustY(nil,angle, dist) + me.momy,
		FixedDiv(me.height,me.scale)/2,
		MT_THOK
	)
	whiff.state = S_MM_KNIFE_WHIFF
	whiff.fuse = -1 --whiff.tics
	whiff.angle = angle
	whiff.renderflags = $|RF_NOSPLATBILLBOARD|RF_SLOPESPLAT
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
	
	--wumbo steve
	whiff.spritexscale = whiff.scale
	whiff.spriteyscale = FixedMul(cos(slope.zangle), whiff.scale + (slope.zangle == ANGLE_90 - 1 and 1024 or 0))
	
	me.whiff_fx = whiff
	
	if MMCAM
	and MMCAM.TOTALCAMS
		for k,cam in pairs(MMCAM.TOTALCAMS)
			if not (cam and cam.valid) then continue end
			if not (cam.health) then continue end
			if not (cam.args) then continue end
			if (cam.args.viewpoint) then continue end
			if not (cam.args.melee and cam.args.melee.valid) then continue end
			
			if not distchecks(item,p, cam.args.melee) then continue end
			
			P_KillMobj(cam,item.mobj,me)
		end
	end
	
end

MM:addPlayerScript(function(p)
	local me = p.mo
	
	if not (me and me.valid) then return end
	if (me.flags & MF_NOTHINK) then return end
	
	if (me.whiff_fx and me.whiff_fx.valid)
		local angle = p.cmd.angleturn << 16
		local dist = 16*FU
		
		P_MoveOrigin(me.whiff_fx,
			me.x + P_ReturnThrustX(nil,angle, dist) + me.momx,
			me.y + P_ReturnThrustY(nil,angle, dist) + me.momy,
			me.z + (me.height/2)
		)
		me.whiff_fx.angle = angle
		
		local aiming = AngleFixed(p.aiming + ANGLE_90)
		--clamp so it doesnt distort so much
		aiming = max(50*FU,min(130*FU,$))
		aiming = FixedAngle($) - ANGLE_90
		
		local whiff = me.whiff_fx
		local slope = whiff.floorspriteslope
		slope.o = {
			x = whiff.x, y = whiff.y, z = whiff.z
		}
		slope.zangle = aiming
		slope.xydirection = angle

		--wumbo steve
		whiff.spritexscale = whiff.scale
		whiff.spriteyscale = FixedMul(cos(slope.zangle), whiff.scale + (slope.zangle == ANGLE_90 - 1 and 1024 or 0))
	end
end)

return weapon