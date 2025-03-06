--there could be a better way to do this
local function HUD_GoalDrawer(v,p)
	local x = 5*FU - MMHUD.xoffset
	local y = 37*FU
	local flags = V_SNAPTOTOP|V_SNAPTOLEFT|V_ALLOWLOWERCASE|V_PERPLAYER
	
	if MM_N.dueling then return end
	
	if p.mm.clues.startamount ~= nil then
		if p.mm.clues.startamount ~= 0
		and p.mm.role ~= MMROLE_SHERIFF
			local complete = #p.mm.clues.list == 0 and V_YELLOWMAP or 0
			v.drawString(x,
				y,
				(#p.mm.clues.list).."/"..p.mm.clues.startamount.." Clues left",
				flags|complete,
				"thin-fixed"
			)
			y = $+8*FU
		end
	end
	
	if p.mm.role == MMROLE_MURDERER
	and MM_N.minimum_killed > 0
		local complete = MM_N.peoplekilled >= MM_N.minimum_killed and V_YELLOWMAP or 0
		local needed = MM_N.numbertokill
		v.drawString(x,
			y,
			MM_N.peoplekilled.."/"..needed.." People killed",
			flags|complete,
			"thin-fixed"
		)
		y = $+8*FU
	end
	
end
return HUD_GoalDrawer