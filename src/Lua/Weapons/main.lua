mobjinfo[freeslot "MT_MM_WEAPON"] = {
	radius = 24*FU,
	height = 24*FU,
	spawnstate = S_THOK,
	flags = MF_NOGRAVITY|MF_NOCLIP|MF_NOCLIPHEIGHT,
	flags2 = MF2_DONTDRAW
}

MM.weapons = {}

local roles = MM.require "Variables/Data/Roles"

local function getWeapon(file)
	local data = dofile("Weapons/"..file.."/def.lua")

	MM.weapons[file] = data
end

-- globalized version for modding
function MM:makeWeapon(name, data)
	self.weapons[name] = data
end

local function spawn_weapon(p, name)
	local weapon = P_SpawnMobj(p.mo.x, p.mo.y, p.mo.z, MT_MM_WEAPON)
	weapon.__type = name
	weapon.target = p.mo
	weapon.fired = false
	weapon.state = MM.weapons[name].state

	weapon.ox = 0
	weapon.oy = 0
	weapon.oz = 0

	weapon.hidden = true
	weapon.hidepressed = false

	MM.weapons[name].spawn(p, weapon)

	return weapon
end

function MM:giveWeapon(p, name, forced, time)
	if not (p.mo and p.mm and not p.mm.spectator) then return end
	if not (self.weapons[name]) then return end

	if p.mm.weapon and p.mm.weapon.valid and not forced then
		local data = self:getWpnData(p.mm.weapon)

		if not data.hold_another then
			return
		end

		p.mm.weapon2 = spawn_weapon(p, name)
		p.mm.weapon2.time = time or 5*TICRATE

		p.mm.weapon.hidden = true
		return
	end

	if p.mm.weapon and p.mm.weapon.valid then
		P_RemoveMobj(p.mm.weapon)
	end

	p.mm.weapon = spawn_weapon(p, name)
end

function MM:getWpnData(wpn)
	if not (wpn and wpn.valid) then return end

	return self.weapons[wpn.__type]
end

local weapons = {}
addHook("NetVars", function(n) weapons = n($) end)

addHook("MobjSpawn", function(wpn)
	table.insert(weapons, wpn)
end, MT_MM_WEAPON)

local function do_damage(pmo, mo)
	if (roles[pmo.player.mm.role].team == roles[mo.player.mm.role].team) then
		if not roles[pmo.player.mm.role].friendlyfire then
			return
		end
	end

	if MM.weapons[pmo.player.mm.weapon.__type].on_damage
	and MM.weapons[pmo.player.mm.weapon.__type].on_damage(pmo, mo, pmo.player.mm.weapon) then
		return
	end
	P_DamageMobj(mo, pmo.player.mm.weapon, pmo, 999, DMG_INSTAKILL)

	return true
end

local function search_players(p,target)
	if not (p
	and p.mo
	and p.mo.valid
	and p.mo.health
	and p.mm
	and not p.mm.spectator
	and p.mm.weapon
	and p.mm.weapon.valid) then return end

	local wpn = p.mm.weapon
	local wpn_t = MM:getWpnData(wpn)

	for p2 in players.iterate do
		if not (p2
		and p2.mo
		and p2.mo.valid
		and p2.mo.health
		and p2.mm
		and not p2.mm.spectator
		and p2 ~= p) then continue end

		local dist = R_PointToDist2(p.mo.x, p.mo.y, p2.mo.x, p2.mo.y)
		local z_dist = abs(p2.mo.z-p.mo.z)

		if dist > (p.mo.radius+p2.mo.radius)*3 then
			continue
		end
		if z_dist > max(p.mo.height, p2.mo.height)*5/4 then
			continue
		end
		
		if not P_CheckSight(p.mo,p2.mo) then return end
		
		if wpn.mark
		and not wpn.hidden
		and not (wpn.hit) then
			P_SpawnLockOn(p, p2.mo, S_LOCKON1)
		end

		local canDamage = wpn_t.can_damage and wpn_t.can_damage(p.mo, wpn)
		if canDamage == nil then
			canDamage = false
		end

		if not wpn.hidden
		and canDamage then
			do_damage(p.mo, p2.mo)
		end
	end
end

local function drop_weapon(wpn, restrict_pickup)
	wpn.dropped = true

	local p = wpn.target.player

	if p.mm.weapon == wpn then
		p.mm.weapon = nil
	end
	if p.mm.weapon2 == wpn then
		p.mm.weapon2 = nil
	end

	local x = wpn.target.x
	local y = wpn.target.y
	local d_wpn = MM:spawnDroppedWeapon(x, y, wpn.z, wpn.__type)
	
	d_wpn.angle = wpn.target.angle
	P_Thrust(d_wpn,d_wpn.angle,8*d_wpn.scale)
	P_SetObjectMomZ(d_wpn,4*FU)

	if restrict_pickup then
		d_wpn.target = wpn.target
	end

	P_RemoveMobj(wpn)
end

addHook("MobjThinker", function(wpn)
	if not (wpn and wpn.valid) then return end
	if not (wpn.target
	and wpn.target.valid
	and wpn.target.player
	and wpn.target.player.mm
	and (wpn.target.player.mm.weapon == wpn
	or wpn.target.player.mm.weapon2 == wpn)) then
		P_RemoveMobj(wpn)
		return
	end
	
	local p = wpn.target.player
	
	local data = MM:getWpnData(wpn)

	if p.mm.weapon == wpn
	and (p.mm.weapon2 and p.mm.weapon2.valid) then
		-- prioritize second weapon
		wpn.flags2 = $|MF2_DONTDRAW
		data.think(p, wpn)
		return
	end

	if wpn.time ~= nil then
		wpn.time = max(0, $-1)
		if not (wpn.time) then
			drop_weapon(wpn, true)
			return
		end
	end

	if p.cmd.buttons & BT_ATTACK
	and not (p.lastbuttons & BT_ATTACK) then
		data.attack(p, wpn)
	end

	if data.droppable
	and (p.cmd.buttons & BT_CUSTOM2 and p.lastbuttons & BT_CUSTOM2 == 0)
	and not wpn.dropped then
		drop_weapon(wpn, wpn == p.mm.weapon2)
		return
	end

	if wpn.hidden then
		wpn.flags2 = $|MF2_DONTDRAW
	else
		wpn.flags2 = $ & ~MF2_DONTDRAW
	end

	if p.cmd.buttons & BT_CUSTOM1
	and not (wpn.hidepressed) then
		wpn.hidden = not wpn.hidden
		if not wpn.hidden
		and data.equip then
			data.equip(p, wpn)
		end
	end

	wpn.hidepressed = (p.cmd.buttons & BT_CUSTOM1)

	data.think(p, wpn)

	search_players(p)
end, MT_MM_WEAPON)

addHook("PostThinkFrame", function()
	for k,wpn in pairs(weapons) do
		if not (wpn and wpn.valid) then
			table.remove(weapons,k)
			continue
		end

		wpn.momx = wpn.target.momx
		wpn.momy = wpn.target.momy
		wpn.momz = wpn.target.momz
		wpn.angle = wpn.target.angle
		P_MoveOrigin(wpn,
			wpn.target.x+wpn.ox,
			wpn.target.y+wpn.oy,
			wpn.target.z+(wpn.target.height/2)+wpn.oz
		)
	end
end)

getWeapon("Knife")
getWeapon("Gun")

dofile "Weapons/dropped"