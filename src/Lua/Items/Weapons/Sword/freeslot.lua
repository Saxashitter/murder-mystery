states[freeslot("S_MM_SWORD")] = {
	sprite = freeslot("SPR_RSWD"),
	frame = A,
	tics = -1
}

/*
freeslot("S_MM_SWORD_LUNGE1")
freeslot("S_MM_SWORD_LUNGE2")
states[S_MM_SWORD_LUNGE1] = {
	sprite = SPR_RSWD,
	frame = B,
	tics = 2,
	nextstate = S_MM_SWORD_LUNGE2
}
states[S_MM_SWORD_LUNGE2] = {
	sprite = SPR_RSWD,
	frame = C,
	tics = TICRATE - 2,
	nextstate = S_MM_SWORD
}
*/

sfxinfo[freeslot("sfx_sequip")].caption = "Sword unsheathe"
sfxinfo[freeslot("sfx_slunge")] = { 
	caption = "Sword lunge",
	flags = SF_X2AWAYSOUND
}
sfxinfo[freeslot("sfx_sslash")] = { 
	caption = "Sword slashes",
	flags = SF_X2AWAYSOUND
}

return S_MM_SWORD