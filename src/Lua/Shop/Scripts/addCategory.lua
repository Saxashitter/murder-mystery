return function(cate_name)
	MM.Shop.catcre = $ + 1
	
	table.insert(MM.Shop.categories, MM.Shop.catcre, {
		name = cate_name or "Category"..MM.Shop.catcre,
		items = {}
	})
	print('MM.Shop.addCategory(): Added category "'..(cate_name or "Category"..MM.Shop.catcre)..'" ('..MM.Shop.catcre..')')
	
	return MM.Shop.catcre, MM.Shop.categories[MM.Shop.catcre]
end