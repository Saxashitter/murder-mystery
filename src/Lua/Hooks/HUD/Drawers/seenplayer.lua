local sglib = MM.require "Libs/sglib"

local draw_name = ""
local g_seenplayer
local tics = 0

addHook("SeenPlayer", function(player, seenplayer)
	if not MM:isMM() then return end

	if seenplayer
	and seenplayer.mm then
		local name = seenplayer.name

		if seenplayer.mm.alias
		and seenplayer.mm.alias.name then
			name = seenplayer.mm.alias.name
		end

		draw_name = name
		g_seenplayer = seenplayer
		tics = 10

		return false
	end
end)

return function(v,p,c)
	if not MM:isMM() then
		draw_name = ""
		tics = 0
		return
	end

	if g_seenplayer and g_seenplayer.valid 
	and g_seenplayer.mo and g_seenplayer.valid then
		local g_mo = g_seenplayer.mo
		local flip = 1 
		
		if P_MobjFlip(p.realmo) ~= P_MobjFlip(g_mo) then
			flip = -1
		end
		
		local to_screen = sglib.ObjectTracking(v,p,c,{ x = g_mo.x, y = g_mo.y, z = g_mo.z+(( (g_mo.height*3)/2)*flip ) })
		
		if to_screen and to_screen.onScreen then
			v.drawString(to_screen.x, to_screen.y-4*FU, draw_name, V_ALLOWLOWERCASE|V_GREENMAP|V_50TRANS, "thin-fixed-center")
		end
	end
	
	tics = max(0, $-1)
	if tics == 0 then
		draw_name = ""
		g_seenplayer = nil
	end
end