local weapon = {}

local MAX_COOLDOWN = 3*TICRATE
local MAX_ANIM = TICRATE

weapon.id = "gun"
weapon.display_name = "Gun"
weapon.display_icon = "MM_GUN"
weapon.state = dofile "Items/Weapons/Gun/freeslot"
weapon.timeleft = -1
weapon.hit_time = TICRATE/3
weapon.animation_time = TICRATE
weapon.cooldown_time = 3*TICRATE
weapon.position = {
	x = FU,
	y = 0,
	z = 0
}
weapon.animation_position = {
	x = FU,
	y = -FU/4,
	z = 0
}
weapon.sidestick = true
weapon.animation = true
weapon.damage = true
weapon.weaponize = true
weapon.droppable = true
weapon.shootable = true
weapon.shootmobj = dofile "Items/Weapons/Gun/bullet"
weapon.equipsfx = sfx_gequip
weapon.hitsfx = sfx_gnfire

return weapon