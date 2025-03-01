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

COM_AddCommand("MM_BuyItem", function(p, name)
	if not MM:isMM() then return end

	MM:GiveItem(p, name)
end)

local function doAndInsert(file, realname)
	MM.Shop[realname or file] = dofile("Shop/Scripts/"..file)
end

doAndInsert("addCategory")
doAndInsert("addItem")
doAndInsert("buyItem")
