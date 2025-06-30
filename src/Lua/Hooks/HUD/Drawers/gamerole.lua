local roles = MM.require "Variables/Data/Roles"

--Good coding practices
--press tab to see the old role drawer
local function HUD_RoleDrawer(v,p)
	if not (p.mm and roles[p.mm.role]) then return end
	if (p.mm_save.afkmode and p.spectator) then return end
	
	--we have enough screen space
	if v.width() >= 800
	--the game would squish the text to illegibility
	and not splitscreen
		MMHUD.HUD_RoleDrawer(v,p)
		return
	end
	
	local y = (p == secondarydisplayplayer) and (v.height()/v.dupy() << (FRACBITS-1)) or 0
	
	----Draw "Killed by"
	if p.spectator 
	or not (p.mo and p.mo.valid)
	or p.mo.health == 0 then
		v.slideDrawString(320*FU,
			y,
			"Dead",
			V_GRAYMAP|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"fixed-right"
		)
		return
	end
	----
	
	v.slideDrawString(320*FU,
		y,
		roles[p.mm.role].name,
		roles[p.mm.role].color|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
		"fixed-right"
	)
	
	if leveltime <= MM_N.pregame_time*2
	and not splitscreen
		v.slideDrawString(320*FU,
			8*FU,
			"Press TAB to view more",
			V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_PERPLAYER,
			"thin-fixed-right"
		)	
	end
	
end

return HUD_RoleDrawer
