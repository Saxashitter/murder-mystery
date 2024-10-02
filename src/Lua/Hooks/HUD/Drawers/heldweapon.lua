local TR = TICRATE

local secondticker = 0
local secondscale = FU*2
local secondx = 45*FU
local secondy = 130*FU

local function drawSecondWeapon(v,p)
	local slidein = MMHUD.xoffset
	secondscale = ease.outquad(FU*2/10,$,FU)
	secondx = ease.outquad(FU*2/10,$,25*FU)
	secondy = ease.outquad(FU*2/10,$,130*FU)
	
	if secondticker == -1
		secondscale = FU*2
		secondy = 130*FU
		secondx = 45*FU
		return
	end
	local wpn_t = MM:getWpnData(p.mm.weapon)
	
	v.drawScaled(secondx - slidein, 
		secondy,
		secondscale/2,
		v.cachePatch("MMWEAPON"),
		V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_50TRANS
	)

	v.drawScaled(secondx - 18*FU - slidein,
		secondy + 2*FU,
		secondscale/2,
		v.cachePatch(wpn_t and wpn_t.icon or "MISSING"),
		V_SNAPTOLEFT|V_SNAPTOBOTTOM
	)
	
	v.drawString(secondx + FU - slidein,
		secondy,
		"Main",
		V_ALLOWLOWERCASE|V_SNAPTOLEFT|V_SNAPTOBOTTOM,
		"thin-fixed"
	)
	
	v.drawScaled(secondx - 20*FU - slidein,
		secondy,
		secondscale,
		v.cachePatch("CURWEAP"),
		V_SNAPTOLEFT|V_SNAPTOBOTTOM
	)
	
end

return function(v,p)
	if (p.mm and p.mm.spectator) then return end

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

		
		drawSecondWeapon(v,p)
		if wpn == p.mm.weapon2 then
			secondticker = $+1
		else
			secondticker = -1
		end
		--v.drawString(5*FU - slidein, y - (10*FU), above_text, V_SNAPTOBOTTOM|V_SNAPTOLEFT|V_ALLOWLOWERCASE, "thin-fixed")

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
		if wpn.time ~= nil then
			v.drawScaled(9*FU - slidein,
				180*FU,
				FU,
				v.cachePatch("STTNUM"..(wpn.time/TR)),
				V_SNAPTOLEFT|V_SNAPTOBOTTOM,
				((leveltime%(2*TR)) < 30*TR) and (leveltime/5 & 1) and v.getColormap(TC_RAINBOW,SKINCOLOR_RED) or nil
			)
		end
		
		local cd = wpn.cooldown
		local maxdelay = 5*TR
		yoffset = ease.outquad((FU/maxdelay)*cd,0,-10*FU)
	else
		v.drawString(47*FU - slidein,
			156*FU,
			"No Weapon",
			V_GRAYMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin-fixed"
		)	
		v.drawString(47*FU - slidein,
			170*FU,
			"[C3] - Pick up",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
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