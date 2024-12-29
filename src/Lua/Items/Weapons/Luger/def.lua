local weapon = {}

local roles = MM.require "Variables/Data/Roles"

local MAX_COOLDOWN = 3*TICRATE
local MAX_ANIM = TICRATE

weapon.id = "luger"
weapon.category = "Weapon"
weapon.display_name = "Luger"
weapon.display_icon = "MM_LUGER"
weapon.state = dofile("Items/Weapons/Luger/freeslot")
weapon.timeleft = -1
weapon.hit_time = TICRATE/3
weapon.animation_time = TICRATE/3
weapon.cooldown_time = 4*TICRATE
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
weapon.droppable = false
weapon.shootable = true
weapon.shootmobj = MT_MM_REVOLV_BULLET
weapon.pickupsfx = sfx_gnpick
weapon.equipsfx = sfx_gequip
weapon.attacksfx = sfx_lugrsh
weapon.allowdropmobj = false
weapon.maxshots = 3

function weapon:postpickup(p)
	if (MM_N.dueling) then return end
	if roles[p.mm.role].team == true then
		self.restrict[p.mm.role] = true
		self.timeleft = 5*TICRATE
	end
end

--we dont need to do much here
weapon.hiddenthinker = function(item,p)
	item.ammoleft = $ or weapon.maxshots
end
weapon.thinker = weapon.hiddenthinker

weapon.attack = function(item,p)
	if item.ammoleft == nil or item.ammoleft == 0 then return end
	
	item.ammoleft = $ - 1
	
	if item.ammoleft == 0
		MM:DropItem(p,nil,false,true,true)
	end
end

weapon.drawer = function(v, p,item, x,y,scale,flags, selected, active)
	if not selected then return end
	if item.ammoleft == nil then return end
	
	v.drawString(160*FU,y - 20*FU,
		"Ammo: "..item.ammoleft.." / "..weapon.maxshots,
		(flags &~V_ALPHAMASK)|V_ALLOWLOWERCASE,
		"thin-fixed-center"
	)
end

return weapon