local roles = MM.require "Variables/Data/Roles"

return function(p) -- Role handler
	if MM:pregame() then return end
	if p.mm.got_weapon then return end
	
	local givenweapon = roles[p.mm.role].weapon
	if MM_N.dueling then
		givenweapon = MM_N.duel_item
	end
	
	local queuedweapons = {}
	local hook_event = MM.events["GiveStartWeapon"]
	for i,v in ipairs(hook_event)
		local result = {MM.tryRunHook("GiveStartWeapon", v,
			p
		)}
		for k, v in ipairs(result)
			--override
			if v == true
				p.mm.got_weapon = true
				return
			end

			if type(v) == "string"
				table.insert(queuedweapons, v)
			end
		end
	end

	if not givenweapon then
		p.mm.got_weapon = true
		return
	end
	
	MM:GiveItem(p, givenweapon) -- Main item

	if #queuedweapons then
		for i,weapon_id in ipairs(queuedweapons) do
			MM:GiveItem(p, weapon_id)
		end
	end
	
	p.mm.got_weapon = true
end