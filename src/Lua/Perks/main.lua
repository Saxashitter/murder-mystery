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

dofile(path.."Ghost")
dofile(path.."Ninja")
dofile(path.."Swap")
dofile(path.."Trap")
dofile(path.."Footsteps")
dofile(path.."XRay")
dofile(path.."Haste")
dofile(path.."FakeGun")
