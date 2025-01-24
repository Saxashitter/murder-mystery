local roles = MM.require "Variables/Data/Roles"

return function(p) -- Role handler
	if MM:pregame() then return end
	if p.mm.got_weapon then return end
	
	local givenweapon = roles[p.mm.role].weapon
	if MM_N.dueling then
		givenweapon = MM_N.duel_item
	end
	
	local newweapon = MM.runHook("GiveStartWeapon", p)
	local queuedweapons
	local allstring = true

	-- check if arguments are string
	for i,v in ipairs({newweapon}) do
		if type(v) ~= "string" then
			allstring = false
		end
	end
	
	if newweapon ~= nil then
		--override
		if newweapon == true then
			p.mm.got_weapon = true
			return
		elseif allstring then
			queuedweapons = ({newweapon})
		end
	end
	
	if not givenweapon then
		p.mm.got_weapon = true
		return
	end
	
	MM:GiveItem(p, givenweapon) -- Main item

	if allstring and queuedweapons then
		for i,weapon_id in ipairs(queuedweapons) do
			MM:GiveItem(p, weapon_id)
		end
	end
	
	p.mm.got_weapon = true
end