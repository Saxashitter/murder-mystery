local weapon = {}

local MAX_COOLDOWN = TICRATE
local MAX_ANIM = MAX_COOLDOWN
local MAX_HIT = MAX_COOLDOWN/3

weapon.id = "beartrap"
weapon.category = "Weapon"
weapon.display_name = "Bear Trap"
weapon.display_icon = "MM_BEARTRAP"
weapon.state = dofile "Items/Weapons/BearTrap/freeslot"
weapon.timeleft = -1
weapon.hit_time = TICRATE/3
weapon.animation_time = TICRATE/2
weapon.cooldown_time = TICRATE/2
weapon.range = FU
weapon.zrange = FU
weapon.position = {
	--(FU*3/2) yw jisk
	x = tofixed("1.5"),
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
weapon.weaponize = false
weapon.droppable = false
weapon.shootable = false
weapon.allowdropmobj = false
weapon.shootmobj = MT_THOK
weapon.equipsfx = sfx_None
weapon.attacksfx = sfx_None
weapon.minemobj = MT_MM_BEARTRAP
weapon.maxshots = 20

local function DropBearTrap(p)
	local me = p.mo
	local mine = P_SpawnMobjFromMobj(me,
		P_ReturnThrustX(nil,me.angle,64*FU),
		P_ReturnThrustY(nil,me.angle,64*FU),
		FixedDiv(me.height,me.scale)/2,
		weapon.minemobj
	)
	mine.angle = me.angle
	mine.scale = me.scale
	mine.tracer = me
end

-- Copied lugger code. This should really be implemented in a cleaner way.
weapon.hiddenthinker = function(item,p)
	item.ammoleft = $ or weapon.maxshots
end
weapon.thinker = weapon.hiddenthinker

weapon.attack = function(item,p)
	if item.ammoleft == nil or item.ammoleft == 0 then return end
	
	DropBearTrap(p)
	item.ammoleft = $ - 1
	
	if item.ammoleft == 0
		MM:DropItem(p,nil,false,true,true)
	end
end

weapon.drawer = function(v, p,item, x,y,scale,flags, selected, active)
	if item.ammoleft == nil then return end
	if not selected
		v.drawString(x, (y + 32*scale) - 8*FU,
			item.ammoleft.."/"..weapon.maxshots,
			(flags &~V_ALPHAMASK)|V_ALLOWLOWERCASE,
			"thin-fixed"
		)
		
		return
	end
	
	v.drawString(160*FU,y - 20*FU,
		"Ammo: "..item.ammoleft.." / "..weapon.maxshots,
		(flags &~V_ALPHAMASK)|V_ALLOWLOWERCASE,
		"thin-fixed-center"
	)
end

--dofile "Items/Weapons/BearTrap/trap"

return weapon