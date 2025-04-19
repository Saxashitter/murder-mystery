local path = "Perks/Scripts/"

/*
the way that these are set up is:
	- each MMPERK_* has 2 indexes in MM_PERKS
	- index 'primary' is the function that is ran when the perk
	  is in the primary slot
	- index 'secondary' is the function that is ran when the perk
	  is in the secondary slot. usually this is just a weaker version
	  of the perk, but can just be the primary by doing
	  MM_PERKS[MMPERK_*].secondary = MM_PERKS[MMPERK_*].primary
*/

rawset(_G, "MM_PERKS",{})
MM_PERKS.category_id, MM_PERKS.category_ptr = MM.Shop.addCategory("Perks")

--TODO: weapon 6 & 7 activate primary and secondary perks respectively
--see "perk-rewerk" branch
/*
MM_PERKS.perkActiveDown = function(p, inSecondSlot)
	local has2Perks = inSecondSlot
	if inSecondSlot
		if p.mm_save.pri_perk
		
		end
	end
	
	if ((p.cmd.buttons & BT_TOSSFLAG)
	and not (p.lastbuttons & BT_TOSSFLAG))
	--nothing uses c3
	and (has2Perks and (p.cmd.buttons & BT_CUSTOM3) or true)
		return true
	end
	return false
end
*/

dofile(path.."Footsteps")
dofile(path.."Ninja")
dofile(path.."FakeGun")
dofile(path.."Haste")
dofile(path.."Trap")
dofile(path.."Ghost")
dofile(path.."XRay")
dofile(path.."Swap")

--helpers
local itemid_to_perkid = {}
local perkid_to_itemid = {}
do
	local cate = MM_PERKS.category_ptr
	
	for i = 1, #cate.items
		local item = MM.Shop.items[cate.items[i]]
		
		itemid_to_perkid[i] = item.perk_id
		perkid_to_itemid[item.perk_id] = i
	end
end
MM_PERKS.itemid_to_perkid = itemid_to_perkid
MM_PERKS.perkid_to_itemid = perkid_to_itemid

MM_PERKS.num_perks = 8
