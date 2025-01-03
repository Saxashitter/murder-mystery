states[freeslot("S_MM_KNIFE")] = {
	sprite = freeslot("SPR_KNFE"),
	frame = A,
	tics = -1
}

sfxinfo[freeslot("sfx_kequip")].caption = "Knife equip"
sfxinfo[freeslot("sfx_kffire")] = { 
	caption = "Stab",
	flags = SF_X4AWAYSOUND
}
sfxinfo[freeslot("sfx_kwhiff")].caption = "Whiff"

--Sprite credit: instashield by pastel
states[freeslot("S_MM_KNIFE_WHIFF")] = {
	sprite = freeslot("SPR_MMWH"),
	frame = A|FF_FLOORSPRITE|FF_ANIMATE|FF_SEMIBRIGHT,
	var1 = G,
	var2 = 1,
	tics = G + 1
}

return S_MM_KNIFE