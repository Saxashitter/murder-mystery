local function manage_position(p, item)
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

	local x = FixedMul(FixedMul(p.mo.radius, cos(p.drawangle)), item.pos.x)
	local y = FixedMul(FixedMul(p.mo.radius, sin(p.drawangle)), item.pos.y)

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

			item.mobj.angle = p.drawangle
	
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

end)