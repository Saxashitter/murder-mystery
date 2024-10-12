// WEAPON SYSTEM BY @j1sk ON DISCORD
// ORIGINALLY FOR ZE2

// MM ITEM SYSTEM V2

local shallowCopy = MM.require "Libs/shallowCopy"

MM.ItemPresets = {

}

function MM:CreateItem(name,input_table)
	if not name then
		error("Name not included.")
	end
	if type(name) ~= "string" then
		error("Arg1 is not a string.")
	end
	if not input_table then
		error("Table not found.")
	end
	if type(input_table) ~= "table" then
		error("Arg2 is not a table.")
	end

	input_table.item_id = #self.ItemPresets + 1
	input_table.displayname = name
	if input_table.count and not (input_table.max_count) then
		input_table.max_count = input_table.count
	end
	
	if input_table.ammo and not (input_table.max_ammo) then
		input_table.max_ammo = input_table.ammo
	end
	
	input_table.firerate_left = 0
	
	local idname = ("ITEM_"..name:upper()):gsub(" ","_"):gsub("'","")
	local idglobal 

	table.insert(self.ItemPresets, temp_table) -- Push new item
	rawset(_G, idname, #self.ItemPresets) -- Define Item Global
	
	print("\x84MM:".."\x82 Item ".."\""..name.." ("..idname..")".."\" included ["..(#self.ItemPresets).."]")
	return #self.ItemPresets -- Item ID
end



function MM:FetchInventory(p)
	if not (p and p.valid and p.mm) then return end

	return p.mm.inventory and p.mm.inventory.items
end

function MM:FetchInventoryLimit(p)
	if not (p and p.valid and p.mm) then return 1 end
	return 5 -- placeholder, will expand later
end

function MM:FetchInventorySlot(p, slot)
	if not (p and p.valid and p.mm) then return end

	local inv = self:FetchInventory(p)
	slot = $ or p.mm.inventory.cur_sel

	return inv and inv[slot]
end

function MM:ClearInventorySlot(p, slot)
	if not (p and p.valid and p.mm) then return end

	slot = $ or p.mm.inventory.cur_sel

	local inv = self:FetchInventory(p)
	if inv and inv[slot] then
		inv[slot] = nil
		return true
	end

	return false
end

-- returns number
function MM:FetchEmptySlot(p)
	if not (p and p.valid and p.mm) then return end

	for i=1,self:FetchInventoryLimit(p) do
		if not (self:FetchInventorySlot(p, i)) then
			return i
		end	
	end
	
	return false
end

function MM:GetInventoryItemFromId(p, item_id)
	if not (p and p.valid and p.mm) then return end

	local found
	local found_slot
	
	for i=1,self:FetchInventoryLimit(p) do
		if self:FetchInventorySlot(p, i)
		and self:FetchInventorySlot(p, i).item_id
		and self:FetchInventorySlot(p, i).item_id == item_id then
			found = self:FetchInventorySlot(p, i)
			found_slot = i
			
			return found, found_slot
		end
	end
		
	return false
end

function MM:IsInventoryFull(p)
	if not (p and p.valid and p.mm) then return end
	local inv = self:FetchInventory(p)

	if inv
	and #self:FetchInventory(p) >= self:FetchInventoryLimit(p) then
		return true
	elseif inv then
		return false
	end

	return true
end

function MM:GetItemInfoIndex(iteminfo, index, skin, real)
	if not iteminfo then return end

	if not (iteminfo.skin_overwrite
	and iteminfo.skin_overwrite[skin])
	or not skin
	and index then -- no overwrite or no skin, has index
		return iteminfo[index]
	elseif index then
		if skin and iteminfo.skin_overwrite[skin][index] and not real then
			return iteminfo.skin_overwrite[skin][index]
		elseif iteminfo[index] then
			return iteminfo[index]
		end
	end
end

function MM:SetItemInfoIndex(iteminfo, index, value, skin, real)
	if not iteminfo then return end
	if value == nil then return end

	if not (iteminfo.skin_overwrite and iteminfo.skin_overwrite[skin]) or not skin and index then -- no overwrite or no skin, has index
		if iteminfo[index] then
			iteminfo[index] = value
		end
	elseif index then
		if skin and iteminfo.skin_overwrite[skin][index] and not real then
			iteminfo.skin_overwrite[skin][index] = value
		elseif iteminfo[index] then
			iteminfo[index] = value
		end
	end
end

function MM:CopyItemFromID(item_id)
	local item = shallowCopy(self.ItemPresets[item_id]) or error("Invalid item_id.")

	item.ontrigger = nil
	item.onspawn = nil
	item.onhit = nil
	item.thinker = nil

	return item
end

-- iteminfo can be number or table
function MM:GiveItem(p, item_input, count, slot)
	if not (p and p.valid and p.mm) then return end

	local datatype = type(item_input)
	local isTable = datatype == "table"
	local isNumber = datatype == "number"
	
	if not item_input or (isTable and item_input and not item_input.item_id) 
	or (isNumber and item_input and not self.ItemPresets[item_input]) then
		return false
	elseif self:FetchInventory(p) then
		local item

		if isNumber then
			item = shallowCopy(self.ItemPresets[item_input])
		elseif isTable then
			item = shallowCopy(item_input)
		else
			error("Invalid Type")
		end
		
		--destroy functions
		item.ontrigger = nil
		item.onspawn = nil
		item.onhit = nil
		item.thinker = nil
		
		if count ~= nil then
			item.count = count
			item.limited = true
		end
		
		if slot then
			self:FetchInventory(p)[i] = item
			return true
		end

		local real_count = count or item.count
		local item_id
		
		if isNumber then
			item_id = item_input
		elseif isTable then
			item_id = item_input.item_id
		end
		
		local fitem,fslot = self:GetInventoryItemFromId(p, item_id) --print(fitem,fslot)

		if fitem and fitem.count and fitem.count + real_count <= fitem.max_count then
			self:FetchInventorySlot(p, fslot).count = $ + real_count
			--print("Added apon exiting item")
		elseif self:FetchEmptySlot(p) then
			local emptyslot = self:FetchEmptySlot(p) 
			
			if emptyslot then
				self:FetchInventory(p)[emptyslot] = item
				--print("Went to empty slot")
			end
		else
			CONS_Printf(p, "\x85\Inventory full!")
			return false
		end
		
		return true
	elseif not self:FetchInventory(p) then
		CONS_Printf(p, "\x85\Invalid inventory!")
		return false
	end
	
	return false
end

// FETCH VALID ITEMS

dofile "Items/Weapons/main"