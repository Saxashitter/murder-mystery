local weapon = {}

local MAX_COOLDOWN = TICRATE/2
local MAX_ANIM = TICRATE

dofile "Weapons/Gun/Bullet"

weapon.state = dofile "Weapons/Gun/freeslot"
weapon.spawn = function(p, k)
	k.cooldown = 0
	k.anim = 0
end
weapon.attack = function(p, k)
	if k.cooldown or k.hidden then
		return false
	end

	k.cooldown = MAX_COOLDOWN
	k.anim = MAX_ANIM

	local bullet = P_SpawnMobjFromMobj(p.mo, 0,0,p.mo.height/2, MT_MM_BULLET)
	bullet.momx = FixedMul(48*cos(p.mo.angle), cos(p.aiming))
	bullet.momy = FixedMul(48*sin(p.mo.angle), cos(p.aiming))
	bullet.momz = 48*sin(p.aiming)
	bullet.color = p.mo.color
	bullet.target = p.mo

	S_StartSound(p.mo, sfx_thok)
	return true
end
weapon.can_damage = function(p, k)
	return (k.hit)
end
weapon.think = function(p, k)
	local anim_time = FixedDiv(k.anim, MAX_ANIM)

	local _ox = FixedMul(p.mo.radius, cos(p.mo.angle-(90*ANG1)))
	local _oy = FixedMul(p.mo.radius, sin(p.mo.angle-(90*ANG1)))
	local _ax = _ox+FixedMul(-12*FU, cos(p.mo.angle))
	local _ay = _oy+FixedMul(-12*FU, sin(p.mo.angle))

	k.ox = ease.incubic(anim_time, _ox, _ax)
	k.oy = ease.incubic(anim_time, _oy, _ay)

	k.cooldown = max(0, $-1)
	k.anim = max(0, $-1)
end
weapon.name = "Gun"
weapon.icon = "MM_GUN"
weapon.droppable = true
weapon.restrict = {false, true, false}

return weapon