local function HUD_WeaponDrawer(v,p)
	if (p.spectator) then return end
	
	local slidein = MMHUD.xoffset
	
	local trans = 0
	local yoffset = 0

	local patch = v.cachePatch("MMWEAPON")
	local x = 45*FU
	local y = 155*FU

	v.drawScaled(x - slidein, y, FU, patch, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_50TRANS)

	local wpn = (p.mm.weapon2 and p.mm.weapon2.valid) and p.mm.weapon2 or p.mm.weapon

	if wpn and wpn.valid
		local wpn_t = MM:getWpnData(wpn)
		local text_string = wpn_t.name or "Weapon"
		local text_width = v.stringWidth(text_string, V_ALLOWLOWERCASE, "normal")

		local above_text = ""
		if wpn == p.mm.weapon2 then
			above_text = "Secondary"
		end
		if wpn.time ~= nil then
			above_text = $..", "..wpn.time/TICRATE
		end

		v.drawString(5*FU - slidein, y - (10*FU), above_text, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_ALLOWLOWERCASE, "thin-fixed")

		--Name
		v.drawString(47*FU - slidein,
			156*FU,
			text_string,
			V_YELLOWMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"fixed"
		)
		
		--Tooltips
		v.drawString(47*FU - slidein + (text_width*FU) + 2*FU,
			157*FU,
			(wpn.hidden and "Hidden..." or "Showing!"),
			V_ORANGEMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE|(p.mm.weapon.hidden and V_30TRANS or 0),
			"thin-fixed"
		)
		v.drawString(47*FU - slidein,
			170*FU,
			"[C1] - "..(wpn.hidden and "Show" or "Hide").." weapon",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin-fixed"
		)
		local y = 178
		if wpn_t.droppable then
			v.drawString(47*FU - slidein,
				y*FU,
				"[C2] - Drop weapon",
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
				"thin-fixed"
			)
			y = $+8
		end
		if not wpn.hidden
			v.drawString(47*FU - slidein,
				y*FU,
				"[FIRE] - Use weapon",
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
				"thin-fixed"
			)
		end
		
		--Icon
		v.drawScaled(9*FU - slidein,
			159*FU,
			FU,
			v.cachePatch(wpn_t.icon or "MISSING"), --v.cachePatch("MISSING"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|trans
		)
		
		local cd = wpn.cooldown
		yoffset = ease.outquad((FU/TR)*cd,0,-10*FU)
	else
		v.drawString(47*FU - slidein,
			156*FU,
			"No Weapon",
			V_GRAYMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin-fixed"
		)	
	end
	
	v.drawScaled(5*FU - slidein,
		155*FU + yoffset,
		FU*2,
		v.cachePatch("CURWEAP"),
		V_SNAPTOLEFT|V_SNAPTOBOTTOM|trans
	)
end

return HUD_WeaponDrawer