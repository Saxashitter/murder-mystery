local text_height = 20*FU

MMHUD.texts = {}

addHook("MapChange", do
	MMHUD.texts = {}
end)

local function lerp(a, b, t)
	return FixedMul(a, FU-t) + FixedMul(b, t)
end

function MMHUD:PushToTop(text, subtext, tics)
	for k,v in pairs(MMHUD.texts) do
		if k < #MMHUD.texts-2
		and v.tics > 9 then
			v.tics = 9
		end
	end

	table.insert(MMHUD.texts, {
		text = text or "TEST",
		subtext = subtext or "Description",
		y = -text_height,
		tics = tics or -1
	})
end

return function(v)
	if not (MMHUD.texts and #MMHUD.texts) then return end

	local listForRemoval = {}

	for i,str in pairs(MMHUD.texts) do
		local i = #MMHUD.texts-i
		local target_y = 35*FU + text_height*i
		local trans = 0

		if str.tics >= 0 then
			str.tics = max(0, $-1)

			if not (str.tics) then
				listForRemoval[#listForRemoval+1] = str
				continue
			end

			if str.tics <= 9 then
				local tics = 9-str.tics

				trans = V_10TRANS*tics
			end
		end

		str.y = lerp($, target_y, FU/7)

		v.drawString(160*FU, str.y, str.text, V_SNAPTOTOP|trans, "fixed-center")
		v.drawString(160*FU, str.y+(text_height/2), str.subtext, V_SNAPTOTOP|trans, "thin-fixed-center")
	end

	for _,str in pairs(listForRemoval) do
		for k,v in pairs(MMHUD.texts) do
			if str == v then
				table.remove(MMHUD.texts, k)
				break
			end
		end
	end
end