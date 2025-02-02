local roles = MM.require "Variables/Data/Roles"

--Good coding practices
--press tab to see the old role drawer
local function HUD_RoleDrawer(v,p)
	if not (p.mm and roles[p.mm.role]) then return end
	if (p.mm_save.afkmode and p.spectator) then return end
	
	local off = MMHUD.xoffset
	
	--we have enough screen space
	if v.width() >= 800
	--the game would squish the text to illegibility
	and not splitscreen
		MMHUD.HUD_RoleDrawer(v,p)
		return
	end
	
	----Draw "Killed by"
	if p.spectator 
	or not (p.mo and p.mo.valid)
	or p.mo.health == 0 then
		v.drawString(320*FU + off,
			0,
			"Dead",
			V_GRAYMAP|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_PERPLAYER,
			"fixed-right"
		)
		return
	end
	----
	
	v.drawString(320*FU + off,
		0,
		roles[p.mm.role].name,
		roles[p.mm.role].color|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_PERPLAYER,
		"fixed-right"
	)
	
	if leveltime <= MM_N.pregame_time*2
		v.drawString(320*FU + off,
			8*FU,
			"Press TAB to view more",
			V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE|V_PERPLAYER,
			"thin-fixed-right"
		)	
	end
	
end

return HUD_RoleDrawer
