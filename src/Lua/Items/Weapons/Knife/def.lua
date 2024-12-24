local roles = MM.require "Variables/Data/Roles"

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
weapon.equipsfx = sfx_kequip
weapon.hitsfx = sfx_kffire

weapon.thinker = function(item, p)
	if not (p and p.valid) then return end
	
	for p2 in players.iterate do
		if not (p2 ~= p
		and p2
		and p2.mo
		and p2.mo.health
		and p2.mm
		and not p2.mm.spectator) then continue end

		local dist = R_PointToDist2(p.mo.x, p.mo.y, p2.mo.x, p2.mo.y)
		local maxdist = FixedMul(p.mo.radius+p2.mo.radius, item.range)

		if dist > maxdist
		or abs((p.mo.z + p.mo.height/2) - (p2.mo.z + p2.mo.height/2)) > FixedMul(max(p.mo.height, p2.mo.height), item.zrange or item.range)
		or not P_CheckSight(p.mo, p2.mo) then
			continue
		end

		if roles[p.mm.role].team == roles[p2.mm.role].team
		and not roles[p.mm.role].friendlyfire then
			continue
		end
		
		local adiff = FixedAngle(
			AngleFixed(R_PointToAngle2(p.mo.x, p.mo.y, p2.mo.x, p2.mo.y)) - AngleFixed(p.mo.angle)
		)
		if AngleFixed(adiff) > 180*FU
			adiff = InvAngle($)
		end
		if (AngleFixed(adiff) > 90*FU)
			continue
		end
		
		/*
		if MM.runHook("AttackPlayer", p, p2) then
			continue
		end

		if item.damage then
			P_DamageMobj(p2.mo, item.mobj, p.mo, 999, DMG_INSTAKILL)
		end
		
		if def.onhit then
			def.onhit(item,p,p2)
		end
		
		item.anim = min(item.max_anim/3, $)
		if item.hitsfx then
			S_StartSound(p.mo, item.hitsfx)
		end
		continue
		*/
		
		P_SpawnLockOn(p, p2.mo, S_LOCKON1)
	end
end

--Whiff so people know youre bad at the game
weapon.onmiss = function(item,p)
	S_StartSound(p.mo,sfx_kwhiff)
end

return weapon