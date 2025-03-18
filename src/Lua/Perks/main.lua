local path = "Perks/Scripts/"

/*
the way that a perk entry is set up is:
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

MM_PERKS.perkActiveDown = function(p, inSecondSlot)
	local thisbutton = inSecondSlot and 7 or 6
	if ((p.cmd.buttons & BT_WEAPONMASK ~= p.lastbuttons & BT_WEAPONMASK)
	and (p.cmd.buttons & BT_WEAPONMASK == thisbutton))
		return true
	end
	return false
end

--perk_t.drawer now hooks into this
MM_PERKS.drawPerkIcon = function(v,p,c, slot,perk)
	local flags = V_SNAPTOLEFT|V_SNAPTOBOTTOM|V_PERPLAYER
	local scale = FU/2
	local x = 5*FU - MMHUD.xoffset
	local y = 170*FU - 32*scale - 10*FU
	
	if (slot == 2)
		x = $ + 4*FU + 32*scale
	end
	
	local perk_t = MM_PERKS[perk]
	if perk_t == nil
		v.drawScaled(x,y, scale, v.cachePatch("MM_NOITEM"), flags|V_50TRANS)
		return
	end
	
	local y_off = 0
	local drawtoggle = true
	if perk_t.drawer ~= nil
		local newoff,newflags,dontdrawtoggle = perk_t.drawer(v,p,c, slot, {
			x = x,
			y = y,
			flags = flags,
			scale = scale
		})
		if newoff ~= nil
			y_off = newoff
		end
		if newflags ~= nil
			flags = $|newflags
		end
		if dontdrawtoggle
			drawtoggle = false
		end
	end
	y = $ + y_off
	
	local icon = perk_t.icon or "MM_NOITEM"
	local icon_scale = perk_t.icon_scale or FU
	
	v.drawScaled(x,y, FixedMul(scale, icon_scale), v.cachePatch(icon), flags)
	if (perk_t.flags & (slot == 1 and MPF_TOGGLEABLEPRI or MPF_TOGGLEABLESEC))
	and drawtoggle
		v.drawString(x + 32*scale, y + 32*scale - 8*FU,
			"w"..((slot == 1) and "6" or "7"),
			flags|V_ALLOWLOWERCASE,
			"thin-fixed-right"
		)
	end
	
	if (perk_t.postdraw ~= nil)
		perk_t.postdraw(v,p,c, slot, {
			x = x,
			y = y,
			flags = flags,
			scale = scale
		})
	end
	
end

dofile(path.."Footsteps")
dofile(path.."Ninja")
dofile(path.."FakeGun")
dofile(path.."Haste")
dofile(path.."Trap")
dofile(path.."Ghost")
dofile(path.."XRay")
dofile(path.."Swap")

MM_PERKS.num_perks = 8
