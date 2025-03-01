return function(props)
	MM.Shop.libcre = $ + 1
	
	if type(props) ~= "table"
		error("MM.Shop.addItem argument 1 expected table, got "..type(props).." instead.", 2)
	end
	
	table.insert(MM.Shop.items, MM.Shop.libcre, {
		name = props.name or "Item"..MM.Shop.libcre,
		price = props.price or 0,
		category = props.category or 0,
		
		purchase = props.purchase,
		equip = props.equip,
	})
	
	--add this item's id to the categories list of items
	if MM.Shop.categories[props.category] ~= nil
		table.insert(MM.Shop.categories[props.category].items, MM.Shop.libcre)
		print("MM.Shop.addItem(): Added category reference")
	else
		if props.category
			print("MM.Shop.addItem(): Invalid category reference")
		end
		MM.Shop.items[MM.Shop.libcre].category = 0
	end
	
	print('MM.Shop.addItem(): Added item "'..(props.name or "Item"..MM.Shop.libcre)..'"')
	
	return MM.Shop.libcre
end