local text_height = 10*FU
local subtext_height = 8*FU

MMHUD.texts = {}

addHook("MapChange", do
	MMHUD.texts = {}
end)

local function lerp(a, b, t)
	return FixedMul(a, FU-t) + FixedMul(b, t)
end

function MMHUD:PushToTop(tics, text, ...)
	if #MMHUD.texts > 8 then
		local amount = #MMHUD.texts - 8
		
		for i = 1,amount do
			table.remove(MMHUD.texts, 1)
		end
	end

	table.insert(MMHUD.texts, {
		text = text or "TEST",
		subtexts = {...}, --subtext or "Description",
		y = -text_height,
		tics = tics or -1
	})
end

return function(v)
	if not (MMHUD.texts and #MMHUD.texts) then return end

	local listForRemoval = {}

	local target_y = 16*FU
	for i,str in pairs(MMHUD.texts) do
		local i = #MMHUD.texts-i
		local trans = 0
		local total_height = 0
		
		if str.tics >= 0 then
			if not (paused or MM:pregame())
				str.tics = max(0, $-1)
			end
			
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
		total_height = text_height
		
		v.slideDrawString(160*FU, str.y, str.text, V_SNAPTOTOP|trans, "fixed-center")
		
		for i,subt in ipairs(str.subtexts) do
			if subt == nil
				table.remove(str.subtexts, i)
				continue
			end
			local y = str.y+text_height
			
			y = $+(subtext_height*(i-1))
			
			v.slideDrawString(160*FU, y, subt, V_SNAPTOTOP|trans, "thin-fixed-center")
			total_height = $ + subtext_height
		end
		
		target_y = $ + total_height
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