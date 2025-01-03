--there could be a better way to do this
local function HUD_GoalDrawer(v,p)
	local x = 5*FU - MMHUD.xoffset
	local y = 34*FU
	
	if MM_N.dueling then return end
	
	if MM_N.clues_amount ~= 0
	and p.mm.role ~= MMROLE_SHERIFF
		local complete = #p.mm.clues == 0 and V_YELLOWMAP or 0
		v.drawString(x,
			y,
			(#p.mm.clues).."/"..MM_N.clues_amount.." Clues left",
			V_SNAPTOTOP|V_SNAPTOLEFT|V_ALLOWLOWERCASE|complete,
			"thin-fixed"
		)
		y = $+8*FU
	end
	if p.mm.role == MMROLE_MURDERER
	and MM_N.minimum_killed > 0
		local complete = MM_N.peoplekilled >= MM_N.minimum_killed and V_YELLOWMAP or 0
		local count = MM:countPlayers()
		local needed = count.regulars + count.inactive
		v.drawString(x,
			y,
			MM_N.peoplekilled.."/"..needed.." People killed",
			V_SNAPTOTOP|V_SNAPTOLEFT|V_ALLOWLOWERCASE|complete,
			"thin-fixed"
		)
		y = $+8*FU
	end
	
end
return HUD_GoalDrawer