local weapon = {}

local MAX_COOLDOWN = TICRATE
local MAX_ANIM = MAX_COOLDOWN
local MAX_HIT = MAX_COOLDOWN/3

weapon.state = dofile "Weapons/Knife/Freeslot"
weapon.spawn = function(p, k)
	k.cooldown = 0
	k.anim = 0
	k.hit = 0
	k.mark = true
end
weapon.attack = function(p, k)
	if k.cooldown or k.hidden then
		return false
	end

	k.cooldown = MAX_COOLDOWN
	k.anim = MAX_ANIM
	k.hit = MAX_HIT

	return true
end
weapon.can_damage = function(p, k)
	return (k.hit)
end
weapon.on_damage = function(mo, mo2, k)
	local anglediff = anglefix(R_PointToAngle2(mo.x, mo.y, mo2.x, mo2.y))
	local angle = anglefix(mo.angle)

	--print(abs(angle-anglediff)/FU)

	S_StartSound(mo, sfx_kffire)
	k.hit = 0
end
weapon.equip = function(p, k)
	S_StartSound(p.mo, sfx_kequip)
	k.cooldown = max($, 24)
end
weapon.think = function(p, k)
	local anim_time = FixedDiv(k.anim, MAX_ANIM)

	local _ox = FixedMul(p.mo.radius, cos(p.mo.angle-(90*ANG1)))
	local _oy = FixedMul(p.mo.radius, sin(p.mo.angle-(90*ANG1)))
	local _ax = FixedMul(p.mo.radius, cos(p.mo.angle))
	local _ay = FixedMul(p.mo.radius, sin(p.mo.angle))

	k.ox = ease.incubic(anim_time, _ox, _ax)
	k.oy = ease.incubic(anim_time, _oy, _ay)

	k.cooldown = max(0, $-1)
	k.anim = max(0, $-1)
	k.hit = max(0, $-1)
end
weapon.name = "Knife"
weapon.icon = "MM_KNIFE"
weapon.restrict = {true, false, true}
weapon.hold_another = true

return weapon