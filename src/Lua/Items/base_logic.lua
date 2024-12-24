local roles = MM.require "Variables/Data/Roles"

local function manage_position(p, item, set)
	if not item.stick then return end

	if not (item.mobj and item.mobj.valid) then
		item.mobj = MM:MakeWeaponMobj(p, item)
	end

	local tpfunc = set and P_SetOrigin or P_MoveOrigin

	if item.animation then
		local t = FixedDiv(item.anim, item.max_anim)

		item.pos = {
			x = ease.incubic(t, item.default_pos.x, item.anim_pos.x),
			y = ease.incubic(t, item.default_pos.y, item.anim_pos.y),
			z = ease.incubic(t, item.default_pos.z, item.anim_pos.z),
		}
	else
		item.pos = {
			x = item.default_pos.x,
			y = item.default_pos.y,
			z = item.default_pos.z
		}
	end

	local radius = p.mo.radius

	local ox = FixedMul(radius*3/2, item.pos.y)
	local oy = FixedMul(radius*3/2, -item.pos.x)

	local xx = FixedMul(ox, cos(p.mo.angle))
	local xy = FixedMul(ox, sin(p.mo.angle))
	local yx = FixedMul(oy, sin(p.mo.angle))
	local yy = FixedMul(oy, cos(p.mo.angle))

	local x = xx-yx
	local y = yy+xy
	local h = p.mo.height/2
	local z = FixedMul(h, item.pos.z)

	item.mobj.angle = p.mo.angle
	item.mobj.scale = p.mo.scale
	item.mobj.fuse = 1
	tpfunc(item.mobj,
		p.mo.x + x,
		p.mo.y + y,
		p.mo.z+h+z
	)
	
	--Hide in 1st person
	item.mobj.dontdrawforviewmobj = p.mo 
end

addHook("PostThinkFrame", do
	if not MM:isMM() then return end

	for p in players.iterate do
		if not (p and p.mo and p.mm) then continue end

		local inv = p.mm.inventory

		for i,item in pairs(inv.items) do
			if not (item.mobj and item.mobj.valid) then
				item.mobj = MM:MakeWeaponMobj(p, item)
			end

			if i ~= inv.cur_sel
			or inv.hidden then
				item.mobj.flags2 = $|MF2_DONTDRAW
				continue
			end
			item.mobj.flags2 = $ & ~MF2_DONTDRAW
	
			manage_position(p, item)
								
			if item.hiddenforothers then
				item.mobj.drawonlyforplayer = p
			end
		end
	end
end)

MM:addPlayerScript(function(p)
	local inv = p.mm.inventory
	local sel = 0

	if p.cmd.buttons & BT_CUSTOM1
	and not (p.lastbuttons & BT_CUSTOM1)
	and not (MM:pregame()) then
		inv.hidden = not inv.hidden

		local item = inv.items[inv.cur_sel]

		if item then
			local def = MM.Items[item.id]
			if inv.hidden then
				if def.unequip then
					def.unequip(item, p)
				end
			else
				if def.equip then
					def.equip(item, p)
				end

				if item.equipsfx then
					S_StartSound(p.mo, item.equipsfx)
				end

				item.anim = 0
				item.hit = 0
				item.cooldown = max(item.cooldown, 20)
				manage_position(p, item, true)
			end
		end
	end

	for i,item in pairs(p.mm.inventory.items) do
		if item.timeleft >= 0 then
			item.timeleft = max(0, $-1)
		end
		if item.timeleft == 0 then
			if item.droppable then
				MM:DropItem(p, i, nil, true, true)
			else
				MM:ClearInventorySlot(p, i)
			end
		end 
	end

	if p.cmd.buttons & BT_WEAPONNEXT
	and not (p.lastbuttons & BT_WEAPONNEXT) then
		sel = $+1
	end

	if p.cmd.buttons & BT_WEAPONPREV
	and not (p.lastbuttons & BT_WEAPONPREV) then
		sel = $-1
	end

	if abs(sel)
	and not MM.runHook("InventorySwitch", p) then
		S_StartSound(nil,sfx_menu1,p)
		
		local old_sel = inv.cur_sel
		inv.cur_sel = $+sel

		if inv.cur_sel < 1 then
			inv.cur_sel = p.mm.inventory.count
		end
		if inv.cur_sel > p.mm.inventory.count then
			inv.cur_sel = 1
		end

		if not inv.hidden then
			local newitem = inv.items[inv.cur_sel]
			local newdef = MM.Items[newitem and newitem.id or ""]
	
			if item
			and def
			and def.unequip then
				def.unequip(item, p)
			end
	
			if newitem
			and newdef
			and newdef.equip then
				newdef.equip(newitem, p)
			end
	
			if newitem
			and newitem.equipsfx then
				S_StartSound(p.mo, newitem.equipsfx)
			end
	
			if newitem then
				newitem.anim = 0
				newitem.hit = 0
				newitem.cooldown = max(newitem.cooldown, 12)
				manage_position(p, newitem, true)
			end
		end
	end

	local item = inv.items[inv.cur_sel]

	if not item then return end

	local def = MM.Items[item.id]

	// timers

	if not inv.hidden then
		item.hit = max(0, $-1)
		item.anim = max(0, $-1)
		item.cooldown = max(0, $-1)
		if def.thinker
			def.thinker(item, p)
		end
	end

	// drop le weapon

	if p.cmd.buttons & BT_CUSTOM2
	and not (p.lastbuttons & BT_CUSTOM2)
	and not MM.runHook("ItemDrop", p) then
		MM:DropItem(p)
		return
	end

	// attacking/use

	if p.cmd.buttons & BT_ATTACK
	and not (p.lastbuttons & BT_ATTACK)
	and not (item.cooldown) 
	and not inv.hidden
	and not MM.runHook("ItemUse", p) then
		item.hit = item.max_hit
		item.anim = item.max_anim
		item.cooldown = item.max_cooldown

		if item.shootable then
			local bullet = P_SpawnMobjFromMobj(p.mo,
				0,0,
				FixedDiv(p.mo.height,p.mo.scale)/2,
				item.shootmobj
			)

			bullet.angle = p.mo.angle
			bullet.aiming = p.aiming
			bullet.color = p.mo.color
			bullet.target = p.mo

			P_InstaThrust(bullet, bullet.angle, 32*cos(p.aiming))
			bullet.momz = 32*sin(p.aiming)

			table.insert(item.bullets, bullet)
		end
		if def.attack then
			def.attack(item, p)
		end
		if item.attacksfx then
			S_StartSound(p.mo, item.attacksfx)
		end
	end

	// hit detection

	if (item.damage or item.cantouch)
	and item.hit
	and not inv.hidden then
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
		end
	end
end)