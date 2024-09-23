local weapon = {}

local MAX_COOLDOWN = TICRATE
local MAX_ANIM = MAX_COOLDOWN
local MAX_HIT = MAX_COOLDOWN/3

weapon.state = dofile "Weapons/Knife/Freeslot"
weapon.spawn = function(p, k)
	k.cooldown = 0
	k.anim = 0
	k.hit = 0
	k.hidden = true
	k.hidepressed = false
end
weapon.attack = function(p, k)
	if k.cooldown or k.hidden then
		return false
	end

	k.cooldown = MAX_COOLDOWN
	k.anim = MAX_ANIM
	k.hit = MAX_HIT

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
	local _ax = FixedMul(p.mo.radius, cos(p.mo.angle))
	local _ay = FixedMul(p.mo.radius, sin(p.mo.angle))

	k.ox = ease.incubic(anim_time, _ox, _ax)
	k.oy = ease.incubic(anim_time, _oy, _ay)

	k.cooldown = max(0, $-1)
	k.anim = max(0, $-1)
	k.hit = max(0, $-1)
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
weapon.name = "Knife"
weapon.icon = "MM_KNIFE"
weapon.restrict = {true, false, true}

return weapon