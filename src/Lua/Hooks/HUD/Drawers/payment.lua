local ticker = 0
local TR = TICRATE

MMHUD.info_slideout = false
MMHUD.info_count = 0
MMHUD.info_ticker = 0

return function(v,p)
	if (not MM_N.gameover)
	or (p.mm.ringspaid == 0)
		ticker = 0
		MMHUD.info_ticker = 0
		MMHUD.info_count = 0
		MMHUD.info_slideout = false
		return
	end
	
	MMHUD.info_slideout = true
	
	if (ticker > TR)
	and MMHUD.info_count ~= p.mm.ringspaid
		MMHUD.info_count = ease.outquad(FU/(2*TR)*(ticker-TR), 0, p.mm.ringspaid)
		if ticker == 3*TR
			MMHUD.info_count = p.mm.ringspaid
		end
	end
	
	/*
	v.drawString(
		x,
		60*FU,
		count,
		V_SNAPTOLEFT,
		"fixed"
	)
	*/
	
	ticker = $ + 1
	MMHUD.info_ticker = ticker
end