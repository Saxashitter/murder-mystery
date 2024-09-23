local weapon = {}

local MAX_COOLDOWN = TICRATE/2
local MAX_ANIM = TICRATE

dofile "Weapons/Gun/Bullet"

weapon.state = dofile "Weapons/Gun/freeslot"
weapon.spawn = function(p, k)
	k.cooldown = 0
	k.anim = 0
	k.hidden = true
	k.hidepressed = false
end
weapon.attack = function(p, k)
	if k.cooldown or k.hidden then
		return false
	end

	k.cooldown = MAX_COOLDOWN
	k.anim = MAX_ANIM

	local bullet = P_SpawnMobjFromMobj(p.mo, 0,0,p.mo.height/2, MT_MM_BULLET)
	bullet.momx = 48*cos(p.mo.angle)
	bullet.momy = 48*sin(p.mo.angle)
	bullet.color = p.mo.color
	bullet.target = p.mo

	S_StartSound(p.mo, sfx_thok)
	return true
end
weapon.can_damage = function(p, k, p2)
	return (k.hit and not k.hidden)
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

	if k.hidden then
		k.flags2 = $|MF2_DONTDRAW
	else
		k.flags2 = $ & ~MF2_DONTDRAW
	end

	if p.cmd.buttons & BT_CUSTOM1
	and not (k.hidepressed) then
		k.hidden = not k.hidden
	end

	k.hidepressed = (p.cmd.buttons & BT_CUSTOM1)
end
weapon.name = "Gun"
weapon.icon = "MM_GUN"
weapon.droppable = true
weapon.restrict = {false, true, false}

return weapon