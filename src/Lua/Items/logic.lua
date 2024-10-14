local function manage_position(p, item)
	if not item.stick then return end

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

	local ox = FixedMul(p.mo.radius*3/2, item.pos.y)
	local oy = FixedMul(p.mo.radius*3/2, -item.pos.x)

	local xx = FixedMul(ox, cos(p.mo.angle))
	local xy = FixedMul(ox, sin(p.mo.angle))
	local yx = FixedMul(oy, sin(p.mo.angle))
	local yy = FixedMul(oy, cos(p.mo.angle))

	local x = xx-yx
	local y = yy+xy

	item.mobj.angle = p.mo.angle
	P_MoveOrigin(item.mobj,
		p.mo.x+x,
		p.mo.y+y,
		p.mo.z+FixedMul(p.mo.height/2, p.mo.scale)+item.pos.z
	)
end

addHook("PostThinkFrame", do
	if not MM:isMM() then return end

	for p in players.iterate do
		if not (p and p.mm and #p.mm.inventory.items) then continue end

		local inv = p.mm.inventory

		for i,item in ipairs(inv.items) do
			if not (item.mobj and item.mobj.valid) then
				item.mobj = MM:MakeWeaponMobj(p, item)
			end

			if i ~= inv.cur_sel then
				item.mobj.flags = $|MF2_DONTDRAW
				continue
			end
	
			manage_position(p, item)
		end
	end
end)

MM:addPlayerScript(function(p)
	if not (#p.mm.inventory.items) then return end

	local inv = p.mm.inventory

	if not inv.items[inv.cur_sel] then return end

	local item = inv.items[inv.cur_sel]
	local def = MM.Items[item.id]

	// timers
	item.hit = max(0, $-1)
	item.anim = max(0, $-1)
	item.cooldown = max(0, $-1)

	// attacking/use
	if p.cmd.buttons & BT_ATTACK
	and not (p.lastbuttons & BT_ATTACK)
	and not (item.cooldown) then
		item.hit = item.max_hit
		item.anim = item.max_anim
		item.cooldown = item.max_cooldown

		if def.attack then
			def.attack(item, p)
		end
		if item.attacksfx >= 0 then
			S_StartSound(p.mo, item.attacksfx)
		end
	end

	// hit detection

	if item.damage
	and not item.shootable
	and item.hit then
		for p2 in players.iterate do
			if not (p2
			and p2.mo
			and p2.mo.health
			and p2.mm
			and not p2.mm.spectator) then continue end

			local dist = R_PointToDist2(p.mo.x, p.mo.y, p2.mo.x, p2.mo.y)
			local maxdist = (p.mo.radius+p2.mo.radius)*3/2

			if dist > maxdist
			or abs(p.mo.z-p2.mo.z) > max(p.mo.height, p2.mo.height)*3/2
			or not P_CheckSight(p.mo, p2.mo) then
				continue
			end

			P_DamageMobj(p2.mo, item.mobj, p.mo, 999, DMG_INSTAKILL)
			item.hit = 0
			return
		end
	end
end)