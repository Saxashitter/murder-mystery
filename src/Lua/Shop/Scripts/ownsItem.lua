return function(p, item_id)
	local item_t = MM.Shop.items[item_id]
	
	if item_t == nil then return false; end
	if (p.mm_save == nil) then return false; end
	
	return p.mm_save.purchased[item_id] == true
end