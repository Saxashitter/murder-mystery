local roles = MM.require "Variables/Data/Roles"

--Good coding practices
local function HUD_RoleDrawer(v,p)
	if not (p.mm and roles[p.mm.role]) then return end
	local off = MMHUD.xoffset
	
	----Draw "Killed by"
	if p.spectator 
	or not (p.mo and p.mo.valid)
	or p.mo.health == 0 then
		v.drawString(320*FU + off,
			0,
			"Dead",
			V_GRAYMAP|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
			"fixed-right"
		)
		return
	end
	----
	
	v.drawString(320*FU + off,
		0,
		roles[p.mm.role].name,
		roles[p.mm.role].color|V_SNAPTORIGHT|V_SNAPTOTOP|V_ALLOWLOWERCASE,
		"fixed-right"
	)
end

return HUD_RoleDrawer