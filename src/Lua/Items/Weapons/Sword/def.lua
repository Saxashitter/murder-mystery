local roles = MM.require "Variables/Data/Roles"

local weapon = {}

local MAX_COOLDOWN = TICRATE
local MAX_ANIM = MAX_COOLDOWN
local MAX_HIT = MAX_COOLDOWN/5

weapon.id = "sword"
weapon.category = "Weapon"
weapon.display_name = "Sword"
weapon.display_icon = "MM_ROBLOX_SWORD"
weapon.state = dofile "Items/Weapons/Sword/freeslot"
weapon.timeleft = -1
weapon.hit_time = 2
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
weapon.equipsfx = sfx_sequip
weapon.hitsfx = sfx_kffire

weapon.thinker = function(item, p)
	if not (p and p.valid) then return end
	
	--so FUCKING good
	local mo = item.mobj
	
	if item.frameanimation
		mo.frame = (item.frameanimation >= TICRATE and B or C)
		if (item.frameanimation >= TICRATE - 5)
			P_SpawnGhostMobj(mo).frame = $|FF_ADD|FF_SEMIBRIGHT
		end
		
		item.frameanimation = $-1
		if item.frameanimation == 0
			mo.frame = A
		end
	end
end

weapon.attack = function(item,p)
	--so goood.
	item.frameanimation = TICRATE
	item.mobj.frame = B
	S_StartSound(p.mo,P_RandomChance(FU/2) and sfx_slunge or sfx_sslash)
end

return weapon