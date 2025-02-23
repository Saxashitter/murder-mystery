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

MM_PERKS.perkActiveDown = function(p, inSecondSlot)
	if ((p.cmd.buttons & BT_TOSSFLAG)
	and not (p.lastbuttons & BT_TOSSFLAG))
	--nothing uses c3
	and (inSecondSlot and (p.cmd.buttons & BT_CUSTOM3) or true)
		return true
	end
	return false
end

dofile(path.."Ghost")
dofile(path.."Ninja")
dofile(path.."Swap")
dofile(path.."Trap")
dofile(path.."Footsteps")
dofile(path.."XRay")
dofile(path.."Haste")
dofile(path.."FakeGun")

MM_PERKS.num_perks = 8
