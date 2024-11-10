local TR = TICRATE

local secondticker = 0
local secondscale = FU*2
local secondx = 45*FU
local secondy = 130*FU

return function(v,p)
	if (p.mm and p.mm.spectator) then return end
	
	MMHUD.interpolate(v,true)
	
	local slidein = MMHUD.xoffset
	
	local trans = 0
	local yoffset = 0

	local patch = v.cachePatch("MMWEAPON")
	local x = 45*FU
	local y = 155*FU
	local hiddenc
	if p.mm.inventory.hidden then
		--EZ colorswap to signify hidden weapon
		--to SIGMAfy
		hiddenc = v.getColormap(TC_RAINBOW,SKINCOLOR_SILVER)
	end

	v.drawScaled(x - slidein, y, FU, patch, V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_50TRANS)

	local item = p.mm.inventory.items[p.mm.inventory.cur_sel]

	if item 
		local text_string = item.display_name or "Weapon"
		local text_width = v.stringWidth(text_string, V_ALLOWLOWERCASE, "normal")

		if item.timeleft >= 0 then
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
		local y = 170
		local text = p.mm.inventory.hidden and "Show" or "Hide"
		v.drawString(47*FU - slidein,
			y*FU,
			"[C1] - "..text.." items",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin-fixed")
		y = $+8
		if item.droppable then
			v.drawString(47*FU - slidein,
				y*FU,
				"[C2] - Drop weapon",
				V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
				"thin-fixed"
			)
			y = $+8
		end
		v.drawString(47*FU - slidein,
			y*FU,
			"[FIRE] - Use weapon",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin-fixed"
		)

		--Icon
		v.drawScaled(9*FU - slidein,
			159*FU,
			FU,
			v.cachePatch(item.display_icon or "MISSING"), --v.cachePatch("MISSING"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|trans
		)
		
		local cd = item.cooldown
		local maxdelay = item.max_cooldown
		local t = maxdelay > 0 and FU/maxdelay or 0

		if p.mm.inventory.hidden then
			t = 0
		end

		yoffset = ease.outquad(t*cd,0,-10*FU)
		
		if item.timeleft >= 0 then
			local time = tostring( item.timeleft/TR )
			local cmap = ((leveltime%(2*TR)) < 30*TR) and (leveltime/5 & 1) and v.getColormap(TC_RAINBOW,SKINCOLOR_RED) or nil
			local x = 10*FU
			
			for i = 1,string.len(time)
				local n = string.sub(time,i,i)
				v.drawScaled(x - slidein,
					--Cant have this obscured by CURWEAP
					179*FU + yoffset,
					FU,
					v.cachePatch( "STTNUM"..n ),
					V_SNAPTOLEFT|V_SNAPTOBOTTOM,
					cmap
				)
				x = $ + 8*FU
			end
			
		end
		
	else
		v.drawScaled(9*FU - slidein,
			159*FU,
			FU,
			v.cachePatch("MM_NOITEM"),
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_50TRANS
		)
		
		v.drawString(47*FU - slidein,
			156*FU,
			"No Weapon",
			V_GRAYMAP|V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin-fixed"
		)	
		local text = p.mm.inventory.hidden and "Show" or "Hide"
		v.drawString(47*FU - slidein,
			170*FU,
			"[C1] - "..text.." items",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin-fixed")
		v.drawString(47*FU - slidein,
			178*FU,
			"[C3] - Pick up",
			V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_ALLOWLOWERCASE,
			"thin-fixed"
		)	
	end
	
	v.drawScaled(5*FU - slidein,
		155*FU + yoffset,
		FU*2,
		v.cachePatch("CURWEAP"),
		V_SNAPTOLEFT|V_SNAPTOBOTTOM|trans,
		hiddenc
	)
end