rawset(_G,"CV_MM",{})

CV_MM.afkkickmode = CV_RegisterVar({
	name = "mm_afkmode",
	defaultvalue = "off",
	flags = CV_NETVAR,
	PossibleValue = {off = 0, kick = 1, kill = 2}
})

CV_MM.debug = CV_RegisterVar({
	name = "mm_debug",
	defaultvalue = "On",
	flags = CV_NETVAR,
	PossibleValue = CV_OnOff
})
