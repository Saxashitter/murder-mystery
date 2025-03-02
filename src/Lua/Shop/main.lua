MM.Shop = {}

MM.Shop.libcre = 0
MM.Shop.catcre = 0

MM.Shop.categories = {
	/*
	[category_id] = {
		name = string,
		items = {
			[1] = item_id,
			[2] = item_id,
			[3] = item_id,
		},
	}
	*/
}

MM.Shop.items = {
	/*
	[item_id] = {
		name = string,
		price = int,
		category = int, (id)
		
		--"hooks"
		purchase = func,
		equip = func,
	}
	*/
}

local function doAndInsert(file, realname)
	MM.Shop[realname or file] = dofile("Shop/Scripts/"..file)
end

doAndInsert("addCategory")
doAndInsert("addItem")
doAndInsert("buyItem")

COM_AddCommand("MM_TryBuyItem", function(p, sig, id, sound)
	if not MM:isMM() then return end
	if sig ~= MM_luaSignature
		CONS_Printf(p, "Can't use MM_TryBuyItem manually.")
		return
	end
	
	MM.Shop.buyItem(p, tonumber(id), (sound ~= nil))
end)