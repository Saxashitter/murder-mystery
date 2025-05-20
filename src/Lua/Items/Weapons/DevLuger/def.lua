local weapon = {}

local roles = MM.require "Variables/Data/Roles"

weapon.id = "devluger"
weapon.category = "Weapon"
weapon.display_name = "\x82Super Sigma OP Luger"
weapon.display_icon = "MM_LUGER"
weapon.state = S_MM_LUGER
weapon.timeleft = -1
weapon.hit_time = 1
weapon.animation_time = 1
weapon.cooldown_time = 1
weapon.range = FU*2
weapon.position = {
	x = FU,
	y = 0,
	z = 0
}
weapon.animation_position = {
	x = FU,
	y = -FU/2,
	z = 0
}
weapon.stick = true
weapon.animation = true
weapon.damage = false
weapon.weaponize = true
weapon.droppable = true
weapon.shootable = true
weapon.shootmobj = MT_MM_REVOLV_BULLET
weapon.pickupsfx = sfx_gnpick
weapon.equipsfx = sfx_gequip
weapon.attacksfx = sfx_revlsh
weapon.allowdropmobj = true
weapon.rapidfire = true
weapon.max_ammo = 100
weapon.aimtrail = true

return weapon