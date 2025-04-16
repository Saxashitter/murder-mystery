--it would make more sense to rename this file to "inventory.lua"
local itemname = {
	--first disp. player
	[1] = {
		oldid = '',
		id = '',
		tics = 0,
	},
	
	--second disp. player
	[2] = {
		oldid = '',
		id = '',
		tics = 0,
	}
}

local function V_DrawBox(props)
	if not (props.v) then return end

	local v = props.v
	local x = props.x or 0
	local y = props.y or 0
	local flags = props.flags or 0
	local scale = props.scale or FU
	local selected = props.selected or false
	local graphic = props.graphic or "MM_NOITEM"
	local timeleft = props.timeleft or -1
	local item = props.item
	local inv = props.inv

	local trans = V_40TRANS
	--Presumably no item in this slot
	if selected and (graphic ~= "MM_NOITEM") then trans = 0 end

	v.drawScaled(
		x,y,
		scale,
		v.cachePatch(graphic),
		flags|trans
	)

	if selected then
		local yoffset = 0
		local cmap = v.getColormap(nil,nil,"Grayscale")
		if not inv.hidden
			if item
				local cd = item.cooldown
				local maxdelay = item.max_cooldown
				local t = maxdelay > 0 and FU/maxdelay or 0
				yoffset = ease.outquad(t*cd,0,-10*FU)
			end
			cmap = nil
		end
		
		v.drawScaled(
			x-(4*scale),
			y-(4*scale) + yoffset,
			scale*2,
			v.cachePatch("CURWEAP"),
			flags,
			cmap
		)
	end

	if timeleft >= 0 then
		v.drawString(x, y,
			tostring(timeleft/TICRATE),
			flags|trans,
			"fixed"
		)
	end
	
	if item == nil then return end
	
	local def = MM.Items[item.id]
	
	if (item.max_ammo ~= 0)
	and (not item.noammoinduels and not MM_N.dueling)
		if not selected
			v.drawString(x, (y + 32*scale) - 8*FU,
				item.ammo.."/"..item.max_ammo,
				(flags &~V_ALPHAMASK)|V_ALLOWLOWERCASE,
				"thin-fixed"
			)
		else
			v.drawString(160*FU,y - 20*FU,
				"Ammo: "..item.ammo.." / "..item.max_ammo,
				(flags &~V_ALPHAMASK)|V_ALLOWLOWERCASE,
				"thin-fixed-center"
			)
		end
	end
	
	--def drawer draws over everything?
	if (def.drawer)
		def.drawer(v, props.p, item, x,y, scale, flags, selected, not inv.hidden)
	end
end

return function(v, p)
	if not (p.mm and not p.mm.spectator) then return end
	if (p.spectator) then return end

	local inv = p.mm.inventory
	local items = inv.items
	local count = inv.count
	local curitem = items[inv.cur_sel]
	local myitemname = p == displayplayer and itemname[1] or itemname[2]
	
	local x = 160*FU
	local y = 172*FU + MMHUD.xoffset
	local scale = FU*3/4 --*2/count
	x = $ - (count*17*scale)
	
	
	if curitem ~= myitemname.oldid
		myitemname.tics = 3*TICRATE
	end
	
	if myitemname.tics
		myitemname.tics = $-1
		
		if curitem and curitem.display_name
			local trans = myitemname.tics < 10 and (9 - myitemname.tics)<<V_ALPHASHIFT or 0
			v.drawString(x, y - 12*FU,
				curitem.display_name,
				V_PERPLAYER|V_SNAPTOBOTTOM|trans|V_ALLOWLOWERCASE,
				"thin-fixed"
			)
		end
	end
	
	for i = 1,count do
		V_DrawBox{
			v = v,
			x = x,
			y = y,
			scale = scale,
			selected = i == inv.cur_sel,
			timeleft = items[i] and items[i].timeleft,
			graphic = items[i] and items[i].display_icon,
			flags = V_SNAPTOBOTTOM|V_PERPLAYER,
			inv = inv,
			item = items[i],
			p = p,
		}
		
		x = $+(36*scale)
	end
	myitemname.oldid = curitem
	
	--controls
	x = 5*FU - MMHUD.xoffset
	y = 170*FU
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|V_PERPLAYER
	
	if (p.pflags & (PF_ANALOGMODE|PF_DIRECTIONCHAR) == (PF_ANALOGMODE|PF_DIRECTIONCHAR))
		v.drawString(
			x,y - 16*FU,
			"Automatic mode\nis not recommended.",
			flags|V_REDMAP|V_RETURN8,
			"thin-fixed"
		)
	end
	
	v.drawString(
		x,y,
		"[C1] - "..(inv.hidden and "Equip" or "Unequip").." Items",
		flags,
		"thin-fixed"
	)
	y = $+8*FU
	
	if curitem and curitem.droppable then
		v.drawString(x,y,
			"[C2] - Drop weapon",
			flags,
			"thin-fixed"
		)
		y = $+8*FU
	end
	
	if (curitem)
		v.drawString(x,y,
			"[FIRE] - Use weapon",
			flags,
			"thin-fixed"
		)
		y = $+8*FU
	end
end
