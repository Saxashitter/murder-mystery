-- PLACEHOLDER SEENPLAYER CODE

local draw_name = ""
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
		tics = 10

		return false
	end
end)

return function(v)
	if not MM:isMM() then
		draw_name = ""
		tics = 0
		return
	end

	v.drawString(160, 110, draw_name, V_ALLOWLOWERCASE, "center")
	tics = max(0, $-1)
	if tics == 0 then
		draw_name = ""
	end
end