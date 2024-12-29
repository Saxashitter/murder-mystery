local weapon = {}

local roles = MM.require "Variables/Data/Roles"

local MAX_COOLDOWN = 3*TICRATE
local MAX_ANIM = TICRATE

weapon.id = "gun"
weapon.category = "Weapon"
weapon.display_name = "Shotgun"
weapon.display_icon = "MM_GUN"
weapon.state = dofile "Items/Weapons/Gun/freeslot"
weapon.timeleft = -1
weapon.hit_time = TICRATE/3
weapon.animation_time = TICRATE
weapon.cooldown_time = 3*TICRATE
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
weapon.shootmobj = dofile "Items/Weapons/Gun/bullet"
weapon.pickupsfx = sfx_gnpick
weapon.equipsfx = sfx_gequip
weapon.attacksfx = sfx_gnfire
weapon.allowdropmobj = true

function weapon:postpickup(p)
	if (MM_N.dueling) then return end
	if roles[p.mm.role].team == true then
		self.restrict[p.mm.role] = true
		self.timeleft = 5*TICRATE
	end
end

--shotgun spread
function weapon:attack(p)
	for i = -2,2
		if i == 0 then continue end
		
		local bullet = P_SpawnMobjFromMobj(p.mo,
			--dont spawn in the wall
			P_ReturnThrustX(nil,p.mo.angle, 2*FU),
			P_ReturnThrustY(nil,p.mo.angle, 2*FU),
			FixedDiv(p.mo.height,p.mo.scale)/2,
			self.shootmobj
		)

		bullet.angle = p.mo.angle + FixedAngle(P_RandomFixed()*i)*2
		bullet.aiming = p.aiming + FixedAngle(P_RandomFixed()*(P_RandomChance(FU/2) and 1 or -1))*7
		bullet.color = p.mo.color
		bullet.target = p.mo

		P_InstaThrust(bullet, bullet.angle, 32*cos(bullet.aiming))
		bullet.momz = 32*sin(bullet.aiming)

		table.insert(self.bullets, bullet)

	end
end

--(v, props.p, item, x,y, scale, flags, selected, not inv.hidden)
/*
weapon.drawer = function(v, p,item, x,y,scale,flags, selected, active)
	if selected and active
		v.drawString(160,100,"Test",0)
	end
end
*/

return weapon