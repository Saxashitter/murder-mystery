rawset(_G,"CV_MM",{})

CV_MM.afkkickmode = CV_RegisterVar({
	name = "mm_afkmode",
	defaultvalue = "off",
	flags = CV_NETVAR,
	PossibleValue = {off = 0, kick = 1, kill = 2}
})