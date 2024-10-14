local path = "Items/Weapons/"

mobjinfo[freeslot "MT_MM_WEAPON"] = {
	radius = 1,
	height = 1,
	spawnstate = S_THOK,
	flags = MF_NOCLIP|MF_NOGRAVITY|MF_NOCLIP|MF_NOBLOCKMAP
}

MM:CreateItem(dofile(path.."Gun/def"))
MM:CreateItem(dofile(path.."Knife/def"))