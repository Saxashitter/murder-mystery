local dropped_mobjs = {}
addHook("NetVars", function(n) dropped_mobjs = n($) end)

mobjinfo[freeslot "MT_MM_DROPPEDWEAPON"] = {
	radius = 32*FU,
	height = 16*FU,
	spawnstate = S_THOK
}

function MM:spawnDroppedWeapon(x, y, z, name)
	if not self.weapons[name] then return end

	local wpn_t = self.weapons[name]

	local wpn = P_SpawnMobj(x, y, z, MT_MM_DROPPEDWEAPON)
	wpn.state = wpn_t.state
	wpn.restrict = wpn_t.restrict
	wpn.give = name

	if not (dropped_mobjs[name]) then
		dropped_mobjs[name] = {}
	end

	table.insert(dropped_mobjs[name], wpn)

	return wpn
end

local function canPickUp(toucher, d_wpn)
	if (d_wpn.timealive ~= nil and d_wpn.timealive < 10) then
		return false
	end

	if not (toucher
	and toucher.valid
	and toucher.health
	and toucher.player
	and toucher.player.mm
	and not toucher.player.mm.spectator) then return false end

	if toucher == d_wpn.target then return false end

	if (toucher.player.mm.weapon and toucher.player.mm.weapon.valid) then
		--if toucher.player.mm.role == 2
		local data = MM:getWpnData(toucher.player.mm.weapon)

		if data.hold_another
		and not (toucher.player.mm.weapon2
		and toucher.player.mm.weapon2.valid) then
			return true
		end
	
		return false
	end

	return true
end

addHook("MobjThinker", function(d_wpn)
	d_wpn.angle = $+(ANG1*3/2)
	
	if d_wpn.timealive == nil then
		d_wpn.timealive = 0
	else
		d_wpn.timealive = $+1
	end

	local PICKUP_DIST = 120*FU

	for p in players.iterate do
		if not canPickUp(p.mo, d_wpn) then
			continue
		end

		local dist = R_PointToDist2(p.mo.x, p.mo.y, d_wpn.x, d_wpn.y)
		local zDist = abs(p.mo.z-d_wpn.z)

		if dist > PICKUP_DIST
		or zDist > PICKUP_DIST then
			--print(abs(dist-PICKUP_DIST)/FU)
			continue
		end

		if p.cmd.buttons & BT_CUSTOM3
		and not (p.lastbuttons & BT_CUSTOM3) then
			MM:giveWeapon(p, d_wpn.give)
			P_RemoveMobj(d_wpn)
			break
		end
	end
end, MT_MM_DROPPEDWEAPON)

addHook("PostThinkFrame", do
	-- manage weapons
	for _,class in pairs(dropped_mobjs) do
		for k,wpn in pairs(class) do
			if not (wpn and wpn.valid) then
				table.remove(class, k)
				continue
			end
		end
	end
end)

function MM:isWeaponOnMap(name)
	if not dropped_mobjs[name] then return false end

	if #dropped_mobjs[name] then
		return dropped_mobjs[name]
	end
end