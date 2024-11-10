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
weapon.hit_time = 6
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

return weapon