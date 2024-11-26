--it would make more sense to rename this file to "inventory.lua"
local itemname = {
	oldid = '',
	id = '',
	tics = 0,
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
		local cmap = v.getColormap(TC_RAINBOW,SKINCOLOR_SILVER)
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
		customhud.CustomFontString(v,
			x, y,
			tostring(timeleft/TICRATE),
			"STCFG",
			flags|trans,
			"left",
			scale*3/2,
			SKINCOLOR_WHITE
		)
	end
end

return function(v, p)
	MMHUD.interpolate(v,false)
	
	if not (p.mm and not p.mm.spectator) then return end

	local inv = p.mm.inventory
	local items = inv.items
	local count = inv.count

	local x = 8*FU - MMHUD.xoffset
	local y = 175*FU
	local scale = FU*3/count
	
	if items[inv.cur_sel] ~= itemname.oldid
		itemname.tics = 3*TICRATE
	end
	
	if itemname.tics
		itemname.tics = $-1
		
		local curitem = items[inv.cur_sel]
		if curitem and curitem.display_name
			local trans = itemname.tics < 10 and (9 - itemname.tics)<<V_ALPHASHIFT or 0
			v.drawString(x, y - 12*FU,
				curitem.display_name,
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|trans|V_ALLOWLOWERCASE,
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
			flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM,
			inv = inv,
			item = items[i],
		}

		x = $+(36*scale)
	end
	itemname.oldid = items[inv.cur_sel]
end