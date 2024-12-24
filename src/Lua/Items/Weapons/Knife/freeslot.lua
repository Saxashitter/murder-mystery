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

return S_MM_KNIFE