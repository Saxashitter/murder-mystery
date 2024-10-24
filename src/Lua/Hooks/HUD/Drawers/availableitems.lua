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
		v.drawScaled(
			x-(4*scale),y-(4*scale),
			scale*2,
			v.cachePatch("CURWEAP"),
			flags
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
			SKINCOLOR_WHITE)
	end
end

return function(v, p)
	if not (p.mm and not p.mm.spectator) then return end

	local count = p.mm.inventory.count

	local x = 180*FU + MMHUD.xoffset
	local y = 175*FU
	local scale = FU*3/count

	local inv = p.mm.inventory
	local items = inv.items

	v.drawString(x, y-(10*FU), "Weapon Prev/Next", V_SNAPTORIGHT|V_SNAPTOBOTTOM, "thin-fixed")
	v.drawString(x, y-(10*FU), "Weapon Prev/Next", V_SNAPTORIGHT|V_SNAPTOBOTTOM, "thin-fixed")

	for i = 1,count do
		V_DrawBox{
			v = v,
			x = x,
			y = y,
			scale = scale,
			selected = i == inv.cur_sel,
			timeleft = items[i] and items[i].timeleft,
			graphic = items[i] and items[i].display_icon,
			flags = V_SNAPTORIGHT|V_SNAPTOBOTTOM
		}

		x = $+(36*scale)
	end
end