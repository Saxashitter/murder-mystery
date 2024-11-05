local text_height = 20*FU

MMHUD.toptexts = {
	y = -text_height,
	targety = -text_height,
	strs = {}
}

addHook("MapLoad", do
	MMHUD.toptexts = {
		y = -text_height,
		targety = -text_height,
		strs = {}
	}
end)

local function lerp(a, b, t)
	return FixedMul(a, FU-t) + FixedMul(b, t)
end

function MMHUD:PushToTop(text, subtext)
	table.insert(MMHUD.toptexts.strs, {
		text or "TEST",
		subtext or "Description"
	})
	MMHUD.toptexts.targety = $+text_height
end

COM_AddCommand("MM_Test", function()
	MMHUD:PushToTop()
end)

return function(v)
	if not (#MMHUD.toptexts.strs) then return end

	MMHUD.toptexts.y = lerp($, MMHUD.toptexts.targety, FU/8)

	for i,str in ipairs(MMHUD.toptexts.strs) do
		local y = MMHUD.toptexts.y

		y = $-(text_height*(i-1))

		v.drawString(160*FU, y, "Hi", V_SNAPTOTOP, "fixed-center")
		v.drawString(160*FU, y+(text_height/2), "Lol", V_SNAPTOTOP, "thin-fixed-center")
	end
end