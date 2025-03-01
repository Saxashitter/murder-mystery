return function(p, item_id, allowsound)
	local item_t = MM.Shop.items[item_id]
	
	if item_t == nil then return end
	if (p.mm_save == nil) then return end
	
	--cant afford
	if p.mm_save.rings < item_t.price then return end
	if (p.mm_save.purchased[item_id] == true) then return end
	
	p.mm_save.rings = $ - item_t.price
	p.mm_save.purchased[item_id] = true
	
	if allowsound
		S_StartSound(nil,sfx_chchng,p)
	end
end