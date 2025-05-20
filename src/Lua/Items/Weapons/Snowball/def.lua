local weapon = {}

local MAX_COOLDOWN = TICRATE
local MAX_ANIM = MAX_COOLDOWN
local MAX_HIT = MAX_COOLDOWN/3

weapon.id = "snowball"
weapon.category = "Weapon"
weapon.display_name = "Snowball"
weapon.display_icon = "MM_SNOWBALL"
weapon.state = dofile "Items/Weapons/Snowball/freeslot"
weapon.timeleft = -1
weapon.hit_time = TICRATE/3
weapon.animation_time = TICRATE/2
weapon.cooldown_time = TICRATE/2
weapon.range = FU
weapon.zrange = FU
weapon.position = {
	x = FU,
	y = 0,
	z = 0
}
weapon.animation_position = {
	x = 0,
	y = (FU/10)*8,
	z = FU/3
}
weapon.stick = true
weapon.animation = true
weapon.damage = false
weapon.weaponize = true
weapon.droppable = false
weapon.shootable = false
weapon.allowdropmobj = false
weapon.shootmobj = MT_THOK
weapon.equipsfx = sfx_None
weapon.attacksfx = freeslot "sfx_mcthrw"
weapon.max_ammo = 8
weapon.aimtrail = true

weapon.attack = function(item,p)
	P_SPMAngle(p.mo, MT_MM_SNOWBALL_BULLET, p.mo.angle, 1)
end

dofile "Items/Weapons/Snowball/bullet"

return weapon